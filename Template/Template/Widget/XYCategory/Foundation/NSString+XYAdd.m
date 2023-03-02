//
//  NSString+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2016/12/24.
//  Copyright © 2016年 nevsee. All rights reserved.
//

#import "NSString+XYAdd.h"
#import "NSData+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(NSString_XYAdd)

@implementation NSString (XYAdd)

- (NSArray *)xy_substrings {
    __block NSMutableArray *strings = [NSMutableArray array];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              [strings addObject:substring];
                          }];
    return strings;
}

- (NSString *)xy_substringFromIndex:(NSUInteger)index less:(BOOL)less {
    return [self xy_substringFromIndex:index less:less nonASCIIAsTwo:NO];
}

- (NSString *)xy_substringFromIndex:(NSUInteger)index less:(BOOL)less nonASCIIAsTwo:(BOOL)nonASCIIAsTwo {
    NSUInteger length = nonASCIIAsTwo ? self.xy_lengthByCountingNonASCIICharacterAsTwo : self.length;
    if (index == 0) return self;
    if (index >= length) return @"";
    index = nonASCIIAsTwo ? [self _transformIndexToDefaultModeWithIndex:index] : index;
    NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:index];
    BOOL match = range.length > 1; // composed character sequence
    return [self substringFromIndex:match && range.location != index ? (less ? NSMaxRange(range) : range.location) : index];
}

- (NSString *)xy_substringToIndex:(NSUInteger)index less:(BOOL)less {
    return [self xy_substringToIndex:index less:less nonASCIIAsTwo:NO];
}

- (NSString *)xy_substringToIndex:(NSUInteger)index less:(BOOL)less nonASCIIAsTwo:(BOOL)nonASCIIAsTwo {
    NSUInteger length = nonASCIIAsTwo ? self.xy_lengthByCountingNonASCIICharacterAsTwo : self.length;
    if (index == 0) return @"";
    if (index >= length) return self;
    index = nonASCIIAsTwo ? [self _transformIndexToDefaultModeWithIndex:index] : index;
    NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:index];
    BOOL match = range.length > 1; // composed character sequence
    return [self substringToIndex:match && range.location != index ? (less ? range.location : NSMaxRange(range)) : index];
}

- (NSString *)xy_substringWithRange:(NSRange)range less:(BOOL)less {
    return [self xy_substringWithRange:range less:less nonASCIIAsTwo:NO];
}

- (NSString *)xy_substringWithRange:(NSRange)range less:(BOOL)less nonASCIIAsTwo:(BOOL)nonASCIIAsTwo {
    NSUInteger length = nonASCIIAsTwo ? self.xy_lengthByCountingNonASCIICharacterAsTwo : self.length;
    if (range.length == 0) return @"";
    if (range.location == 0 && range.length >= length) return self;
    
    XYIGNORE_WARC_RETAIN_CYCLE_WARNING_BEGIN
    __block NSRange (^findLessRangeBlock)(NSRange range);
    findLessRangeBlock = ^NSRange (NSRange range) {
        if (range.length == 0) return range;
        NSRange crange = [self rangeOfComposedCharacterSequencesForRange:range];
        // check composed character sequence
        if (NSEqualRanges(crange, range)) return crange;
        if (crange.location == range.location) {
            return findLessRangeBlock(NSMakeRange(range.location, range.length - 1));
        } else {
            return findLessRangeBlock(NSMakeRange(range.location + 1, range.length - 1));
        }
    };
    XYIGNORE_WARC_RETAIN_CYCLE_WARNING_END
    
    range = nonASCIIAsTwo ? [self _transformRangeToDefaultModeWithRange:range] : range;
    NSRange resultRange = less ? findLessRangeBlock(range) : [self rangeOfComposedCharacterSequencesForRange:range];
    return [self substringWithRange:resultRange];
}

- (NSString *)xy_stringByTrimming {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)xy_stringByTrimmingAll {
    return [self stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];;
}

- (NSString *)xy_stringByRemovingCharacterAtIndex:(NSUInteger)index {
    if (index == self.length) return self;
    NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:index];
    return [self stringByReplacingCharactersInRange:range withString:@""];
}

- (NSString *)xy_stringByRemovingCharacterAtRange:(NSRange)range {
    if (range.length == 0) return self;
    if (range.location == 0 && range.length == self.length) return @"";
    NSRange crange = [self rangeOfComposedCharacterSequencesForRange:range];
    return [self stringByReplacingCharactersInRange:crange withString:@""];
}

- (NSString *)xy_stringByRemovingLastCharacter {
    return [self xy_stringByRemovingCharacterAtIndex:self.length - 1];
}

- (NSString *)xy_firstLetterCapitalized {
    if (self.length == 0) return nil;
    return [NSString stringWithFormat:@"%@%@", [self substringToIndex:1].uppercaseString, [self substringFromIndex:1]];
}

