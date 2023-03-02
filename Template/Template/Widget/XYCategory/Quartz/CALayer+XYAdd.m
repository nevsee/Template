//
//  CALayer+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2017/1/10.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "CALayer+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(CALayer_XYAdd)

@implementation CALayer (XYAdd)

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

- (CGPoint)xy_center {
    return CGPointMake(self.frame.origin.x + self.frame.size.width / 2,
                       self.frame.origin.y + self.frame.size.height / 2);
}

- (void)setXy_center:(CGPoint)xy_center {
    CGRect frame = self.frame;
    frame.origin.x = xy_center.x - frame.size.width / 2;
    frame.origin.y = xy_center.y - frame.size.height / 2;
    self.frame = frame;
}

- (CGFloat)xy_centerX {
    return self.frame.origin.x + self.frame.size.width / 2;
}

- (void)setXy_centerX:(CGFloat)xy_centerX {
    CGRect frame = self.frame;
    frame.origin.x = xy_centerX - frame.size.width / 2;
    self.frame = frame;
}

- (CGFloat)xy_centerY {
    return self.frame.origin.y + self.frame.size.height / 2;
}

- (void)setXy_centerY:(CGFloat)xy_centerY {
    CGRect frame = self.frame;
    frame.origin.y = xy_centerY - frame.size.height / 2;
    self.frame = frame;
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

- (void)xy_addCornerRadius:(CGFloat)radius rectCorner:(UIRectCorner)rectCorner {
    [self xy_addCornerRadius:radius bounds:self.bounds rectCorner:rectCorner];
}

- (void)xy_addCornerRadius:(CGFloat)radius bounds:(CGRect)bounds rectCorner:(UIRectCorner)rectCorner {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = bounds;
    mask.path = path.CGPath;
    self.mask  = mask;
}

- (void)xy_addCornerRadius:(CGFloat)radius maskCorner:(CACornerMask)maskCorner {
    self.cornerRadius = radius;
    self.maskedCorners = maskCorner;
}

- (void)xy_addCornerRadius:(CGFloat)radius curve:(CALayerCornerCurve)curve {
    self.cornerRadius = radius;
    self.cornerCurve = curve;
}

- (void)xy_addCornerRadius:(CGFloat)radius maskCorner:(CACornerMask)maskCorner curve:(CALayerCornerCurve)curve {
    self.cornerRadius = radius;
    self.maskedCorners = maskCorner;
    self.cornerCurve = curve;
}

- (void)xy_addContinuousCornerRadius:(CGFloat)radius {
    if (@available(iOS 13, *)) self.cornerCurve = kCACornerCurveContinuous;
    self.cornerRadius = radius;
}

- (void)xy_addContinuousCornerRadius:(CGFloat)radius maskCorner:(CACornerMask)maskCorner {
    if (@available(iOS 13, *)) self.cornerCurve = kCACornerCurveContinuous;
    self.cornerRadius = radius;
    self.maskedCorners = maskCorner;
}

- (void)xy_addShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity bounds:(CGRect)bounds {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bounds];
    self.shadowPath = path.CGPath;
    self.shadowColor = color.CGColor;
    self.shadowOffset = offset;
    self.shadowRadius = radius;
    self.shadowOpacity = opacity;
}

- (void)xy_addShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity {
    self.shadowColor = color.CGColor;
    self.shadowOffset = offset;
    self.shadowRadius = radius;
    self.shadowOpacity = opacity;
}

- (void)xy_removeAllSublayers {
    while (self.sublayers.count) {
        [self.sublayers.lastObject removeFromSuperlayer];
    }
}

- (UIImage *)xy_snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (CAShapeLayer *)xy_layerWithSize:(CGSize)size inside:(CGRect)inside color:(UIColor *)color radius:(CGFloat)radius {
    CGRect bound = CGRectMake(0, 0, size.width, size.height);
    UIBezierPath *outPath = [UIBezierPath bezierPathWithRect:bound];
    UIBezierPath *inPath = [[UIBezierPath bezierPathWithRoundedRect:inside cornerRadius:radius] bezierPathByReversingPath];
    [outPath appendPath:inPath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = outPath.CGPath;
    layer.fillColor = color.CGColor; // fill color
    layer.strokeColor = color.CGColor; // line color
    return layer;
}

+ (void)xy_performWithoutAnimation:(void (^ NS_NOESCAPE)(void))actionsWithoutAnimation {
    if (!actionsWithoutAnimation) return;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    actionsWithoutAnimation();
    [CATransaction commit];
}

@end
