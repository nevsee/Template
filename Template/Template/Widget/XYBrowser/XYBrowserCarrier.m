//
//  XYBrowserCarrier.m
//  XYBrowser
//
//  Created by nevsee on 2022/10/11.
//

#import "XYBrowserCarrier.h"
#import "XYBrowserController.h"

static UIImage * XYImageNamed(NSString *name) {
    if (!name) return nil;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"XYBrowser" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

@implementation XYBrowserImageCarrier

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakObj = self;
        XYBrowserImagePlayer *imagePlayer = [[XYBrowserImagePlayer alloc] init];
        imagePlayer.beginToLoad = ^{
            __strong typeof(weakObj) self = weakObj;
            [self.loadingIndicator startIndicator];
        };
        imagePlayer.readyToPlay = ^(BOOL ready) {
            __strong typeof(weakObj) self = weakObj;
            [self.loadingIndicator stopIndicator];
        };
        imagePlayer.progressDidChange = ^(CGFloat progress) {
            __strong typeof(weakObj) self = weakObj;
            [self.loadingIndicator updateIndicatorProgress:progress];
        };
        [self addSubview:imagePlayer];
        _imagePlayer = imagePlayer;
        
        XYBrowserLoadingIndicator *loadingIndicator = [[XYBrowserLoadingIndicator alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [imagePlayer addSubview:loadingIndicator];
        _loadingIndicator = loadingIndicator;
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        [singleTapGestureRecognizer requireGestureRecognizerToFail:imagePlayer.doubleTapGestureRecognizer];
        [self addGestureRecognizer:singleTapGestureRecognizer];
        _singleTapGestureRecognizer = singleTapGestureRecognizer;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imagePlayer.frame = self.bounds;
    _loadingIndicator.center = self.center;
}

- (void)singleTapAction {
    [_browserController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadContentWithAsset:(XYBrowserAsset *)asset index:(NSUInteger)index {
    _asset = asset;
    _index = index;
    [_imagePlayer loadImageWithURL:asset.originURL thumbImage:asset.thumbImage];
}

- (void)startDisplay {
    [_imagePlayer startAnimatedImage];
}

- (void)stopDisplay {
    [_imagePlayer stopAnimatedImage];
    [_imagePlayer revertZooming];
}

- (UIView *)playerView {
    return _imagePlayer;
}

- (UIView *)contentView {
    return _imagePlayer.imageView;
}

- (void)updateSubviewAlphaExceptPlayer:(CGFloat)alpha {
    _loadingIndicator.alpha = alpha;
    _errorIndicator.alpha = alpha;
}

- (void)updateClipsToBounds:(BOOL)clipsToBounds {
    _imagePlayer.scrollView.clipsToBounds = clipsToBounds;
}

@end

#pragma mark -

@implementation XYBrowserVideoCarrier

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakObj = self;
        XYBrowserVideoPlayer *videoPlayer = [[XYBrowserVideoPlayer alloc] init];
        videoPlayer.beginToLoad = ^{
            __strong typeof(weakObj) self = weakObj;
            self.playButton.hidden = YES;
            self.toolBar.userInteractionEnabled = NO;
            [self.loadingIndicator startIndicator];
        };
        videoPlayer.readyToPlay = ^(BOOL ready) {
            __strong typeof(weakObj) self = weakObj;
            if (ready) {
                self.toolBar.userInteractionEnabled = YES;
                self.toolBar.durationLabel.text = [self getTimeFromSecond:self.videoPlayer.duration];
            }
            self.toolBar.playButton.hidden = ready && self.videoPlayer.playEnabled;
            self.toolBar.pauseButton.hidden = !(ready && self.videoPlayer.playEnabled);
            self.playButton.hidden = ready && self.videoPlayer.playEnabled;
            [self.loadingIndicator stopIndicator];
        };
        videoPlayer.timeDidChange = ^(NSTimeInterval time) {
            __strong typeof(weakObj) self = weakObj;
            self.toolBar.timeLabel.text = [self getTimeFromSecond:time];
            self.toolBar.progressSlider.value = time / self.videoPlayer.duration;
        };
        videoPlayer.timeControlStatusDidChange = ^(AVPlayerTimeControlStatus status) {
            __strong typeof(weakObj) self = weakObj;
            if (status == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate) {
                [self.loadingIndicator startIndicator];
            } else if (status == AVPlayerTimeControlStatusPlaying) {
                [self.loadingIndicator stopIndicator];
            } else {
                [self.loadingIndicator stopIndicator];
            }
        };
        videoPlayer.playToEnd = ^{
            __strong typeof(weakObj) self = weakObj;
            [self.videoPlayer stopAndBackToBegin];
            self.playButton.hidden = NO;
            self.toolBar.playButton.hidden = NO;
            self.toolBar.pauseButton.hidden = YES;
        };
        [self addSubview:videoPlayer];
        _videoPlayer = videoPlayer;
        
        XYBrowserLoadingIndicator *loadingIndicator = [[XYBrowserLoadingIndicator alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [self addSubview:loadingIndicator];
        _loadingIndicator = loadingIndicator;
        
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.bounds = CGRectMake(0, 0, 80, 80);
        [playButton setImage:XYImageNamed(@"xy_browser_play") forState:UIControlStateNormal];
        [playButton setImage:XYImageNamed(@"xy_browser_play") forState:UIControlStateHighlighted];
        [playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playButton];
        _playButton = playButton;
        
        XYBrowserVideoToolBar *toolBar = [[XYBrowserVideoToolBar alloc] init];
        [toolBar.playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
        [toolBar.pauseButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
        [toolBar.progressSlider addTarget:self action:@selector(startDragAction:) forControlEvents:UIControlEventTouchDown];
        [toolBar.progressSlider addTarget:self action:@selector(draggingAction:) forControlEvents:UIControlEventValueChanged];
        [toolBar.progressSlider addTarget:self action:@selector(stopDragAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:toolBar];
        _toolBar = toolBar;
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTapGestureRecognizer];
        _singleTapGestureRecognizer = singleTapGestureRecognizer;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotice) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _videoPlayer.frame = self.bounds;
    _playButton.center = self.center;
    _loadingIndicator.center = self.center;
    _toolBar.frame = ({
        CGFloat height = 50;
        CGFloat width = self.bounds.size.width - _toolBarInsets.left - _toolBarInsets.right - self.safeAreaInsets.left - self.safeAreaInsets.right;
        CGRectMake(_toolBarInsets.left + self.safeAreaInsets.left, self.bounds.size.height - self.safeAreaInsets.bottom - _toolBarInsets.bottom - height, width, height);
    });
}

// Action
- (void)applicationDidEnterBackgroundNotice {
    if (!_videoPlayer.playEnabled) return;
    _playButton.hidden = NO;
    _toolBar.playButton.hidden = NO;
    _toolBar.pauseButton.hidden = YES;
    [_videoPlayer pause];
}

- (void)playAction {
    if (_videoPlayer.playEnabled) {
        [_videoPlayer pause];
    } else {
        [_videoPlayer play];
    }
    _playButton.hidden = _videoPlayer.playEnabled;
    _toolBar.playButton.hidden = _videoPlayer.playEnabled;
    _toolBar.pauseButton.hidden = !_videoPlayer.playEnabled;
}

- (void)startDragAction:(UISlider *)slider {
    _playButton.hidden = YES;
    [_videoPlayer removeVideoTimeObserver];
}

- (void)draggingAction:(UISlider *)slider {
    NSTimeInterval targetTime = slider.value * _videoPlayer.duration;
    _toolBar.timeLabel.text = [self getTimeFromSecond:targetTime];
    [_videoPlayer seekToTime:targetTime completion:nil];
}

- (void)stopDragAction:(UISlider *)slider {
    _playButton.hidden = _videoPlayer.playEnabled;
    [_videoPlayer addVideoTimeObserver];
}

- (void)singleTapAction {
    CGFloat alpha = _toolBar.alpha < 1 ? 1 : 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.toolBar.alpha = alpha;
    }];
}

// Method
- (NSString *)getTimeFromSecond:(NSTimeInterval)second {
    NSUInteger min = floor(second / 60);
    NSUInteger sec = floor(second - min * 60);
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)min, (long)sec];
}

- (void)loadContentWithAsset:(XYBrowserAsset *)asset index:(NSUInteger)index {
    _asset = asset;
    _index = index;
    [_videoPlayer loadVideoWithURL:asset.originURL thumbImage:asset.thumbImage];
}

- (void)startDisplay {
    _playButton.hidden = YES;
    _toolBar.playButton.hidden = YES;
    _toolBar.pauseButton.hidden = NO;
    [_videoPlayer play];
}

- (void)stopDisplay {
    _playButton.hidden = NO;
    _toolBar.playButton.hidden = NO;
    _toolBar.pauseButton.hidden = YES;
    _toolBar.alpha = 1;
    [_videoPlayer stopAndBackToBegin];
}

- (UIView *)playerView {
    return _videoPlayer;
}

- (UIView *)contentView {
    return _videoPlayer.playerView;
}

- (void)updateSubviewAlphaExceptPlayer:(CGFloat)alpha {
    _toolBar.alpha = alpha;
    _playButton.alpha = alpha;
    _loadingIndicator.alpha = alpha;
    _errorIndicator.alpha = alpha;
}

- (void)updateClipsToBounds:(BOOL)clipsToBounds {
    // do nothing
}

@end

@interface XYBrowserVideoCarrier (XYAppearance)
@end

@implementation XYBrowserVideoCarrier (XYAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XYBrowserVideoCarrier *appearance = [XYBrowserVideoCarrier appearance];
        appearance.toolBarInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    });
}

