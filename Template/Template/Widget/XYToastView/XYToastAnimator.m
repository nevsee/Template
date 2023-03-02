//
//  XYToastAnimator.m
//  XYToastView
//
//  Created by nevsee on 2017/3/13.
//

#import "XYToastAnimator.h"
#import "XYToastView.h"

XYToastAnimationStyle const XYToastAnimationStyleBounce = @"XYToastAnimationStyleBounce";
XYToastAnimationStyle const XYToastAnimationStyleZoom = @"XYToastAnimationStyleZoom";
XYToastAnimationStyle const XYToastAnimationStyleFade = @"XYToastAnimationStyleFade";
XYToastAnimationStyle const XYToastAnimationStyleSlipTop = @"XYToastAnimationStyleSlipTop";
XYToastAnimationStyle const XYToastAnimationStyleSlipLeft = @"XYToastAnimationStyleSlipLeft";
XYToastAnimationStyle const XYToastAnimationStyleSlipBottom = @"XYToastAnimationStyleSlipBottom";
XYToastAnimationStyle const XYToastAnimationStyleSlipRight = @"XYToastAnimationStyleSlipRight";

static NSMutableDictionary *animationDescribers;

@interface XYToastAnimator ()
@property (nonatomic, strong) NSObject<XYToastAnimatorDescriber> *showDescriber;
@property (nonatomic, strong) NSObject<XYToastAnimatorDescriber> *hideDescriber;
@end

@implementation XYToastAnimator

#pragma mark # Life

+ (void)initialize {
    if (!animationDescribers) {
        animationDescribers = [NSMutableDictionary dictionary];
    }
    animationDescribers[XYToastAnimationStyleBounce] = @"_XYToastAnimationBounceDescriber";
    animationDescribers[XYToastAnimationStyleZoom] = @"_XYToastAnimationZoomDescriber";
    animationDescribers[XYToastAnimationStyleFade] = @"_XYToastAnimationFadeDescriber";
    animationDescribers[XYToastAnimationStyleSlipTop] = @"_XYToastAnimationSlipDescriber";
    animationDescribers[XYToastAnimationStyleSlipLeft] = @"_XYToastAnimationSlipDescriber";
    animationDescribers[XYToastAnimationStyleSlipBottom] = @"_XYToastAnimationSlipDescriber";
    animationDescribers[XYToastAnimationStyleSlipRight] = @"_XYToastAnimationSlipDescriber";
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isShowing = NO;
        _isAnimating = NO;
    }
    return self;
}

- (void)showWithCompletion:(void (^)(BOOL))completion {
    _isShowing = YES;
    _isAnimating = YES;
    __weak __typeof(self) weak = self;
    [self.showDescriber animateWithAnimator:self show:YES completion:^(BOOL finished) {
        __strong __typeof(weak) self = weak;
        self.isAnimating = NO;
        if (completion) completion(finished);
    }];
}

- (void)hideWithCompletion:(void (^)(BOOL))completion {
    _isShowing = NO;
    _isAnimating = YES;
    __weak __typeof(self) weak = self;
    [self.hideDescriber animateWithAnimator:self show:NO completion:^(BOOL finished) {
        __strong __typeof(weak) self = weak;
        self.isAnimating = NO;
        if (completion) completion(finished);
    }];
}

+ (void)registerAnimationDescriber:(NSString *)describer forStyle:(XYToastAnimationStyle)style {
    if (!animationDescribers || !style) return;
    if (!animationDescribers) {
        animationDescribers = [NSMutableDictionary dictionary];
    }
    [animationDescribers setObject:describer forKey:style];
}

- (void)setShowStyle:(XYToastAnimationStyle)showStyle {
    _showStyle = showStyle;
    NSString *describerName = animationDescribers[showStyle];
    _showDescriber = [[NSClassFromString(describerName) alloc] init];
}

- (void)setHideStyle:(XYToastAnimationStyle)hideStyle {
    _hideStyle = hideStyle;
    NSString *describerName = animationDescribers[hideStyle];
    _hideDescriber = [[NSClassFromString(describerName) alloc] init];
}

- (NSTimeInterval)showDuration {
    if (_showDuration > 0) return _showDuration;
    return _showDescriber.showDuration;
}

- (NSTimeInterval)hideDuration {
    if (_hideDuration > 0) return _hideDuration;
    return _hideDescriber.hideDuration;
}

@end

#pragma mark -

@interface _XYToastAnimationBounceDescriber : NSObject <XYToastAnimatorDescriber>
@end

@implementation _XYToastAnimationBounceDescriber

- (NSTimeInterval)showDuration {
    return 0.5;
}

- (NSTimeInterval)hideDuration {
    return 0.25;
}

- (void)animateWithAnimator:(XYToastAnimator *)animator show:(BOOL)show completion:(void (^)(BOOL))completion {
    XYToastBackgroundView *animationView = animator.toastView.backgroundView;
    UIView *maskView = animator.toastView.maskView;
    if (!animationView) {
        if (completion) completion(YES);
        return;
    }
    
    UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction;
    
    if (show) {
        animationView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        maskView.alpha = 0;
        [UIView animateWithDuration:animator.showDuration delay:0 usingSpringWithDamping:0.45 initialSpringVelocity:0 options:option animations:^{
            animationView.transform = CGAffineTransformIdentity;
            maskView.alpha = 1;
        } completion:^(BOOL finished) {
            if (completion) completion(finished);
        }];
    } else {
        [UIView animateWithDuration:animator.hideDuration delay:0 options:option animations:^{
            animationView.transform = CGAffineTransformMakeScale(0.6, 0.6);
            animationView.alpha = 0;
            maskView.alpha = 0;
        } completion:^(BOOL finished) {
            animationView.transform = CGAffineTransformIdentity;
            animationView.alpha = 1;
            maskView.alpha = 1;
            if (completion) completion(finished);
        }];
    }
}

