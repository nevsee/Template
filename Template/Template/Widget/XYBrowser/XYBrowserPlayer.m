//
//  XYBrowserPlayer.m
//  XYBrowser
//
//  Created by nevsee on 2022/10/11.
//

#import "XYBrowserPlayer.h"

@interface XYBrowserScrollView : UIScrollView
@end

@implementation XYBrowserScrollView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint velocity = [self.panGestureRecognizer velocityInView:self];
    BOOL canScrollVertical = self.contentSize.height + self.adjustedContentInset.top + self.adjustedContentInset.bottom > self.bounds.size.height;

    if (fabs(velocity.y) > fabs(velocity.x) && velocity.y > 0 &&
        canScrollVertical &&
        (fabs(self.contentOffset.y) < __FLT_MIN__ || fabs(self.contentOffset.y + self.safeAreaInsets.top) < __FLT_MIN__) &&
        [gestureRecognizer isEqual:self.panGestureRecognizer]) {
        return NO;
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end

@interface XYBrowserImagePlayer ()
@property (nonatomic, strong) SDImageCache *imageCache;
@property (nonatomic, assign, readwrite) XYBrowserAssetState state;
@end

@implementation XYBrowserImagePlayer

- (void)dealloc {
    [self resetPlayer];
    [self.imageCache clearMemory];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _maximumZoomScale = 2;
        _maximumLimitedSize = 3990;
        _tooHighRatio = 3;

        XYBrowserScrollView *scrollView = [[XYBrowserScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        scrollView.minimumZoomScale = 1;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        _scrollView = scrollView;

        SDAnimatedImageView *imageView = [[SDAnimatedImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.maxBufferSize = NSUIntegerMax;
        [scrollView addSubview:imageView];
        _imageView = imageView;

        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTapGestureRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGestureRecognizer];
        _doubleTapGestureRecognizer = doubleTapGestureRecognizer;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
}

- (void)setBounds:(CGRect)bounds {
    BOOL changed = !CGSizeEqualToSize(bounds.size, self.bounds.size);
    [super setBounds:bounds];
    if (!changed) return;
    [self revertZooming];
    [self updateScrollViewMaximumZoomScaleIfNeeded];
}

- (void)setFrame:(CGRect)frame {
    BOOL changed = !CGSizeEqualToSize(frame.size, self.frame.size);
    [super setFrame:frame];
    if (!changed) return;
    [self revertZooming];
    [self updateScrollViewMaximumZoomScaleIfNeeded];
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
- (void)doubleTapAction:(UITapGestureRecognizer *)sender {
    if (!_imageView.image) return;
    
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

// Method
- (void)loadImageWithURL:(NSURL *)url thumbImage:(UIImage *)thumbImage {
    _imageURL = url;
    _thumbImage = thumbImage;
    
    // reset player
    [self resetPlayer];
    
    // load image
    if (_beginToLoad) _beginToLoad();
    
    if (thumbImage) {
        _imageView.image = thumbImage;
        [self revertZooming];
        [self updateScrollViewMaximumZoomScaleIfNeeded];
    }
    
    if (!url) {
        if (_readyToPlay) _readyToPlay(thumbImage != nil);
        return;
    }

    if (url.isFileURL) {
        UIImage *image = [SDAnimatedImage imageWithContentsOfFile:url.path];
        if (!image) image = [UIImage imageWithContentsOfFile:url.path];
        _imageView.image = image;
        if (image) {
            [self revertZooming];
            [self updateScrollViewMaximumZoomScaleIfNeeded];
        }
        _state = XYBrowserAssetStateLocal;
        if (_readyToPlay) _readyToPlay(image != nil);
    } else {
        NSDictionary *context = nil;
        if (_maximumLimitedSize > 0) {
            NSValue *thumbnailPixelSize = [NSValue valueWithCGSize:CGSizeMake(_maximumLimitedSize, _maximumLimitedSize)];
            context = @{SDImageCoderDecodeThumbnailPixelSize: thumbnailPixelSize, SDWebImageContextImageCache: self.imageCache};
        } else {
            context = @{SDWebImageContextImageCache: self.imageCache};
        }
        
        __weak typeof(self) weakObj = self;
        [_imageView sd_setImageWithURL:url placeholderImage:thumbImage options:0 context:context progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
            __strong typeof(weakObj) self = weakObj;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (expectedSize <= 0) return;
                if (self.progressDidChange) self.progressDidChange((CGFloat)receivedSize / (CGFloat)expectedSize);
                self.state = XYBrowserAssetStateDownloading;
            });
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            __strong typeof(weakObj) self = weakObj;
            if (error.code == SDWebImageErrorCancelled) return;
            if (image) {
                [self revertZooming];
                [self updateScrollViewMaximumZoomScaleIfNeeded];
            }
            self.state = image ? XYBrowserAssetStateCompleted : XYBrowserAssetStateFailed;
            if (self.readyToPlay) self.readyToPlay(image != nil);
        }];
    }
}

- (void)revertZooming {
    if (CGRectIsEmpty(self.bounds)) return;
    if (!_imageView.image) return;
    
    // reset zoom scale
    if (_scrollView.zoomScale != 1) _scrollView.zoomScale = 1;

    // reset image size
    CGSize imageSize = _imageView.image.size;
    CGSize scrollViewSize = self.bounds.size;
    CGFloat imageViewX = 0, imageViewY = 0, imageViewWidth = 0, imageViewHeight = 0;
    BOOL isPortrait = scrollViewSize.height > scrollViewSize.width;

    if (imageSize.width > imageSize.height) {
        // width of the image in horizontal state
        CGFloat expectWidthWhenLanscape = floor((imageSize.width / imageSize.height) * scrollViewSize.height);
        
        // whether to calculate the image size based on the screen width
        BOOL baseOnWidth = isPortrait ? YES : (expectWidthWhenLanscape > scrollViewSize.width);

        if (baseOnWidth) {
            imageViewWidth = scrollViewSize.width;
            imageViewHeight = floor((imageSize.height / imageSize.width) * scrollViewSize.width);
        } else {
            imageViewWidth = floor((imageSize.width / imageSize.height) * scrollViewSize.height);
            imageViewHeight = scrollViewSize.height;
        }
    } else {
        BOOL tooHigh = _tooHighRatio > 0 ? imageSize.height / imageSize.width >= _tooHighRatio : NO;
        
        // whether to calculate the image size based on the screen height
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
    
    // reset scroll view
    _scrollView.contentSize = CGSizeMake(scrollViewSize.width, imageViewHeight);
    _scrollView.contentOffset = CGPointZero;
}

- (void)startAnimatedImage {
    if (!_imageView.image.sd_isAnimated) return;
    [_imageView startAnimating];
}

- (void)stopAnimatedImage {
    if (!_imageView.image.sd_isAnimated) return;
    [_imageView stopAnimating];
}

- (void)resetPlayer {
    _imageView.image = nil;
    _imageView.animationImages = nil;
    [_imageView sd_cancelCurrentImageLoad];
}

- (void)updateScrollViewMaximumZoomScaleIfNeeded {
    if (!_imageView.image) return;
    CGFloat ratio = (CGFloat)_imageView.image.size.width / (CGFloat)_imageView.image.size.height;
    if (!isnan(ratio) && ratio > 3) {
        _scrollView.maximumZoomScale = _maximumZoomScale * MIN(ratio / 3, 5);
    } else {
        _scrollView.maximumZoomScale = _maximumZoomScale;
    }
}

// Access
- (NSString *)cachedImagePath {
    if (!_imageURL) return nil;
    if (_imageURL.isFileURL) return _imageURL.path;
    return [self.imageCache cachePathForKey:_imageURL.absoluteString];
}

- (SDImageCache *)imageCache {
    if (!_imageCache) {
        SDImageCache *imageCache = [[SDImageCache alloc] initWithNamespace:@"" diskCacheDirectory:_cachePath];
        _imageCache = imageCache;
    }
    return _imageCache;
}

- (void)setCachePath:(NSString *)cachePath {
    if ([cachePath isEqualToString:_cachePath]) return;
    _cachePath = cachePath;
    _imageCache = [[SDImageCache alloc] initWithNamespace:@"" diskCacheDirectory:cachePath];
}

@end

#pragma mark -

@interface XYBrowserVideoPlayer ()
@property (nonatomic, strong) VIResourceLoaderManager *loaderManager;
@property (nonatomic, strong) id videoTimeObserver;
@end

@implementation XYBrowserVideoPlayer

- (void)dealloc {
    [self resetPlayer];
    [self.loaderManager cancelLoaders];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        XYBrowserVideoPlayerView *playerView = [[XYBrowserVideoPlayerView alloc] init];
        playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        playerView.playerLayer.masksToBounds = YES;
        [self addSubview:playerView];
        _playerView = playerView;
    }
    return self;
}

- (void)setBounds:(CGRect)bounds {
    BOOL changed = !CGSizeEqualToSize(bounds.size, self.bounds.size);
    [super setBounds:bounds];
    if (!changed) return;
    [self updatePlayerViewFrame];
}

- (void)setFrame:(CGRect)frame {
    BOOL changed = !CGSizeEqualToSize(frame.size, self.frame.size);
    [super setFrame:frame];
    if (!changed) return;
    [self updatePlayerViewFrame];
}

// Action
- (void)videoPlayToEndTimeNotice:(NSNotification *)notice {
    AVPlayerItem *item = notice.object;
    if (!item || ![_playerView.playerLayer.player.currentItem isEqual:item]) return;
    _playEnabled = NO;
    if (_playToEnd) _playToEnd();
}

- (void)finishCacheNotice:(NSNotification *)notice {
    VICacheConfiguration *config = notice.userInfo[VICacheConfigurationKey];
    if (![config.url isEqual:_videoURL]) return;
    _state = config.progress >= 1.0 ? XYBrowserAssetStateCompleted : XYBrowserAssetStateFailed;
}

// Method
- (void)loadVideoWithURL:(NSURL *)url thumbImage:(UIImage *)thumbImage {
    _videoURL = url;
    _thumbImage = thumbImage;
    
    // reset player
    [self resetPlayer];
    
    // load video
    if (_beginToLoad) _beginToLoad();
    
    if (thumbImage) {
        _playerView.playerLayer.contents = (__bridge id)thumbImage.CGImage;
        [self setNeedsLayout];
    }
    
    if (!url) {
        if (_readyToPlay) _readyToPlay(NO);
        return;
    };
    
    if (url.isFileURL) {
        _playerView.playerLayer.player = [AVPlayer playerWithURL:url];
        _state = XYBrowserAssetStateLocal;
    } else {
        VICacheConfiguration *config = [VICacheManager cacheConfigurationForURL:url];
        _state = config.progress >= 1.0 ? XYBrowserAssetStateCompleted : XYBrowserAssetStateDownloading;
        AVPlayerItem *playerItem = [self.loaderManager playerItemWithURL:url];
        _playerView.playerLayer.player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    if (_autoplay) [self play];
    
    [self addVideoNotification];
    [self addVideoStateObserver];
    [self addVideoTimeObserver];
}

- (void)play {
    _playEnabled = YES;
    [_playerView.playerLayer.player play];
}

- (void)pause {
    _playEnabled = NO;
    [_playerView.playerLayer.player pause];
}

- (void)seekToTime:(NSTimeInterval)time completion:(void (^)(BOOL))completion {
    [_playerView.playerLayer.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) completionHandler:completion];
}

- (void)stopAndBackToBegin {
    _playEnabled = NO;
    [_playerView.playerLayer.player pause];
    [_playerView.playerLayer.player seekToTime:CMTimeMake(0, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)updatePlayerViewFrame {
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) return;
    if (CGSizeEqualToSize(self.presentationSize, CGSizeZero) && !_thumbImage) return;
    CGFloat viewRatio = self.bounds.size.width / self.bounds.size.height;
    CGFloat videoRatio = self.presentationSize.width / self.presentationSize.height;
    if (isnan(videoRatio)) {
        videoRatio = _thumbImage.size.width / _thumbImage.size.height;
    }
    if (videoRatio > viewRatio) {
        CGFloat height = self.bounds.size.width / videoRatio;
        _playerView.frame = CGRectMake(0, (self.bounds.size.height - height) / 2, self.bounds.size.width, height);
    } else {
        CGFloat width = self.bounds.size.height * videoRatio;
        _playerView.frame = CGRectMake((self.bounds.size.width - width) / 2, 0, width, self.bounds.size.height);
    }
}

- (void)resetPlayer {
    [self removeVideoNotification];
    [self removeVideoStateObserver];
    [self removeVideoTimeObserver];
    _playEnabled = NO;
    _playerView.playerLayer.contents = nil;
    _playerView.playerLayer.player = nil;
}

- (void)addVideoNotification {
    __weak typeof(self) weakObj = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        __strong typeof(weakObj) self = weakObj;
        [self videoPlayToEndTimeNotice:note];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:VICacheManagerDidFinishCacheNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        __strong typeof(weakObj) self = weakObj;
        [self finishCacheNotice:note];
    }];
}

- (void)removeVideoNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addVideoStateObserver {
    if (!_playerView.playerLayer.player.currentItem) return;
    [_playerView.playerLayer.player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
    [_playerView.playerLayer.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_playerView.playerLayer.player.currentItem addObserver:self forKeyPath:@"presentationSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeVideoStateObserver {
    if (!_playerView.playerLayer.player.currentItem) return;
    [_playerView.playerLayer.player removeObserver:self forKeyPath:@"timeControlStatus"];
    [_playerView.playerLayer.player.currentItem removeObserver:self forKeyPath:@"status"];
    [_playerView.playerLayer.player.currentItem removeObserver:self forKeyPath:@"presentationSize"];
}

- (void)addVideoTimeObserver {
    if (_videoTimeObserver) return;
    __weak typeof(self) weakObj = self;
    _videoTimeObserver = [_playerView.playerLayer.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time) {
        __strong typeof(weakObj) self = weakObj;
        if (self.timeDidChange) self.timeDidChange(CMTimeGetSeconds(time));
    }];
}

- (void)removeVideoTimeObserver {
    if (!_videoTimeObserver) return;
    [_playerView.playerLayer.player removeTimeObserver:_videoTimeObserver];
    _videoTimeObserver = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"timeControlStatus"]) {
        AVPlayerTimeControlStatus status = _playerView.playerLayer.player.timeControlStatus;
        if (_timeControlStatusDidChange) _timeControlStatusDidChange(status);
    }
    else if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = _playerView.playerLayer.player.currentItem.status;
        if (_readyToPlay) _readyToPlay(status == AVPlayerItemStatusReadyToPlay);
    }
    else if ([keyPath isEqualToString:@"presentationSize"]) {
        [self updatePlayerViewFrame];
    }
}

