//
//  YYPickerDateMaker.h
//  Template
//
//  Created by nevsee on 2022/1/7.
//

#import "YYPickerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, YYPickerDateMode) {
    YYPickerDateModeYear = 1 << 0, ///< 年
    YYPickerDateModeMonth = 1 << 1, ///< 月
    YYPickerDateModeDay = 1 << 2, ///< 日
    YYPickerDateModeHour = 1 << 3, ///< 时
    YYPickerDateModeMinute = 1 << 4, ///< 分
    YYPickerDateModeSecond = 1 << 5, ///< 秒
};

/**
 日期数据源
 1.mode只能是连续性日期，如 Year | Month ✅  Month | Day ✅  Year | Day ❎
 2.sort支持日期显示顺序，与mode对应，如 1;1;1；
 3.format支持日期显示格式，与mode对应，如 %d年;%d月;%d日；
 4.非完整日期情况下，默认取最小日期minimumDate，如 Month | Day；
 */
@interface YYPickerDateMaker : NSObject <YYPickerDataSourceMaker>
@property (nonatomic, assign) YYPickerDateMode mode;
@property (nonatomic, strong, nullable) NSString *sort; ///< 显示顺序，0倒序，1正序，用`;`隔开，默认nil
@property (nonatomic, strong, nullable) NSString *format; ///< 显示格式，用`;`隔开，默认nil
@property (nonatomic, strong, nullable) NSCalendarIdentifier identifier; ///< 默认NSCalendarIdentifierGregorian
@property (nonatomic, strong, nullable) NSLocale *locale; ///< 地区，默认nil
@property (nonatomic, strong, nullable) NSTimeZone *timeZone; ///< 时区，默认nil
@property (nonatomic, strong, nullable) NSDate *minimumDate; ///< 起始日期，默认[NSDate distantPast]
@property (nonatomic, strong, nullable) NSDate *maximumDate; ///< 结束日期，默认[NSDate distantFuture]
- (nullable NSArray *)indexesOfDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
