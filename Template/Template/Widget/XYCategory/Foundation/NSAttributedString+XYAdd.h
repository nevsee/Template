//
//  NSAttributedString+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2020/10/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (XYAdd)

/**
 Creates and returns an NSAttributedString with a given image.
 */
+ (instancetype)xy_attributedStringWithImage:(UIImage *)image;
+ (instancetype)xy_attributedStringWithImage:(UIImage *)image
                              baselineOffset:(CGFloat)offset
                                  leftMargin:(CGFloat)leftMargin
                                 rightMargin:(CGFloat)rightMargin;

/**
 Creates and returns a white space NSAttributedString with a given width.
 */
+ (instancetype)xy_attributedStringWithFixedSpace:(CGFloat)width;

/**
 Creates and returns an NSAttributedString with a given string (NSString / NSAttributedString).
 */
+ (instancetype)xy_attributedStringWithString:(id)string
                                         font:(nullable UIFont *)font
                                    textColor:(nullable UIColor *)textColor;

+ (instancetype)xy_attributedStringWithString:(id)string
                                         font:(nullable UIFont *)font
                                    textColor:(nullable UIColor *)textColor
                                  lineSpacing:(CGFloat)lineSpacing;

+ (instancetype)xy_attributedStringWithString:(id)string
                                         font:(nullable UIFont *)font
                                    textColor:(nullable UIColor *)textColor
                                  lineSpacing:(CGFloat)lineSpacing
                                  kernSpacing:(CGFloat)kernSpacing
                                    alignment:(NSTextAlignment)alignment;

/**
 Returns the size of the attributed string that rendered with the specified constraints.
 */
- (CGSize)xy_sizeForFixedSize:(CGSize)size;
- (CGFloat)xy_widthForFixedHeight:(CGFloat)height;
- (CGFloat)xy_heightForFixedWidth:(CGFloat)width;

/**
 Returns a string with highlighted search string.
 */
- (NSAttributedString *)xy_highlightedOfString:(NSString *)searchString
                               foregroundColor:(nullable UIColor *)foregroundColor
                               backgroundColor:(nullable UIColor *)backgroundColor;

/**
 Returns the length of the string by counting the length of a non ASCII character to two.
 */
- (NSUInteger)xy_lengthByCountingNonASCIICharacterAsTwo;

/**
 Returns the range of the string.
 */
- (NSRange)xy_range;

@end

NS_ASSUME_NONNULL_END
