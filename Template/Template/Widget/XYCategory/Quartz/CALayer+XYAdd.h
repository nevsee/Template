//
//  CALayer+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2017/1/10.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XYCategoryUtility.h"

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (XYAdd)

@property (nonatomic) CGFloat xy_top;
@property (nonatomic) CGFloat xy_left;
@property (nonatomic) CGFloat xy_bottom;
@property (nonatomic) CGFloat xy_right;
@property (nonatomic) CGFloat xy_width;
@property (nonatomic) CGFloat xy_height;
@property (nonatomic) CGPoint xy_center;
@property (nonatomic) CGFloat xy_centerX;
@property (nonatomic) CGFloat xy_centerY;
@property (nonatomic) CGPoint xy_origin;
@property (nonatomic) CGSize xy_size;

/**
 Adds corner for the layer.
 */
- (void)xy_addCornerRadius:(CGFloat)radius rectCorner:(UIRectCorner)rectCorner;
- (void)xy_addCornerRadius:(CGFloat)radius bounds:(CGRect)bounds rectCorner:(UIRectCorner)rectCorner;
- (void)xy_addCornerRadius:(CGFloat)radius maskCorner:(CACornerMask)maskCorner;
- (void)xy_addCornerRadius:(CGFloat)radius curve:(CALayerCornerCurve)curve API_AVAILABLE(ios(13.0));
- (void)xy_addCornerRadius:(CGFloat)radius maskCorner:(CACornerMask)maskCorner curve:(CALayerCornerCurve)curve API_AVAILABLE(ios(13.0));
- (void)xy_addContinuousCornerRadius:(CGFloat)radius;
- (void)xy_addContinuousCornerRadius:(CGFloat)radius maskCorner:(CACornerMask)maskCorner;

/**
 Adds shadow for the layer (shadowPath).
 */
- (void)xy_addShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity bounds:(CGRect)bounds;
- (void)xy_addShadowColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity;

/**
 Removes all sublayers.
 */
- (void)xy_removeAllSublayers;

/**
 Returns a snapshot image of the layer.
 */
- (nullable UIImage *)xy_snapshotImage;

/**
 Returns a layer which inside has a transparent area.
 */
+ (CAShapeLayer *)xy_layerWithSize:(CGSize)size inside:(CGRect)inside color:(UIColor *)color radius:(CGFloat)radius;

/**
 Removes the default animations of the layer.
 */
+ (void)xy_performWithoutAnimation:(void (NS_NOESCAPE ^)(void))actionsWithoutAnimation;

@end

NS_ASSUME_NONNULL_END
