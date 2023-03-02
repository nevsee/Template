//
//  YYPickerDateMaker.m
//  Template
//
//  Created by nevsee on 2022/1/7.
//

#import "YYPickerDateMaker.h"

static inline NSString * YYGetValueSafely(NSArray *values, NSInteger index, NSString *format) {
    if (values.count == 0 || index < 0) return nil;
    index = MIN(index, values.count - 1);
    return format ? [NSString stringWithFormat:format, [values[index] integerValue]] : values[index];
}

static inline NSArray *YYMakeArray(NSInteger min, NSInteger max, BOOL sort) {
    if (min > max) return nil;
    NSMutableArray *array = [NSMutableArray array];
    if (sort) {
        for (NSInteger i = min; i <= max; i++) {
            [array addObject:@(i).stringValue];
        }
    } else {
        for (NSInteger i = max; i >= min; i--) {
            [array addObject:@(i).stringValue];
        }
    }
    return array.copy;
}

@implementation YYPickerDateMaker {
    NSCalendar *_calendar;
    NSDateComponents *_minimumDateComponents, *_maximumDateComponents;
    NSMutableArray *_modes;
    NSMutableDictionary *_sorts, *_formats;
    NSInteger _components;
    NSArray *_years, *_months, *_days, *_hours, *_minutes, *_seconds;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _mode = YYPickerDateModeYear | YYPickerDateModeMonth | YYPickerDateModeDay;
        _identifier = NSCalendarIdentifierGregorian;
        _minimumDate = [NSDate distantPast];
        _maximumDate = [NSDate distantFuture];
        [self updateCalendar];
        [self updateDateComponents];
        [self transformDateMode];
    }
    return self;
}

// Delegate

- (NSInteger)numberOfComponentsInPickerView:(YYPickerView *)pickerView {
    return _components;
}

- (NSInteger)pickerView:(YYPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger mode = [_modes[component] integerValue];
    NSInteger year = -1, month = -1, day = -1, hour = -1, minute = -1;
    
    NSInteger index = 0;
    if (_mode & YYPickerDateModeYear && index <= component) {
        if (_years.count == 0) {
            NSInteger sort = _sorts.count ? [_sorts[@(YYPickerDateModeYear)] integerValue] : 1;
            _years = [self fetchYears:sort];
        }
        NSInteger row = [pickerView selectedRowInComponent:index++];
        year = [_years[row] integerValue];
    }
    if (_mode & YYPickerDateModeMonth && index <= component) {
        if (_months.count == 0 || (index == component && year > -1)) {
            NSInteger sort = _sorts.count ? [_sorts[@(YYPickerDateModeMonth)] integerValue] : 1;
            _months = [self fetchMonthsForYear:year sort:sort];
        }
        NSInteger row = [pickerView selectedRowInComponent:index++];
        month = [YYGetValueSafely(_months, row, nil) integerValue];
    }
    if (_mode & YYPickerDateModeDay && index <= component) {
        if (_days.count == 0 || (index == component && month > -1)) {
            NSInteger sort = _sorts.count ? [_sorts[@(YYPickerDateModeDay)] integerValue] : 1;
            _days = [self fetchDaysForYear:year month:month sort:sort];
        }
        NSInteger row = [pickerView selectedRowInComponent:index++];
        day = [YYGetValueSafely(_days, row, nil) integerValue];
    }
    if (_mode & YYPickerDateModeHour && index <= component) {
        if (_hours.count == 0 || (index == component && day > -1)) {
            NSInteger sort = _sorts.count ? [_sorts[@(YYPickerDateModeHour)] integerValue] : 1;
            _hours = [self fetchHoursForYear:year month:month day:day sort:sort];
        }
        NSInteger row = [pickerView selectedRowInComponent:index++];
        hour = [YYGetValueSafely(_hours, row, nil) integerValue];
    }
    if (_mode & YYPickerDateModeMinute && index <= component) {
        if (_minutes.count == 0 || (index == component && hour > -1)) {
            NSInteger sort = _sorts.count ? [_sorts[@(YYPickerDateModeMinute)] integerValue] : 1;
            _minutes = [self fetchMinutesForYear:year month:month day:day hour:hour sort:sort];
        }
        NSInteger row = [pickerView selectedRowInComponent:index++];
        minute = [YYGetValueSafely(_minutes, row, nil) integerValue];
    }
    if (_mode & YYPickerDateModeSecond && index <= component) {
        if (_seconds.count == 0 || (index == component && minute > -1)) {
            NSInteger sort = _sorts.count ? [_sorts[@(YYPickerDateModeSecond)] integerValue] : 1;
            _seconds = [self fetchSecondsForYear:year month:month day:day hour:hour minute:minute sort:sort];
        }
    }
    
    if (mode == YYPickerDateModeYear) return _years.count;
    if (mode == YYPickerDateModeMonth) return _months.count;
    if (mode == YYPickerDateModeDay) return _days.count;
    if (mode == YYPickerDateModeHour) return _hours.count;
    if (mode == YYPickerDateModeMinute) return _minutes.count;
    if (mode == YYPickerDateModeSecond) return _seconds.count;
    return 0;
}

