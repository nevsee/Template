//
//  XYToastView.m
//  XYToastView
//
//  Created by nevsee on 2017/3/13.
//

#import "XYToastView.h"
#import <objc/runtime.h>

@interface _XYToastViewDeallocMonitor : NSObject
@property (nonatomic, copy) void (^block)(__unsafe_unretained id target);
@property (nonatomic, unsafe_unretained) id target;
@end

@implementation _XYToastViewDeallocMonitor
- (void)dealloc {
    if (_block) _block(_target);
}
@end

@interface UIView (XYToast)
- (void)_xy_startDeallocMonitor:(void (^)(__unsafe_unretained id target))block;
@end

@implementation UIView (XYToast)
- (void)_xy_startDeallocMonitor:(void (^)(__unsafe_unretained id))block {
    _XYToastViewDeallocMonitor *monitor = objc_getAssociatedObject(self, _cmd);
    if (!monitor) {
        monitor = [[_XYToastViewDeallocMonitor alloc] init];
        monitor.block = block;
        monitor.target = self;
        objc_setAssociatedObject(self, _cmd, monitor, OBJC_ASSOCIATION_RETAIN);
    }
}
@end

#pragma mark -

static NSMutableArray<XYToastView *> *toastHolders;

@interface XYToastView ()
@property (nonatomic, strong, readwrite) UIView *maskView;
@property (nonatomic, assign, readwrite) BOOL isVisible;
@property (nonatomic, weak) NSTimer *hideDelayTimer;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) BOOL hiddenAnimated;
@end

@implementation XYToastView

#pragma mark # Life

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        [self parameterSetup:view];
        [self startDeallocMonitorForView:view];
        [self userInterfaceSetup];
    }
    return self;
}

- (void)dealloc {
    [_hideDelayTimer invalidate];
    _hideDelayTimer = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self calculateLayouts];
}

- (void)parameterSetup:(UIView *)view {
    _parentView = view;
    _position = XYToastViewPositionCenter;
    _animator = [[XYToastAnimator alloc] init];
    _animator.showStyle = XYToastAnimationStyleFade;
    _animator.hideStyle = XYToastAnimationStyleFade;
    _animator.toastView = self;
    _contentInsets = UIEdgeInsetsZero;
    _contentOffset = CGPointZero;
    _definesDismissalTouch = NO;
    _definesSafeAreaAdaptation = YES;
    _hiddenAnimated = YES;
}

- (void)userInterfaceSetup {
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)];
    
    UIView *maskView = [[UIView alloc] init];
    [maskView addGestureRecognizer:ges];
    [self addSubview:maskView];
    _maskView = maskView;
    
    XYToastDefaultBackgroundView *backgroundView = [[XYToastDefaultBackgroundView alloc] init];
    backgroundView.toastView = self;
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;

    XYToastDefaultContentView *contentView = [[XYToastDefaultContentView alloc] init];
    contentView.toastView = self;
    [backgroundView addSubview:contentView];
    _contentView = contentView;
}

#pragma mark # Action

- (void)dismissAction {
    if (!_definesDismissalTouch) return;
    [self hideAnimated:_hiddenAnimated];
}

- (void)hideAction:(NSTimer *)timer {
    [self hideAnimated:_hiddenAnimated];
}

#pragma mark # Method

// Private
- (void)calculateLayouts {
    if (!_contentView) return;
    
    self.frame = _parentView.bounds;
    
    // mask view
    _maskView.frame = _parentView.bounds;
    
    // content view
    CGFloat hi = self.insets.left + self.insets.right; // horizontal interval
    CGFloat vi = self.insets.top + self.insets.bottom; // vertical interval
    
    CGSize ts = self.frame.size; // toast view size
    CGSize es = CGSizeMake(ts.width - hi, ts.height - vi); // effective area size
    CGSize cs = [_contentView sizeThatFits:es]; // content view size
    CGFloat cx = _contentOffset.x, cy = _contentOffset.y, cw = cs.width, ch = cs.height;
    
    switch (_position) {
        case XYToastViewPositionCenter:
            cx += (es.width - cs.width) / 2 + self.insets.left;
            cy += (es.height - cs.height) / 2 + self.insets.top;
            break;
        case XYToastViewPositionTop:
            cx += (es.width - cs.width) / 2 + self.insets.left;
            cy += self.insets.top;
            break;
        case XYToastViewPositionLeft:
            cx += self.insets.left;
            cy += (es.height - cs.height) / 2 + self.insets.top;
            break;
        case XYToastViewPositionBottom:
            cx += (es.width - cs.width) / 2 + self.insets.left;
            cy += es.height - cs.height + self.insets.top;
            break;
        case XYToastViewPositionRight:
            cx += es.width - cs.width + self.insets.left;
            cy += (es.height - cs.height) / 2 + self.insets.top;
            break;
    }
    
    cx = floorf(cx); cy = floorf(cy); cw = floorf(cw); ch = floorf(ch);
    if (!CGSizeEqualToSize(_backgroundView.frame.size, _contentView.frame.size)) return;
    
    _backgroundView.frame = CGRectMake(cx, cy, cw, ch);
    _contentView.frame = CGRectMake(0, 0, cw, ch);
}

