//
//  YYGlobalUtility+Date.h
//  Template
//
//  Created by nevsee on 2022/1/28.
//

#import "YYGlobalUtility.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YYDateFormatDisplayMode) {
    /// yyyy-MM-dd HH:mm:ss
    YYDateFormatDisplayModeDateAndTime,
    
    /// yyyy-MM-dd
    YYDateFormatDisplayModeDate,
    
    /// 0 <= time < 60s          8秒前
    /// 60s <= time < 1h        8分钟前
    /// 1h <= time < 24h        8小时前
    /// 今年                          11-08
    /// 往年                          2018-11-08
    YYDateFormatDisplayModeRange,
    
    /// 当天                               18:18
    /// 当天 < time <= 昨天        昨天 18:18
    /// 昨天 < time <= 一周        星期一 18:18
    /// 今年                              11-08
    /// 往年                              2018-08-18
    YYDateFormatDisplayModeSpecific,
};

@interface YYGlobalUtility (Date)

/**
 将时间戳转化成逻辑时间字符串
 @param timestamp 秒级时间戳
 */
+ (NSString *)formatTimestamp:(NSTimeInterval)timestamp forMode:(YYDateFormatDisplayMode)mode;

/**
 获取当前秒级时间戳
 */
+ (NSString *)getCurrentSecondTimestamp;

/**
 获取当前毫秒级时间戳
 */
+ (NSString *)getCurrentMillisecondTimestamp;

@end

NS_ASSUME_NONNULL_END
