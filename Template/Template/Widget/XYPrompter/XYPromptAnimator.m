//
//  XYPromptAnimator.m
//  XYPrompter
//
//  Created by nevsee on 2018/9/20.
//

#import "XYPromptAnimator.h"
#import "XYPromptContainerController.h"

XYPromptAnimationStyle const XYPromptAnimationStyleNone = @"XYPromptAnimationStyleNone";
XYPromptAnimationStyle const XYPromptAnimationStyleBounce = @"XYPromptAnimationStyleBounce";
XYPromptAnimationStyle const XYPromptAnimationStyleZoom = @"XYPromptAnimationStyleZoom";
XYPromptAnimationStyle const XYPromptAnimationStyleFade = @"XYPromptAnimationStyleFade";
XYPromptAnimationStyle const XYPromptAnimationStyleSlipTop = @"XYPromptAnimationStyleSlipTop";
XYPromptAnimationStyle const XYPromptAnimationStyleSlipLeft = @"XYPromptAnimationStyleSlipLeft";
XYPromptAnimationStyle const XYPromptAnimationStyleSlipBottom = @"XYPromptAnimationStyleSlipBottom";
XYPromptAnimationStyle const XYPromptAnimationStyleSlipRight = @"XYPromptAnimationStyleSlipRight";

static NSMutableDictionary *animationDescribers;

@interface XYPromptAnimator ()
@property (nonatomic, weak, readwrite) UIView *animationView;
@property (nonatomic, weak, readwrite) XYPromptContainerController *animationController;
@property (nonatomic, strong) NSObject<XYPromptAnimationDescriber> *presentDescriber;
@property (nonatomic, strong) NSObject<XYPromptAnimationDescriber> *dismissDescriber;
@end

@implementation XYPromptAnimator

+ (void)initialize {
    if (!animationDescribers) {
        animationDescribers = [NSMutableDictionary dictionary];
    }
    animationDescribers[XYPromptAnimationStyleNone] = @"_XYPromptAnimationNoneDescriber";
    animationDescribers[XYPromptAnimationStyleBounce] = @"_XYPromptAnimationBounceDescriber";
    animationDescribers[XYPromptAnimationStyleZoom] = @"_XYPromptAnimationZoomDescriber";
    animationDescribers[XYPromptAnimationStyleFade] = @"_XYPromptAnimationFadeDescriber";
    animationDescribers[XYPromptAnimationStyleSlipTop] = @"_XYPromptAnimationSlipDescriber";
    animationDescribers[XYPromptAnimationStyleSlipLeft] = @"_XYPromptAnimationSlipDescriber";
    animationDescribers[XYPromptAnimationStyleSlipBottom] = @"_XYPromptAnimationSlipDescriber";
    animationDescribers[XYPromptAnimationStyleSlipRight] = @"_XYPromptAnimationSlipDescriber";
}

- (void)presentAnimation:(void (^)(BOOL))completion {
    [_presentDescriber animateWithAnimator:self present:YES completion:completion];
}

- (void)dismissAnimation:(void (^)(BOOL))completion {
    [_dismissDescriber animateWithAnimator:self present:NO completion:completion];
}

+ (void)registerAnimationDescriber:(NSString *)describer forStyle:(XYPromptAnimationStyle)style {
    if (!animationDescribers || !style) return;
    if (!animationDescribers) {
        animationDescribers = [NSMutableDictionary dictionary];
    }
    [animationDescribers setObject:describer forKey:style];
}

- (void)setPresentStyle:(XYPromptAnimationStyle)presentStyle {
    _presentStyle = presentStyle;
    NSString *describerName = animationDescribers[presentStyle];
    _presentDescriber = [[NSClassFromString(describerName) alloc] init];
}

- (void)setDismissStyle:(XYPromptAnimationStyle)dismissStyle {
    _dismissStyle = dismissStyle;
    NSString *describerName = animationDescribers[dismissStyle];
    _dismissDescriber = [[NSClassFromString(describerName) alloc] init];
}

- (NSTimeInterval)presentDuration {
    if (_presentDuration > 0) return _presentDuration;
    return _presentDescriber.presentDuration;
}

- (NSTimeInterval)dismissDuration {
    if (_dismissDuration > 0) return _dismissDuration;
    return _dismissDescriber.dismissDuration;
}

@end

#pragma mark -
@interface _XYPromptAnimationNoneDescriber : NSObject <XYPromptAnimationDescriber>
@end

@implementation _XYPromptAnimationNoneDescriber

- (NSTimeInterval)presentDuration {
    return 0;
}

- (NSTimeInterval)dismissDuration {
    return 0;
}

- (void)animateWithAnimator:(XYPromptAnimator *)animator present:(BOOL)present completion:(void (^)(BOOL))completion {
    NSTimeInterval duration = present ? animator.presentDuration : animator.dismissDuration;
    [UIView animateWithDuration:duration animations:^{
    } completion:^(BOOL finished) {
        if (completion) completion(finished);
    }];
}

@end


@interface _XYPromptAnimationBounceDescriber : NSObject <XYPromptAnimationDescriber>
@end

@implementation _XYPromptAnimationBounceDescriber

- (NSTimeInterval)presentDuration {
    return 0.5;
}

- (NSTimeInterval)dismissDuration {
    return 0.25;
}

