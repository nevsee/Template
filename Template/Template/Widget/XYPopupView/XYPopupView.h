//
//  XYPopupView.h
//  XYPopupView
//
//  Created by nevsee on 2017/12/11.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#if __has_include(<XYPopupView/XYPopupView.h>)
FOUNDATION_EXPORT double XYPopupViewVersionNumber;
FOUNDATION_EXPORT const unsigned char XYPopupViewVersionString[];
#import <XYPopupView/XYPopupContainer.h>
#import <XYPopupView/XYPopupAnimator.h>
#else
#import "XYPopupCarrierView.h"
#import "XYPopupAnimator.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/// The direction of a popup view
typedef NS_ENUM(NSInteger, XYPopupDirection) {
    XYPopupDirectionTop,
    XYPopupDirectionLeft,
    XYPopupDirectionBottom,
    XYPopupDirectionRight
};

/// The rule that seeks the best direction
typedef NS_ENUM(NSInteger, XYPopupSeekRule) {
    XYPopupSeekRuleClockwise, ///< top: top -> right -> bottom -> left
    XYPopupSeekRuleAnticlockwise, ///< top: top -> left -> bottom -> right
    XYPopupSeekRuleSymmetryClockwise, ///< top: top -> bottom / right -> left
    XYPopupSeekRuleSymmetryAnticlockwise, ///< top: top -> bottom / left -> right
};

@interface XYPopupView : UIView

///-------------------------------
/// @name Infomation
///-------------------------------

/// The super view of the popup
@property (nonatomic, weak, readonly) UIView *parentView;

/// The mask view of the popup
@property (nonatomic, strong, readonly) UIView *maskView;

/// The content view of the popup
@property (nonatomic, strong, readonly) UIView *contentView;

/// The carrier view of the popup
@property (nonatomic, strong, readonly) XYPopupCarrierView *carrierView;

/// The actual direction the popup is pointing.
@property (nonatomic, assign, readonly) XYPopupDirection actualDirection;

/// Whether the popup is visible or not.
@property (nonatomic, assign, readonly) BOOL isVisible;

///-------------------------------
/// @name Configuration
///-------------------------------

/// The view that the popup should point at.
@property (nonatomic, weak, nullable) UIView *sourceView;

/// The bar item that the popup should point at.
@property (nonatomic, weak, nullable) UIBarItem *sourceBarItem;

/// The rect that the popup should point at.
@property (nonatomic, assign) CGRect sourceRect;

/// Which preferred direction the popup is pointing. Defaults to XYPopupDirectionBottom.
@property (nonatomic, assign) XYPopupDirection preferredDirection;

/// Defaults to XYPopupSeekRuleSymmetryAnticlockwise.
@property (nonatomic, assign) XYPopupSeekRule seekRule;

/// Defaults to XYPopupAnimationStyleZoom.
@property (nonatomic, strong) XYPopupAnimator *animator;

/// Whether to dismiss when touching the background view. Defaults to YES.
@property (nonatomic, assign) BOOL definesDismissalTouch;

/// Whether to adapt to safe area automatically. Defaults to YES.
@property (nonatomic, assign) BOOL definesSafeAreaAdaptation;

///-------------------------------
/// @name Appeareace
///-------------------------------

/// Describes the distance between the source view and the popup
@property (nonatomic, assign) CGFloat popupSpacing UI_APPEARANCE_SELECTOR;

/// Describes the distance between the parent view and the popup
@property (nonatomic, assign) CGFloat popupMargin UI_APPEARANCE_SELECTOR;

/// Describes the size of the arrow.
@property (nonatomic, assign) CGSize arrowSize UI_APPEARANCE_SELECTOR;

/// Describes how far from the center of the source view the center of the arrow should appear.
@property (nonatomic, assign) CGPoint arrowOffset UI_APPEARANCE_SELECTOR;

/// Sets mask view background color.
@property (nonatomic, strong) UIColor *maskColor UI_APPEARANCE_SELECTOR;

/// Sets popup background color.
@property (nonatomic, strong) UIColor *fillColor UI_APPEARANCE_SELECTOR;

/// sets popup corner radius.
@property (nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

/// sets popup shadow color.
@property (nonatomic, strong, nullable) UIColor *shadowColor UI_APPEARANCE_SELECTOR;

/// sets popup shadow color.
@property (nonatomic, assign) CGSize shadowOffset UI_APPEARANCE_SELECTOR;

/// sets popup shadow color.
@property (nonatomic, assign) CGFloat shadowRadius UI_APPEARANCE_SELECTOR;

/// sets popup shadow color.
@property (nonatomic, assign) CGFloat shadowOpacity UI_APPEARANCE_SELECTOR;

@property (nonatomic, copy, nullable) void (^didShowBlock)(UIView *inView);
@property (nonatomic, copy, nullable) void (^didHideBlock)(UIView *inView);

/**
 This is the designated initializer for XYPopupView.
 */
- (instancetype)initWithContentView:(UIView *)contentView;

/**
 This is the designated initializer for XYPopupView.
 The popup will be added to the window if `parentView` is nil.
 */
- (instancetype)initWithContentView:(UIView *)contentView parentView:(nullable UIView *)parentView;

- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;

@end

@interface UIView (XYPopupView)
@property (nonatomic, weak) XYPopupView *xy_popup;
@end

NS_ASSUME_NONNULL_END
