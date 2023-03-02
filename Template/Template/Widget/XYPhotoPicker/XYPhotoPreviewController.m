//
//  XYPhotoPreviewController.m
//  XYPhotoPicker
//
//  Created by nevsee on 2017/6/10.
//

#import "XYPhotoPreviewController.h"
#import "XYPhotoPickerController.h"
#import "XYPhotoPickerHelper.h"
#import "XYPhotoPickerAppearance.h"
#import "XYPhoto.h"
#import <objc/runtime.h>

#if __has_include(<SDWebImage/SDWebImage.h>)
#import <SDWebImage/SDAnimatedImageView.h>
#else
#import "SDAnimatedImageView.h"
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#define kXYTopBarHeight ([XYPhotoPickerHelper isInterfaceLandscape] ? 32 : 44)
static CGFloat const kXYTopButtonWidth = 80;
static CGFloat const kXYTopButtonPadding = 30;

@interface  XYPhotoPreviewTopBar : UIView
@property (nonatomic, strong) UIVisualEffectView *backgroundView;
@property (nonatomic, strong) UIButton *backButton; // 返回按钮
@property (nonatomic, strong) UIButton *chooseButton; // 选择按钮
- (void)updateChooseButtonState:(BOOL)choosed;
@end

@implementation XYPhotoPreviewTopBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        XYPhotoPickerAppearance *appearance = [XYPhotoPickerAppearance appearance];
        
        self.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [self addSubview:backgroundView];
        _backgroundView = backgroundView;
        
        UIImage *backImage = [[XYPhotoPickerHelper imageNamed:appearance.previewTopBarBackImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kXYTopButtonWidth - backImage.size.width - kXYTopButtonPadding);
        [backButton setImage:backImage forState:UIControlStateNormal];
        [self addSubview:backButton];
        _backButton = backButton;
        
        UIImage *chooseNormalImage = [XYPhotoPickerHelper imageNamed:appearance.previewTopBarNotSelectedImage];
        UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.contentEdgeInsets = UIEdgeInsetsMake(0, kXYTopButtonWidth - chooseNormalImage.size.width - kXYTopButtonPadding, 0, 0);
        [chooseButton setImage:chooseNormalImage forState:UIControlStateNormal];
        [self addSubview:chooseButton];
        _chooseButton = chooseButton;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat safeAreaLeft = self.safeAreaInsets.left;
    CGFloat safeAreaRight = self.safeAreaInsets.right;

    _backgroundView.frame = self.bounds;
    _backButton.frame = CGRectMake(safeAreaLeft, self.bounds.size.height - kXYTopBarHeight, kXYTopButtonWidth, kXYTopBarHeight);
    _chooseButton.frame = CGRectMake(self.bounds.size.width - kXYTopButtonWidth - safeAreaRight, self.bounds.size.height - kXYTopBarHeight, kXYTopButtonWidth, kXYTopBarHeight);
}

- (void)updateChooseButtonState:(BOOL)choosed {
    _chooseButton.selected = choosed;
    
    XYPhotoPickerAppearance *appearance = [XYPhotoPickerAppearance appearance];
    if (choosed) {
        UIImage *chooseSelectedImage = [XYPhotoPickerHelper imageNamed:appearance.previewTopBarSelectedImage];
        [_chooseButton setImage:chooseSelectedImage forState:UIControlStateNormal];
    } else {
        UIImage *chooseNormalImage = [XYPhotoPickerHelper imageNamed:appearance.previewTopBarNotSelectedImage];
        [_chooseButton setImage:chooseNormalImage forState:UIControlStateNormal];
    }
}

@end

#pragma mark -

static CGFloat const kXYToolBarHeight = 50;
static CGFloat const kXYToolbarHorizontalPadding = 20;
static CGFloat const kXYToolbarVerticalPadding = 8;
static CGFloat const kXYToolbarSendButtonInset = 14;

@interface  XYPhotoPreviewToolBar : UIView
@property (nonatomic, strong) UIVisualEffectView *backgroundView;
@property (nonatomic, strong) UIButton *originButton; // 原图按钮
@property (nonatomic, strong) UIButton *sendButton; // 发送按钮
@property (nonatomic, assign) BOOL isFirstLayout; // 是否是第一次更新布局
@property (nonatomic, assign) BOOL isUpdating; // 是否是再次更新发送按钮布局
@property (nonatomic, strong) XYPhotoPickerConfiguration *configuration;
- (void)updateOriginButtonStatus;
- (void)updateViewWhenChoosingAsset:(NSInteger)assetCount;
@end

