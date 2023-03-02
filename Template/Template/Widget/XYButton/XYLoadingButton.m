//
//  XYLoadingButton.m
//  XYWidget
//
//  Created by nevsee on 2021/2/25.
//

#import "XYLoadingButton.h"
#import "XYWeakProxy.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface XYLoadingButton ()
@property (nonatomic, weak, readwrite) UIView<XYLoadingButtonAnimator> *animator;
@property (nonatomic, weak) NSTimer *delayTimer;
@property (nonatomic, weak) UIView *masker;
@end

@implementation XYLoadingButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType animator:(UIView<XYLoadingButtonAnimator> *)animator {
    XYLoadingButton *button = [self buttonWithType:buttonType];
    if (button) {
        button.dimsButtonWhenHighlighted = NO;
        animator.alpha = 0;
        button.animator = animator;
        [button addSubview:animator];
    }
    return button;
}

- (void)dealloc {
    [_delayTimer invalidate];
    _delayTimer = nil;
    [_masker removeFromSuperview];
    _masker = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_animator setFrame:self.bounds];
}

// Timer
- (void)timingIfNeeded {
    if (_maximumLoadingTime <= 0) return;
    NSTimer *delayTimer = [NSTimer timerWithTimeInterval:_maximumLoadingTime target:self selector:@selector(overtimeAction) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:delayTimer forMode:NSRunLoopCommonModes];
    _delayTimer = delayTimer;
}

- (void)overtimeAction {
    [self stopFailureAnimation];
}

// Mask
- (void)maskingIfNeeded {
    if (!_sourceView) return;
    UIView *masker = [[UIView alloc] initWithFrame:_sourceView.bounds];
    masker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_sourceView addSubview:masker];
    _masker = masker;
}

- (void)startAnimation {
    self.titleLabel.alpha = 0;
    self.imageView.alpha = 0;
    _animator.alpha = 1;
    _animating = YES;
    [self maskingIfNeeded];
    [self timingIfNeeded];
    [_animator startAnimation];
}

- (void)stopAnimation:(XYLoadingResultState)state completion:(void (^)(void))completion {
    __weak typeof(self) weak = self;
    [self.animator stopAnimation:state completion:^{
        __strong typeof(weak) self = weak;
        if (completion) completion();
        self.titleLabel.alpha = 1;
        self.imageView.alpha = 1;
        self.animator.alpha = 0;
        self->_animating = NO;
        [self.masker removeFromSuperview];
        [self.delayTimer invalidate];
    }];
}

- (void)stopAnimation {
    [self stopAnimation:XYLoadingResultStateDefault completion:nil];
}

- (void)stopSuccessAnimation {
    [self stopAnimation:XYLoadingResultStateSuccess completion:nil];
}

- (void)stopFailureAnimation {
    [self stopAnimation:XYLoadingResultStateFailure completion:nil];
}

@end

#pragma mark -

@interface XYLoadingButtonIndicatorView ()
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation XYLoadingButtonIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIActivityIndicatorViewStyle style;
        if (@available(iOS 13.0, *)) {
            style = UIActivityIndicatorViewStyleMedium;
        } else {
            style = UIActivityIndicatorViewStyleWhite;
        }
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        indicator.color = [UIColor whiteColor];
        [self addSubview:indicator];
        _indicator = indicator;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_indicator setCenter:self.center];
}

- (void)startAnimation {
    [_indicator startAnimating];
}

- (void)stopAnimation:(XYLoadingResultState)state completion:(void (^)(void))completion {
    [_indicator stopAnimating];
    if (completion) completion();
}

- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle {
    _indicatorStyle = indicatorStyle;
    _indicator.activityIndicatorViewStyle = indicatorStyle;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    _indicator.color = indicatorColor;
}

@end

#pragma clang diagnostic pop