- (NSString *)pickerView:(YYPickerView *)pickerView valueForRow:(NSInteger)row inComponent:(NSUInteger)component {
    NSInteger mode = [_modes[component] integerValue];
    if (mode == YYPickerDateModeYear) return YYGetValueSafely(_years, row, nil);
    if (mode == YYPickerDateModeMonth) return YYGetValueSafely(_months, row, nil);
    if (mode == YYPickerDateModeDay) return YYGetValueSafely(_days, row, nil);
    if (mode == YYPickerDateModeHour) return YYGetValueSafely(_hours, row, nil);
    if (mode == YYPickerDateModeMinute) return YYGetValueSafely(_minutes, row, nil);
    if (mode == YYPickerDateModeSecond) return YYGetValueSafely(_seconds, row, nil);
    return nil;
}

- (NSString *)pickerView:(YYPickerView *)pickerView nameForRow:(NSInteger)row inComponent:(NSUInteger)component {
    NSInteger mode = [_modes[component] integerValue];
    NSString *format = _formats.count ? _formats[@(mode)] : nil;
    if (mode == YYPickerDateModeYear) return YYGetValueSafely(_years, row, format);
    if (mode == YYPickerDateModeMonth) return YYGetValueSafely(_months, row, format);
    if (mode == YYPickerDateModeDay) return YYGetValueSafely(_days, row, format);
    if (mode == YYPickerDateModeHour) return YYGetValueSafely(_hours, row, format);
    if (mode == YYPickerDateModeMinute) return YYGetValueSafely(_minutes, row, format);
    if (mode == YYPickerDateModeSecond) return YYGetValueSafely(_seconds, row, format);
    return nil;
}

// Method

- (void)updateCalendar {
    if (!_calendar || ![_calendar.calendarIdentifier isEqualToString:_identifier]) {
        _calendar = [NSCalendar calendarWithIdentifier:_identifier];
    }
    if (_locale) _calendar.locale = _locale;
    if (_timeZone) _calendar.timeZone = _timeZone;
}

- (void)updateDateComponents {
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    _minimumDateComponents = [_calendar components:unit fromDate:_minimumDate ?: [NSDate distantPast]];
    _maximumDateComponents = [_calendar components:unit fromDate:_maximumDate ?: [NSDate distantFuture]];
}

- (void)transformDateMode {
    _components = 0;
    _modes = [NSMutableArray array];
    _sorts = [NSMutableDictionary dictionary];
    _formats = [NSMutableDictionary dictionary];
    
    NSInteger index = 0;
    NSArray *tempSorts = [_sort componentsSeparatedByString:@";"];
    NSArray *tempFormats = [_format componentsSeparatedByString:@";"];
    
    while (index < 6) {
        YYPickerDateMode mode = 1 << index;
        index++;
        if (!(_mode & mode)) continue;
        [_modes addObject:@(mode)];
        if (tempSorts && _components < tempSorts.count) {
            [_sorts setObject:tempSorts[_components] forKey:@(mode)];
        }
        if (tempFormats && _components < tempFormats.count) {
            [_formats setObject:tempFormats[_components] forKey:@(mode)];
        }
        _components++;
    }
}