@end

@implementation XYBrowserVideoToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.bounds = CGRectMake(0, 0, 25, 25);
        [playButton setImage:XYImageNamed(@"xy_browser_tool_play") forState:UIControlStateNormal];
        [playButton setImage:XYImageNamed(@"xy_browser_tool_play") forState:UIControlStateHighlighted];
        [self addSubview:playButton];
        _playButton = playButton;
        
        UIButton *pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pauseButton.bounds = CGRectMake(0, 0, 25, 25);
        pauseButton.hidden = YES;
        [pauseButton setImage:XYImageNamed(@"xy_browser_tool_pause") forState:UIControlStateNormal];
        [pauseButton setImage:XYImageNamed(@"xy_browser_tool_pause") forState:UIControlStateHighlighted];
        [self addSubview:pauseButton];
        _pauseButton = pauseButton;
        
        UISlider *progressSlider = [[UISlider alloc] init];
        progressSlider.minimumTrackTintColor = [UIColor whiteColor];
        progressSlider.maximumTrackTintColor = [UIColor lightGrayColor];
        [progressSlider setThumbImage:XYImageNamed(@"xy_browser_thumb") forState:UIControlStateNormal];
        [progressSlider setThumbImage:XYImageNamed(@"xy_browser_thumb") forState:UIControlStateHighlighted];
        [self addSubview:progressSlider];
        _progressSlider = progressSlider;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.text = @"00:00";
        [self addSubview:timeLabel];
        _timeLabel = timeLabel;
        
        UILabel *durationLabel = [[UILabel alloc] init];
        durationLabel.font = [UIFont systemFontOfSize:12];
        durationLabel.textColor = [UIColor whiteColor];
        durationLabel.textAlignment = NSTextAlignmentCenter;
        durationLabel.text = @"--:--";
        [self addSubview:durationLabel];
        _durationLabel = durationLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat contentHeight = self.bounds.size.height - _contentInsets.top - _contentInsets.bottom;

    CGSize playSize = [_playButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    _playButton.frame = CGRectMake(_contentInsets.left, (contentHeight - playSize.height) / 2 + _contentInsets.top, playSize.width, playSize.height);
    
    CGSize pauseSize = [_pauseButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    _pauseButton.frame = CGRectMake(_contentInsets.left, (contentHeight - pauseSize.height) / 2 + _contentInsets.top, pauseSize.width, pauseSize.height);
    
    CGFloat timeWidth = 55, timeLeftMargin = 19;
    _timeLabel.frame = CGRectMake(CGRectGetMaxX(_playButton.frame) + timeLeftMargin, 0, timeWidth, contentHeight);
    _durationLabel.frame = CGRectMake(self.bounds.size.width - _contentInsets.right - timeWidth, 0, timeWidth, contentHeight);
    
    CGFloat progressMargin = 4;
    CGFloat progressX = CGRectGetMaxX(_timeLabel.frame) + progressMargin;
    _progressSlider.frame = CGRectMake(progressX, 0, CGRectGetMinX(_durationLabel.frame) - progressMargin - progressX, contentHeight);
}

@end

@interface XYBrowserVideoToolBar (XYAppearance)
@end

@implementation XYBrowserVideoToolBar (XYAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XYBrowserVideoToolBar *appearance = [XYBrowserVideoToolBar appearance];
        appearance.contentInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    });
}

@end