@end

@interface _XYToastAnimationZoomDescriber : NSObject <XYToastAnimatorDescriber>
@end

@implementation _XYToastAnimationZoomDescriber

- (NSTimeInterval)showDuration {
    return 0.25;
}

- (NSTimeInterval)hideDuration {
    return 0.25;
}

- (void)animateWithAnimator:(XYToastAnimator *)animator show:(BOOL)show completion:(void (^)(BOOL))completion {
    XYToastBackgroundView *animationView = animator.toastView.backgroundView;
    UIView *maskView = animator.toastView.maskView;
    if (!animationView) {
        if (completion) completion(YES);
        return;
    }
    
    UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction;
    
    if (show) {
        animationView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        maskView.alpha = 0;
        [UIView animateWithDuration:animator.showDuration delay:0 options:option animations:^{
            animationView.transform = CGAffineTransformIdentity;
            maskView.alpha = 1;
        } completion:^(BOOL finished) {
            if (completion) completion(finished);
        }];
    } else {
        [UIView animateWithDuration:animator.hideDuration delay:0 options:option animations:^{
            animationView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            animationView.alpha = 0;
            maskView.alpha = 0;
        } completion:^(BOOL finished) {
            animationView.transform = CGAffineTransformIdentity;
            animationView.alpha = 1;
            maskView.alpha = 1;
            if (completion) completion(finished);
        }];
    }
}

@end

@interface _XYToastAnimationFadeDescriber : NSObject <XYToastAnimatorDescriber>
@end

@implementation _XYToastAnimationFadeDescriber

- (NSTimeInterval)showDuration {
    return 0.2;
}

- (NSTimeInterval)hideDuration {
    return 0.15;
}

- (void)animateWithAnimator:(XYToastAnimator *)animator show:(BOOL)show completion:(void (^)(BOOL))completion {
    XYToastBackgroundView *animationView = animator.toastView.backgroundView;
    UIView *maskView = animator.toastView.maskView;
    if (!animationView) {
        if (completion) completion(YES);
        return;
    }
    
    UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction;

    if (show) {
        animationView.alpha = 0;
        maskView.alpha = 0;
        [UIView animateWithDuration:animator.showDuration delay:0 options:option animations:^{
            animationView.alpha = 1;
            maskView.alpha = 1;
        } completion:^(BOOL finished) {
            if (completion) completion(finished);
        }];
    } else {
        [UIView animateWithDuration:animator.hideDuration delay:0 options:option animations:^{
            animationView.alpha = 0;
            maskView.alpha = 0;
        } completion:^(BOOL finished) {
            animationView.alpha = 1;
            maskView.alpha = 1;
            if (completion) completion(finished);
        }];
    }
}

@end

@interface _XYToastAnimationSlipDescriber : NSObject <XYToastAnimatorDescriber>
@end

@implementation _XYToastAnimationSlipDescriber

- (NSTimeInterval)showDuration {
    return 0.5;
}

- (NSTimeInterval)hideDuration {
    return 0.35;
}

- (void)animateWithAnimator:(XYToastAnimator *)animator show:(BOOL)show completion:(void (^)(BOOL))completion {
    XYToastBackgroundView *animationView = animator.toastView.backgroundView;
    UIView *maskView = animator.toastView.maskView;
    [animator.toastView setNeedsLayout];
    [animator.toastView layoutIfNeeded];
    
    if (!animationView) {
        if (completion) completion(YES);
        return;
    }
    
    UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction;
    
    CGRect cf = animator.toastView.parentView.bounds;
    CGRect af = animationView.frame;
    CGRect tf = CGRectZero;
    
    if (show) {
        if (animator.showStyle == XYToastAnimationStyleSlipTop) tf = (CGRect){af.origin.x, -af.size.height, af.size};
        else if (animator.showStyle == XYToastAnimationStyleSlipLeft) tf = (CGRect){-af.size.width, af.origin.y, af.size};
        else if (animator.showStyle == XYToastAnimationStyleSlipBottom) tf = (CGRect){af.origin.x, cf.size.height, af.size};
        else if (animator.showStyle == XYToastAnimationStyleSlipRight) tf = (CGRect){cf.size.width, af.origin.y, af.size};
        animationView.frame = tf;
        
        maskView.alpha = 0;
        [UIView animateWithDuration:animator.showDuration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:option animations:^{
            animationView.frame = af;
            maskView.alpha = 1;
        } completion:^(BOOL finished) {
            if (completion) completion(YES);
        }];
    } else {
        if (animator.hideStyle == XYToastAnimationStyleSlipTop) af = (CGRect){af.origin.x, -af.size.height, af.size};
        else if (animator.hideStyle == XYToastAnimationStyleSlipLeft) af = (CGRect){-af.size.width, af.origin.y, af.size};
        else if (animator.hideStyle == XYToastAnimationStyleSlipBottom) af = (CGRect){af.origin.x, cf.size.height, af.size};
        else if (animator.hideStyle == XYToastAnimationStyleSlipRight) af = (CGRect){cf.size.width, af.origin.y, af.size};
        
        [UIView animateWithDuration:animator.hideDuration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:option animations:^{
            animationView.frame = af;
            maskView.alpha = 0;
        } completion:^(BOOL finished) {
            maskView.alpha = 1;
            if (completion) completion(finished);
        }];
    }
}

@end