- (NSString *)xy_base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)options {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:options];
}

- (NSData *)xy_base64EncodedDataWithOptions:(NSDataBase64EncodingOptions)options {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedDataWithOptions:options];
}

- (NSString *)xy_base64DecodedStringWithOptions:(NSDataBase64DecodingOptions)options {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:options];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSData *)xy_base64DecodedDataWithOptions:(NSDataBase64DecodingOptions)options {
    return [[NSData alloc] initWithBase64EncodedString:self options:options];
}

- (NSString *)xy_URLEncodedString {
    /**
     @see https://github.com/AFNetworking/AFNetworking/blob/master/AFNetworking/AFURLRequestSerialization.m
     Returns a percent-escaped string following RFC 3986 for a query string key or value.
     RFC 3986 states that the following characters are "reserved" characters.
        - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
        - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
     In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
     query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
     should be percent-escaped in the query string.
        - parameter string: The string to be percent-escaped.
        - returns: The percent-escaped string.
     */
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    static NSUInteger const batchSize = 50;
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];

    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;

    while (index < self.length) {
        NSUInteger length = MIN(self.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [self rangeOfComposedCharacterSequencesForRange:range];
        NSString *substring = [self substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        index += range.length;
    }
    
    return escaped;
}

- (NSString *)xy_URLDecodedString {
    return [self stringByRemovingPercentEncoding];
}

- (id)xy_jsonValueDecoded {
    return [[self xy_dataValue] xy_jsonValueDecoded];
}

- (CGSize)xy_sizeForAttributes:(NSDictionary *)attributes size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result = CGSizeZero;
    if (!attributes || !attributes[NSFontAttributeName]) return result;
    
    NSMutableParagraphStyle *paragraphStyle = attributes[NSParagraphStyleAttributeName];
    NSMutableDictionary *attributesCopy = attributes.mutableCopy;
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        attributesCopy[NSParagraphStyleAttributeName] = paragraphStyle;
    }
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        result = [self boundingRectWithSize:size
                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                 attributes:attributesCopy
                                    context:nil].size;
    } else {
        XYIGNORE_WDEPRECATED_DECLARATIONS_WARNING_BEGIN
        result = [self sizeWithFont:attributes[NSFontAttributeName] constrainedToSize:size lineBreakMode:lineBreakMode];
        XYIGNORE_WDEPRECATED_DECLARATIONS_WARNING_END
    }
    return result;
}

- (CGSize)xy_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    if (!font) return CGSizeZero;
    NSDictionary *attributes = @{NSFontAttributeName: font};
    return [self xy_sizeForAttributes:attributes size:size mode:lineBreakMode];
}

- (CGFloat)xy_widthForAttributes:(NSDictionary *)attributes height:(CGFloat)height {
    return [self xy_sizeForAttributes:attributes size:CGSizeMake(HUGE, height) mode:NSLineBreakByWordWrapping].width;
}

- (CGFloat)xy_widthForFont:(UIFont *)font height:(CGFloat)height {
    if (!font) return 0;
    NSDictionary *attributes = @{NSFontAttributeName: font};
    return [self xy_widthForAttributes:attributes height:height];
}

- (CGFloat)xy_heightForAttributes:(NSDictionary *)attributes width:(CGFloat)width {
    return [self xy_sizeForAttributes:attributes size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping].height;
}

- (CGFloat)xy_heightForFont:(UIFont *)font width:(CGFloat)width {
    if (!font) return 0;
    NSDictionary *attributes = @{NSFontAttributeName: font};
    return [self xy_heightForAttributes:attributes width:width];
}

- (CGFloat)xy_heightForAttributes:(NSDictionary *)attributes width:(CGFloat)width line:(NSUInteger)line {
    if (line <= 0 || line > 999) return 0;
    CGFloat maxHeight = [self xy_heightForAttributes:attributes width:width];
    CGFloat lineHeight = [NSString xy_heightForAttributes:attributes line:line];
    return lineHeight >= maxHeight ? maxHeight : lineHeight;
}

- (CGFloat)xy_heightForFont:(UIFont *)font width:(CGFloat)width line:(NSUInteger)line {
    if (!font) return 0;
    NSDictionary *attributes = @{NSFontAttributeName: font};
    return [self xy_heightForAttributes:attributes width:width line:line];
}

- (NSUInteger)xy_lineForAttributes:(NSDictionary *)attributes width:(CGFloat)width {
    CGFloat lineHeight = [NSString xy_heightForAttributes:attributes line:1];
    CGFloat maxHeight = [self xy_heightForAttributes:attributes width:width];
    if (lineHeight == 0) return 0;
    return (NSUInteger)((maxHeight + 1) / lineHeight);
}