@implementation XYPhotoPreviewToolBar

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        XYPhotoPickerAppearance *appearance = [XYPhotoPickerAppearance appearance];
        
        _isFirstLayout = YES;
        _isUpdating = YES;
        self.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [self addSubview:backgroundView];
        _backgroundView = backgroundView;
        
        NSString *originName = [XYPhotoPickerHelper localizedStringForKey:appearance.originName];
        NSAttributedString *originNormalTitle = [[NSAttributedString alloc] initWithString:originName attributes:appearance.previewToolBarItemNormalAttributes];
        UIButton *originButton = [UIButton buttonWithType:UIButtonTypeCustom];
        originButton.adjustsImageWhenHighlighted = NO;
        originButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        originButton.selected = self.configuration.needsOriginPhoto;
        [originButton setImage:[XYPhotoPickerHelper imageNamed:appearance.previewToolBarOriginNotSelectedImage] forState:UIControlStateNormal];
        [originButton setImage:[XYPhotoPickerHelper imageNamed:appearance.previewToolBarOriginSelectedImage] forState:UIControlStateSelected];
        [originButton setAttributedTitle:originNormalTitle forState:UIControlStateNormal];
        [originButton setAttributedTitle:originNormalTitle forState:UIControlStateSelected];
        [originButton sizeToFit];
        [self addSubview:originButton];
        _originButton = originButton;
        
        NSString *doneName = [XYPhotoPickerHelper localizedStringForKey:appearance.doneName];
        NSAttributedString *sendNormalTitle = [[NSAttributedString alloc] initWithString:doneName attributes:appearance.previewToolBarItemNormalAttributes];
        NSAttributedString *sendDisabledTitle = [[NSAttributedString alloc] initWithString:doneName attributes:appearance.previewToolBarItemDisabledAttributes];
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.layer.cornerRadius = 3;
        sendButton.layer.masksToBounds = YES;
        sendButton.enabled = NO;
        [sendButton setAttributedTitle:sendNormalTitle forState:UIControlStateNormal];
        [sendButton setAttributedTitle:sendDisabledTitle forState:UIControlStateDisabled];
        [sendButton setBackgroundColor:appearance.previewToolBarItemDisabledBackgroundColor];
        [sendButton sizeToFit];
        [self addSubview:sendButton];
        _sendButton = sendButton;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat safeAreaLeft = self.safeAreaInsets.left;
    CGFloat safeAreaRight = self.safeAreaInsets.right;
    
    _backgroundView.frame = self.bounds;
    
    if (_isFirstLayout) {
        _originButton.frame = CGRectMake(safeAreaLeft, 0, CGRectGetWidth(_originButton.bounds) + kXYToolbarHorizontalPadding * 2, kXYToolBarHeight);
        _isFirstLayout = NO;
    } else {
        _originButton.frame = CGRectMake(safeAreaLeft, 0, CGRectGetWidth(_originButton.bounds), kXYToolBarHeight);
    }

    if (_isUpdating) {
        _sendButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(_sendButton.bounds) - kXYToolbarHorizontalPadding - kXYToolbarSendButtonInset * 2 - safeAreaRight, kXYToolbarVerticalPadding, CGRectGetWidth(_sendButton.bounds) + kXYToolbarSendButtonInset * 2, kXYToolBarHeight - kXYToolbarVerticalPadding * 2);
        _isUpdating = NO;
    } else {
        _sendButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(_sendButton.bounds) - kXYToolbarHorizontalPadding - safeAreaRight, CGRectGetMinY(_sendButton.frame), CGRectGetWidth(_sendButton.bounds), CGRectGetHeight(_sendButton.bounds));
    }
}

