//
//  XYPromptTransition.m
//  XYPrompter
//
//  Created by nevsee on 2018/9/20.
//

#import "XYPromptTransition.h"
#import "XYPromptContainerController.h"
#import "XYPromptAnimator.h"
#import "XYPromptInteractor.h"
#import "XYPrompter.h"

@implementation XYPromptAnimatedTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (_type == XYPromptTransitionTypePresent) {
        return _animator.presentDuration;
    } else {
        return _animator.dismissDuration;
    }
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (_type == XYPromptTransitionTypePresent) {
        [self presentAnimation:transitionContext];
    } else {
        [self dismissAnimation:transitionContext];
    }
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval duration = ![self hasNoneAnimation:0] ? [self transitionDuration:transitionContext] : 0.02;
    UIView *cv = [transitionContext containerView];
    UINavigationController *nvc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    XYPromptContainerController *tvc = [nvc isKindOfClass:UINavigationController.class] ? nvc.viewControllers.firstObject : nvc;
    UIViewController *pvc = tvc.child;
    if (!pvc) return;
    
    [cv addSubview:nvc.view];
    
    // add pvc to tvc
    [tvc addChildViewController:pvc];
    [tvc.contentView addSubview:pvc.view];
    
    // background view animation
    [tvc.backgroundView transitWithDuration:duration present:YES];

    // content view animation
    [_animator presentAnimation:^(BOOL finished) {
        if (!transitionContext.transitionWasCancelled) {
            [pvc didMoveToParentViewController:tvc];
        }
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval duration = ![self hasNoneAnimation:1] ? [self transitionDuration:transitionContext] : 0.02;
    UINavigationController *nvc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    XYPromptContainerController *fvc = [nvc isKindOfClass:UINavigationController.class] ? nvc.viewControllers.firstObject : nvc;
    UIViewController *pvc = fvc.child;
    
    [pvc willMoveToParentViewController:nil];
    
    // background view animation
    [fvc.backgroundView transitWithDuration:duration present:NO];

    // content view animation
    [_animator dismissAnimation:^(BOOL finished) {
        if (!transitionContext.transitionWasCancelled) {
            [pvc.view removeFromSuperview];
            [pvc didMoveToParentViewController:nil];
        };
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (BOOL)hasNoneAnimation:(NSInteger)condition {
    if (condition) {
        return _animator.dismissStyle == XYPromptAnimationStyleNone;
    } else {
        return _animator.presentStyle == XYPromptAnimationStyleNone;
    }
}

@end

#pragma mark -

@interface XYPromptInteractor ()
@property (nonatomic, strong) void (^interactionDescriber) (XYPromptInteractor *interactor);
@end

@implementation XYPromptInteractiveTransition

- (void)reset {
    [_interactor updateType:0 progress:0 interactive:NO];
}

- (CGFloat)completionSpeed {
    return _interactor.type == XYPromptInteractionTypeFinished ? 1 - self.percentComplete : self.percentComplete;
}

- (void)setInteractor:(XYPromptInteractor *)interactor {
    _interactor = interactor;

    // handle interactive transition
    interactor.interactionDescriber = ^(XYPromptInteractor *aInteractor) {
        switch (aInteractor.type) {
            case XYPromptInteractionTypeChanged:
                [self updateInteractiveTransition:aInteractor.progress];
                break;
            case XYPromptInteractionTypeCancelled:
                [self cancelInteractiveTransition];
                [self reset];
                break;
            case XYPromptInteractionTypeFinished:
                [self finishInteractiveTransition];
                [self reset];
                break;
            default:
                break;
        }
    };
}

@end
