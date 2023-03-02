//
//  UIColor+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2016/12/24.
//  Copyright © 2016年 nevsee. All rights reserved.
//

#import "UIColor+XYAdd.h"
#import "NSString+XYAdd.h"
#import "NSArray+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(UIColor_XYAdd)

static inline NSUInteger _xy_color_hexStrToInt(NSString *str) {
    uint32_t result = 0;
    if (str.length == 1) {
        str = [str stringByAppendingString:str];
    }
    sscanf([str UTF8String], "%X", &result);
    return result;
}

static BOOL _xy_color_hexStrToRGBA(NSString *str, CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    str = [[str xy_stringByTrimming] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //       RGB        RGBA         RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    // RGB, RGBA, RRGGBB, RRGGBBAA
    if (length < 5) {
        *r = _xy_color_hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.f;
        *g = _xy_color_hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.f;
        *b = _xy_color_hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.f;
        if (length == 4)  *a = _xy_color_hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.f;
        else *a = 1;
    } else {
        *r = _xy_color_hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.f;
        *g = _xy_color_hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.f;
        *b = _xy_color_hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.f;
        if (length == 8) *a = _xy_color_hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.f;
        else *a = 1;
    }
    return YES;
}

static BOOL _xy_color_RGBAStrToRGBA(NSString *str, CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    str = [str xy_stringByTrimming];
    if (str.length == 0) return NO;
    
    NSArray<NSString *> *components = [str xy_componentsSeparatedByStrings:@","];
    components = [components xy_filteredArrayUsingBlock:^BOOL(NSString *item, NSInteger index) {
        return item.xy_stringByTrimming.length > 0;
    }];
    
    if (components.count < 3 || components.count > 4) {
        return NO;
    }
    
    // RGB RGBA
    *r = components[0].integerValue / 255.f;
    *g = components[1].integerValue / 255.f;
    *b = components[2].integerValue / 255.f;
    *a = components.count == 4 ? components[3].floatValue : 1;
    
    return YES;
}

@implementation UIColor (XYAdd)

- (CGFloat)xy_red {
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)xy_green {
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)xy_blue {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)xy_alpha {
    return CGColorGetAlpha(self.CGColor);
}

- (CGFloat)xy_hue {
    CGFloat h = 0, s, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return h;
}

- (CGFloat)xy_saturation {
    CGFloat h, s = 0, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return s;
}

- (CGFloat)xy_brightness {
    CGFloat h, s, b = 0, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return b;
}

+ (UIColor *)xy_colorWithHexString:(NSString *)hexString {
    CGFloat r, g, b, a;
    if (_xy_color_hexStrToRGBA(hexString, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

+ (UIColor *)xy_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    CGFloat r, g, b, a;
    if (_xy_color_hexStrToRGBA(hexString, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
    }
    return nil;
}

+ (UIColor *)xy_colorWithRGBValue:(uint32_t)rgbValue {
    return [self xy_colorWithRGBValue:rgbValue alpha:1];
}

+ (UIColor *)xy_colorWithRGBValue:(uint32_t)rgbValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:alpha];
}

+ (UIColor *)xy_colorWithRGBAValue:(uint32_t)rgbaValue {
    return [UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24) / 255.0f
                           green:((rgbaValue & 0xFF0000) >> 16) / 255.0f
                            blue:((rgbaValue & 0xFF00) >> 8) / 255.0f
                           alpha:(rgbaValue & 0xFF) / 255.0f];
}

+ (UIColor *)xy_colorWithRGBAString:(NSString *)rgbaString {
    CGFloat r, g, b, a;
    if (_xy_color_RGBAStrToRGBA(rgbaString, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

+ (UIColor *)xy_colorWithRGBString:(NSString *)rgbString alpha:(CGFloat)alpha {
    CGFloat r, g, b, a;
    if (_xy_color_RGBAStrToRGBA(rgbString, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
    }
    return nil;
}

+ (UIColor *)xy_randomColor {
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return [UIColor colorWithRed:r / 255.f green:g/ 255.f blue:b / 255.f alpha:1.0];
}

- (NSString *)xy_hexString {
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    } else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    return hex;
}

- (NSString *)xy_hexStringWithAlpha {
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    } else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    return [hex stringByAppendingFormat:@"%02lx", (unsigned long)(self.xy_alpha * 255.0 + 0.5)];
}

- (uint32_t)xy_rgbValue {
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    return (red << 16) + (green << 8) + blue;
}

- (uint32_t)xy_rgbaValue {
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    uint8_t alpha = a * 255;
    return (red << 24) + (green << 16) + (blue << 8) + alpha;
}

- (NSString *)xy_rgbString {
    return [NSString stringWithFormat:@"%.0f,%.0f,%.0f",
            round(self.xy_red * 255),
            round(self.xy_green * 255),
            round(self.xy_blue * 255)];
}

- (NSString *)xy_rgbaString {
    return [NSString stringWithFormat:@"%.0f,%.0f,%.0f,%.2f",
            round(self.xy_red * 255),
            round(self.xy_green * 255),
            round(self.xy_blue * 255),
            self.xy_alpha];
}

- (UIColor *)xy_transitionToColor:(UIColor *)toColor progress:(CGFloat)progress {
    return [UIColor xy_transitionFromColor:self toColor:toColor progress:progress];
}

+ (UIColor *)xy_transitionFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress {
    if (progress <= 0) return fromColor;
    if (progress >= 1) return toColor;
    
    CGFloat fromRed = fromColor.xy_red;
    CGFloat fromGreen = fromColor.xy_green;
    CGFloat fromBlue = fromColor.xy_blue;
    CGFloat fromAlpha = fromColor.xy_alpha;
    
    CGFloat toRed = toColor.xy_red;
    CGFloat toGreen = toColor.xy_green;
    CGFloat toBlue = toColor.xy_blue;
    CGFloat toAlpha = toColor.xy_alpha;
    
    CGFloat percentRed = fromRed + (toRed - fromRed) * progress;
    CGFloat percentGreen = fromGreen + (toGreen - fromGreen) * progress;
    CGFloat percentBlue = fromBlue + (toBlue - fromBlue) * progress;
    CGFloat percentAlpha = fromAlpha + (toAlpha - fromAlpha) * progress;
    
    return [UIColor colorWithRed:percentRed green:percentGreen blue:percentBlue alpha:percentAlpha];
}

@end
