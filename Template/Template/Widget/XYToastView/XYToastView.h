//
//  XYToastView.h
//  XYToastView
//
//  Created by nevsee on 2017/3/13.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#if __has_include(<XYToastView/XYToastView.h>)
FOUNDATION_EXPORT double XYToastViewVersionNumber;
FOUNDATION_EXPORT const unsigned char XYToastViewVersionString[];
#import <XYToastView/XYToastBackgroundView.h>
#import <XYToastView/XYToastContentView.h>
#import <XYToastView/XYToastAnimator.h>
#else
#import "XYToastBackgroundView.h"
#import "XYToastContentView.h"
#import "XYToastAnimator.h"
#endif

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XYToastViewPosition) {
    XYToastViewPositionCenter,
    XYToastViewPositionTop,
    XYToastViewPositionLeft,
    XYToastViewPositionBottom,
    XYToastViewPositionRight,
};

@interface XYToastView : UIView

@property (nonatomic, strong, readonly) UIView *maskView;

/// Defaults to XYToastDefaultBackgroundView.
@property (nonatomic, strong) XYToastBackgroundView *backgroundView;

/// Defaults to XYToastDefaultContentView.
@property (nonatomic, strong) XYToastContentView *contentView;

/// Defaults to XYToastViewPositionCenter.
@property (nonatomic, assign) XYToastViewPosition position;

/// Defaults to XYToastAnimationStyleFade.
@property (nonatomic, strong) XYToastAnimator *animator;

/// Defaults to UIEdgeInsetsZero.
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/// Defaults to CGPointZero.
@property (nonatomic, assign) CGPoint contentOffset;

/// Dismiss when touching the mask view. Defaults to NO.
@property (nonatomic, assign) BOOL definesDismissalTouch;

/// Adapts to safe area automatically. Defaults to NO.
@property (nonatomic, assign) BOOL definesSafeAreaAdaptation;

@property (nonatomic, copy, nullable) void (^didShowBlock)(UIView *inView);
@property (nonatomic, copy, nullable) void (^didHideBlock)(UIView *inView);

@property (nonatomic, weak, readonly) UIView *parentView;
@property (nonatomic, assign, readonly) BOOL isVisible;

- (instancetype)initWithView:(UIView *)view;

- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end

@interface XYToastView (XYAdd)

/**
 Returns the top toast view
 */
+ (nullable XYToastView *)topToastInView:(UIView *)view;

/**
 Returns all toast views
 */
+ (nullable NSArray<XYToastView *> *)allToastInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
