//
//  XYPrompter.h
//  XYPrompter
//
//  Created by nevsee on 2018/9/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if __has_include(<XYPrompter/XYPrompter.h>)
FOUNDATION_EXPORT double XYPrompterVersionNumber;
FOUNDATION_EXPORT const unsigned char XYPrompterVersionString[];
#import <XYPrompter/XYPromptAnimator.h>
#import <XYPrompter/XYPromptInteractor.h>
#import <XYPrompter/XYPromptAutorotation.h>
#import <XYPrompter/XYPromptContainerController.h>
#else
#import "XYPromptAnimator.h"
#import "XYPromptInteractor.h"
#import "XYPromptAutorotation.h"
#import "XYPromptContainerController.h"
#endif

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XYPromptPosition) {
    XYPromptPositionCenter,
    XYPromptPositionTop,
    XYPromptPositionLeft,
    XYPromptPositionBottom,
    XYPromptPositionRight,
};

@interface XYPrompter : NSObject

/// The position of the content view. Defaults to XYPromptPositionCenter.
@property (nonatomic, assign) XYPromptPosition position;

/// The color of the background view. Defaults to black color (0.3 alpha).
@property (nonatomic, strong, nullable) UIColor *backgroundColor;

/// The blur effect of the background view. Defaults to nil.
@property (nonatomic, strong, nullable) UIBlurEffect *backgroundEffect;

/// Provides a class  to customize the prompter background. Defaults to nil.
@property (nonatomic, strong, nullable) Class<XYPromptContainerBackgroundDescriber> backgroundViewClass;

/// Spacing between keyboard and content view. Defaults to 0.
@property (nonatomic, assign) CGFloat keyboardSpacing;

/// The content view offset. Defaults to CGPointZero.
@property (nonatomic, assign) CGPoint contentOffset;

/// The provided navigation class must hand over the autorotation to the top view controller. Defaults to nil.
/// @example return [self.topViewController supportedInterfaceOrientations]
@property (nonatomic, strong, nullable) Class navigationClass;

/// Dismisses when touching the background view. Defaults to YES.
@property (nonatomic, assign) BOOL definesDismissalTouch;

/// Hides keyboard when touching the background view. Defaults to YES.
@property (nonatomic, assign) BOOL definesKeyboardHiddenTouch;

/// Adapts to keyboard pop-up automatically. Defaults to YES.
@property (nonatomic, assign) BOOL definesKeyboardAdaptation;

/// Adapts to safe area automatically. Defaults to YES.
@property (nonatomic, assign) BOOL definesSafeAreaAdaptation;

/// Needs animation or not when the content size is changed. Defaults to YES.
@property (nonatomic, assign) BOOL definesSizeChangingAnimation;

/// Creates a new window to cover the current interface. Defaults to YES.
@property (nonatomic, assign) BOOL definesWindowCarrier;

/// Defines autorotation mode of the presented view controller.
@property (nonatomic, strong, readonly) XYPromptAutorotation *autorotation;

/// Defines animated transition type.
@property (nonatomic, strong, readonly) XYPromptAnimator *animator;

/// Defines interactive transition type.
@property (nonatomic, strong, readonly) XYPromptInteractor *interactor;

@property (nonatomic, strong, nullable) void (^willPresentBlock)(void);
@property (nonatomic, strong, nullable) void (^didPresentBlock)(void);
@property (nonatomic, strong, nullable) void (^willDismissBlock)(void);
@property (nonatomic, strong, nullable) void (^didDismissBlock)(void);

@property (nonatomic, weak, readonly, nullable) UIViewController *inController;
@property (nonatomic, weak, readonly) UIViewController *presentedViewController;
@property (nonatomic, weak, readonly) UIViewController *presentingViewController;

@property (nonatomic, assign, readonly) BOOL beingPresented;
@property (nonatomic, assign, readonly) BOOL beingDismissed;

/**
 The value of inController must not be nil when definesWindowCarrier is set to NO.
 */
- (void)present:(UIViewController *)controller;
- (void)present:(UIViewController *)controller inController:(nullable UIViewController *)inController;
- (void)present:(UIViewController *)controller inController:(nullable UIViewController *)inController completion:(nullable void (^)(void))completion;

- (void)dismiss;
- (void)dismissWithCompletion:(nullable void (^)(void))completion;
@end

/// A notification will be posted when the content view's size is changed.
UIKIT_EXTERN NSNotificationName const XYPrompterContentSizeChangeNotification;
UIKIT_EXTERN NSString *const XYPrompterAnimationDurationUserInfoKey;
UIKIT_EXTERN NSString *const XYPrompterAnimationOptionUserInfoKey;

@interface UIViewController (XYPrompter)
@property (nonatomic) XYPrompter *xy_prompter;
@property (nonatomic) CGSize xy_portraitContentSize; ///< content size of portrait interface
@property (nonatomic) CGSize xy_landscapeContentSize; /// < content size of landscape interface
@end

NS_ASSUME_NONNULL_END
