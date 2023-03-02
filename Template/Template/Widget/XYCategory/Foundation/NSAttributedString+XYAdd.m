//
//  NSAttributedString+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2020/10/20.
//

#import "NSAttributedString+XYAdd.h"
#import "NSString+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(NSAttributedString_XYAdd)

@implementation NSAttributedString (XYAdd)

+ (instancetype)xy_attributedStringWithImage:(UIImage *)image {
    return [self xy_attributedStringWithImage:image baselineOffset:0 leftMargin:0 rightMargin:0];
}

+ (instancetype)xy_attributedStringWithImage:(UIImage *)image baselineOffset:(CGFloat)offset leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin {
    if (!image) {
        return nil;
    }
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    NSMutableAttributedString *string = [[NSAttributedString attributedStringWithAttachment:attachment] mutableCopy];
    [string addAttribute:NSBaselineOffsetAttributeName value:@(offset) range:NSMakeRange(0, string.length)];
    if (leftMargin > 0) {
        [string insertAttributedString:[self xy_attributedStringWithFixedSpace:leftMargin] atIndex:0];
    }
    if (rightMargin > 0) {
        [string appendAttributedString:[self xy_attributedStringWithFixedSpace:rightMargin]];
    }
    return string;
}

+ (instancetype)xy_attributedStringWithFixedSpace:(CGFloat)width {
    UIGraphicsBeginImageContext(CGSizeMake(width, 1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [self xy_attributedStringWithImage:image];
}

+ (instancetype)xy_attributedStringWithString:(id)string font:(UIFont *)font textColor:(UIColor *)textColor {
    return [self xy_attributedStringWithString:string font:font textColor:textColor lineSpacing:0];
}

+ (instancetype)xy_attributedStringWithString:(id)string font:(UIFont *)font textColor:(UIColor *)textColor lineSpacing:(CGFloat)lineSpacing {
    return [self xy_attributedStringWithString:string font:font textColor:textColor lineSpacing:lineSpacing kernSpacing:0 alignment:NSTextAlignmentLeft];
}

+ (instancetype)xy_attributedStringWithString:(id)string font:(UIFont *)font textColor:(UIColor *)textColor lineSpacing:(CGFloat)lineSpacing kernSpacing:(CGFloat)kernSpacing alignment:(NSTextAlignment)alignment {
    if (!string) return nil;
    
    NSMutableAttributedString *result = nil;
    if ([string isKindOfClass:NSString.class]) {
        result = [[NSMutableAttributedString alloc] initWithString:string];
    } else if ([string isKindOfClass:NSAttributedString.class] || [string isKindOfClass:NSMutableAttributedString.class]) {
        result = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    }
    if (!result) return nil;
    
    if (font) [result addAttribute:NSFontAttributeName value:font range:result.xy_range];
    if (textColor) [result addAttribute:NSForegroundColorAttributeName value:textColor range:result.xy_range];
    if (kernSpacing > 0) [result addAttribute:NSKernAttributeName value:@(kernSpacing) range:result.xy_range];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    style.alignment = alignment;
    [result addAttribute:NSParagraphStyleAttributeName value:style range:result.xy_range];
    return result;
}

- (CGSize)xy_sizeForFixedSize:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) return CGSizeZero;
    return [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                              context:nil].size;
}

- (CGFloat)xy_widthForFixedHeight:(CGFloat)height {
    if (height <= 0) return 0;
    return [self xy_sizeForFixedSize:CGSizeMake(HUGE, height)].width;
}

- (CGFloat)xy_heightForFixedWidth:(CGFloat)width {
    if (width <= 0) return 0;
    return [self xy_sizeForFixedSize:CGSizeMake(width, HUGE)].height;
}

- (NSAttributedString *)xy_highlightedOfString:(NSString *)searchString foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor {
    if (!searchString || searchString.length == 0) return self;
    if (!foregroundColor && !backgroundColor) return self;
    NSError *error;
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:searchString options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) return self;
        
    NSMutableAttributedString *attributedString = self.mutableCopy;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (foregroundColor) [attributes setValue:foregroundColor forKey:NSForegroundColorAttributeName];
    if (backgroundColor) [attributes setValue:backgroundColor forKey:NSBackgroundColorAttributeName];
    
    [expression enumerateMatchesInString:self.string options:NSMatchingReportProgress range:self.string.xy_range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange range = result.range;
        if (range.length > 0) {
            [attributedString addAttributes:attributes range:range];
        }
    }];
    return attributedString.copy;
}

- (NSUInteger)xy_lengthByCountingNonASCIICharacterAsTwo {
    return self.string.xy_lengthByCountingNonASCIICharacterAsTwo;
}

- (NSRange)xy_range {
    return self.string.xy_range;
}

@end
