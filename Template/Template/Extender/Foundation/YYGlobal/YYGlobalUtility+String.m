//
//  YYGlobalUtility+String.m
//  Template
//
//  Created by nevsee on 2022/1/27.
//

#import "YYGlobalUtility+String.h"

@implementation YYGlobalUtility (String)

+ (NSString *)formatDecimalValue:(id)value fractionDigits:(NSInteger)fractionDigits style:(NSNumberFormatterStyle)style roundingMode:(NSNumberFormatterRoundingMode)roundingMode {
    return [self formatDecimalValue:value fractionDigits:fractionDigits style:style roundingMode:roundingMode setting:nil];
}

+ (NSString *)formatDecimalValue:(id)value fractionDigits:(NSInteger)fractionDigits style:(NSNumberFormatterStyle)style roundingMode:(NSNumberFormatterRoundingMode)roundingMode setting:(void (NS_NOESCAPE ^)(NSNumberFormatter *))setting {
    if (!value) return nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = style;
    formatter.maximumFractionDigits = fractionDigits;
    formatter.roundingMode = roundingMode;
    NSNumber *number = nil;
    if ([value isKindOfClass:NSString.class]) {
        number = [NSNumber numberWithDouble:[value doubleValue]];
    } else if ([value isKindOfClass:NSNumber.class]) {
        number = value;
    }
    if (setting) setting(formatter);
    return [formatter stringFromNumber:number];
}

+ (NSAttributedString *)tagStrings:(NSArray *)list textAttributes:(NSDictionary *)textAttributes insets:(UIEdgeInsets)insets cornerRadius:(CGFloat)cornerRadius backgroundColor:(UIColor *)backgroundColor itemSpacing:(CGFloat)itemSpacing lineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment usingDescriptor:(NSString * _Nonnull (^ NS_NOESCAPE)(id _Nonnull))descriptor {
    if (list.count == 0) return nil;
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    for (NSInteger i = 0; i < list.count; i++) {
        NSString *text = descriptor ? descriptor(list[i]) : list[i];
        XYLabel *label = [[XYLabel alloc] init];
        label.textInsets = insets;
        label.backgroundColor = backgroundColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.opaque = NO;
        label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:textAttributes];
        [label sizeToFit];
        
        UIImage *image = [label xy_snapshotImage];
        if (cornerRadius == -1) cornerRadius = image.size.height / 2.0;
        NSAttributedString *tagAttr = [NSAttributedString xy_attributedStringWithImage:[image xy_roundedImageWithRadius:cornerRadius]];
        [result appendAttributedString:tagAttr];
        
        if (i < list.count - 1) {
            NSAttributedString *spaceAttr = [NSAttributedString xy_attributedStringWithFixedSpace:itemSpacing];
            [result appendAttributedString:spaceAttr];
        }
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    style.alignment = alignment;
    [result addAttribute:NSParagraphStyleAttributeName value:style range:result.xy_range];
    return result.copy;
}

@end
