//
//  XYCodeScanView.m
//  XYCodeScanner
//
//  Created by nevsee on 2021/10/8.
//

#import "XYCodeScanView.h"
#import <AVFoundation/AVFoundation.h>

@interface XYCodeScanView () <AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong) UIImpactFeedbackGenerator *feedbackGenerator;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;
@property (nonatomic, strong) dispatch_queue_t outputQueue;
@property (nonatomic, assign) CGFloat currentZoomFactor;
@property (nonatomic, assign) CGFloat maxZoomFactor;
@end

@implementation XYCodeScanView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.blackColor;
        self.feedbackStyle = UIImpactFeedbackStyleMedium;
        _videoZoomFactor = 3;
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (!granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.didInitBlock) self.didInitBlock(self, NO, NO);
                });
                return;
            }
            
            if ([self isSimulator]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.didInitBlock) self.didInitBlock(self, NO, NO);
                });
                return;
            }
            
            BOOL error = NO;
            self.outputQueue = dispatch_queue_create("com.nevsee.code.scan", DISPATCH_QUEUE_CONCURRENT);
            
            // device
            NSArray<AVCaptureDeviceType> *deviceTypes = @[
                AVCaptureDeviceTypeBuiltInWideAngleCamera,
                AVCaptureDeviceTypeBuiltInDualCamera,
            ];
            AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceTypes mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
            self.device = discoverySession.devices.firstObject;
            self.maxZoomFactor = self.device.activeFormat.videoMaxZoomFactor;
            
            // input
            NSError *deviceInputError;
            AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&deviceInputError];
            if (deviceInputError) error = YES;
            self.deviceInput = deviceInput;

            // output
            AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
            [metadataOutput setMetadataObjectsDelegate:self queue:self.outputQueue];
            self.metadataOutput = metadataOutput;
            
            AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
            [videoDataOutput setSampleBufferDelegate:self queue:self.outputQueue];
            self.videoDataOutput = videoDataOutput;

            // session
            AVCaptureSession *session = [[AVCaptureSession alloc] init];
            [session beginConfiguration];
            session.sessionPreset = AVCaptureSessionPresetHigh;
            if ([session canAddInput:deviceInput]) {[session addInput:deviceInput];} else {error = YES;}
            if ([session canAddOutput:videoDataOutput]) [session addOutput:videoDataOutput];
            if ([session canAddOutput:metadataOutput]) {[session addOutput:metadataOutput];} else {error = YES;}
            [session commitConfiguration];
            self.session = session;
            
            // connection
            AVCaptureConnection *connection = [videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
            connection.videoOrientation = AVCaptureVideoOrientationPortrait;
            
            // the types of metadata objects
            NSArray *metadataObjectTypes = @[
                AVMetadataObjectTypeUPCECode,
                AVMetadataObjectTypeCode39Code,
                AVMetadataObjectTypeCode39Mod43Code,
                AVMetadataObjectTypeEAN13Code,
                AVMetadataObjectTypeEAN8Code,
                AVMetadataObjectTypeCode93Code,
                AVMetadataObjectTypeCode128Code,
                AVMetadataObjectTypePDF417Code,
                AVMetadataObjectTypeQRCode,
                AVMetadataObjectTypeAztecCode,
                AVMetadataObjectTypeInterleaved2of5Code,
                AVMetadataObjectTypeITF14Code,
                AVMetadataObjectTypeDataMatrixCode,
            ];
            NSArray *results = [self filterMetadataObjectTypes:metadataObjectTypes];
            if (results.count > 0) {
                metadataOutput.metadataObjectTypes = results;
            } else {
                error = YES;
            }
            
            // init failed
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.didInitBlock) self.didInitBlock(self, NO, YES);
                });
                return;
            }

            // preview layer
            AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            previewLayer.opacity = 0;
            self.previewLayer = previewLayer;
            
            // zoom gesture
            UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
            [self addGestureRecognizer:pinchGesture];
            self->_pinchGesture = pinchGesture;
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            tapGesture.numberOfTapsRequired = 2;
            [tapGesture requireGestureRecognizerToFail:pinchGesture];
            [self addGestureRecognizer:tapGesture];
            self->_tapGesture = tapGesture;
            
            // start running
            [session startRunning];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.layer addSublayer:previewLayer];
                [self.layer addSublayer:self.animator];
                [self initMetadataOutputRectOfInterestIfNeeded];
                previewLayer.opacity = 1;
                [self.animator startAnimation];
                if (self.didInitBlock) self.didInitBlock(self, YES, YES);
            });
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _previewLayer.frame = self.bounds;
    _animator.frame = self.bounds;
    _indicator.frame = self.bounds;
}

- (void)dealloc {
    [_session stopRunning];
}