- (NSUInteger)xy_lineForFont:(UIFont *)font width:(CGFloat)width {
    if (!font) return 0;
    NSDictionary *attributes = @{NSFontAttributeName: font};
    return [self xy_lineForAttributes:attributes width:width];
}

+ (CGFloat)xy_heightForAttributes:(NSDictionary *)attributes line:(NSUInteger)line {
    if (line <= 0 || line > 999) return 0;
    NSString *str = @"*";
    for (NSInteger i = 1; i < line; i ++) {
        str = [str stringByAppendingString:@"\n*"];
    }
    return [str xy_heightForAttributes:attributes width:HUGE];
}

+ (CGFloat)xy_heightForFont:(UIFont *)font line:(NSUInteger)line {
    if (!font) return 0;
    NSDictionary *attributes = @{NSFontAttributeName: font};
    return [self xy_heightForAttributes:attributes line:line];
}

+ (NSString *)xy_stringWithTimestamp:(NSTimeInterval)timestamp format:(NSString *)format {
    if (timestamp == 0 || format.length == 0) return nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [formatter stringFromDate:date];
}

+ (NSString *)xy_stringWithTimestamp:(NSTimeInterval)timestamp format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    if (timestamp == 0 || format.length == 0) return nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [formatter stringFromDate:date];
}

- (NSUInteger)xy_lengthByCountingNonASCIICharacterAsTwo {
    NSUInteger length = 0;
    for (NSUInteger i = 0, l = self.length; i < l; i++) {
        unichar character = [self characterAtIndex:i];
        if (isascii(character)) {
            length += 1;
        } else {
            length += 2;
        }
    }
    return length;
}

- (NSRange)xy_range {
    return NSMakeRange(0, self.length);
}

- (NSArray *)xy_componentsSeparatedByStrings:(NSString *)strings {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:strings];
    return [self componentsSeparatedByCharactersInSet:set];
}

- (NSArray *)xy_invertedComponentsSeparatedByStrings:(NSString *)strings {
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:strings] invertedSet];
    return [self componentsSeparatedByCharactersInSet:set];
}

- (NSData *)xy_dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)xy_mandarinLatinTransformedByUppercase:(BOOL)uppercase needsDiacritics:(BOOL)needsDiacritics {
    NSMutableString *mutableString = self.mutableCopy;
    CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformMandarinLatin, NO);
    if (!needsDiacritics) {
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, NO);
    }
    return uppercase ? mutableString.uppercaseString : mutableString;
}

- (NSArray<NSValue *> *)xy_allRangesOfString:(NSString *)searchString {
    if (!searchString || searchString.length == 0) return nil;
    NSError *error;
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:searchString options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) return nil;
        
    __block NSMutableArray *results = [NSMutableArray array];
    [expression enumerateMatchesInString:self options:NSMatchingReportProgress range:self.xy_range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange range = result.range;
        if (range.length > 0) {
            [results addObject:[NSValue valueWithRange:result.range]];
        }
    }];
    return results.count > 0 ? results.copy : nil;
}

+ (NSString *)xy_stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

- (NSString *)xy_mimeTypeForBase64String {
    if (self.length == 0 || !([self hasPrefix:@"data:"] && [self containsString:@";base64,"])) return nil;
    NSString *prefixData = [self componentsSeparatedByString:@";base64,"].firstObject;
    if (prefixData.length == 0) return nil;
    return [prefixData componentsSeparatedByString:@"data:"].lastObject;
}

- (NSString *)xy_effectiveContentForBase64String {
    if (self.length == 0 || !([self hasPrefix:@"data:"] && [self containsString:@";base64,"])) return nil;
    return [self componentsSeparatedByString:@";base64,"].lastObject;
}

#pragma mark # Private

- (NSUInteger)_transformIndexToDefaultModeWithIndex:(NSUInteger)index {
    CGFloat strlength = 0.f;
    NSUInteger i = 0;
    for (i = 0; i < self.length; i++) {
        unichar character = [self characterAtIndex:i];
        if (isascii(character)) {
            strlength += 1;
        } else {
            strlength += 2;
        }
        if (strlength >= index + 1) return i;
    }
    return 0;
}

- (NSRange)_transformRangeToDefaultModeWithRange:(NSRange)range {
    CGFloat strlength = 0.f;
    NSRange resultRange = NSMakeRange(NSNotFound, 0);
    NSUInteger i = 0;
    for (i = 0; i < self.length; i++) {
        unichar character = [self characterAtIndex:i];
        if (isascii(character)) {
            strlength += 1;
        } else {
            strlength += 2;
        }
        if (strlength >= range.location + 1) {
            if (resultRange.location == NSNotFound) {
                resultRange.location = i;
            }
            
            if (range.length > 0 && strlength >= NSMaxRange(range)) {
                resultRange.length = i - resultRange.location + (strlength == NSMaxRange(range) ? 1 : 0);
                return resultRange;
            }
        }
    }
    return resultRange;
}

@end
