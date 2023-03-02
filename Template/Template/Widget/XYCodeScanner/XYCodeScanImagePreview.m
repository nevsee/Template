//
//  XYCodeScanImagePreview.m
//  XYCodeScanner
//
//  Created by nevsee on 2021/10/22.
//

#import "XYCodeScanImagePreview.h"
#import <AVFoundation/AVFoundation.h>
#import <Vision/Vision.h>

@interface XYCodeScanImagePreview ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImpactFeedbackGenerator *feedbackGenerator;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation XYCodeScanImagePreview

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.blackColor;
        self.feedbackStyle = UIImpactFeedbackStyleMedium;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView = imageView;
        [self addSubview:imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    _indicator.frame = self.bounds;
}

// Method
- (void)detectImageCodeFeaturesWithResultBlock:(XYCodeScanImageResultBlock)resultBlock {
    if (!_screenImage && !_originImage) {
        if (resultBlock) resultBlock(@[]);
    }
        
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        // detects screen image
        NSArray *features = [self obtainImageCodeFeatures:self.screenImage];
        NSMutableArray *results = [NSMutableArray array];
        
        if (features.count > 0) {
            for (VNBarcodeObservation *feature in features) {
                XYCodeScanResult *result = [self transformCoordinateForFeature:feature];
                [results addObject:result];
            }
        } else {
            // no features in screen image, then detects origin image
            features = [self obtainImageCodeFeatures:self.originImage];
            VNBarcodeObservation *feature = features.firstObject;
            if (feature) {
                XYCodeScanResult *result = [[XYCodeScanResult alloc] init];
                result.stringValue = feature.payloadStringValue;
                [results addObject:result];
            }
        }
        if (results.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!self.audioUrl || [AVAudioSession sharedInstance].outputVolume == 0) {
                    [self.feedbackGenerator impactOccurred];
                } else {
                    [self.audioPlayer play];
                }
            });
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            self.indicator.results = results.copy;
            [self addSubview:self.indicator];
            if (resultBlock) resultBlock(results);
        });
    });
}

- (void)clean {
    _originImage = nil;
    _screenImage = nil;
    _imageView.image = nil;
}
 
- (NSArray *)obtainImageCodeFeatures:(UIImage *)image {
    NSMutableArray *results = [NSMutableArray array];
    VNDetectBarcodesRequest *barcodesRequest = [[VNDetectBarcodesRequest alloc] initWithCompletionHandler:^(VNRequest *request, NSError *error) {
        [results addObjectsFromArray:request.results];
    }];
    CGImagePropertyOrientation orientation = [self transformImageOrientation:image.imageOrientation];
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image.CGImage orientation:orientation options:@{}];
    [handler performRequests:@[barcodesRequest] error:nil];
    return results;
}

- (XYCodeScanResult *)transformCoordinateForFeature:(VNBarcodeObservation *)feature {
    // the origin is the image's lower-left corner
    CGSize size = _screenImage.size;
    CGRect bounds = feature.boundingBox;
    CGPoint p1 = feature.topLeft, p2 = feature.bottomLeft, p3 = feature.bottomRight, p4 = feature.topRight;
    
    // transform to UIKit coordinate
    bounds = CGRectMake(bounds.origin.x * size.width, (1 - bounds.origin.y - bounds.size.height) * size.height, bounds.size.width * size.width, bounds.size.height * size.height);
    p1 = CGPointMake(p1.x * size.width, (1 - p1.y) * size.height);
    p2 = CGPointMake(p2.x * size.width, (1 - p2.y) * size.height);
    p3 = CGPointMake(p3.x * size.width, (1 - p3.y) * size.height);
    p4 = CGPointMake(p4.x * size.width, (1 - p4.y) * size.height);
    
    XYCodeScanResult *result = [[XYCodeScanResult alloc] init];
    result.bounds = bounds;
    result.corners = @[NSStringFromCGPoint(p1), NSStringFromCGPoint(p2), NSStringFromCGPoint(p3), NSStringFromCGPoint(p4)];
    result.stringValue = feature.payloadStringValue;
    result.symbology = feature.symbology;
    return result;
}

- (CGImagePropertyOrientation)transformImageOrientation:(UIImageOrientation)orientation {
    switch (orientation) {
        case UIImageOrientationUp:
            return kCGImagePropertyOrientationUp;
        case UIImageOrientationLeft:
            return kCGImagePropertyOrientationLeft;
        case UIImageOrientationDown:
            return kCGImagePropertyOrientationDown;
        case UIImageOrientationRight:
            return kCGImagePropertyOrientationRight;
        case UIImageOrientationUpMirrored:
            return kCGImagePropertyOrientationUpMirrored;
        case UIImageOrientationLeftMirrored:
            return kCGImagePropertyOrientationLeftMirrored;
        case UIImageOrientationDownMirrored:
            return kCGImagePropertyOrientationDownMirrored;
        case UIImageOrientationRightMirrored:
            return kCGImagePropertyOrientationRightMirrored;
    }
}

// Access
- (void)setScreenImage:(UIImage *)screenImage {
    _screenImage = screenImage;
    _imageView.image = screenImage;
}

- (void)setOriginImage:(UIImage *)originImage {
    _originImage = originImage;
    if (_screenImage) return;
    _imageView.image = originImage;
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
