//
//  YYEmptyView.m
//  Template
//
//  Created by nevsee on 2021/11/25.
//

#import "YYEmptyView.h"

@implementation YYEmptyView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_loadingContentView) {
        _loadingContentView.xy_size = [_loadingContentView sizeThatFits:self.bounds.size];
        _loadingContentView.center = CGPointMake(self.xy_width / 2 + _loadingOffset.horizontal, self.xy_height / 2 + _loadingOffset.vertical);
    }
    if (_resultContentView) {
        _resultContentView.xy_size = [_resultContentView sizeThatFits:self.bounds.size];
        _resultContentView.center = (CGPoint){self.xy_width / 2 + _resultOffset.horizontal, self.xy_height / 2 + _resultOffset.vertical};
    }
    if (_errorContentView) {
        _errorContentView.xy_size = [_errorContentView sizeThatFits:self.bounds.size];
        _errorContentView.center = (CGPoint){self.xy_width / 2 + _errorOffset.horizontal, self.xy_height / 2 + _errorOffset.vertical};
    }
}

- (void)transformContentAlpha {
    _loadingContentView.alpha = (_mode == YYEmptyContentModeLoading);
    _resultContentView.alpha = (_mode == YYEmptyContentModeResult);
    _errorContentView.alpha = (_mode == YYEmptyContentModeError);
}

- (void)updateLoadingContentState {
    if (self.alpha == 0 || self.isHidden || _loadingContentView.alpha == 0 || !self.superview) {
        [_loadingContentView stopLoading];
    } else {
        [_loadingContentView startLoading];
    }
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self updateLoadingContentState];
}

- (void)setLoadingContentView:(__kindof YYEmptyLoadingContentView *)loadingContentView {
    if (_loadingContentView) {
        [_loadingContentView removeFromSuperview];
    }
    _loadingContentView = loadingContentView;
    [self addSubview:loadingContentView];
    [self transformContentAlpha];
    [self updateLoadingContentState];
    [self setNeedsLayout];
}

- (void)setResultContentView:(__kindof YYEmptyPlaceholderContentView *)resultContentView {
    if (_resultContentView) {
        [_resultContentView removeFromSuperview];
    }
    _resultContentView = resultContentView;
    [self addSubview:resultContentView];
    [self transformContentAlpha];
    [self updateLoadingContentState];
    [self setNeedsLayout];
}

- (void)setErrorContentView:(__kindof YYEmptyPlaceholderContentView *)errorContentView {
    if (_errorContentView) {
        [_errorContentView removeFromSuperview];
    }
    _errorContentView = errorContentView;
    [self addSubview:errorContentView];
    [self transformContentAlpha];
    [self updateLoadingContentState];
    [self setNeedsLayout];
}

- (void)setMode:(YYEmptyContentMode)mode {
    _mode = mode;
    [self transformContentAlpha];
    [self updateLoadingContentState];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    [self updateLoadingContentState];
}

- (void)setAlpha:(CGFloat)alpha {
    [super setAlpha:alpha];
    [self updateLoadingContentState];
}

@end

#pragma mark -

@implementation YYEmptyView (YYConvenient)

+ (instancetype)defaultView {
    return [self defaultViewWithTarget:nil retryAction:nil];
}

+ (instancetype)defaultViewWithTarget:(id)target retryAction:(SEL)retryAction {
    return [self viewWithMode:-1 target:target retryAction:retryAction];
}

+ (instancetype)viewWithMode:(YYEmptyContentMode)mode {
    return [self viewWithMode:mode target:nil retryAction:nil];
}

+ (instancetype)viewWithMode:(YYEmptyContentMode)mode target:(id)target retryAction:(SEL)retryAction {
    YYEmptyView *emptyView = [[YYEmptyView alloc] init];
    
    if (mode == YYEmptyContentModeLoading || mode == -1) {
        YYEmptyLoadingContentView *loadingContentView = [[YYEmptyLoadingContentView alloc] init];
        loadingContentView.animationView.fileName = YYLottieAnimationManager.loadingRingName;
        loadingContentView.animationSize = YYLottieAnimationManager.loadingRingSize;
        emptyView.loadingContentView = loadingContentView;
    }
    if (mode == YYEmptyContentModeResult  || mode == -1) {
        YYEmptyPlaceholderContentView *resultContentView = [[YYEmptyPlaceholderContentView alloc] init];
        resultContentView.imageView.image = XYImageMake(@"no_data_1");
        resultContentView.textLabel.text = @"暂无数据";
        emptyView.resultContentView = resultContentView;
    }
    if (mode == YYEmptyContentModeError  || mode == -1) {
        YYEmptyPlaceholderContentView *errorContentView = [[YYEmptyPlaceholderContentView alloc] init];
        errorContentView.imageView.image = XYImageMake(@"network_error_1");
        errorContentView.textLabel.text = @"请求异常，请检查网络";
        [errorContentView.operationButton setTitle:@"重试" forState:UIControlStateNormal];
        [errorContentView.operationButton addTarget:target action:retryAction forControlEvents:UIControlEventTouchUpInside];
        emptyView.errorContentView = errorContentView;
    }
    emptyView.mode = (mode == -1) ? YYEmptyContentModeLoading : mode;
    return emptyView;
}

