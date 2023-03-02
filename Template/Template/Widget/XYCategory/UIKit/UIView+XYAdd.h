//
//  UIView+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2016/12/28.
//  Copyright © 2016年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYCategoryUtility.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XYAdd)

@property (nonatomic) CGFloat xy_left;
@property (nonatomic) CGFloat xy_top;
@property (nonatomic) CGFloat xy_right;
@property (nonatomic) CGFloat xy_bottom;
@property (nonatomic) CGFloat xy_width;
@property (nonatomic) CGFloat xy_height;
@property (nonatomic) CGFloat xy_centerX;
@property (nonatomic) CGFloat xy_centerY;
@property (nonatomic) CGPoint xy_origin;
@property (nonatomic) CGSize xy_size;

/**
 Returns the view safe area.
 */
@property (nonatomic, readonly) UIEdgeInsets xy_safeAreaInsets;

/**
 Returns the view's controller.
 */
@property (nonatomic, readonly, nullable) UIViewController *xy_viewController;

/**
 Adds corner for the view.
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
 Removes all subviews.
 */
- (void)xy_removeAllSubviews;

/**
 Returns a snapshot image of the view.
 */
- (nullable UIImage *)xy_snapshotImage;
- (nullable UIImage *)xy_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

@end

NS_ASSUME_NONNULL_END
