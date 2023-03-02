//
//  UIViewController+XYAutorotation.h
//  XYConstructor
//
//  Created by nevsee on 2017/9/23.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (XYAutorotation)

@property (nonatomic) BOOL xy_shouldAutorotate;
@property (nonatomic) UIInterfaceOrientationMask xy_supportedInterfaceOrientations;
@property (nonatomic) UIInterfaceOrientation xy_preferredInterfaceOrientationForPresentation;

/// supportedInterfaceOrientations 是否包含当前界面方向
@property (nonatomic, readonly) BOOL xy_containsInterfaceOrientation;

/// supportedInterfaceOrientations 所支持的方向中最优的方向
@property (nonatomic, readonly) UIDeviceOrientation xy_optimalDeviceOrientation;

/**
 设备旋转到当前控制器最优支持方向
 @return YES表示需要旋转，NO表示不需要旋转
 */
- (BOOL)xy_rotateToOptimaDeviceOrientationIfNeeded;

/**
 设备旋转到给定的方向
 @param orientation 需要旋转的方向
 @return YES表示设备旋转到给定方向，NO表示设备与给定方向一致不需要旋转
 */
+ (BOOL)xy_rotateToDeviceOrientation:(UIDeviceOrientation)orientation;

/**
 设备旋转到竖屏方向
 @return 如果当前界面方向是竖屏，则不旋转返回NO，否则旋转设备到竖屏返回YES
 */
+ (BOOL)xy_rotateToDevicePortraitOrientationIfNeeded;

/**
 将一个 UIInterfaceOrientationMask 转换成对应的 UIDeviceOrientation
 */
+ (UIDeviceOrientation)xy_transformsInterfaceOrientationMaskToDeviceOrientation:(UIInterfaceOrientationMask)mask;

/**
 判断一个 UIInterfaceOrientationMask 是否包含某个给定的 UIDeviceOrientation 方向
 */
+ (BOOL)xy_containsDeviceOrientation:(UIDeviceOrientation)deviceOrientation inInterfaceOrientationMask:(UIInterfaceOrientationMask)mask;

/**
 判断一个 UIInterfaceOrientationMask 是否包含某个给定的 UIInterfaceOrientation 方向
 */
+ (BOOL)xy_containsInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation inInterfaceOrientationMask:(UIInterfaceOrientationMask)mask ;

@end
