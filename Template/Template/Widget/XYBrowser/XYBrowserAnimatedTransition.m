//
//  XYBrowserAnimatedTransition.m
//  XYBrowser
//
//  Created by nevsee on 2022/10/25.
//

#import <objc/runtime.h>
#import "XYBrowserAnimatedTransition.h"
#import "XYBrowserController.h"

@interface XYBrowserAnimatedTransition ()
@property (nonatomic, assign) BOOL prefersSourceViewHidden;
@property (nonatomic, strong) UIView *savedSourceView;
@end

@implementation XYBrowserAnimatedTransition

- (instancetype)init {
    self = [super init];
    if (self) {
        _prefersSourceViewHidden = YES;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (_style == XYBrowserTransitionStyleFade) {
        [self fadeAnimationForTransitionContext:transitionContext];
    } else {
        [self zoomAnimationForTransitionContext:transitionContext];
    }
}
 
- (void)fadeAnimationForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    if (_type == XYBrowserTransitionTypePresent) {
        [containerView addSubview:_browserController.view];
        CGFloat alpha = toView.alpha;
        toView.alpha = 0;
        UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:self.duration delay:0 options:option animations:^{
            toView.alpha = alpha;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:self.duration delay:0 options:option animations:^{
            fromView.alpha = 0;
        } completion:^(BOOL finished) {
            [fromView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

- (void)zoomAnimationForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    if (_type == XYBrowserTransitionTypePresent) {
        [containerView addSubview:toView];
        [toView setNeedsLayout];
        [toView layoutIfNeeded];

        XYBrowserView *browserView = _browserController.browserView;
        UIView<XYBrowserCarrierDescriber> *carrierView = [browserView currentCarrierView];
        UIView *sourceView = _browserController.sourceView ? _browserController.sourceView(browserView.currentIndex) : nil;
        UIView *contentView = carrierView.contentView;

        if (!CGRectEqualToRect(sourceView.frame, CGRectZero) && !CGRectEqualToRect(contentView.frame, CGRectZero)) {
            UIColor *backgroundColor = toView.backgroundColor;
            CGRect sourceRect = [toView convertRect:sourceView.frame fromView:sourceView.superview];
            
            toView.backgroundColor = [backgroundColor colorWithAlphaComponent:0];
            [browserView updateSubviewAlphaExceptCarrier:0];
            [carrierView updateSubviewAlphaExceptPlayer:0];
            
            // update source view hidden state
            if (_prefersSourceViewHidden) {
                sourceView.hidden = YES;
                _savedSourceView = sourceView;
            }
            contentView.hidden = YES;
            
            // add animated view
            UIImageView *animatedView = [[UIImageView alloc] initWithFrame:sourceRect];
            if ([contentView respondsToSelector:@selector(image)]) {
                animatedView.image = ((UIImageView *)contentView).image;
            }
            animatedView.contentMode = contentView.contentMode;
            animatedView.layer.cornerRadius = sourceView.layer.cornerRadius;
            animatedView.layer.masksToBounds = YES;
            [toView addSubview:animatedView];
            
            UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut;
            [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:option animations:^{
                animatedView.frame = contentView.frame;
                animatedView.layer.cornerRadius = 0;
                toView.backgroundColor = backgroundColor;
            } completion:^(BOOL finished) {
                contentView.hidden = NO;
                [animatedView removeFromSuperview];
                [browserView updateSubviewAlphaExceptCarrier:1];
                [carrierView updateSubviewAlphaExceptPlayer:1];
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        } else {
            [self fadeAnimationForTransitionContext:transitionContext];
        }
    } else {
        XYBrowserView *browserView = _browserController.browserView;
        UIView<XYBrowserCarrierDescriber> *carrierView = [browserView currentCarrierView];
        UIView *sourceView = _browserController.sourceView ? _browserController.sourceView(browserView.currentIndex) : nil;
        UIView *contentView = carrierView.contentView;
        
        if (!CGRectEqualToRect(sourceView.frame, CGRectZero) && !CGRectEqualToRect(contentView.frame, CGRectZero)) {
            CGRect sourceRect = [fromView convertRect:sourceView.frame fromView:sourceView.superview];

            [browserView updateSubviewAlphaExceptCarrier:0];
            [carrierView updateSubviewAlphaExceptPlayer:0];
            
            // update source view hidden state
            if (_prefersSourceViewHidden && ![sourceView isEqual:_savedSourceView]) {
                _savedSourceView.hidden = NO;
                sourceView.hidden = YES;
            }
            contentView.hidden = YES;
            
            // add animated view
            UIImageView *animatedView = [[UIImageView alloc] initWithFrame:contentView.frame];
            if ([sourceView respondsToSelector:@selector(image)]) {
                animatedView.image = ((UIImageView *)sourceView).image;
            }
            animatedView.contentMode = sourceView.contentMode;
            animatedView.layer.masksToBounds = YES;
            [fromView addSubview:animatedView];
            
            UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut;
            [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:option animations:^{
                animatedView.frame = sourceRect;
                animatedView.layer.cornerRadius = sourceView.layer.cornerRadius;
                fromView.backgroundColor = [UIColor clearColor];
            } completion:^(BOOL finished) {
                sourceView.hidden = NO;
                [animatedView removeFromSuperview];
                [fromView removeFromSuperview];
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        } else {
            _savedSourceView.hidden = NO;
            [self fadeAnimationForTransitionContext:transitionContext];
        }
    }
}

- (NSTimeInterval)duration {
    if (_duration > 0) return _duration;
    if (_style == XYBrowserTransitionStyleFade) return 0.2;
    else if (_style == XYBrowserTransitionStyleZoom) return 0.4;
    else return 0.2;
}

@end


@implementation XYBrowserAnimatedTransition (XYZoomStyleSupport)

- (void)updateSourceViewStateIfNeeded {
    if (!_browserController.sourceView || !_prefersSourceViewHidden) return;
    if (_style != XYBrowserTransitionStyleZoom) return;
    UIView *currentSourceView = _browserController.sourceView(_browserController.browserView.currentIndex);
    if ([currentSourceView isEqual:_savedSourceView]) return;
    _savedSourceView.hidden = NO;
    _savedSourceView = currentSourceView;
    _savedSourceView.hidden = YES;
}

@end