// -1 表示单选
- (void)updateViewWhenChoosingAsset:(NSInteger)assetCount {
    NSString *doneName = [XYPhotoPickerHelper localizedStringForKey:[XYPhotoPickerAppearance appearance].doneName];
    NSAttributedString *sendTitle = nil;
    if (assetCount > 0) {
        sendTitle = [[NSAttributedString alloc] initWithString:[doneName stringByAppendingFormat:@"·%@", @(assetCount)] attributes:[XYPhotoPickerAppearance appearance].previewToolBarItemNormalAttributes];
        _sendButton.enabled = YES;
        [_sendButton setAttributedTitle:sendTitle forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:[XYPhotoPickerAppearance appearance].previewToolBarItemNormalBackgroundColor];
    } else if (assetCount == 0) {
        sendTitle = [[NSAttributedString alloc] initWithString:doneName attributes:[XYPhotoPickerAppearance appearance].previewToolBarItemNormalAttributes];
        _sendButton.enabled = NO;
        [_sendButton setAttributedTitle:sendTitle forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:[XYPhotoPickerAppearance appearance].previewToolBarItemDisabledBackgroundColor];
    } else if (assetCount == -1) {
        _sendButton.enabled = YES;
        [_sendButton setBackgroundColor:[XYPhotoPickerAppearance appearance].previewToolBarItemNormalBackgroundColor];
    }
    [_sendButton sizeToFit];
    _isUpdating = YES;
    [self setNeedsLayout];
}

- (void)updateOriginButtonStatus {
    _configuration.needsOriginPhoto = !_configuration.needsOriginPhoto;
    _originButton.selected = _configuration.needsOriginPhoto;
}

- (void)setConfiguration:(XYPhotoPickerConfiguration *)configuration {
    _configuration = configuration;
    _originButton.selected = configuration.needsOriginPhoto;
}

@end

#pragma mark -

static CGFloat const kXYPhotoPreviewCellPadding = 20;
static CGFloat const kXYPhotoPreviewVideoButtonSize = 85;

@interface XYPhotoPreviewCell : UICollectionViewCell
@property (nonatomic, strong) void (^didTapCellBlock)(BOOL isVideoPlay);
- (void)refreshCellWithAsset:(XYAsset *)asset;
// image
- (void)revertZooming;
- (void)requestGifImageIfNeeded;
- (void)stopGifImageWhenScrolling;
// video
- (void)stopVideoAndBackToBegin;
@end

@implementation XYPhotoPreviewCell
- (void)refreshCellWithAsset:(XYAsset *)asset {}
- (void)revertZooming {}
- (void)requestGifImageIfNeeded {}
- (void)stopGifImageWhenScrolling {}
- (void)stopVideoAndBackToBegin {};
@end

@interface XYPhotoPreviewImageCell : XYPhotoPreviewCell <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SDAnimatedImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) XYAsset *asset;
@property (nonatomic, assign) NSInteger requestID;
@property (nonatomic, assign) NSInteger gifRequestID;
@end

@implementation XYPhotoPreviewImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delaysContentTouches = NO;
        scrollView.minimumZoomScale = 1;
        scrollView.maximumZoomScale = 3;
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        scrollView.delegate = self;
        [self.contentView addSubview:scrollView];
        _scrollView = scrollView;
        
        SDAnimatedImageView *imageView = [[SDAnimatedImageView alloc] init];
        imageView.clearBufferWhenStopped = YES;
        imageView.resetFrameIndexWhenStopped = YES;
        imageView.autoPlayAnimatedImage = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imageView];
        _imageView = imageView;

        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.delaysTouchesEnded = NO;
        [self.contentView addGestureRecognizer:doubleTapGesture];
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        singleTapGesture.numberOfTapsRequired = 1;
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
        [self.contentView addGestureRecognizer:singleTapGesture];
        
        UIActivityIndicatorViewStyle style;
        if (@available(iOS 13.0, *)) {
            style = UIActivityIndicatorViewStyleLarge;
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            style = UIActivityIndicatorViewStyleWhiteLarge;
#pragma clang diagnostic pop
        }
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        indicatorView.color = [UIColor whiteColor];
        [self.contentView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(0, 0, self.bounds.size.width - kXYPhotoPreviewCellPadding, self.bounds.size.height);
    _indicatorView.center = _scrollView.center;
}

- (void)setBounds:(CGRect)bounds {
    BOOL changed = !CGSizeEqualToSize(bounds.size, self.frame.size);
    [super setBounds:bounds];
    if (!changed) return;
    [self revertZooming];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_asset cancelRequest:_requestID];
    [_asset cancelRequest:_gifRequestID];
}

// Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize frameSize = _scrollView.bounds.size;
    CGSize contentSize = _scrollView.contentSize;
    CGFloat offsetX = (frameSize.width > contentSize.width) ? (frameSize.width - contentSize.width) * 0.5 : 0;
    CGFloat offsetY = (frameSize.height > contentSize.height) ? (frameSize.height - contentSize.height) * 0.5 : 0;
    _imageView.center = CGPointMake(contentSize.width * 0.5 + offsetX, contentSize.height * 0.5 + offsetY);
}

// Action
- (void)singleTapAction:(UITapGestureRecognizer *)sender {
    if (self.didTapCellBlock) self.didTapCellBlock(NO);
}

- (void)doubleTapAction:(UITapGestureRecognizer *)sender {
    if (_scrollView.zoomScale > _scrollView.minimumZoomScale) {
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    } else {
        CGRect zoomRect = CGRectZero;
        CGPoint touchPoint = [sender locationInView:_imageView];
        CGFloat zoomScale = _scrollView.maximumZoomScale;
        zoomRect.size.width = self.frame.size.width / zoomScale;
        zoomRect.size.height = self.frame.size.height / zoomScale;
        zoomRect.origin.x = touchPoint.x - zoomRect.size.width / 2;
        zoomRect.origin.y = touchPoint.y - zoomRect.size.height / 2;
        [_scrollView zoomToRect:zoomRect animated:YES];
    }
}

- (void)refreshCellWithAsset:(XYAsset *)asset {
    _asset = asset;
    
    // 重置视图
    [self resetCell];
    
    // 加载略缩图
    CGFloat targetWidth = self.bounds.size.width;
    CGFloat targetHeight = targetWidth * roundf((CGFloat)asset.phAsset.pixelHeight / (CGFloat)asset.phAsset.pixelWidth);
    
    __weak typeof(self) weakObj = self;
    _requestID = [asset requestThumbnailImageWithsize:CGSizeMake(targetWidth, targetHeight) progress:nil completion:^(UIImage *result, NSDictionary *info) {
        __strong typeof(weakObj) self = weakObj;
        if (self.requestID != [info[PHImageResultRequestIDKey] integerValue]) return;
        [self.imageView setImage:result];
        [self revertZooming];
    }];
    
    // 针对宽图片优化最大缩放参数
    [self updateScrollViewMaximumZoomScaleIfNeeded];
}

- (void)resetCell {
    _requestID = 0;
    _imageView.image = nil;
    [_indicatorView stopAnimating];
}

- (void)updateScrollViewMaximumZoomScaleIfNeeded {
    CGFloat ratio = (CGFloat)_asset.phAsset.pixelWidth / (CGFloat)_asset.phAsset.pixelHeight;
    if (!isnan(ratio) && ratio > 2) {
        _scrollView.maximumZoomScale = 3 * (ratio / 2);
    } else {
        _scrollView.maximumZoomScale = 3;
    }
}

