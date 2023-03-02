//
//  YYTipView.h
//  Template
//
//  Created by nevsee on 2021/12/28.
//

#import "XYToastView.h"

NS_ASSUME_NONNULL_BEGIN

/// 提示视图
@interface YYTipView : XYToastView

/// 隐藏所有tipView
+ (void)hideAllTipsInView:(UIView *)view animated:(BOOL)animated;

/// 加载提示
- (void)showLoading;
- (void)showLoadingAnimated:(BOOL)animated;
- (void)showLoadingWithText:(nullable NSString *)text;
- (void)showLoadingWithText:(nullable NSString *)text animated:(BOOL)animated;

/// 错误提示
- (void)showErrorWithText:(nullable NSString *)text;
- (void)showErrorWithText:(nullable NSString *)text animated:(BOOL)animated;
- (void)showErrorWithText:(nullable NSString *)text afterDelay:(NSTimeInterval)delay;
- (void)showErrorWithText:(nullable NSString *)text afterDelay:(NSTimeInterval)delay animated:(BOOL)animated;

/// 成功提示
- (void)showSuccessWithText:(nullable NSString *)text;
- (void)showSuccessWithText:(nullable NSString *)text animated:(BOOL)animated;
- (void)showSuccessWithText:(nullable NSString *)text afterDelay:(NSTimeInterval)delay;
- (void)showSuccessWithText:(nullable NSString *)text afterDelay:(NSTimeInterval)delay animated:(BOOL)animated;

/// 信息提示
- (void)showInfoWithText:(nullable NSString *)text;
- (void)showInfoWithText:(nullable NSString *)text animated:(BOOL)animated;
- (void)showInfoWithText:(nullable NSString *)text afterDelay:(NSTimeInterval)delay;
- (void)showInfoWithText:(nullable NSString *)text afterDelay:(NSTimeInterval)delay animated:(BOOL)animated;

@end

@interface UIView (YYTipSupport)

- (void)hide;
- (void)hideAnimated:(BOOL)animated;

/// interactionEnabled: 是否允许用户与下层视图交互
/// hideOtherTips: 是否隐藏其他tipView

/// interactionEnabled: NO / hideOtherTips: YES
- (void)showLoading;
- (void)showLoadingWithInteractionEnabled:(BOOL)interactionEnabled;
- (void)showLoadingWithInteractionEnabled:(BOOL)interactionEnabled hideOtherTips:(BOOL)hideOtherTips;
- (void)showLoadingWithText:(nullable NSString *)text;
- (void)showLoadingWithText:(nullable NSString *)text interactionEnabled:(BOOL)interactionEnabled;
- (void)showLoadingWithText:(nullable NSString *)text interactionEnabled:(BOOL)interactionEnabled hideOtherTips:(BOOL)hideOtherTips;

/// interactionEnabled: YES / hideOtherTips: YES
- (void)showErrorWithText:(nullable NSString *)text;
- (void)showErrorWithText:(nullable NSString *)text interactionEnabled:(BOOL)interactionEnabled;
- (void)showErrorWithText:(nullable NSString *)text interactionEnabled:(BOOL)interactionEnabled hideOtherTips:(BOOL)hideOtherTips;

/// interactionEnabled: YES / hideOtherTips: YES
- (void)showSuccessWithText:(nullable NSString *)text;
- (void)showSuccessWithText:(nullable NSString *)text interactionEnabled:(BOOL)interactionEnabled;
- (void)showSuccessWithText:(nullable NSString *)text interactionEnabled:(BOOL)interactionEnabled hideOtherTips:(BOOL)hideOtherTips;

/// interactionEnabled: YES / hideOtherTips: YES
- (void)showInfoWithText:(nullable NSString *)text;
- (void)showInfoWithText:(nullable NSString *)text interactionEnabled:(BOOL)interactionEnabled;
- (void)showInfoWithText:(nullable NSString *)text interactionEnabled:(BOOL)interactionEnabled hideOtherTips:(BOOL)hideOtherTips;;

@end

NS_ASSUME_NONNULL_END