// 查询时间
- (NSArray *)fetchYears:(BOOL)sort {
    NSInteger beginYear = _minimumDateComponents.year;
    NSInteger endYear = _maximumDateComponents.year;
    return YYMakeArray(beginYear, endYear, sort);
}

- (NSArray *)fetchMonthsForYear:(NSInteger)year sort:(BOOL)sort {
    if (year == -1) year = _minimumDateComponents.year;
    
    NSInteger beginMonth = 1;
    NSInteger endMonth = 12;
    if (year == _minimumDateComponents.year) {
        beginMonth = _minimumDateComponents.month;
    }
    if (year == _maximumDateComponents.year) {
        endMonth = _maximumDateComponents.month;
    }
    return YYMakeArray(beginMonth, endMonth, sort);
}

- (NSArray *)fetchDaysForYear:(NSInteger)year month:(NSInteger)month sort:(BOOL)sort {
    if (year == -1) year = _minimumDateComponents.year;
    if (month == -1) month = _minimumDateComponents.month;
    
    NSInteger beginDay = 1;
    NSInteger endDay = [NSDate xy_numberOfDaysInMonth:month year:year];
    if (year == _minimumDateComponents.year &&
        month == _minimumDateComponents.month) {
        beginDay = _minimumDateComponents.day;
    }
    if (year == _maximumDateComponents.year &&
        month == _maximumDateComponents.month) {
        endDay = _maximumDateComponents.day;
    }
    return YYMakeArray(beginDay, endDay, sort);
}

- (NSArray *)fetchHoursForYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day sort:(BOOL)sort {
    if (year == -1) year = _minimumDateComponents.year;
    if (month == -1) month = _minimumDateComponents.month;
    if (day == -1) day = _minimumDateComponents.day;
    
    NSInteger beginHour = 0;
    NSInteger endHour = 23;
    if (year == _minimumDateComponents.year &&
        month == _minimumDateComponents.month &&
        day == _minimumDateComponents.day) {
        beginHour = _minimumDateComponents.hour;
    }
    if (year == _maximumDateComponents.year &&
        month == _maximumDateComponents.month &&
        day == _maximumDateComponents.day) {
        endHour = _maximumDateComponents.hour;
    }
    return YYMakeArray(beginHour, endHour, sort);
}

- (NSArray *)fetchMinutesForYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour sort:(BOOL)sort {
    if (year == -1) year = _minimumDateComponents.year;
    if (month == -1) month = _minimumDateComponents.month;
    if (day == -1) day = _minimumDateComponents.day;
    if (hour == -1) hour = _minimumDateComponents.hour;
    
    NSInteger beginMinute = 0;
    NSInteger endMinute = 59;
    if (year == _minimumDateComponents.year &&
        month == _minimumDateComponents.month &&
        day == _minimumDateComponents.day &&
        hour == _minimumDateComponents.hour) {
        beginMinute = _minimumDateComponents.minute;
    }
    if (year == _maximumDateComponents.year &&
        month == _maximumDateComponents.month &&
        day == _maximumDateComponents.day &&
        hour == _maximumDateComponents.hour) {
        endMinute = _maximumDateComponents.minute;
    }
    return YYMakeArray(beginMinute, endMinute, sort);
}

- (NSArray *)fetchSecondsForYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute sort:(BOOL)sort {
    if (year == -1) year = _minimumDateComponents.year;
    if (month == -1) month = _minimumDateComponents.month;
    if (day == -1) day = _minimumDateComponents.day;
    if (hour == -1) hour = _minimumDateComponents.hour;
    if (minute == -1) minute = _minimumDateComponents.minute;
    
    NSInteger beginSecond = 0;
    NSInteger endSecond = 59;
    if (year == _minimumDateComponents.year &&
        month == _minimumDateComponents.month &&
        day == _minimumDateComponents.day &&
        hour == _minimumDateComponents.hour &&
        minute == _minimumDateComponents.minute) {
        beginSecond = _minimumDateComponents.second;
    }
    if (year == _maximumDateComponents.year &&
        month == _maximumDateComponents.month &&
        day == _maximumDateComponents.day &&
        hour == _maximumDateComponents.hour &&
        minute == _maximumDateComponents.minute) {
        endSecond = _maximumDateComponents.second;
    }
    return YYMakeArray(beginSecond, endSecond, sort);
}