- (void)revertZooming {
    if (CGRectIsEmpty(self.bounds)) return;
    if (!_imageView.image) return;
    
    // revert zoom scale
    _scrollView.zoomScale = _scrollView.minimumZoomScale;
    _scrollView.frame = CGRectMake(0, 0, self.bounds.size.width - kXYPhotoPreviewCellPadding, self.bounds.size.height);
    
    // revert image view frame
    CGSize imageSize = _imageView.image.size;
    CGSize scrollViewSize = _scrollView.bounds.size;
    CGFloat imageViewX = 0, imageViewY = 0, imageViewWidth = 0, imageViewHeight = 0;
    BOOL isPortrait = scrollViewSize.height > scrollViewSize.width;

    if (imageSize.width > imageSize.height) { // 宽图
        // 横屏状态下宽图预计宽度
        CGFloat expectWidthWhenLanscape = floor((imageSize.width / imageSize.height) * scrollViewSize.height);
        // 是否基于屏幕宽度计算图片大小
        BOOL baseOnWidth = isPortrait ? YES : (expectWidthWhenLanscape > scrollViewSize.width);

        if (baseOnWidth) {
            imageViewWidth = scrollViewSize.width;
            imageViewHeight = floor((imageSize.height / imageSize.width) * scrollViewSize.width);
        } else {
            imageViewWidth = floor((imageSize.width / imageSize.height) * scrollViewSize.height);
            imageViewHeight = scrollViewSize.height;
        }
    } else { // 高图
        // 图片高度大于宽度3倍情况视为超高图片
        BOOL tooHigh = imageSize.height / imageSize.width >= 3;
        // 是否基于屏幕高度计算图片大小
        BOOL baseOnHeight = isPortrait ? NO : !tooHigh;

        if (baseOnHeight) {
            imageViewWidth = floor((imageSize.width / imageSize.height) * scrollViewSize.height);
            imageViewHeight = scrollViewSize.height;
        } else {
            imageViewWidth = MIN(scrollViewSize.width, scrollViewSize.height);
            imageViewHeight = floor((imageSize.height / imageSize.width) * imageViewWidth);
        }
    }
    imageViewX = (scrollViewSize.width - imageViewWidth) / 2;
    imageViewY = MAX((scrollViewSize.height - imageViewHeight) / 2, 0);
    _imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
    
    // revert content offset
    _scrollView.contentSize = CGSizeMake(scrollViewSize.width, imageViewHeight);
    _scrollView.contentOffset = CGPointZero;
}

- (void)requestGifImageIfNeeded {
    if (_asset.assetSubType != XYAssetSubTypeGIF) return;

    __weak typeof(self) weakObj = self;
    _gifRequestID = [_asset requestAssetImageInfoWithProgress:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        __strong typeof(weakObj) self = weakObj;
        // 从iCloud下载
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.gifRequestID == [info[PHImageResultRequestIDKey] integerValue]) {
                [self.indicatorView startAnimating];
            }
        });
    } completion:^(NSDictionary<XYAssetInfoKey,id> *info) {
        __strong typeof(weakObj) self = weakObj;
        NSDictionary *assetInfo = info[XYAssetInfoOriginInfoKey];
        if (self.gifRequestID == [assetInfo[PHImageResultRequestIDKey] integerValue]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                SDAnimatedImage *image = [SDAnimatedImage imageWithData:info[XYAssetInfoImageDataKey] scale:1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.indicatorView stopAnimating];
                    [self.imageView setImage:image];
                    [self.imageView startAnimating];
                });
            });
        }
    }];
}

- (void)stopGifImageWhenScrolling {
    if (_asset.assetSubType != XYAssetSubTypeGIF) return;
    [_imageView stopAnimating];
}

@end

@interface XYPhotoPreviewVideoCell : XYPhotoPreviewCell
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) AVPlayerLayer *playLayer;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) XYAsset *asset;
@property (nonatomic, assign) NSInteger requestID;
@property (nonatomic, assign) NSInteger videoRequestID;
@end

@implementation XYPhotoPreviewVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        AVPlayerLayer *playLayer = [[AVPlayerLayer alloc] init];
        playLayer.backgroundColor = [UIColor blackColor].CGColor;
        playLayer.contentsGravity = kCAGravityResizeAspect;
        [self.contentView.layer addSublayer:playLayer];
        _playLayer = playLayer;
        
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.adjustsImageWhenHighlighted = NO;
        playButton.hidden = YES;
        [playButton setImage:[XYPhotoPickerHelper imageNamed:@"xy_video_play"] forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:playButton];
        _playButton = playButton;
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        singleTapGesture.numberOfTapsRequired = 1;
        [self.contentView addGestureRecognizer:singleTapGesture];
        
        UIActivityIndicatorViewStyle style;
        if (@available(iOS 13.0, *)) {
            style = UIActivityIndicatorViewStyleLarge;
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            style = UIActivityIndicatorViewStyleWhiteLarge;
#pragma clang diagnostic pop
        }
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        indicatorView.color = [UIColor whiteColor];
        [self.contentView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _playLayer.frame = CGRectMake(0, 0, self.bounds.size.width - kXYPhotoPreviewCellPadding, self.bounds.size.height);
    [CATransaction commit];
    
    _playButton.frame = CGRectMake((self.bounds.size.width - kXYPhotoPreviewVideoButtonSize - kXYPhotoPreviewCellPadding) / 2, (self.bounds.size.height - kXYPhotoPreviewVideoButtonSize) / 2, kXYPhotoPreviewVideoButtonSize, kXYPhotoPreviewVideoButtonSize);
    _indicatorView.center = _playButton.center;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_asset cancelRequest:_requestID];
    [_asset cancelRequest:_videoRequestID];
}

