//
//  UIViewController+XYNavigation.h
//  XYConstructor
//
//  Created by nevsee on 2017/3/26.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const XYBlankSpaceBackTitle; ///< 空白返回按钮标题

@interface UIViewController (XYNavigation)

///-------------------------------
/// @name 导航栏信息
///-------------------------------

@property (nonatomic, strong, readonly) XYNavigationController *xy_navigationController;
@property (nonatomic, strong, readonly) UINavigationBar *xy_navigationBar;
@property (nonatomic, strong, readonly) XYNavigationBarBackground *xy_navigationBarBackground;
@property (nonatomic, assign, readonly) BOOL xy_navigationBarHidden;

///-------------------------------
/// @name 导航栈
///-------------------------------
@property (nonatomic, assign, readonly) BOOL xy_containsInNavigationStack; ///< 是否在导航栈中

///-------------------------------
/// @name 导航栏设置
///-------------------------------

@property (nonatomic, strong, nullable) UIBarButtonItem *xy_backItem;
@property (nonatomic, strong, nullable) NSString *xy_preferredBackItemTitle;
@property (nonatomic, strong, nullable) UIImage *xy_preferredBackItemImage;
@property (nonatomic, strong, nullable) UIColor *xy_preferredNavigationBarTintColor;
@property (nonatomic, strong, nullable) UIImage *xy_preferredNavigationBarImage;
@property (nonatomic, strong, nullable) UIColor *xy_preferredNavigationBarSeparatorColor;
@property (nonatomic, assign) UIBarStyle xy_preferredNavigationBarStyle;
@property (nonatomic, assign) CGFloat xy_preferredNavigationBarAlpha;
@property (nonatomic, assign) BOOL xy_prefersNavigationBarHidden;
@property (nonatomic, assign) BOOL xy_prefersNavigationBarTranslucent;
@property (nonatomic, assign) BOOL xy_prefersNavigationBarAnimatedWhenHidden;

///-------------------------------
/// @name 手势返回
///-------------------------------

@property (nonatomic, assign) BOOL xy_interactivePopEnabled; ///< 是否允许手势返回

/**
 监听返回手势，返回手势触发时调用
 @return YES可以手势返回，NO不能手势返回
 */
- (BOOL)xy_poppingByInteractiveGestureRecognizer;

/**
 更新导航栏按钮信息
 */
- (void)xy_updateBarButtonItem:(UIBarButtonItem *)barButtonItem title:(nullable NSString *)title image:(nullable UIImage *)image;

/**
 更新导航栏返回按钮信息
 */
- (void)xy_updateBackItemWithTitle:(nullable NSString *)title;
- (void)xy_updateBackItemWithImage:(nullable UIImage *)image;
- (void)xy_updateBackItemWithTitle:(nullable NSString *)title image:(nullable UIImage *)image;

/**
 更新导航栏标题
 */
- (void)xy_updateTitle:(NSString *)title forColor:(UIColor *)color;
- (void)xy_updateTitle:(NSString *)title forFont:(UIFont *)font;
- (void)xy_updateTitle:(NSString *)title forTheme:(NSDictionary *)theme;

/**
 隐藏或显示导航栏
 */
- (void)xy_hideNavigationBarAnimated:(BOOL)animated;

/**
 改变导航栏透明度
 */
- (void)xy_transformNavigationBarAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
