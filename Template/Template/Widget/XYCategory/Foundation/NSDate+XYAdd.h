//
//  NSDate+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2019/11/6.
//  Copyright © 2019 yimai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (XYAdd)
@property (nonatomic, readonly) NSInteger xy_era;
@property (nonatomic, readonly) NSInteger xy_year;
@property (nonatomic, readonly) NSInteger xy_month;
@property (nonatomic, readonly) NSInteger xy_day;
@property (nonatomic, readonly) NSInteger xy_hour;
@property (nonatomic, readonly) NSInteger xy_minute;
@property (nonatomic, readonly) NSInteger xy_second;
@property (nonatomic, readonly) NSInteger xy_nanosecond;
@property (nonatomic, readonly) NSInteger xy_weekday;
@property (nonatomic, readonly) NSInteger xy_weekdayOrdinal;
@property (nonatomic, readonly) NSInteger xy_quarter;
@property (nonatomic, readonly) NSInteger xy_weekOfMonth;
@property (nonatomic, readonly) NSInteger xy_weekOfYear;
@property (nonatomic, readonly) NSInteger xy_yearForWeekOfYear;
@property (nonatomic, readonly, getter=xy_isLeapMonth) BOOL xy_leapMonth;
@property (nonatomic, readonly, getter=xy_isLeapYear) BOOL xy_leapYear;
@property (nonatomic, readonly, getter=xy_isToday) BOOL xy_today; ///< (based on current locale)
@property (nonatomic, readonly, getter=xy_isYesterday) BOOL xy_yesterday; ///< (based on current locale)
@property (nonatomic, readonly) NSTimeInterval xy_timestamp;

/**
 Returns a date parsed from given string interpreted using the format.
 @example [NSDate xy_dateWithString:@"1990:10:25" format:@"yyyy:MM:dd"]
*/
+ (nullable NSDate *)xy_dateWithString:(NSString *)dateString format:(NSString *)format;
+ (nullable NSDate *)xy_dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(nullable NSTimeZone *)timeZone locale:(nullable NSLocale *)locale;

/**
 Returns a formatted string representing this date.
 @param format See http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 @example
 Pattern                                             Result
 yyyy.MM.dd G 'at' HH:mm:ss zzz       1996.07.10 AD at 15:08:56 PDT
 EEE, MMM d, ''yy                               Wed, July 10, '96
 h:mm a                                               12:08 PM
 hh 'o''clock' a, zzzz                      12 o'clock PM, Pacific Daylight Time
 K:mm a, z                                           0:00 PM, PST
 yyyyy.MMMM.dd GGG hh:mm aaa            01996.July.10 AD 12:08 PM
 */
- (nullable NSString *)xy_stringWithFormat:(NSString *)format;
- (nullable NSString *)xy_stringWithFormat:(NSString *)format timeZone:(nullable NSTimeZone *)timeZone locale:(nullable NSLocale *)locale;

/**
 Returns days of a month in a year.
 */
+ (NSUInteger)xy_numberOfDaysInMonth:(NSUInteger)month year:(NSUInteger)year;

@end

NS_ASSUME_NONNULL_END
