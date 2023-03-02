//
//  XYPrompter.m
//  XYPrompter
//
//  Created by nevsee on 2018/9/20.
//

#import <objc/runtime.h>
#import "XYPrompter.h"
#import "XYPromptTransition.h"

NSNotificationName const XYPrompterContentSizeChangeNotification = @"com.xyprompter.contentsizechange";
NSString *const XYPrompterAnimationDurationUserInfoKey = @"com.xyprompter.animationduration";
NSString *const XYPrompterAnimationOptionUserInfoKey = @"com.xyprompter.animationoption";

@interface XYPromptAnimator ()
@property (nonatomic, weak) UIView *animationView;
@property (nonatomic, weak) XYPromptContainerController *animationController;
@end

#pragma mark -

@interface XYPrompter () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) XYPromptAnimatedTransition *animatedTransition;
@property (nonatomic, strong) XYPromptInteractiveTransition *interactiveTransition;
@property (nonatomic, strong) XYPromptContainerWindow *containerWindow;
@property (nonatomic, weak) XYPromptContainerController *containerController;
@end

@implementation XYPrompter

- (instancetype)init {
    self = [super init];
    if (self) {
        _position = XYPromptPositionCenter;
        _backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _keyboardSpacing = 0;
        _contentOffset = CGPointZero;
        _definesDismissalTouch = YES;
        _definesKeyboardHiddenTouch = YES;
        _definesKeyboardAdaptation = YES;
        _definesSafeAreaAdaptation = YES;
        _definesSizeChangingAnimation = YES;
        _definesWindowCarrier = YES;
        // autorotation
        _autorotation = [[XYPromptAutorotation alloc] initWithType:YES];
        _autorotation.prompter = self;
        // animator
        _animator = [[XYPromptAnimator alloc] init];
        _animator.presentStyle = XYPromptAnimationStyleBounce;
        _animator.dismissStyle = XYPromptAnimationStyleBounce;
        _animatedTransition = [[XYPromptAnimatedTransition alloc] init];
        _animatedTransition.animator = _animator;
        // interactor
        _interactor = [[XYPromptInteractor alloc] init];
        _interactiveTransition = [[XYPromptInteractiveTransition alloc] init];
        _interactiveTransition.interactor = _interactor;
    }
    return self;
}

#pragma mark # Delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _animatedTransition.type = XYPromptTransitionTypePresent;
    return  _animatedTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _animatedTransition.type = XYPromptTransitionTypeDismiss;
    return  _animatedTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return _interactiveTransition.interactor.interactive ? _interactiveTransition : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return _interactiveTransition.interactor.interactive ? _interactiveTransition : nil;
}

#pragma mark # Method

- (UIViewController *)findEffectiveController:(UIViewController *)controller {
    if (!controller) return nil;
    
    while (controller.presentedViewController && !controller.isBeingDismissed) {
        controller = controller.presentedViewController;
    }
    if (controller.isBeingDismissed) {
        controller = controller.presentingViewController;
    }
    return controller;
}

- (void)present:(UIViewController *)controller {
    [self present:controller inController:nil];
}

- (void)present:(UIViewController *)controller inController:(UIViewController *)inController {
    [self present:controller inController:inController completion:nil];
}

/**
 holding relations:
 present mode:
    effectivePresentingController -> effectivePresentedViewController (containerController) -> controller -> prompter
 window mode: (Breaking retain cycle when container controller is deallocated)
    containerWindow -> effectivePresentingController -> effectivePresentedViewController (containerController) -> controller -> prompter -> containerWindow
 */
- (void)present:(UIViewController *)controller inController:(UIViewController *)inController completion:(void (^)(void))completion {
    if (!controller) return;
    if (!_definesWindowCarrier && !inController) return;
    _inController = inController;

    // find effective presenting view controller
    UIViewController *effectivePresentingController = nil;
    if (_definesWindowCarrier) {
        effectivePresentingController = [[XYPromptContainerRootController alloc] init];
        effectivePresentingController.view.backgroundColor = [UIColor clearColor];
        ((XYPromptContainerRootController *)effectivePresentingController).prompter = self;
    } else {
        effectivePresentingController = [self findEffectiveController:inController];
    }
    if (!effectivePresentingController || effectivePresentingController.isBeingDismissed) return;
    
    // hold prompter
    controller.xy_prompter = self;

    // container controller
    XYPromptContainerController *containerController = [[XYPromptContainerController alloc] init];
    containerController.child = controller;
    containerController.xy_prompter = self;
    _containerController = containerController;
    
    // animation view
    _animator.animationView = containerController.contentView;
    _animator.animationController = containerController;

    // presenting view controller
    _presentingViewController = effectivePresentingController;
    
    // presented view controller
    UIViewController *effectivePresentedViewController = containerController;
    if (_navigationClass != NULL && [_navigationClass isSubclassOfClass:UINavigationController.class]) {
        effectivePresentedViewController = [[_navigationClass alloc] initWithRootViewController:containerController];
    }
    effectivePresentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    effectivePresentedViewController.transitioningDelegate = self;
    _presentedViewController = effectivePresentedViewController;
    
    // make window visible
    if (_definesWindowCarrier) {
        XYPromptContainerWindow *containerWindow = [[XYPromptContainerWindow alloc] init];
        containerWindow.windowLevel = UIWindowLevelAlert - 4;
        containerWindow.backgroundColor = [UIColor clearColor];
        containerWindow.rootViewController = effectivePresentingController;
        [containerWindow makeKeyAndVisible];
        _containerWindow = containerWindow;
    }
    
    // present
    [effectivePresentingController presentViewController:effectivePresentedViewController animated:YES completion:completion];
}

- (void)dismiss {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    [_presentedViewController dismissViewControllerAnimated:YES completion:completion];
}

- (BOOL)beingPresented {
    return _presentedViewController.isBeingPresented;
}

- (BOOL)beingDismissed {
    return _presentedViewController.isBeingDismissed;
}

@end

#pragma mark -

@implementation UIViewController (XYPrompter)

- (void)setXy_prompter:(XYPrompter *)xy_prompter {
    if (!xy_prompter) nil;
    objc_setAssociatedObject(self, _cmd, xy_prompter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XYPrompter *)xy_prompter {
    return objc_getAssociatedObject(self, @selector(setXy_prompter:));
}

- (void)setXy_portraitContentSize:(CGSize)xy_portraitContentSize {
    objc_setAssociatedObject(self, _cmd, NSStringFromCGSize(xy_portraitContentSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)xy_portraitContentSize {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_portraitContentSize:));
    if (!value) return CGSizeZero;
    return CGSizeFromString(value);
}

- (void)setXy_landscapeContentSize:(CGSize)xy_landscapeContentSize {
    objc_setAssociatedObject(self, _cmd, NSStringFromCGSize(xy_landscapeContentSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)xy_landscapeContentSize {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_landscapeContentSize:));
    if (!value) return CGSizeZero;
    return CGSizeFromString(value);
}

@end
