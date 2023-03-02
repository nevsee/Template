//
//  UIView+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2016/12/28.
//  Copyright © 2016年 nevsee. All rights reserved.
//

#import "UIView+XYAdd.h"
#import "CALayer+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(UIView_XYAdd)

@implementation UIView (XYAdd)

- (CGFloat)xy_left {
    return self.frame.origin.x;
}

- (void)setXy_left:(CGFloat)xy_left {
    CGRect frame = self.frame;
    frame.origin.x = xy_left;
    self.frame = frame;
}

- (CGFloat)xy_top {
    return self.frame.origin.y;
}

- (void)setXy_top:(CGFloat)xy_top {
    CGRect frame = self.frame;
    frame.origin.y = xy_top;
    self.frame = frame;
}

- (CGFloat)xy_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setXy_right:(CGFloat)xy_right {
    CGRect frame = self.frame;
    frame.origin.x = xy_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)xy_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setXy_bottom:(CGFloat)xy_bottom {
    CGRect frame = self.frame;
    frame.origin.y = xy_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)xy_width {
    return self.frame.size.width;
}

- (void)setXy_width:(CGFloat)xy_width {
    CGRect frame = self.frame;
    frame.size.width = xy_width;
    self.frame = frame;
}

- (CGFloat)xy_height {
    return self.frame.size.height;
}

- (void)setXy_height:(CGFloat)xy_height {
    CGRect frame = self.frame;
    frame.size.height = xy_height;
    self.frame = frame;
}

- (CGFloat)xy_centerX {
    return self.center.x;
}

- (void)setXy_centerX:(CGFloat)xy_centerX {
    CGPoint center = self.center;
    center.x = xy_centerX;
    self.center = center;
}

- (CGFloat)xy_centerY {
    return self.center.y;
}

- (void)setXy_centerY:(CGFloat)xy_centerY {
    CGPoint center = self.center;
    center.y = xy_centerY;
    self.center = center;
}

- (CGPoint)xy_origin {
    return self.frame.origin;
}

- (void)setXy_origin:(CGPoint)xy_origin {
    CGRect frame = self.frame;
    frame.origin = xy_origin;
    self.frame = frame;
}

- (CGSize)xy_size {
    return self.frame.size;
}

- (void)setXy_size:(CGSize)xy_size {
    CGRect frame = self.frame;
    frame.size = xy_size;
    self.frame = frame;
}

- (UIEdgeInsets)xy_safeAreaInsets {
    if ([self respondsToSelector:@selector(safeAreaInsets)]) {
        return self.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

- (UIViewController *)xy_viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)xy_addCornerRadius:(CGFloat)radius rectCorner:(UIRectCorner)rectCorner {
    [self.layer xy_addCornerRadius:radius rectCorner:rectCorner];
}

- (void)xy_addCornerRadius:(CGFloat)radius bounds:(CGRect)bounds rectCorner:(UIRectCorner)rectCorner {
    [self.layer xy_addCornerRadius:radius bounds:bounds rectCorner:rectCorner];
}

- (void)xy_addCornerRadius:(CGFloat)radius maskCorner:(CACornerMask)maskCorner {
    [self.layer xy_addCornerRadius:radius maskCorner:maskCorner];
}

- (void)xy_addCornerRadius:(CGFloat)radius curve:(CALayerCornerCurve)curve {
    [self.layer xy_addCornerRadius:radius curve:curve];
}

- (void)xy_addCornerRadius:(CGFloat)radius maskCorner:(CACornerMask)maskCorner curve:(CALayerCornerCurve)curve {
    [self.layer xy_addCornerRadius:radius maskCorner:maskCorner curve:curve];
}

- (void)xy_addContinuousCornerRadius:(CGFloat)radius {
    [self.layer xy_addContinuousCornerRadius:radius];
}

- (void)xy_addContinuousCornerRadius:(CGFloat)radius maskCorner:(CACornerMask)maskCorner {
    [self.layer xy_addContinuousCornerRadius:radius maskCorner:maskCorner];
}

- (void)xy_addShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity bounds:(CGRect)bounds {
    [self.layer xy_addShadowColor:color offset:offset radius:radius opacity:opacity bounds:bounds];
}

- (void)xy_addShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity {
    [self.layer xy_addShadowColor:color offset:offset radius:radius opacity:opacity];
}

- (void)xy_removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (UIImage *)xy_snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

- (UIImage *)xy_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self xy_snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

@end
