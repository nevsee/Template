//
//  XYPopupAnimator.m
//  XYPopupView
//
//  Created by nevsee on 2017/12/11.
//

#import "XYPopupAnimator.h"
#import "XYPopupView.h"

XYPopupAnimationStyle const XYPopupAnimationStyleNone = @"XYPopupAnimationStyleNone";
XYPopupAnimationStyle const XYPopupAnimationStyleBounce = @"XYPopupAnimationStyleBounce";
XYPopupAnimationStyle const XYPopupAnimationStyleZoom = @"XYPopupAnimationStyleZoom";
XYPopupAnimationStyle const XYPopupAnimationStyleFade = @"XYPopupAnimationStyleFade";

static NSMutableDictionary *animationDescribers;

@interface XYPopupAnimator ()
@property (nonatomic, strong) NSObject<XYPopupAnimationDescriber> *showDescriber;
@property (nonatomic, strong) NSObject<XYPopupAnimationDescriber> *hideDescriber;
@end

@implementation XYPopupAnimator

+ (void)initialize {
    if (!animationDescribers) {
        animationDescribers = [NSMutableDictionary dictionary];
    }
    animationDescribers[XYPopupAnimationStyleBounce] = @"_XYPopupAnimationBounceDescriber";
    animationDescribers[XYPopupAnimationStyleZoom] = @"_XYPopupAnimationZoomDescriber";
    animationDescribers[XYPopupAnimationStyleFade] = @"_XYPopupAnimationFadeDescriber";
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

+ (void)registerAnimationDescriber:(NSString *)describer forStyle:(XYPopupAnimationStyle)style {
    if (!animationDescribers || !style) return;
    if (!animationDescribers) {
        animationDescribers = [NSMutableDictionary dictionary];
    }
    [animationDescribers setObject:describer forKey:style];
}

- (void)setShowStyle:(XYPopupAnimationStyle)showStyle {
    _showStyle = showStyle;
    NSString *describerName = animationDescribers[showStyle];
    _showDescriber = [[NSClassFromString(describerName) alloc] init];
}

- (void)setHideStyle:(XYPopupAnimationStyle)hideStyle {
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

@interface _XYPopupAnimationBounceDescriber : NSObject <XYPopupAnimationDescriber>
@end

@implementation _XYPopupAnimationBounceDescriber

- (NSTimeInterval)showDuration {
    return 0.5;
}

- (NSTimeInterval)hideDuration {
    return 0.15;
}

- (void)animateWithAnimator:(XYPopupAnimator *)animator show:(BOOL)show completion:(void (^)(BOOL))completion {
    XYPopupCarrierView *animationView = animator.popupView.carrierView;
    UIView *maskView = animator.popupView.maskView;
    if (!animationView) {
        if (completion) completion(YES);
        return;
    }
    
    [animator.popupView setNeedsLayout];
    [animator.popupView layoutIfNeeded];
    
    // set anchor point
    CGRect frame = animationView.frame;
    if (frame.size.width > 0 && frame.size.height > 0) {
        CGFloat x = CGRectGetMidX(animationView.arrowRect) / frame.size.width;
        CGFloat y = CGRectGetMidY(animationView.arrowRect) / frame.size.height;
        animationView.layer.anchorPoint = CGPointMake(x, y);
        animationView.frame = frame;
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

@interface _XYPopupAnimationZoomDescriber : NSObject <XYPopupAnimationDescriber>
@end

@implementation _XYPopupAnimationZoomDescriber

- (NSTimeInterval)showDuration {
    return 0.25;
}

- (NSTimeInterval)hideDuration {
    return 0.25;
}

- (void)animateWithAnimator:(XYPopupAnimator *)animator show:(BOOL)show completion:(void (^)(BOOL))completion {
    XYPopupCarrierView *animationView = animator.popupView.carrierView;
    UIView *maskView = animator.popupView.maskView;
    if (!animationView) {
        if (completion) completion(YES);
        return;
    }
    
    [animator.popupView setNeedsLayout];
    [animator.popupView layoutIfNeeded];
    
    // set anchor point
    CGRect frame = animationView.frame;
    if (frame.size.width > 0 && frame.size.height > 0) {
        CGFloat x = CGRectGetMidX(animationView.arrowRect) / frame.size.width;
        CGFloat y = CGRectGetMidY(animationView.arrowRect) / frame.size.height;
        animationView.layer.anchorPoint = CGPointMake(x, y);
        animationView.frame = frame;
    }
    
    UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction;
    
    if (show) {
        animationView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        maskView.alpha = 0;
        [UIView animateWithDuration:self.showDuration delay:0 options:option animations:^{
            animationView.transform = CGAffineTransformIdentity;
            maskView.alpha = 1;
        } completion:^(BOOL finished) {
            if (completion) completion(finished);
        }];
    } else {
        [UIView animateWithDuration:self.hideDuration delay:0 options:option animations:^{
            animationView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            animationView.alpha = 0;
            maskView.alpha = 0;
        } completion:^(BOOL finished) {
            animationView.transform = CGAffineTransformIdentity;
            animationView.alpha = 1;
            if (completion) completion(finished);
        }];
    }
}

@end

@interface _XYPopupAnimationFadeDescriber : NSObject <XYPopupAnimationDescriber>
@end

@implementation _XYPopupAnimationFadeDescriber

- (NSTimeInterval)showDuration {
    return 0.2;
}

- (NSTimeInterval)hideDuration {
    return 0.15;
}

- (void)animateWithAnimator:(XYPopupAnimator *)animator show:(BOOL)show completion:(void (^)(BOOL))completion {
    XYPopupCarrierView *animationView = animator.popupView.carrierView;
    UIView *maskView = animator.popupView.maskView;
    if (!animationView) {
        if (completion) completion(YES);
        return;
    }
    
    UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction;
    
    if (show) {
        animationView.alpha = 0;
        maskView.alpha = 0;
        [UIView animateWithDuration:self.showDuration delay:0 options:option animations:^{
            animationView.alpha = 1;
            maskView.alpha = 1;
        } completion:^(BOOL finished) {
            if (completion) completion(finished);
        }];
    } else {
        [UIView animateWithDuration:self.hideDuration delay:0 options:option animations:^{
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