@end

#pragma mark -

@implementation YYEmptyLoadingContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        YYLottieAnimationView *animationView = [[YYLottieAnimationView alloc] init];
        [self addSubview:animationView];
        _animationView = animationView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _animationView.frame = self.bounds;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return _animationSize;
}

- (void)startLoading {
    if (_animationView.isAnimationPlaying) return;
    [_animationView play];
}

- (void)stopLoading {
    [_animationView stop];
}

@end

#pragma mark -

@implementation YYEmptyPlaceholderContentView {
    CGSize _imageSize;
    CGSize _textSize;
    CGSize _buttonSize;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _minimumHorizontalPadding = 40;
        _textTopMargin = 15;
        _buttonTopMargin = 4;
        _buttonExpansion = CGSizeMake(30, 6);
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        _imageView = imageView;
        
        TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        label.font = XYFontMake(16);
        label.textColor = YYNeutral8Color;
        label.textAlignment = NSTextAlignmentCenter;
        label.kern = 0.5;
        label.lineSpacing = 5;
        label.numberOfLines = 0;
        [self addSubview:label];
        _textLabel = label;
        
        XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:YYTheme3Color forState:UIControlStateNormal];
        [button.titleLabel setFont:XYFontMake(14)];
        [self addSubview:button];
        _operationButton = button;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat y = 0;
    if (!XYSizeIsEmpty(_imageSize)) {
        _imageView.frame = (CGRect){(self.xy_width - _imageSize.width) / 2, y, _imageSize};
        y += _imageSize.height;
    }
    if (!XYSizeIsEmpty(_textSize)) {
        _textLabel.frame = (CGRect){(self.xy_width - _textSize.width) / 2, y + _textTopMargin, _textSize};
        y += (_textSize.height + _textTopMargin);
    }
    if (!XYSizeIsEmpty(_buttonSize)) {
        _operationButton.frame = (CGRect){(self.xy_width - _buttonSize.width) / 2, y + _buttonTopMargin, _buttonSize};
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (XYSizeIsEmpty(size)) return CGSizeZero;
    
    CGFloat maxContentWidth = size.width - _minimumHorizontalPadding * 2;
    CGFloat contentWidth = 0;
    CGFloat contentHeight = 0;
    
    // 图片大小
    if (_imageView.image) {
        _imageSize = _fixedImageSize;
        if (XYSizeIsEmpty(_imageSize)) {
            _imageSize = _imageView.image.size;
        }
        CGFloat imageRadio = _imageSize.height / _imageSize.width;
        CGFloat imageWidth = MIN(_imageSize.width, maxContentWidth);
        _imageSize = CGSizeMake(imageWidth, imageWidth * imageRadio);
        contentWidth = _imageSize.width;
        contentHeight = _imageSize.height;
    }
    
    // 文字大小
    if (_textLabel.text) {
        _textSize = [_textLabel sizeThatFits:CGSizeMake(maxContentWidth, HUGE)];
        contentWidth = MAX(contentWidth, _textSize.width);
        contentHeight += (_textSize.height + _textTopMargin);
    }
    
    // 按钮大小
    if (_operationButton.imageView.image || _operationButton.titleLabel.text) {
        CGSize buttonSize = [_operationButton sizeThatFits:CGSizeMake(maxContentWidth, HUGE)];
        _buttonSize = CGSizeMake(MIN(buttonSize.width + _buttonExpansion.width, maxContentWidth), buttonSize.height + _buttonExpansion.height);
        contentWidth = MAX(contentWidth, _buttonSize.width);
        contentHeight += (_buttonSize.height + _buttonTopMargin);
    }

    return CGSizeMake(contentWidth, contentHeight);
}

@end
