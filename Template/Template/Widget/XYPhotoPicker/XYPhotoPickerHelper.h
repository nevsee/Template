//
//  XYPhotoPickerHelper.h
//  XYPhotoPicker
//
//  Created by nevsee on 2017/6/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYPhotoPickerHelper : NSObject

/**
 转换时间
 */
+ (NSString *)transformTimeIntervalWithSecond:(NSTimeInterval)second;

/**
 复选框勾选动画
 */
+ (void)addAnimationForCheckBoxButton:(UIButton *)button;
+ (void)removeAnimationForCheckBoxButton:(UIButton *)button;

/**
 是否是横屏
 */
+ (BOOL)isInterfaceLandscape;

/**
 国际化
 */
+ (NSString *)localizedStringForKey:(NSString *)key;

/**
 获取app名称
 */
+ (NSString *)obtainAppDisplayName;

/**
 获取图片
 */
+ (UIImage *)imageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
