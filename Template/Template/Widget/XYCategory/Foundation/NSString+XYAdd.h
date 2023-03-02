//
//  NSString+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2016/12/24.
//  Copyright © 2016年 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define XYStringSafeMake(str) ([str isKindOfClass:[NSString class]] && str ? str : @"")

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XYAdd)

#pragma mark Substring

/**
 Returns an array containing all characters (Avoid breaking up character sequences).
 @example
 NSString *text = @"12😀";
 text.xy_strings is @[1, 2, 😀]"
 */
- (NSArray<NSString *> *)xy_substrings;

/**
 Returns a substring (Avoid breaking up character sequences).
 @example
 NSString *text = @"12😀";
 [text xy_substringFromIndex:3 less:YES] is @"";
 [text xy_substringFromIndex:3 less:NO] is @"😀";
 [text substringFromIndex:3] is @"\ude1d";
 */
- (NSString *)xy_substringFromIndex:(NSUInteger)index less:(BOOL)less;
- (NSString *)xy_substringFromIndex:(NSUInteger)index less:(BOOL)less nonASCIIAsTwo:(BOOL)nonASCIIAsTwo;

- (NSString *)xy_substringToIndex:(NSUInteger)index less:(BOOL)less;
- (NSString *)xy_substringToIndex:(NSUInteger)index less:(BOOL)less nonASCIIAsTwo:(BOOL)nonASCIIAsTwo;

- (NSString *)xy_substringWithRange:(NSRange)range less:(BOOL)less;
- (NSString *)xy_substringWithRange:(NSRange)range less:(BOOL)less nonASCIIAsTwo:(BOOL)nonASCIIAsTwo;

#pragma mark String modifying

/**
 Trims blank characters (space and newline).
 */
- (NSString *)xy_stringByTrimming; ///< head and tail
- (NSString *)xy_stringByTrimmingAll; ///< all

/**
 Removes characters at the specified position (Avoid breaking up character sequences).
 */
- (NSString *)xy_stringByRemovingCharacterAtIndex:(NSUInteger)index;
- (NSString *)xy_stringByRemovingCharacterAtRange:(NSRange)range;
- (NSString *)xy_stringByRemovingLastCharacter;

/**
 The first letter of the string should be capitalized.
 */
@property (nonatomic, strong, readonly, nullable) NSString *xy_firstLetterCapitalized;

#pragma mark Encode and decode

/**
 Returns a Base-64 encoded NSString from the receiver's contents using the given options.
 */
- (nullable NSString *)xy_base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)options;

/**
 Returns a Base-64, UTF-8 encoded NSData from the receiver's contents using the given options.
 */
- (nullable NSData *)xy_base64EncodedDataWithOptions:(NSDataBase64EncodingOptions)options;

/**
 Returns a string from a Base-64, UTF-8 encoded string using the given decode options.
 */
- (nullable NSString *)xy_base64DecodedStringWithOptions:(NSDataBase64DecodingOptions)options;

/**
 Returns an NSData from a Base-64, UTF-8 encoded NSString using the given decode options.
 */
- (nullable NSData *)xy_base64DecodedDataWithOptions:(NSDataBase64DecodingOptions)options;

/**
 Returns the URL encoded string.
 */
- (NSString *)xy_URLEncodedString;

/**
 Returns the URL decoded string.
 */
- (NSString *)xy_URLDecodedString;

/**
 Returns a dictionary or an array which is decoded from receiver's contents.
 Returns nil if an error occurs.
 */
- (nullable id)xy_jsonValueDecoded;

#pragma mark Size

/**
 Returns the size of the string that rendered with the specified constraints.
 `NSLineBreakByWordWrapping` by default.
 */
- (CGSize)xy_sizeForAttributes:(NSDictionary *)attributes size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
- (CGSize)xy_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

- (CGFloat)xy_widthForAttributes:(NSDictionary *)attributes height:(CGFloat)height;
- (CGFloat)xy_widthForFont:(UIFont *)font height:(CGFloat)height;

- (CGFloat)xy_heightForAttributes:(NSDictionary *)attributes width:(CGFloat)width;
- (CGFloat)xy_heightForFont:(UIFont *)font width:(CGFloat)width;

- (CGFloat)xy_heightForAttributes:(NSDictionary *)attributes width:(CGFloat)width line:(NSUInteger)line; ///< 1-999 lines
- (CGFloat)xy_heightForFont:(UIFont *)font width:(CGFloat)width line:(NSUInteger)line;

- (NSUInteger)xy_lineForAttributes:(NSDictionary *)attributes width:(CGFloat)width;
- (NSUInteger)xy_lineForFont:(UIFont *)font width:(CGFloat)width;

+ (CGFloat)xy_heightForAttributes:(NSDictionary *)attributes line:(NSUInteger)line; ///< 1-999 lines
+ (CGFloat)xy_heightForFont:(UIFont *)font line:(NSUInteger)line;

#pragma mark Date

/**
 Returns a formatted string representing this timestamp.
 @example [NSString xy_stringWithTimestamp:@"1504667976" format:@"yyyy:MM:dd"]
*/
+ (nullable NSString *)xy_stringWithTimestamp:(NSTimeInterval)timestamp format:(NSString *)format;
+ (nullable NSString *)xy_stringWithTimestamp:(NSTimeInterval)timestamp format:(NSString *)format timeZone:(nullable NSTimeZone *)timeZone locale:(nullable NSLocale *)locale;

#pragma mark Other

/**
 Returns the length of the string by counting the length of a non ASCII character to two.
 */
- (NSUInteger)xy_lengthByCountingNonASCIICharacterAsTwo;

/**
 Returns the range of the string.
 */
- (NSRange)xy_range;

/**
 Separates string by multiple strings.
 @example
 NSString *str = @"1a2b3c";
 NSArray *results = [str xy_componentsSeparatedByStrings:@"123"];
 results = @[@"", @"a", @"b", @"c"];
 */
- (NSArray<NSString *> *)xy_componentsSeparatedByStrings:(NSString *)strings;

/**
 Separates string by multiple strings.
 @example
 NSString *str = @"1a2b3c";
 NSArray *results = [str xy_invertedComponentsSeparatedByStrings:@"123"];
 results = @[@"1", @"2", @"3", @""];
 */
- (NSArray<NSString *> *)xy_invertedComponentsSeparatedByStrings:(NSString *)strings;

/**
 Returns a data using UTF-8 encoding.
 */
- (nullable NSData *)xy_dataValue;

/**
 Returns a mandarin latin of the string.
 */
- (NSString *)xy_mandarinLatinTransformedByUppercase:(BOOL)uppercase needsDiacritics:(BOOL)needsDiacritics;

/**
 Returns all ranges of the search string.
 @return Nil when no matching or an error occurs.
 */
- (nullable NSArray<NSValue *> *)xy_allRangesOfString:(NSString *)searchString;

/**
 Returns a new UUID NSString.
 */
+ (NSString *)xy_stringWithUUID;

/**
 Returns the MIME-Type of the base64 string.
 @warning Only use for base64 string.
 */
- (nullable NSString *)xy_mimeTypeForBase64String;

/**
 Returns the effective content of the base64 string.
 @warning Only use for base64 string.
 */
- (nullable NSString *)xy_effectiveContentForBase64String;

@end

NS_ASSUME_NONNULL_END