#pragma mark # Delegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CFDictionaryRef dictionaryRef = CMCopyDictionaryOfAttachments(NULL, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)dictionaryRef];
    CFRelease(dictionaryRef);
    NSDictionary *exifDictionary = [[dictionary objectForKey:(NSString *)kCGImagePropertyExifDictionary] copy];
    CGFloat brightnessValue = [[exifDictionary objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.brightnessBlock) self.brightnessBlock(self, brightnessValue);
    });
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count == 0) return;

    [self stopRunning];
    
    // plays audio or gives a feedback
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.audioUrl || [AVAudioSession sharedInstance].outputVolume == 0) {
            [self.feedbackGenerator impactOccurred];
        } else {
            [self.audioPlayer play];
        }
    });

    // transform result
    NSMutableArray *results = [NSMutableArray array];
    for (AVMetadataMachineReadableCodeObject *obj in metadataObjects) {
        AVMetadataMachineReadableCodeObject *transformedObj = (AVMetadataMachineReadableCodeObject *)[_previewLayer transformedMetadataObjectForMetadataObject:obj];
        CGPoint p1, p2, p3, p4;
        CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)transformedObj.corners[0], &p1);
        CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)transformedObj.corners[1], &p2);
        CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)transformedObj.corners[2], &p3);
        CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)transformedObj.corners[3], &p4);
        
        XYCodeScanResult *result = [[XYCodeScanResult alloc] init];
        result.bounds = transformedObj.bounds;
        result.corners = @[NSStringFromCGPoint(p1), NSStringFromCGPoint(p2), NSStringFromCGPoint(p3), NSStringFromCGPoint(p4)];
        result.stringValue = transformedObj.stringValue;
        result.type = transformedObj.type;
        [results addObject:result];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.indicator) {
            self.indicator.results = results.copy;
            [self addSubview:self.indicator];
        }
        if (self.resultBlock) self.resultBlock(self, results.copy);
    });
}

#pragma mark # Action

- (void)pinchAction:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        _currentZoomFactor = _device.videoZoomFactor;
    }
    if (sender.scale >= 1) {
        CGFloat factor = MIN(_currentZoomFactor + sender.scale - 1, _videoZoomFactor);
        [self rampToVideoZoomFactor:factor withRate:50];
    } else {
        CGFloat factor = MAX(_currentZoomFactor - (_videoZoomFactor - sender.scale * _videoZoomFactor), 1);
        [self rampToVideoZoomFactor:factor withRate:50];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (_device.videoZoomFactor - 1 < 0.1) {
        [self rampToVideoZoomFactor:_videoZoomFactor withRate:_videoZoomFactor * 1.2];
    } else {
        [self rampToVideoZoomFactor:1 withRate:_videoZoomFactor * 1.2];
    }
}

#pragma mark # Method

- (void)startRunning {
    if (_session.isRunning) return;
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_HIGH), ^{
        [self.session startRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicator removeFromSuperview];
            [self.animator startAnimation];
        });
    });
}

- (void)stopRunning {
    if (!_session.isRunning) return;
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_HIGH), ^{
        [self.session stopRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.animator stopAnimation];
        });
    });
}

- (void)restartRunning {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_HIGH), ^{
        [self.session stopRunning];
        [self.session startRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicator removeFromSuperview];
            [self.animator stopAnimation];
            [self.animator startAnimation];
        });
    });
}

- (void)rampToVideoZoomFactor:(CGFloat)factor withRate:(CGFloat)rate {
    if (!_device) return;
    factor = MIN(MAX(1, factor), _maxZoomFactor);
    if ([_device lockForConfiguration:nil]) {
        [_device rampToVideoZoomFactor:factor withRate:rate];
        [_device unlockForConfiguration];
    }
}

- (void)cancelVideoZoomRamp {
    if (!_device) return;
    if ([_device lockForConfiguration:nil]) {
        [_device cancelVideoZoomRamp];
        [_device unlockForConfiguration];
    }
}

- (BOOL)isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

- (NSArray *)filterMetadataObjectTypes:(NSArray *)types {
    NSArray *availableTypes = _metadataOutput.availableMetadataObjectTypes;
    NSMutableArray *results = [NSMutableArray array];
    for (id type in types) {
        if ([availableTypes containsObject:type]) {
            [results addObject:type];
        }
    }
    return results;
}

- (void)initMetadataOutputRectOfInterestIfNeeded {
    if (CGRectEqualToRect(_rectOfInterest, CGRectZero)) return;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    _metadataOutput.rectOfInterest = [_previewLayer metadataOutputRectOfInterestForRect:_rectOfInterest];
}

#pragma mark # Access

- (BOOL)isAuthorized {
    return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized;
}

- (void)setRectOfInterest:(CGRect)rectOfInterest {
    if (CGRectEqualToRect(_rectOfInterest, rectOfInterest)) return;
    _rectOfInterest = rectOfInterest;
    if (!_session.isRunning) return;
    if (CGRectEqualToRect(rectOfInterest, CGRectZero)) {
        _metadataOutput.rectOfInterest = CGRectMake(0, 0, 1, 1);
    } else {
        _metadataOutput.rectOfInterest = [_previewLayer metadataOutputRectOfInterestForRect:rectOfInterest];
    }
}

- (void)setAudioUrl:(NSURL *)audioUrl {
    _audioUrl = audioUrl;
    if (!audioUrl) return;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
    [_audioPlayer prepareToPlay];
}

- (void)setFeedbackStyle:(UIImpactFeedbackStyle)feedbackStyle {
    _feedbackStyle = feedbackStyle;
    if (feedbackStyle < 0) return;
    _feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:feedbackStyle];
    [_feedbackGenerator prepare];
}

@end

