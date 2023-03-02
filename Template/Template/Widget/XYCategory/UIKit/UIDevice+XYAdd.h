//
//  UIDevice+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2017/3/30.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (XYAdd)

/// @see http://theiphonewiki.com/wiki/Models
@property (class, nonatomic, readonly) NSString *xy_model;
@property (class, nonatomic, readonly) NSString *xy_modelName;

@property (class, nonatomic, readonly) CGSize xy_screenSize;
@property (class, nonatomic, readonly) CGFloat xy_screenWidth;
@property (class, nonatomic, readonly) CGFloat xy_screenHeight;

/// Whether the screen orientation is landscape or portrait, the device
/// size will remain the same.
@property (class, nonatomic, readonly) CGSize xy_deviceSize;
@property (class, nonatomic, readonly) CGFloat xy_deviceWidth;
@property (class, nonatomic, readonly) CGFloat xy_deviceHeight;

@property (class, nonatomic, readonly) BOOL xy_isPhone;
@property (class, nonatomic, readonly) BOOL xy_isPad;
@property (class, nonatomic, readonly) BOOL xy_isAppleWatch;
@property (class, nonatomic, readonly) BOOL xy_isSimulator;

/// @see https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
@property (class, nonatomic, readonly) BOOL xy_is35Inch; ///< iPhone 4
@property (class, nonatomic, readonly) BOOL xy_is40Inch; ///< iPhone 5
@property (class, nonatomic, readonly) BOOL xy_is47Inch; ///< iPhone 6 / 7 / 8 / SE
@property (class, nonatomic, readonly) BOOL xy_is54Inch; ///< iPhone 12 mini / 13 mini
@property (class, nonatomic, readonly) BOOL xy_is55Inch; ///< iPhone 6p / 7p / 8p
@property (class, nonatomic, readonly) BOOL xy_is58Inch; ///< iPhone X / XS / 11 Pro
@property (class, nonatomic, readonly) BOOL xy_is61Inch; ///< iPhone XR / 11
@property (class, nonatomic, readonly) BOOL xy_is61InchExtra; ///< iPhone 12 / 12 Pro / 13 / 13 Pro / 14
@property (class, nonatomic, readonly) BOOL xy_is61InchExtra2; ///< iPhone 14 Pro
@property (class, nonatomic, readonly) BOOL xy_is65Inch; ///< iPhone XS Max / 11 Pro Max
@property (class, nonatomic, readonly) BOOL xy_is67Inch; ///< iPhone 12 Pro Max / 13 Pro Max / 14 Plus
@property (class, nonatomic, readonly) BOOL xy_is67InchExtra; ///< iPhone 14 Pro Max
@property (class, nonatomic, readonly) CGSize xy_sizeFor35Inch;
@property (class, nonatomic, readonly) CGSize xy_sizeFor40Inch;
@property (class, nonatomic, readonly) CGSize xy_sizeFor47Inch;
@property (class, nonatomic, readonly) CGSize xy_sizeFor54Inch;
@property (class, nonatomic, readonly) CGSize xy_sizeFor55Inch;
@property (class, nonatomic, readonly) CGSize xy_sizeFor58Inch;
@property (class, nonatomic, readonly) CGSize xy_sizeFor61Inch;
@property (class, nonatomic, readonly) CGSize xy_sizeFor61InchExtra;
@property (class, nonatomic, readonly) CGSize xy_sizeFor61InchExtra2;
@property (class, nonatomic, readonly) CGSize xy_sizeFor65Inch;
@property (class, nonatomic, readonly) CGSize xy_sizeFor67Inch;
@property (class, nonatomic, readonly) CGSize xy_sizeFor67InchExtra;

@property (class, nonatomic, readonly) double xy_systemVersion;

/// Whether the iphone is zoom mode.
/// @see https://support.apple.com/zh-cn/guide/iphone/iphd6804774e/ios
@property (class, nonatomic, readonly) BOOL xy_isZoom;

/// Using home indicator device or notched device. eg iPhone X
@property (class, nonatomic, readonly) BOOL xy_isNotched;

/// Returns YES when the screen width is greater than 400 pt.
@property (class, nonatomic, readonly) BOOL xy_isRegular;

/// Whether the iphone is the 64 bit system.
@property (class, nonatomic, readonly) BOOL xy_is64Bit;

/// Safe area inset
@property (class, nonatomic, readonly) UIEdgeInsets xy_safeAreaInsets;

/// Returns disk space size. -1 if error occurs.
@property (class, nonatomic, readonly) int64_t xy_diskSpace;
@property (class, nonatomic, readonly) int64_t xy_diskSpaceFree;
@property (class, nonatomic, readonly) int64_t xy_diskSpaceUsage;

/// Returns cpu usage. -1 if error occurs.
@property (class, nonatomic, readonly) float xy_cpuUsage;

/// Returns memory usage. -1 if error occurs.
@property (class, nonatomic, readonly) int64_t xy_memory;
@property (class, nonatomic, readonly) int64_t xy_memoryFree;
@property (class, nonatomic, readonly) int64_t xy_memoryUsage;

@end

NS_ASSUME_NONNULL_END

