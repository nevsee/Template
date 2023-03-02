//
//  UIColor+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2016/12/24.
//  Copyright © 2016年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define XYColorHEXMake(hex) [UIColor xy_colorWithHexString:hex]
#define XYColorHEXAMake(hex, a) [UIColor xy_colorWithHexString:hex alpha:a]
#define XYColorRGBMake(rgb) [UIColor xy_colorWithRGBValue:rgb]
#define XYColorRGBAMake(rgb, a) [UIColor xy_colorWithRGBValue:rgb alpha:a]

@interface UIColor (XYAdd)

@property (nonatomic, readonly) CGFloat xy_red;
@property (nonatomic, readonly) CGFloat xy_green;
@property (nonatomic, readonly) CGFloat xy_blue;
@property (nonatomic, readonly) CGFloat xy_alpha;
@property (nonatomic, readonly) CGFloat xy_hue;
@property (nonatomic, readonly) CGFloat xy_saturation;
@property (nonatomic, readonly) CGFloat xy_brightness;

/**
 Creates and returns an UIColor with the specified RGB/RGBA hex string.
 @note
 Valid format: RGB  RGBA  RRGGBB  RRGGBBAA
 The `#` or `0x` sign is not required.
 The alpha will be set to 1.0 if there is no alpha component.
 It will return nil when an error occurs in parsing.
 @example
 "0xF6F", "66CCFF77", "#66CCFF88"
 */
+ (nullable UIColor *)xy_colorWithHexString:(NSString *)hexString;
+ (nullable UIColor *)xy_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 Creates and returns an UIColor with the specified RGB/RGBA hex value.
 @note
 Valid format: 0xRRGGBB  0xRRGGBBAA
 The alpha will be set to 1.0 if there is no alpha component.
 It will return nil when an error occurs in parsing.
 @example
 0x66CCFF, 0x66CCFF88
 */
+ (nullable UIColor *)xy_colorWithRGBValue:(uint32_t)rgbValue;
+ (nullable UIColor *)xy_colorWithRGBValue:(uint32_t)rgbValue alpha:(CGFloat)alpha;
+ (nullable UIColor *)xy_colorWithRGBAValue:(uint32_t)rgbaValue;

/**
 Creates and returns an UIColor with the specified RGB/RGBA string.
 @note
 Valid format: R,G,B  R,G,B,A
 The alpha will be set to 1.0 if there is no alpha component.
 It will return nil when an error occurs in parsing.
 @example
 "255,255,255,0.5", "255,255,255"
 */
+ (nullable UIColor *)xy_colorWithRGBAString:(NSString *)rgbaString;
+ (nullable UIColor *)xy_colorWithRGBString:(NSString *)rgbString alpha:(CGFloat)alpha;

/**
 Creates and returns a random color.
 */
+ (UIColor *)xy_randomColor;

/**
 Returns the color's RGB hex string (uppercase).
 Such as "0066CC".
 */
@property (nonatomic, readonly) NSString *xy_hexString;

/**
 Returns the color's RGBA hex string (uppercase).
 Such as "0066CCFF".
 */
@property (nonatomic, readonly) NSString *xy_hexStringWithAlpha;

/**
 Returns the color's RGB hex value (uppercase).
 Such as 0x0066CC.
 */
@property (nonatomic, readonly) uint32_t xy_rgbValue;

/**
 Returns the color's RGBA hex value (uppercase).
 Such as 0x0066CCFF.
 */
@property (nonatomic, readonly) uint32_t xy_rgbaValue;

/**
 Returns the color's RGB string.
 Such as "255,255,255".
 */
@property (nonatomic, readonly) NSString *xy_rgbString;

/**
 Returns the color's RGBA string.
 Such as "255,255,255,0.50".
 */
@property (nonatomic, readonly) NSString *xy_rgbaString;

/**
 Returns the progress percentage color when transitioning from one color to another color.
 The progress value should be in the [0,1] range.
 */
- (UIColor *)xy_transitionToColor:(UIColor *)toColor progress:(CGFloat)progress;
+ (UIColor *)xy_transitionFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
