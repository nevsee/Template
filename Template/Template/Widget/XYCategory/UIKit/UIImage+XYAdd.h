//
//  UIImage+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2017/1/3.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CMSampleBuffer.h>

NS_ASSUME_NONNULL_BEGIN

#define XYImageMake(img) [UIImage imageNamed:img]
#define XYImageFileMake(name) [UIImage xy_imageWithResource:name]
#define XYImageAnimatedFileMake(name) [UIImage xy_animatedImageWithResource:name]

typedef NS_ENUM(NSUInteger, XYImageGrayType) {
    XYImageGrayTypeWeightedAverage, ///< gray = r * 0.3 + g * 0.59 + b * 0.11
    XYImageGrayTypeAverage, ///< gray = (r + g + b) / 3
    XYImageGrayTypeMax, ///< gray = Max(Max(r, g), b)
    XYImageGrayTypeComponentRed, ///< gray = r
    XYImageGrayTypeComponentGreen, ///< gray = g
    XYImageGrayTypeComponentBlue ///< gray = b
};

@interface UIImage (XYAdd)

@property (nonatomic, assign, readonly) BOOL xy_isOpaque;

#pragma mark Initialization

/**
 Creates a image object by custom drawing.
 */
+ (nullable UIImage *)xy_imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale draw:(void (^)(CGContextRef context))draw;

/**
 Creates a pure color image with the given color and size.
 */
+ (nullable UIImage *)xy_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 Creates a 1x1 image with the given color.
 */
+ (nullable UIImage *)xy_imageWithColor:(UIColor *)color;

/**
 Creates a image with the given view.
 */
+ (nullable UIImage *)xy_imageWithView:(UIView *)view;

/**
 Creates a image with the given attributed string.
 */
+ (nullable UIImage *)xy_imageWithAttributedString:(NSAttributedString *)attributedString;
+ (nullable UIImage *)xy_imageWithAttributedString:(NSAttributedString *)attributedString size:(CGSize)size;

/**
 Creates a image with the given buffer.
 */
+ (nullable UIImage *)xy_imageWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**
 Returns a image object associated with the specified filename.
 */
+ (nullable UIImage *)xy_imageWithResource:(NSString *)resource;

/**
 Returns an animated image object associated with the specified filename.
 */
+ (nullable UIImage *)xy_animatedImageWithResource:(NSString *)resource;

#pragma mark Image modifying

/**
 Returns a new image covered by a given image.
 */
- (nullable UIImage *)xy_coveredImageWithImage:(UIImage *)image point:(CGPoint)point;

/**
 Returns a new image which is resized from this image.
 */
- (nullable UIImage *)xy_resizedImageWithSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;
- (nullable UIImage *)xy_resizedImageWithSize:(CGSize)size contentMode:(UIViewContentMode)contentMode scale:(CGFloat)scale;

/**
 Returns a new image which is cropped from this image.
 */
- (nullable UIImage *)xy_croppedImageWithRect:(CGRect)rect;

/**
 Returns a tinted image with the given color.
 This actually use alpha blending of current image and the tint color.
 */
- (nullable UIImage *)xy_tintedImageWithColor:(UIColor *)color;

/**
 Rounds a new image with a given corner radius and corners.
 */
- (nullable UIImage *)xy_roundedImageWithRadius:(CGFloat)cornerRadius;
- (nullable UIImage *)xy_roundedImageWithRadius:(CGFloat)cornerRadius
                                        corners:(UIRectCorner)corners
                                    borderWidth:(CGFloat)borderWidth
                                    borderColor:(nullable UIColor *)borderColor
                                 borderLineJoin:(CGLineJoin)borderLineJoin;

/**
 Returns a new image applied a blur effect.
 */
- (nullable UIImage *)xy_blurredImageWithRadius:(CGFloat)blurRadius;

/**
 Returns a new image with a given image orientation.
 */
- (UIImage *)xy_rotatedImageWithOrientation:(UIImageOrientation)orientation;

/**
 Returns a grayed image with a given type.
 @see https://juejin.cn/post/6926153937863049229#heading-12
 */
- (nullable UIImage *)xy_grayedImageWithType:(XYImageGrayType)type;

/**
 Returns a binarized image with a given threshold.
 @param threshold 0~1
 @see https://juejin.cn/post/6926153937863049229#heading-12
 */
- (nullable UIImage *)xy_binarizedImageWithThreshold:(CGFloat)threshold;

#pragma mark QR code

/**
 Creates a QR Code image.
 */
+ (nullable UIImage *)xy_QRCodeImageWithData:(NSData *)data
                                        size:(CGFloat)size
                             foregroundColor:(nullable UIColor *)foregroundColor
                             backgroundColor:(nullable UIColor *)backgroundColor;

/**
 Creates a QR Code image with a logo inside.
 */
+ (nullable UIImage *)xy_QRCodeImageWithData:(NSData *)data
                                        size:(CGFloat)size
                                       inset:(CGFloat)inset
                             foregroundColor:(nullable UIColor *)foregroundColor
                             backgroundColor:(nullable UIColor *)backgroundColor
                                   logoImage:(nullable UIImage *)logoImage
                                   logoSize:(CGSize)logoSize;

/**
 Returns QR code informations of the image.
 */
- (nullable NSArray<CIQRCodeFeature *> *)xy_detectQRCodeFeatures;

@end

NS_ASSUME_NONNULL_END

