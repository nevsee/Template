//
//  YYGlobalUtility+String.h
//  Template
//
//  Created by nevsee on 2022/1/27.
//

#import "YYGlobalUtility.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYGlobalUtility (String)

/**
 格式化数字
 @param value 数字（NSString / NSNumber）
 @param fractionDigits 小数点位数
 @param roundingMode 四舍五入模式
 @param style 格式样式
 @example
 123456.789 -> 123,456.789（NSNumberFormatterDecimalStyle）
 */
+ (NSString *)formatDecimalValue:(id)value
                  fractionDigits:(NSInteger)fractionDigits
                           style:(NSNumberFormatterStyle)style
                    roundingMode:(NSNumberFormatterRoundingMode)roundingMode;

+ (NSString *)formatDecimalValue:(id)value
                  fractionDigits:(NSInteger)fractionDigits
                           style:(NSNumberFormatterStyle)style
                    roundingMode:(NSNumberFormatterRoundingMode)roundingMode
                         setting:(nullable void (NS_NOESCAPE ^)(NSNumberFormatter *formatter))setting;

/**
 将字符串数组转化成标签样式富文本
 @param list 要转化的数组
 @param textAttributes 文本样式
 @param insets 标签内边距
 @param itemSpacing 标签列间隔
 @param lineSpacing 标签行间隔
 @param backgroundColor 标签背景色
 @param cornerRadius 标签圆角，设置-1为高度一半
 @param alignment 文本对齐方式
 @param descriptor 将list的item转化为字符串
 @example
 [YYGlobalUtility tagStrings:list ... usingDescriptor:^NSString * (id item) {
     YYUserTeam *team = item;
     return team.name;
 }];
 */
+ (NSAttributedString *)tagStrings:(NSArray *)list
                    textAttributes:(NSDictionary *)textAttributes
                            insets:(UIEdgeInsets)insets
                      cornerRadius:(CGFloat)cornerRadius
                   backgroundColor:(UIColor *)backgroundColor
                       itemSpacing:(CGFloat)itemSpacing
                       lineSpacing:(CGFloat)lineSpacing
                         alignment:(NSTextAlignment)alignment
                   usingDescriptor:(nullable NSString * (NS_NOESCAPE ^)(id item))descriptor;

@end

NS_ASSUME_NONNULL_END
