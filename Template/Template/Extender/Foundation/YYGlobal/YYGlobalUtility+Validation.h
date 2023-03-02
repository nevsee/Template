//
//  YYGlobalUtility+Validation.h
//  Template
//
//  Created by nevsee on 2022/1/28.
//

#import "YYGlobalUtility.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYGlobalUtility (Validation)

/**
 验证邮箱
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 验证手机号
 */
+ (BOOL)validatePhone:(NSString *)phone;

/**
 验证身份证
 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

/**
 验证hex字符串
 @discussion 大写或者小写字母
 */
+ (BOOL)validateHex:(NSString *)hex;

/**
 验证链接
 */
+ (BOOL)validateLink:(NSString *)link;

/**
 验证整数
 @discussion 0或者不以0开头的数字
 @example
 0、123可以通过，0123不能通过
 */
+ (BOOL)validateInteger:(NSString *)integer;

/**
 验证小数
 @discussion
 1. 小数点后面至少有一个数字
 2. 小于1的小数整数位只能是0
 @example
 10、10.7可以通过，0.不能通过
 */
+ (BOOL)validateDecimal:(NSString *)decimal;

/**
 验证小数
 @discussion
 1. 小数点后面可以没有数字
 2. 小于1的小数整数位只能是0
 */
+ (BOOL)validateDecimal2:(NSString *)decimal;

/**
 验证数字字符串
 */
+ (BOOL)validateNumber:(NSString *)number;

/**
 验证字母字符串
 @discussion 大写或者小写字母
 */
+ (BOOL)validateCharacter:(NSString *)character;

/**
 验证数字和点字符串
 */
+ (BOOL)validateNumberAndDot:(NSString *)number;

/**
 验证数字和字母字符串
 @discussion 大写或者小写字母
 */
+ (BOOL)validateNumberAndCharacter:(NSString *)string;

/**
 验证输入是否是整数
 @discussion
 1. 0或者不以0开头的数字
 */
+ (BOOL)validateIntegerInputWithText:(NSString *)text replacementRange:(NSRange)replacementRange replacementString:(NSString *)replacementString;

/**
 验证输入是否是小数
 @discussion
 1. 小数点后面至少有一个数字
 2. 小于1的小数整数位只能是0
 */
+ (BOOL)validateDecimalInputWithText:(NSString *)text replacementRange:(NSRange)replacementRange replacementString:(NSString *)replacementString;

@end

NS_ASSUME_NONNULL_END