// Action
- (void)videoPlayToEndTimeNotice:(NSNotification *)notice {
    if (![notice.object isEqual:_playLayer.player.currentItem]) return;
    [self stopVideoAndBackToBegin];
    if (self.didTapCellBlock) self.didTapCellBlock(NO);
}

- (void)applicationDidEnterBackgroundNotice {
    [self stopVideo];
}

- (void)playAction {
    [self playVideo];
}

// Gesture
- (void)singleTapAction:(UITapGestureRecognizer *)sender {
    [self playVideo];
}

// Method
- (void)refreshCellWithAsset:(XYAsset *)asset {
    _asset = asset;
    
    // 重置视图
    [self resetCell];
    
    // 加载视频封面
    __weak typeof(self) weakObj = self;
    CGFloat targetWidth = self.bounds.size.width;
    CGFloat targetHeight = targetWidth * roundf((CGFloat)asset.phAsset.pixelHeight / (CGFloat)asset.phAsset.pixelWidth);
    _requestID = [_asset requestThumbnailImageWithsize:CGSizeMake(targetWidth, targetHeight) progress:nil completion:^(UIImage *result, NSDictionary *info) {
        __strong typeof(weakObj) self = weakObj;
        if (self.requestID != [info[PHImageResultRequestIDKey] integerValue]) return;
        self.playLayer.contents = (__bridge id)result.CGImage;
    }];
    
    // 加载视频
    _videoRequestID = [_asset requestVideoAssetWithProgress:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        __strong typeof(weakObj) self = weakObj;
        // 从iCloud下载
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.videoRequestID == [info[PHImageResultRequestIDKey] integerValue]) {
                [self.indicatorView startAnimating];
                [self.playButton setHidden:YES];
            }
        });
    } completion:^(id result, NSDictionary *info) {
        __strong typeof(weakObj) self = weakObj;
        if (self.videoRequestID == [info[PHImageResultRequestIDKey] integerValue]) {
            AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:result];
            self.playLayer.player = [AVPlayer playerWithPlayerItem:item];
            [self.indicatorView stopAnimating];
            [self.playButton setHidden:NO];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayToEndTimeNotice:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotice) name:UIApplicationDidEnterBackgroundNotification object:nil];
        }
    }];
}

- (void)resetCell {
    _requestID = 0;
    _videoRequestID = 0;
    _playLayer.contents = nil;
    _playLayer.player = nil;
    _playButton.hidden = YES;
    [_indicatorView stopAnimating];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playVideo {
    if (_playLayer.player == nil) return;
    if (_playLayer.player.rate == 0) {
        _playButton.hidden = YES;
        [_playLayer.player play];
        if (self.didTapCellBlock) self.didTapCellBlock(YES);
    } else {
        _playButton.hidden = NO;
        [_playLayer.player pause];
        if (self.didTapCellBlock) self.didTapCellBlock(NO);
    }
}

- (void)stopVideo {
    _playButton.hidden = NO;
    [_playLayer.player pause];
}

- (void)stopVideoAndBackToBegin {
    _playButton.hidden = NO;
    [_playLayer.player pause];
    [_playLayer.player seekToTime:CMTimeMake(0, 1)];
}

@end

#pragma mark -

@interface XYPhotoPreviewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *listView;
@property (nonatomic, strong) XYPhotoPreviewToolBar *toolBar;
@property (nonatomic, strong) XYPhotoPreviewTopBar *topBar;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) BOOL isChangingCollectionViewBounds;
@property (nonatomic, assign) BOOL isFirstLoadGif; // 是否是第一次加载GIF。因为GIF图片加载是在滚动停止之后，第一次进来不会加载，所以记录一个值来判断这种状况。
@property (nonatomic, assign) BOOL isBarHidden; // 工具条是否隐藏
@end

