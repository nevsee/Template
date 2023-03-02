//
//  YYGlobalUtility+Other.h
//  Template
//
//  Created by nevsee on 2022/1/28.
//

#import "YYGlobalUtility.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YYMathOperatingMode) {
    YYMathOperatingModeAdd, ///< 加
    YYMathOperatingModeSubtract, ///< 减
    YYMathOperatingModeMultiply, ///< 乘
    YYMathOperatingModeDivide ///< 除
};

@interface YYGlobalUtility (Other)

/**
 通过首字母排序字符
 @param list 要排序的数组
 @param descriptor 将list的item转化为字母字符串
 @return 排序好的字典 {"keys": ["A", "C"], "values": [[item, item], [item]]}
 @example
 [YYGlobalUtility sortStringsByFirstLetter:users usingDescriptor:^NSString * (id item) {
    YYUserModel *user = item;
    // 转拼音
    return [user.name xy_mandarinLatinTransformedByUppercase:YES needsDiacritics:NO];
 }];
 */
+ (NSDictionary *)sortStringsByFirstLetter:(NSArray *)list usingDescriptor:(nullable NSString * (NS_NOESCAPE ^)(id item))descriptor;

/**
 比较数字大小（NSString/NSDecimalNumber）
 */
+ (NSComparisonResult)compareValue:(id)value1 withValue:(id)value2;

/**
 修改小数精度
 @param value 要调整的小数（NSString/NSDecimalNumber）
 @param scale 精度长度
 @param roundingMode 四舍五入方式
 */
+ (NSDecimalNumber *)modifyDecimalPrecision:(id)value
                                      scale:(short)scale
                               roundingMode:(NSRoundingMode)roundingMode;

/**
 修改小数精度（NSRoundPlain）
 @param value 要调整的小数（NSString/NSDecimalNumber）
 @param scale 精度长度
 */
+ (NSDecimalNumber *)modifyDecimalPrecision:(id)value scale:(short)scale;

/**
 数学运算
 @param value1 运算数（NSString/NSDecimalNumber）
 @param value2 被运算数（NSString/NSDecimalNumber）
 @param scale 精度长度
 @param roundingMode 四舍五入方式
 @param operatingMode 运算方式
 @warning 当运算方式是YYMathOperatingModeDivide时，value2的值不可为空或者0
 */
+ (NSDecimalNumber *)operateWithValue:(id)value1
                                value:(id)value2
                                scale:(short)scale
                         roundingMode:(NSRoundingMode)roundingMode
                        operatingMode:(YYMathOperatingMode)operatingMode;

@end

NS_ASSUME_NONNULL_END
