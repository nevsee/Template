//
//  YYGlobalUtility+Other.m
//  Template
//
//  Created by nevsee on 2022/1/28.
//

#import "YYGlobalUtility+Other.h"

@implementation YYGlobalUtility (Other)

+ (NSDictionary *)sortStringsByFirstLetter:(NSArray *)list usingDescriptor:(NSString * (NS_NOESCAPE ^)(id))descriptor {
    if (list.count == 0) return nil;
    
    static NSInteger const length = 27;
    static NSString *const letters[length] = {
        @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J",
        @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T",
        @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"
    };
    
    // 初始化桶
    NSMutableDictionary *buckets = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < length; i++) {
        NSMutableArray *value = [NSMutableArray array];
        [buckets setObject:value forKey:letters[i]];
    }
    
    // 排序
    for (id item in list) {
        NSString *string = descriptor ? descriptor(item) : item;
        NSString *pinyin = string.uppercaseString;
        if (pinyin.length == 0) {
            [buckets[@"#"] addObject:item];
            continue;
        };
        NSString *key = [pinyin substringToIndex:1];
        if ([buckets.allKeys containsObject:key]) {
            [buckets[key] addObject:item];
        } else {
            [buckets[@"#"] addObject:item];
        }
    }
    
    // 去掉空数据
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *keys = [NSMutableArray array];
    for (NSInteger i = 0; i < length; i++) {
        NSString *key = letters[i];
        NSMutableArray *value = buckets[key];
        if (value.count == 0) continue;
        [values addObject:value];
        [keys addObject:key];
    }
    
    return @{@"keys": keys, @"values": values};
}

+ (NSComparisonResult)compareValue:(id)value1 withValue:(id)value2 {
    if (!value1) value1 = @"0";
    if (!value2) value2 = @"0";
    
    NSDecimalNumber *d1 = nil, *d2 = nil;
    if ([value1 isKindOfClass:NSString.class]) {
        d1 = [NSDecimalNumber decimalNumberWithString:value1];
    } else if ([value1 isKindOfClass:NSDecimalNumber.class]) {
        d1 = value1;
    } else {
        d1 = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    if ([value2 isKindOfClass:NSString.class]) {
        d2 = [NSDecimalNumber decimalNumberWithString:value2];
    } else if ([value2 isKindOfClass:NSDecimalNumber.class]) {
        d2 = value2;
    } else {
        d2 = [NSDecimalNumber decimalNumberWithString:@"0"];
    }

    return [d1 compare:d2];
}

+ (NSDecimalNumber *)modifyDecimalPrecision:(id)value scale:(short)scale roundingMode:(NSRoundingMode)roundingMode {
    if (!value) return nil;
    
    NSDecimalNumber *decimal = nil;
    if ([value isKindOfClass:NSString.class]) {
        decimal = [NSDecimalNumber decimalNumberWithString:value];
    } else if ([value isKindOfClass:NSDecimalNumber.class]) {
        decimal = value;
    }
    if (!decimal) return nil;
    
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    return [decimal decimalNumberByRoundingAccordingToBehavior:behavior];
}

+ (NSDecimalNumber *)modifyDecimalPrecision:(id)value scale:(short)scale {
    return [self modifyDecimalPrecision:value scale:scale roundingMode:NSRoundPlain];
}

+ (NSDecimalNumber *)operateWithValue:(id)value1 value:(id)value2 scale:(short)scale roundingMode:(NSRoundingMode)roundingMode operatingMode:(YYMathOperatingMode)operatingMode {
    if (!value1 || !value2) return nil;
    
    NSDecimalNumber *d1 = nil, *d2 = nil;
    if ([value1 isKindOfClass:NSString.class]) {
        d1 = [NSDecimalNumber decimalNumberWithString:value1];
    } else if ([value1 isKindOfClass:NSDecimalNumber.class]) {
        d1 = value1;
    }
    if ([value2 isKindOfClass:NSString.class]) {
        d2 = [NSDecimalNumber decimalNumberWithString:value2];
    } else if ([value2 isKindOfClass:NSDecimalNumber.class]) {
        d2 = value2;
    }
    if (!d1 || !d2) return nil;
    
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    switch (operatingMode) {
        case YYMathOperatingModeAdd:
            return [d1 decimalNumberByAdding:d2 withBehavior:behavior];
        case YYMathOperatingModeSubtract:
            return [d1 decimalNumberBySubtracting:d2 withBehavior:behavior];
        case YYMathOperatingModeMultiply:
            return [d1 decimalNumberByMultiplyingBy:d2 withBehavior:behavior];
        case YYMathOperatingModeDivide:
            return [d1 decimalNumberByDividingBy:d2 withBehavior:behavior];
    }
}

@end