// Access
- (NSTimeInterval)duration {
    return CMTimeGetSeconds(_playerView.playerLayer.player.currentItem.duration);
}

- (NSTimeInterval)time {
    return CMTimeGetSeconds(_playerView.playerLayer.player.currentItem.currentTime);
}

- (CGSize)presentationSize {
    return _playerView.playerLayer.player.currentItem.presentationSize;
}

- (AVPlayerTimeControlStatus)timeControlStatus {
    return _playerView.playerLayer.player.timeControlStatus;
}

- (NSString *)cachedVideoPath {
    if (!_videoURL) return nil;
    if (_videoURL.isFileURL) return _videoURL.path;
    return [VICacheManager cachedFilePathForURL:_videoURL];
}

- (VIResourceLoaderManager *)loaderManager {
    if (!_loaderManager) {
        [VICacheManager setCacheDirectory:_cachePath];
        VIResourceLoaderManager *loaderManager = [[VIResourceLoaderManager alloc] init];
        _loaderManager = loaderManager;
    }
    return _loaderManager;
}

- (void)setCachePath:(NSString *)cachePath {
    if ([cachePath isEqualToString:_cachePath]) return;
    _cachePath = cachePath;
    [VICacheManager setCacheDirectory:cachePath];
}

@end

@implementation XYBrowserVideoPlayerView

+ (Class)layerClass {
    return AVPlayerLayer.class;
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

- (UIImage *)image {
    return [UIImage imageWithCGImage:(CGImageRef)self.playerLayer.contents];
}

@end