- (NSArray *)indexesOfDate:(NSDate *)date {
    if (!date) return nil;
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    BOOL v1 = [_calendar compareDate:date toDate:_minimumDate toUnitGranularity:unit] == NSOrderedDescending;
    BOOL v2 = [_calendar compareDate:date toDate:_maximumDate toUnitGranularity:unit] == NSOrderedAscending;
    if (!v1 || !v2) return nil;
    NSDateComponents *dateComponents = [_calendar components:unit fromDate:date];
    NSInteger year = dateComponents.year;
    NSInteger month = dateComponents.month;
    NSInteger day = dateComponents.day;
    NSInteger hour = dateComponents.hour;
    NSInteger minute = dateComponents.minute;
    NSInteger second = dateComponents.second;
    
    NSMutableArray *indexes = [NSMutableArray array];
    for (NSInteger i = 0; i < _components; i++) {
        NSInteger mode = [_modes[i] integerValue];
        NSInteger sort = _sorts.count ? [_sorts[@(mode)] integerValue] : 1;
        NSInteger index = 0;
        if (mode == YYPickerDateModeYear) {
            NSArray *values = [self fetchYears:sort];
            index = [values indexOfObject:@(year).stringValue];
            [indexes addObject:@(index)];
        } else if (mode == YYPickerDateModeMonth) {
            NSArray *values = [self fetchMonthsForYear:year sort:sort];
            index = [values indexOfObject:@(month).stringValue];
            [indexes addObject:@(index)];
        } else if (mode == YYPickerDateModeDay) {
            NSArray *values = [self fetchDaysForYear:year month:month sort:sort];
            index = [values indexOfObject:@(day).stringValue];
            [indexes addObject:@(index)];
        } else if (mode == YYPickerDateModeHour) {
            NSArray *values = [self fetchHoursForYear:year month:month day:day sort:sort];
            index = [values indexOfObject:@(hour).stringValue];
            [indexes addObject:@(index)];
        } else if (mode == YYPickerDateModeMinute) {
            NSArray *values = [self fetchMinutesForYear:year month:month day:day hour:hour sort:sort];
            index = [values indexOfObject:@(minute).stringValue];
            [indexes addObject:@(index)];
        } else if (mode == YYPickerDateModeSecond) {
            NSArray *values = [self fetchSecondsForYear:year month:month day:day hour:hour minute:minute sort:sort];
            index = [values indexOfObject:@(second).stringValue];
            [indexes addObject:@(index)];
        }
    }
    return indexes.copy;
}

// Access

- (void)setMode:(YYPickerDateMode)mode {
    if (mode == _mode) return;
    _mode = mode;
    [self transformDateMode];
}

- (void)setSort:(NSString *)sort {
    if ([sort isEqualToString:_sort]) return;
    _sort = sort;
    [self transformDateMode];
}

- (void)setFormat:(NSString *)format {
    if ([format isEqualToString:_format]) return;
    _format = format;
    [self transformDateMode];
}

- (void)setIdentifier:(NSCalendarIdentifier)identifier {
    if (!identifier || [identifier isEqualToString:_identifier]) return;
    _identifier = identifier;
    [self updateCalendar];
    [self updateDateComponents];
}

- (void)setTimeZone:(NSTimeZone *)timeZone {
    if ([timeZone isEqual:_timeZone]) return;
    _timeZone = timeZone;
    [self updateCalendar];
    [self updateDateComponents];
}

- (void)setLocale:(NSLocale *)locale {
    if ([locale isEqual:_locale]) return;
    _locale = locale;
    [self updateCalendar];
    [self updateDateComponents];
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    if ([minimumDate isEqual:_minimumDate]) return;
    _minimumDate = minimumDate;
    [self updateDateComponents];
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    if ([maximumDate isEqual:_maximumDate]) return;
    _maximumDate = maximumDate;
    [self updateDateComponents];
}

@end
