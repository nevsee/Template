//
//  YYGlobalUtility+Date.m
//  Template
//
//  Created by nevsee on 2022/1/28.
//

#import "YYGlobalUtility+Date.h"

@implementation YYGlobalUtility (Date)

+ (NSString *)formatTimestamp:(NSTimeInterval)timestamp forMode:(YYDateFormatDisplayMode)mode {
    if (timestamp == 0) return nil;
    
    static NSDateFormatter *dateAndTimeFormatter;
    static NSDateFormatter *dateFormatter;
    static NSDateFormatter *hourFormatter;
    static NSDateFormatter *monthFormatter;
    static NSDateFormatter *yearFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateAndTimeFormatter = [[NSDateFormatter alloc] init];
        dateAndTimeFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        dateAndTimeFormatter.locale = [NSLocale currentLocale];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        dateFormatter.locale = [NSLocale currentLocale];
        
        hourFormatter = [[NSDateFormatter alloc] init];
        hourFormatter.dateFormat = @"HH:mm";
        hourFormatter.locale = [NSLocale currentLocale];
        
        monthFormatter = [[NSDateFormatter alloc] init];
        monthFormatter.dateFormat = @"MM-dd";
        monthFormatter.locale = [NSLocale currentLocale];
        
        yearFormatter = [[NSDateFormatter alloc] init];
        yearFormatter.dateFormat = @"yyyy-MM-dd";
        yearFormatter.locale = [NSLocale currentLocale];
    });
    NSDate *now = [NSDate new];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSTimeInterval delta = now.timeIntervalSince1970 - date.timeIntervalSince1970;
    
    if (mode == YYDateFormatDisplayModeDateAndTime) {
        return [dateAndTimeFormatter stringFromDate:date];
    }
    else if (mode == YYDateFormatDisplayModeDate) {
        return [dateFormatter stringFromDate:date];
    }
    else if (mode == YYDateFormatDisplayModeRange) {
        if (delta < 0) { // 本地时间有问题
            return [yearFormatter stringFromDate:date];
        } else if (delta < 60) { // 1分钟内
            return [NSString stringWithFormat:@"%@秒前", @(delta == 0 ? 1 : (int)delta)];
        } else if (delta < 60 * 60) { // 1小时内
            return [NSString stringWithFormat:@"%@分钟前", @((int)(delta / 60.0))];
        } else if (delta < 60 * 60 * 24) { // 24小时内
            return [NSString stringWithFormat:@"%@小时前", @((int)(delta / 60.0 / 60.0))];
        } else if (date.xy_year == now.xy_year) { // 今年
            return [monthFormatter stringFromDate:date];
        } else { // 往年
            return [yearFormatter stringFromDate:date];
        }
    }
    else if (mode == YYDateFormatDisplayModeSpecific) {
        if (delta < 0) { // 本地时间有问题
            return [yearFormatter stringFromDate:date];
        } else if (date.xy_isToday) { // 今天
            return [hourFormatter stringFromDate:date];
        } else if (date.xy_isYesterday) { // 昨天
            return [NSString stringWithFormat:@"昨天 %@", [hourFormatter stringFromDate:date]];
        } else if (delta <= 60 * 60 * 24 * 7) { // 星期
            NSArray *weekdays = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
            return [NSString stringWithFormat:@"%@ %@", weekdays[date.xy_weekday - 1], [hourFormatter stringFromDate:date]];
        } else if (date.xy_year == now.xy_year) { // 今年
            return [monthFormatter stringFromDate:date];
        } else { // 往年
            return [yearFormatter stringFromDate:date];
        }
    }
    return [dateAndTimeFormatter stringFromDate:date];
}

+ (NSString *)getCurrentSecondTimestamp {
    NSDate *date = [NSDate date];
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f", timestamp];
}

+ (NSString *)getCurrentMillisecondTimestamp {
    NSDate *date = [NSDate date];
    NSTimeInterval timestamp = [date timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%.0f", timestamp];
}

@end