@implementation XYPhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self parameterSetup];
    [self userInterfaceSetup];
    [self checkAssetStatusInCurrentIndex];
    [self checkAssetCanChooseOriginPhotoInCurrentIndex];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize viewSize = self.view.bounds.size;
    CGSize listViewSize = _listView.bounds.size;
    CGFloat toolBarHeight = kXYToolBarHeight + self.view.safeAreaInsets.bottom;
    CGFloat topBarHeight = kXYTopBarHeight + self.view.safeAreaInsets.top;

    _topBar.frame = CGRectMake(0, 0, viewSize.width, topBarHeight);
    _toolBar.frame = CGRectMake(0, viewSize.height - toolBarHeight, viewSize.width, toolBarHeight);
    
    if (!CGSizeEqualToSize(viewSize, CGSizeMake(listViewSize.width - kXYPhotoPreviewCellPadding, listViewSize.height))) {
        _isChangingCollectionViewBounds = YES;
        [_flowLayout invalidateLayout];
        [_listView setFrame:CGRectMake(0, 0, self.view.bounds.size.width + kXYPhotoPreviewCellPadding, self.view.bounds.size.height)];
        [self scrollToIndex:_currentIndex animated:NO];
        _isChangingCollectionViewBounds = NO;
    }
}

- (void)parameterSetup {
    _isFirstLoadGif = YES;
}

- (void)userInterfaceSetup {
    self.view.backgroundColor = [UIColor blackColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *listView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    listView.backgroundColor = [UIColor clearColor];
    listView.delegate = self;
    listView.dataSource = self;
    listView.scrollsToTop = NO;
    listView.delaysContentTouches = NO;
    listView.showsHorizontalScrollIndicator = NO;
    listView.showsVerticalScrollIndicator = NO;
    listView.pagingEnabled = YES;
    listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    listView.scrollEnabled = _configuration.allowMultipleSelection;
    [listView registerClass:[XYPhotoPreviewCell class] forCellWithReuseIdentifier:@"unknown"];
    [listView registerClass:[XYPhotoPreviewImageCell class] forCellWithReuseIdentifier:@"image"];
    [listView registerClass:[XYPhotoPreviewVideoCell class] forCellWithReuseIdentifier:@"video"];
    [self.view addSubview:listView];
    _listView = listView;
    
    XYPhotoPreviewTopBar *topBar = [[XYPhotoPreviewTopBar alloc] init];
    [topBar.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [topBar.chooseButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topBar];
    _topBar = topBar;
    
    XYPhotoPreviewToolBar *toolBar = [[XYPhotoPreviewToolBar alloc] init];
    toolBar.configuration = _configuration;
    [toolBar.sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [toolBar.originButton addTarget:self action:@selector(originAction) forControlEvents:UIControlEventTouchUpInside];
    [toolBar updateViewWhenChoosingAsset:_configuration.allowMultipleSelection ? _selectedAssets.count : -1];
    [self.view addSubview:toolBar];
    _toolBar = toolBar;
}

#pragma mark # Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _allAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XYAsset *asset = _allAssets[indexPath.row];
    NSString *identifier = @"unknown";
    if (asset.assetType == XYAssetTypeVideo) identifier = @"video";
    else if (asset.assetType == XYAssetTypeImage) identifier = @"image";

    XYPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    __weak typeof(self) weakObj = self;
    cell.didTapCellBlock = ^(BOOL isVideoPlay) {
        __strong typeof(weakObj) self = weakObj;
        [self transformBarAlpha:isVideoPlay];
    };
    [cell refreshCellWithAsset:asset];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_isFirstLoadGif && _configuration.allowPickingGif) {
        _isFirstLoadGif = NO;
        [(XYPhotoPreviewCell *)cell requestGifImageIfNeeded];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(XYPhotoPreviewCell *)cell revertZooming];
    [(XYPhotoPreviewCell *)cell stopVideoAndBackToBegin];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width + kXYPhotoPreviewCellPadding, self.view.bounds.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isChangingCollectionViewBounds) return;
    
    CGFloat itemWidth = scrollView.bounds.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    offsetX = offsetX + (itemWidth * 0.5);
    
    NSInteger currentIndex = offsetX / itemWidth;
    if (currentIndex < _allAssets.count && _currentIndex != currentIndex && itemWidth > 0) {
        // 更新当前下标
        _currentIndex = currentIndex;
        // 检测当前下标图片选中状态
        [self checkAssetStatusInCurrentIndex];
        // 检测当前下标是否能选择原图
        [self checkAssetCanChooseOriginPhotoInCurrentIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_configuration.allowPickingGif) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
        XYPhotoPreviewCell *cell = (XYPhotoPreviewCell *)[_listView cellForItemAtIndexPath:indexPath];
        [cell stopGifImageWhenScrolling];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_configuration.allowPickingGif) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
        XYPhotoPreviewCell *cell = (XYPhotoPreviewCell *)[_listView cellForItemAtIndexPath:indexPath];
        [cell requestGifImageIfNeeded];
    }
}

