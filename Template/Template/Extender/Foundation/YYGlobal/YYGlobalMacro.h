//
//  YYGlobalMacro.h
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#ifndef YYGlobalMacro_h
#define YYGlobalMacro_h

/// 屏幕是否是横屏
#define YYIsInterfaceLandscape [UIApplication.sharedApplication xy_isInterfaceLandscape]

/// 设备是否是横屏
#define YYIsDeviceLandscape [UIApplication.sharedApplication xy_isDeviceLandscape]

/// 带物理凹槽的刘海屏或者使用Home Indicator类型的设备
#define YYIsNotched [UIDevice xy_isNotched]

/// 屏幕宽度大于400pt的设备，小于400pt的设备在横屏时，导航栏状态栏高度会变小
#define YYIsRegular [UIDevice xy_isRegular]

/// 屏幕宽高
#define YYScreenWidth [UIDevice xy_screenWidth]
#define YYScreenHeight [UIDevice xy_screenHeight]

/// 设备宽高
#define YYDeviceWidth [UIDevice xy_deviceWidth]
#define YYDeviceHeight [UIDevice xy_deviceHeight]

/// 安全区域
#define YYSafeArea [UIDevice xy_safeAreaInsets]

/// 状态栏高度
#define YYStatusBarHeight \
(UIApplication.sharedApplication.statusBarHidden ? 0 : UIApplication.sharedApplication.statusBarFrame.size.height)

/// 状态栏静态高度，无论是否隐藏
/// 非Notched设备高度20，Notched设备高度44
/// 特殊情况：iPhone11 高度48，iPhone12/13 高度47, iPhone12/13 mini 50
#define YYStatusBarFixedHeight \
(UIApplication.sharedApplication.statusBarHidden ? \
(YYIsNotched ? (YYIsInterfaceLandscape ? 0 : ([UIDevice.xy_model isEqualToString:@"iPhone12,1"] ? 48 : (UIDevice.xy_is61InchExtra || UIDevice.xy_is67Inch ? 47 : (UIDevice.xy_is54Inch ? 50 : 44)))) : 20) : \
UIApplication.sharedApplication.statusBarFrame.size.height)

/// 导航栏静态高度
#define YYNavigationBarFixedHeight (YYIsInterfaceLandscape ? (YYIsRegular ? 44 : 32) : 44)

/// 导航栏静态高度加状态栏静态高度
#define YYNavigationContentFixedHeight (YYNavigationBarFixedHeight + YYStatusBarFixedHeight)

/// 标签栏静态高度
#define YYTabBarFixedHeight ((YYIsInterfaceLandscape ? (YYIsRegular ? 49 : 32) : 49) + YYSafeArea.bottom)

/// 一个像素大小
#define YYOnePixel (1 / [UIScreen mainScreen].scale)

#endif /* YYGlobalMacro_h */