- (void)animateWithAnimator:(XYPromptAnimator *)animator present:(BOOL)present completion:(void (^)(BOOL))completion {
    UIView *animationView = animator.animationView;
    if (!animationView) {
        if (completion) completion(YES);
        return;
    }
    
    UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut;
    
    if (present) {
        animationView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        [UIView animateWithDuration:animator.presentDuration delay:0 usingSpringWithDamping:0.45 initialSpringVelocity:0 options:option animations:^{
            animationView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (completion) completion(finished);
        }];
    } else {
        [UIView animateWithDuration:animator.dismissDuration delay:0 options:option animations:^{
            animationView.alpha = 0;
            animationView.transform = CGAffineTransformMakeScale(0.6, 0.6);
        } completion:^(BOOL finished) {
            animationView.alpha = 1;
            animationView.transform = CGAffineTransformIdentity;
            if (completion) completion(finished);
        }];
    }
}

@end

@interface _XYPromptAnimationZoomDescriber : NSObject <XYPromptAnimationDescriber>
@end

@implementation _XYPromptAnimationZoomDescriber

- (NSTimeInterval)presentDuration {
    return 0.25;
}

- (NSTimeInterval)dismissDuration {
    return 0.25;
}

- (void)animateWithAnimator:(XYPromptAnimator *)animator present:(BOOL)present completion:(void (^)(BOOL))completion {
    UIView *animationView = animator.animationView;
    if (!animationView) {
        if (completion) completion(YES);
        return;
    }
    
    UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut;
    
    if (present) {
        animationView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:animator.presentDuration delay:0 options:option animations:^{
            animationView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (completion) completion(finished);
        }];
    } else {
        [UIView animateWithDuration:animator.dismissDuration delay:0 options:option animations:^{
            animationView.alpha = 0;
            animationView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            animationView.alpha = 1;
            animationView.transform = CGAffineTransformIdentity;
            if (completion) completion(finished);
        }];
    }
}

@end

@interface _XYPromptAnimationFadeDescriber : NSObject <XYPromptAnimationDescriber>
@end

@implementation _XYPromptAnimationFadeDescriber

- (NSTimeInterval)presentDuration {
    return 0.2;
}

- (NSTimeInterval)dismissDuration {
    return 0.15;
}

- (void)animateWithAnimator:(XYPromptAnimator *)animator present:(BOOL)present completion:(void (^)(BOOL))completion {
    UIView *animationView = animator.animationView;
    if (!animationView) {
        if (completion) completion(YES);
        return;
    }

    UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut;

    if (present) {
        animationView.alpha = 0;
        [UIView animateWithDuration:animator.presentDuration delay:0 options:option animations:^{
            animationView.alpha = 1;
        } completion:^(BOOL finished) {
            if (completion) completion(finished);
        }];
    } else {
        [UIView animateWithDuration:animator.dismissDuration delay:0 options:option animations:^{
            animationView.alpha = 0;
        } completion:^(BOOL finished) {
            animationView.alpha = 1;
            if (completion) completion(finished);
        }];
    }
}

@end

@interface _XYPromptAnimationSlipDescriber : NSObject <XYPromptAnimationDescriber>
@end

@implementation _XYPromptAnimationSlipDescriber

- (NSTimeInterval)presentDuration {
    return 0.5;
}

- (NSTimeInterval)dismissDuration {
    return 0.35;
}

- (void)animateWithAnimator:(XYPromptAnimator *)animator present:(BOOL)present completion:(void (^)(BOOL))completion {
    UIView *animationView = animator.animationView;
    if (!animationView) {
        if (completion) completion(YES);
        return;
    }

    UIView *containerView = animator.animationController.view;
    CGRect cf = containerView.bounds;
    CGRect af = animationView.frame;
    CGRect tf = CGRectZero;
    
    UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut;

    if (present) {
        if (animator.presentStyle == XYPromptAnimationStyleSlipTop) tf = (CGRect){af.origin.x, -cf.size.height, af.size};
        else if (animator.presentStyle == XYPromptAnimationStyleSlipLeft) tf = (CGRect){-cf.size.width, af.origin.y, af.size};
        else if (animator.presentStyle == XYPromptAnimationStyleSlipBottom) tf = (CGRect){af.origin.x, cf.size.height, af.size};
        else if (animator.presentStyle == XYPromptAnimationStyleSlipRight) tf = (CGRect){cf.size.width, af.origin.y, af.size};
        animationView.frame = tf;

        [UIView animateWithDuration:animator.presentDuration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:option animations:^{
            animationView.frame = af;
        } completion:^(BOOL finished) {
            if (completion) completion(finished);
        }];
    } else {
        if (animator.dismissStyle == XYPromptAnimationStyleSlipTop) tf = (CGRect){af.origin.x, -af.size.height, af.size};
        else if (animator.dismissStyle == XYPromptAnimationStyleSlipLeft) tf = (CGRect){-af.size.width, af.origin.y, af.size};
        else if (animator.dismissStyle == XYPromptAnimationStyleSlipBottom) tf = (CGRect){af.origin.x, cf.size.height, af.size};
        else if (animator.dismissStyle == XYPromptAnimationStyleSlipRight) tf = (CGRect){cf.size.width, af.origin.y, af.size};

        [UIView animateWithDuration:animator.dismissDuration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:option animations:^{
            animationView.frame = tf;
        } completion:^(BOOL finished) {
            if (completion) completion(finished);
        }];
    }
}

@end