#pragma mark # Action

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseAction:(UIButton *)sender {
    XYAsset *asset = _allAssets[_currentIndex];
    
    if (sender.selected) {
        // 已经选中情况下取消选中
        // 保存的asset只能通过对比identifier来移除
        for (XYAsset *selectedAsset in _selectedAssets) {
            if (![selectedAsset.identifier isEqualToString:asset.identifier]) continue;
            [_selectedAssets removeObject:selectedAsset]; break;
        }
        [_selectedAssetIdentifiers removeObject:asset.identifier];
    } else {
        // 未选中情况下选中
        // 检查是否超过最大选中数量
        if (_selectedAssets.count >= _configuration.maximumSelectionLimit) {
            XYPhotoPickerController *controller = (XYPhotoPickerController *)self.navigationController;
            if ([controller.pickerDelegate respondsToSelector:@selector(pickerDidOverMaximumSelectionLimit:)]) {
                [controller.pickerDelegate pickerDidOverMaximumSelectionLimit:controller];
            }
            return;
        }
        [_selectedAssets addObject:asset];
        [_selectedAssetIdentifiers addObject:asset.identifier];
    }
    
    // 更新toolbar
    [_toolBar updateViewWhenChoosingAsset:_selectedAssets.count];
    
    // 资源变更回调
    _didUpdateBlock(_currentIndex, asset.identifier);
    
    // 更新topbar
    [_topBar updateChooseButtonState:!sender.isSelected];
}

- (void)originAction {
    [_toolBar updateOriginButtonStatus];
}

- (void)sendAction {
    XYPhotoPickerController *controller = (XYPhotoPickerController *)self.navigationController;
    if ([controller.pickerDelegate respondsToSelector:@selector(picker:didFinishPicking:)]) {
        if (_configuration.allowMultipleSelection) {
            [controller.pickerDelegate picker:controller didFinishPicking:_selectedAssets];
        } else {
            [controller.pickerDelegate picker:controller didFinishPicking:@[_allAssets[_currentIndex]]];
        }
    }
}

#pragma mark # Method

- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < 0 && index >= [_listView numberOfItemsInSection:0]) return;
    [_listView setContentOffset:CGPointMake(index * (self.view.bounds.size.width + kXYPhotoPreviewCellPadding), 0) animated:animated];
}

// 检测当前下标图片选中状态
- (void)checkAssetStatusInCurrentIndex {
    if (!_configuration.allowMultipleSelection) {
        _topBar.chooseButton.hidden = YES;
        return;
    }
    XYAsset *asset = _allAssets[_currentIndex];
    BOOL flag = [_selectedAssetIdentifiers containsObject:asset.identifier];
    [_topBar updateChooseButtonState:flag];
}

// 检测当前下标是否能选择原图
- (void)checkAssetCanChooseOriginPhotoInCurrentIndex {
    XYAsset *asset = _allAssets[_currentIndex];
    BOOL flag = asset.assetType == XYAssetTypeImage && asset.assetSubType == XYAssetSubTypeImage;
    _toolBar.originButton.hidden = !flag;
}

- (void)transformBarAlpha:(BOOL)isVideoPlay {
    if (isVideoPlay && _isBarHidden) return;
    
    _isBarHidden = !_isBarHidden;
    [UIView animateWithDuration:0.1 animations:^{
        self.topBar.alpha = self.isBarHidden ? 0 : 1;
        self.toolBar.alpha = self.isBarHidden ? 0 : 1;
    }];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (BOOL)prefersStatusBarHidden {
    return _isBarHidden;
}

@end

#pragma clang diagnostic pop