- (void)startDeallocMonitorForView:(UIView *)view {
    // 监测到父视图释放后，移除吐司
    __weak typeof(self) weak = self;
    [view _xy_startDeallocMonitor:^(__unsafe_unretained id target) {
        __strong typeof(weak) self = weak;
        if (!self) return;
        [toastHolders removeObject:self];
    }];
}

// public
- (void)showAnimated:(BOOL)animated {
    [XYToastView invoke:^{
        if (self.isVisible) return;
        [self setIsVisible:YES];
        [self.parentView addSubview:self];
        if (animated) {
            __weak __typeof(self) weakSelf = self;
            [self.animator showWithCompletion:^(BOOL finished) {
                __strong __typeof(weakSelf) self = weakSelf;
                if (!self) return;
                if (self.didShowBlock) self.didShowBlock(self.parentView);
            }];
        } else {
            if (self.didShowBlock) self.didShowBlock(self.parentView);
        }
    } forToast:self addition:YES];
}

- (void)hideAnimated:(BOOL)animated {
    [XYToastView invoke:^{
        if (!self.isVisible) return;
        [self setIsVisible:NO];
        [self.hideDelayTimer invalidate];
        if (animated) {
            __weak __typeof(self) weakSelf = self;
            [self.animator hideWithCompletion:^(BOOL finished) {
                __strong __typeof(weakSelf) self = weakSelf;
                if (!self) return;
                [self removeFromSuperview];
                if (self.didHideBlock) self.didHideBlock(self.parentView);
            }];
        } else {
            [self removeFromSuperview];
            if (self.didHideBlock) self.didHideBlock(self.parentView);
        }
    } forToast:self addition:NO];
}

- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    _hiddenAnimated = animated;
    NSTimer *delayTimer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(hideAction:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:delayTimer forMode:NSRunLoopCommonModes];
    [self setHideDelayTimer:delayTimer];
}

+ (void)invoke:(void (NS_NOESCAPE ^)(void))block forToast:(XYToastView *)toast addition:(BOOL)addition {
    if (!toastHolders) toastHolders = [NSMutableArray array];
    if (block) block();
    if (!toast) return;
    if (addition) [toastHolders addObject:toast];
    else [toastHolders removeObject:toast];
}

#pragma mark # Access

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
}

- (void)setAnimator:(XYToastAnimator *)animator {
    _animator = animator;
    _animator.toastView = self;
}

- (void)setBackgroundView:(XYToastBackgroundView *)backgroundView {
    if (_backgroundView) {
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
    }
    backgroundView.toastView = self;
    [backgroundView addSubview:_contentView];
    _backgroundView = backgroundView;
    [self addSubview:backgroundView];
    [self setNeedsLayout];
    
}

- (void)setContentView:(XYToastContentView *)contentView {
    if (_contentView) {
        [_contentView removeFromSuperview];
        _contentView = nil;
    }
    contentView.toastView = self;
    [_backgroundView addSubview:contentView];
    _contentView = contentView;
    [self setNeedsLayout];
}

- (UIEdgeInsets)insets {
    if (_definesSafeAreaAdaptation) {
        if (@available(iOS 11.0, *)) {
            return UIEdgeInsetsMake(_contentInsets.top + self.safeAreaInsets.top, _contentInsets.left + self.safeAreaInsets.left, _contentInsets.bottom + self.safeAreaInsets.bottom, _contentInsets.right + self.safeAreaInsets.right);
        } else {
            return _contentInsets;
        }
    } else {
        return _contentInsets;
    }
}

@end

#pragma mark -

@implementation XYToastView (XYAdd)

+ (XYToastView *)topToastInView:(UIView *)view {
    return [self allToastInView:view].lastObject;
}

+ (NSArray<XYToastView *> *)allToastInView:(UIView *)view {
    if (!view) return nil;
    if (toastHolders.count == 0) return nil;
    
    NSMutableArray *toasts = [[NSMutableArray alloc] init];
    for (UIView *toastView in toastHolders) {
        if ([toastView.superview isEqual:view] && [toastView isKindOfClass:self]) {
            [toasts addObject:toastView];
        }
    }
    return toasts.count > 0 ? [toasts mutableCopy] : nil;
}

@end
