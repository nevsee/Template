//
//  UIViewController+XYNavigation.m
//  XYConstructor
//
//  Created by nevsee on 2017/3/26.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "UIViewController+XYNavigation.h"
#import "UIBarButtonItem+XYCustom.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

NSString *const XYBlankSpaceBackTitle = @"  ";

@implementation UIViewController (XYNavigation)

- (XYNavigationController *)xy_navigationController {
    return (XYNavigationController *)self.navigationController;
}

- (UINavigationBar *)xy_navigationBar {
    return self.xy_navigationController.navigationBar;
}

- (XYNavigationBarBackground *)xy_navigationBarBackground {
    if (![self.navigationController isKindOfClass:XYNavigationController.class]) return nil;
    return self.xy_navigationController.navigationBarBackground;
}

- (BOOL)xy_navigationBarHidden {
    return self.navigationController.navigationBarHidden;
}

- (BOOL)xy_containsInNavigationStack {
    return [self.navigationController.viewControllers containsObject:self];
}

- (UIColor *)xy_preferredNavigationBarTintColor {
    return objc_getAssociatedObject(self, @selector(setXy_preferredNavigationBarTintColor:));
}

- (void)setXy_preferredNavigationBarTintColor:(UIColor *)xy_barTintColor {
    objc_setAssociatedObject(self, _cmd, xy_barTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)xy_preferredNavigationBarImage {
    return objc_getAssociatedObject(self, @selector(setXy_preferredNavigationBarImage:));
}

- (void)setXy_preferredNavigationBarImage:(UIImage *)xy_barImage {
    objc_setAssociatedObject(self, _cmd, xy_barImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)xy_preferredNavigationBarSeparatorColor {
    return objc_getAssociatedObject(self, @selector(setXy_preferredNavigationBarSeparatorColor:));
}

- (void)setXy_preferredNavigationBarSeparatorColor:(UIColor *)xy_preferredNavigationBarSeparatorColor {
    objc_setAssociatedObject(self, _cmd, xy_preferredNavigationBarSeparatorColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarStyle)xy_preferredNavigationBarStyle {
    NSNumber *value = objc_getAssociatedObject(self, @selector(setXy_preferredNavigationBarStyle:));
    return value.integerValue;
}

- (void)setXy_preferredNavigationBarStyle:(UIBarStyle)xy_preferredNavigationBarStyle {
    objc_setAssociatedObject(self, _cmd, @(xy_preferredNavigationBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)xy_preferredNavigationBarAlpha {
    NSNumber *value = objc_getAssociatedObject(self, @selector(setXy_preferredNavigationBarAlpha:));
    return value.floatValue;
}

- (void)setXy_preferredNavigationBarAlpha:(CGFloat)xy_barAlpha {
    objc_setAssociatedObject(self, _cmd, @(xy_barAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xy_prefersNavigationBarHidden {
    NSNumber *value = objc_getAssociatedObject(self, @selector(setXy_prefersNavigationBarHidden:));
    return value.boolValue;
}

- (void)setXy_prefersNavigationBarHidden:(BOOL)xy_barHidden {
    objc_setAssociatedObject(self, _cmd, @(xy_barHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xy_prefersNavigationBarTranslucent {
    NSNumber *value = objc_getAssociatedObject(self, @selector(setXy_prefersNavigationBarTranslucent:));
    return value.boolValue;
}

- (void)setXy_prefersNavigationBarTranslucent:(BOOL)xy_prefersNavigationBarTranslucent {
    objc_setAssociatedObject(self, _cmd, @(xy_prefersNavigationBarTranslucent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xy_prefersNavigationBarAnimatedWhenHidden {
    NSNumber *value = objc_getAssociatedObject(self, @selector(setXy_prefersNavigationBarAnimatedWhenHidden:));
    return value.boolValue;
}

- (void)setXy_prefersNavigationBarAnimatedWhenHidden:(BOOL)xy_prefersNavigationBarAnimatedWhenHidden {
    objc_setAssociatedObject(self, _cmd, @(xy_prefersNavigationBarAnimatedWhenHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)xy_preferredBackItemTitle {
    return objc_getAssociatedObject(self, @selector(setXy_preferredBackItemTitle:));
}

- (void)setXy_preferredBackItemTitle:(NSString *)xy_backItemTitle {
    objc_setAssociatedObject(self, _cmd, xy_backItemTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)xy_preferredBackItemImage {
    return objc_getAssociatedObject(self, @selector(setXy_preferredBackItemImage:));
}

- (void)setXy_preferredBackItemImage:(UIImage *)xy_backItemImage {
    objc_setAssociatedObject(self, _cmd, xy_backItemImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xy_backItemHidden {
    NSNumber *value = objc_getAssociatedObject(self, @selector(setXy_backItemHidden:));
    return value.boolValue;
}

- (void)setXy_backItemHidden:(BOOL)xy_backItemHidden {
    objc_setAssociatedObject(self, _cmd, @(xy_backItemHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xy_interactivePopEnabled {
    NSNumber *value = objc_getAssociatedObject(self, @selector(setXy_interactivePopEnabled:));
    return value.boolValue;
}

- (void)setXy_interactivePopEnabled:(BOOL)xy_interactivePopEnabled {
    objc_setAssociatedObject(self, _cmd, @(xy_interactivePopEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarButtonItem *)xy_backItem {
    UIBarButtonItem *item = objc_getAssociatedObject(self, @selector(setXy_backItem:));
    if (!item) {
        if (self.xy_preferredBackItemTitle.length == 0) {
            self.xy_preferredBackItemTitle = XYBlankSpaceBackTitle;
        }
        item = [UIBarButtonItem xy_itemWithTitle:self.xy_preferredBackItemTitle image:self.xy_preferredBackItemImage alignment:UIControlContentHorizontalAlignmentLeft target:nil action:nil];
        self.xy_backItem = item;
    }
    return item;
}

- (void)setXy_backItem:(UIBarButtonItem *)xy_backItem {
    objc_setAssociatedObject(self, _cmd, xy_backItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark # Public

- (BOOL)xy_poppingByInteractiveGestureRecognizer {
    return YES;
}

- (void)xy_updateBarButtonItem:(UIBarButtonItem *)barButtonItem title:(NSString *)title image:(UIImage *)image {
    NSDictionary *normalAttributes = barButtonItem.xy_normalAttributes;
    NSDictionary *highlightedAttributes = barButtonItem.xy_highlightedAttributes;
    UIImage *normalImage = image;
    UIImage *highlightedImage = [self changeImage:image color:highlightedAttributes[NSForegroundColorAttributeName]];
    NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithString:title ?: @"" attributes:normalAttributes];
    NSAttributedString *highlightedTitle = [[NSAttributedString alloc] initWithString:title ?: @"" attributes:highlightedAttributes];
    
    UIButton *button = barButtonItem.customView;
    [button setAttributedTitle:normalTitle forState:UIControlStateNormal];
    [button setAttributedTitle:highlightedTitle forState:UIControlStateHighlighted];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    if (normalImage && normalTitle.length > 0) {
        if (button.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        } else {
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        }
    } else {
        button.titleEdgeInsets = UIEdgeInsetsZero;
        button.imageEdgeInsets = UIEdgeInsetsZero;
    }
    CGSize size = [button sizeThatFits:CGSizeMake(CGFLOAT_MAX, 44)];
    CGFloat width = size.width + 15;
    button.frame = (CGRect){0, 0, width, 44};
}

- (void)xy_updateBackItemWithTitle:(NSString *)title {
    [self xy_updateBackItemWithTitle:title ?: XYBlankSpaceBackTitle image:self.xy_preferredBackItemImage];
}

- (void)xy_updateBackItemWithImage:(UIImage *)image {
    [self xy_updateBackItemWithTitle:self.xy_preferredBackItemTitle image:image];
}

- (void)xy_updateBackItemWithTitle:(NSString *)title image:(UIImage *)image {
    self.xy_preferredBackItemTitle = title ?: XYBlankSpaceBackTitle;
    self.xy_preferredBackItemImage = image;
    [self xy_updateBarButtonItem:self.xy_backItem title:title image:image];
}

- (void)xy_updateTitle:(NSString *)title forColor:(UIColor *)color {
    if (!title || !color) return;
    NSMutableDictionary *attrs = [UINavigationBar appearance].titleTextAttributes.mutableCopy;
    if (attrs) {
        [attrs setObject:color forKey:NSForegroundColorAttributeName];
    }
    [self xy_updateTitle:title forTheme:attrs];
}

- (void)xy_updateTitle:(NSString *)title forFont:(UIFont *)font {
    if (!title || !font) return;
    NSMutableDictionary *attrs = [UINavigationBar appearance].titleTextAttributes.mutableCopy;
    if (attrs) {
        [attrs setValue:font forKey:NSFontAttributeName];
    }
    [self xy_updateTitle:title forTheme:attrs];
}

- (void)xy_updateTitle:(NSString *)title forTheme:(NSDictionary *)theme {
    if (!title || !theme) return;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:theme];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)xy_hideNavigationBarAnimated:(BOOL)animated {
    self.xy_prefersNavigationBarHidden = !self.xy_navigationController.navigationBarHidden;
    [self.xy_navigationController setNavigationBarHidden:self.xy_prefersNavigationBarHidden animated:animated];
}

- (void)xy_transformNavigationBarAlpha:(CGFloat)alpha {
    if (alpha < 0) alpha = 0;
    if (alpha > 1) alpha = 1;
    self.xy_preferredNavigationBarAlpha = alpha;
    self.xy_navigationBarBackground.alpha = alpha;
}

- (UIImage *)changeImage:(UIImage *)image color:(UIColor *)color {
    if (!color || !image) return nil;
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

#pragma clang diagnostic pop
