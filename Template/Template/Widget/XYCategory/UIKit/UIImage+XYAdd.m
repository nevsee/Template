//
//  UIImage+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2017/1/3.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "UIImage+XYAdd.h"
#import "XYCategoryMacro.h"
#import "XYCategoryUtility.h"
#import "NSAttributedString+XYAdd.h"
#import "UIView+XYAdd.h"
#import "UIColor+XYAdd.h"
#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>

XYSYNTH_DUMMY_CLASS(UIImgae_XYAdd)

static NSArray *_xy_image_screenPreferredScales() {
    static NSArray *scales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1,@2,@3];
        } else if (screenScale <= 2) {
            scales = @[@2,@3,@1];
        } else {
            scales = @[@3,@2,@1];
        }
    });
    return scales;
}

static NSString *_xy_image_appendNameScale(NSString *name, CGFloat scale) {
    if (!name) return nil;
    if (fabs(scale - 1) <= __FLT_EPSILON__ || name.length == 0 || [name hasSuffix:@"/"]) return name.copy;
    return [name stringByAppendingFormat:@"@%@x", @(scale)];
}

static NSString *_xy_image_findImagePath(NSString *resource) {
    if (resource.length == 0) return nil;
    if ([resource hasSuffix:@"/"]) return nil;
    
    NSString *name = [resource stringByDeletingPathExtension];
    NSString *ext = resource.pathExtension;
    NSString *path = nil;
    CGFloat scale = 1;
    
    NSArray *exts = ext.length > 0 ? @[ext] : @[@"", @"png", @"jpeg", @"jpg", @"gif", @"webp", @"apng"];
    NSArray *scales = _xy_image_screenPreferredScales();
    for (NSInteger i = 0; i < scales.count; i ++) {
        scale = [scales[i] floatValue];
        NSString *scaleName = _xy_image_appendNameScale(name, scale);
        for (NSString *e in exts) {
            path = [[NSBundle mainBundle] pathForResource:scaleName ofType:e];
            if (path) break;
        }
        if (path) break;
    }
    
    return path;
}

static NSTimeInterval _xy_image_animatedImageGetFrameDelayAtIndex(CGImageSourceRef source, size_t index) {
    NSTimeInterval delay = 0;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, NULL);
    if (cfFrameProperties) {
        CFDictionaryRef gifProperties = CFDictionaryGetValue(cfFrameProperties, kCGImagePropertyGIFDictionary);
        if (gifProperties) {
            NSNumber *num = CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFUnclampedDelayTime);
            if (num.doubleValue <= __FLT_EPSILON__) {
                num = CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            }
            delay = num.doubleValue;
        }
        CFRelease(cfFrameProperties);
    }
    
    if (delay < 0.011f)  delay = 0.100f;
    return delay;
}

@implementation UIImage (XYAdd)

- (BOOL)xy_isOpaque {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    return alphaInfo == kCGImageAlphaNone ||
    alphaInfo == kCGImageAlphaNoneSkipLast ||
    alphaInfo == kCGImageAlphaNoneSkipFirst;
}

+ (UIImage *)xy_imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale draw:(void (^)(CGContextRef))draw {
    if (size.width <= 0 || size.height <= 0) return nil;
    scale = scale <= 0 ? UIScreen.mainScreen.scale : scale;
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    draw(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)xy_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    return [self xy_imageWithSize:size opaque:NO scale:0 draw:^(CGContextRef context) {
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    }];
}

+ (UIImage *)xy_imageWithColor:(UIColor *)color {
    return [self xy_imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)xy_imageWithView:(UIView *)view {
    if (!view) return nil;
    return [self xy_imageWithSize:view.xy_size opaque:NO scale:0 draw:^(CGContextRef context) {
        [view.layer renderInContext:context];
    }];
}

+ (UIImage *)xy_imageWithAttributedString:(NSAttributedString *)attributedString {
    return [self xy_imageWithAttributedString:attributedString size:CGSizeMake(HUGE, HUGE)];
}

+ (UIImage *)xy_imageWithAttributedString:(NSAttributedString *)attributedString size:(CGSize)size {
    if (!attributedString) return nil;
    CGSize stringSize = [attributedString xy_sizeForFixedSize:size];
    stringSize = CGSizeMake(ceil(stringSize.width), ceil(stringSize.height));
    return [self xy_imageWithSize:stringSize opaque:NO scale:0 draw:^(CGContextRef context) {
        [attributedString drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }];
}

+ (UIImage *)xy_imageWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    if (sampleBuffer == NULL) return nil;
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciimage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:ciimage fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer))];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

+ (UIImage *)xy_imageWithResource:(NSString *)resource {
    NSString *path = _xy_image_findImagePath(resource);
    if (path.length == 0) return nil;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data.length == 0) return nil;
    
    return [[UIImage alloc] initWithData:data];
}

+ (UIImage *)xy_animatedImageWithResource:(NSString *)resource {
    NSString *path = _xy_image_findImagePath(resource);
    if (path.length == 0) return nil;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data.length == 0) return nil;
    
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(sourceRef);
    
    UIImage *animatedImage;
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    } else {
        NSMutableArray *images = [NSMutableArray array];
        NSTimeInterval duration = 0;
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(sourceRef, i, NULL);
            if (!image) continue;
            
            duration += _xy_image_animatedImageGetFrameDelayAtIndex(sourceRef, i);
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        
        if (duration <= __FLT_EPSILON__) duration = (1.0f / 10.0f) * count;
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(sourceRef);
    
    return animatedImage;
}

- (UIImage *)xy_coveredImageWithImage:(UIImage *)image point:(CGPoint)point {
    if (!image) return nil;
    return [UIImage xy_imageWithSize:self.size opaque:self.xy_isOpaque scale:0 draw:^(CGContextRef  _Nonnull context) {
        [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        [image drawAtPoint:point];
    }];
}

- (UIImage *)xy_resizedImageWithSize:(CGSize)size contentMode:(UIViewContentMode)contentMode {
    return [self xy_resizedImageWithSize:size contentMode:contentMode scale:self.scale];
}

- (UIImage *)xy_resizedImageWithSize:(CGSize)size contentMode:(UIViewContentMode)contentMode scale:(CGFloat)scale {
    if (size.width <= 0 || size.height <= 0) return nil;
    CGRect drawRect = XYRectFitWithContentMode(CGRectMake(0, 0, size.width, size.height), self.size, contentMode);
    if (drawRect.size.width == 0 || drawRect.size.height == 0) return nil;
    return [UIImage xy_imageWithSize:size opaque:self.xy_isOpaque scale:scale draw:^(CGContextRef  _Nonnull context) {
        [self drawInRect:drawRect];
    }];
}

- (UIImage *)xy_croppedImageWithRect:(CGRect)rect {
    if (!self.CGImage) return nil;
    rect.origin.x *= self.scale;
    rect.origin.y *= self.scale;
    rect.size.width *= self.scale;
    rect.size.height *= self.scale;
    if (rect.size.width <= 0 || rect.size.height <= 0) return nil;
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)xy_tintedImageWithColor:(UIColor *)color {
    if (!color) return self;
    if (!self.CGImage) return nil;
    BOOL opaque = self.xy_isOpaque ? color.xy_alpha >= 1 : NO;
    return [UIImage xy_imageWithSize:self.size opaque:opaque scale:self.scale draw:^(CGContextRef  _Nonnull context) {
        CGContextTranslateCTM(context, 0, self.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        if (!opaque) {
            CGContextSetBlendMode(context, kCGBlendModeNormal);
            CGContextClipToMask(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
        }
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, self.size.width, self.size.height));
    }];
}

- (UIImage *)xy_roundedImageWithRadius:(CGFloat)cornerRadius {
    return [self xy_roundedImageWithRadius:cornerRadius
                                   corners:UIRectCornerAllCorners
                               borderWidth:0
                               borderColor:nil
                            borderLineJoin:kCGLineJoinMiter];
}

- (UIImage *)xy_roundedImageWithRadius:(CGFloat)cornerRadius
                               corners:(UIRectCorner)corners
                           borderWidth:(CGFloat)borderWidth
                           borderColor:(UIColor *)borderColor
                        borderLineJoin:(CGLineJoin)borderLineJoin {
    
    if (!self.CGImage) return nil;
    
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = cornerRadius > self.scale / 2 ? cornerRadius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)xy_blurredImageWithRadius:(CGFloat)blurRadius {
    if (self.size.width < 1 || self.size.height < 1) return nil;
    if (!self.CGImage) return nil;

    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    if (!hasBlur) return self;

    CGFloat scale = self.scale;
    CGImageRef imageRef = self.CGImage;

    vImage_Buffer effect = {}, scratch = {};
    vImage_Buffer *input = NULL, *output = NULL;

    vImage_CGImageFormat format = {
        .bitsPerComponent = 8,
        .bitsPerPixel = 32,
        .colorSpace = NULL,
        .bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little, //requests a BGRA buffer.
        .version = 0,
        .decode = NULL,
        .renderingIntent = kCGRenderingIntentDefault
    };

    vImage_Error err;
    err = vImageBuffer_InitWithCGImage(&effect, &format, NULL, imageRef, kvImagePrintDiagnosticsToConsole);
    if (err != kvImageNoError) {
        NSLog(@"UIImage+Transform error: vImageBuffer_InitWithCGImage returned error code %zi for inputImage: %@", err, self);
        return nil;
    }
    err = vImageBuffer_Init(&scratch, effect.height, effect.width, format.bitsPerPixel, kvImageNoFlags);
    if (err != kvImageNoError) {
        NSLog(@"UIImage+Transform error: vImageBuffer_Init returned error code %zi for inputImage: %@", err, self);
        return nil;
    }

    input = &effect;
    output = &scratch;

    if (hasBlur) {
        // A description of how to compute the box kernel width from the Gaussian
        // radius (aka standard deviation) appears in the SVG spec:
        // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
        //
        // For larger values of 's' (s >= 2.0), an approximation can be used: Three
        // successive box-blurs build a piece-wise quadratic convolution kernel, which
        // approximates the Gaussian kernel to within roughly 3%.
        //
        // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
        //
        // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
        //
        CGFloat inputRadius = blurRadius * scale;
        if (inputRadius - 2.0 < __FLT_EPSILON__) inputRadius = 2.0;
        uint32_t radius = floor((inputRadius * 3.0 * sqrt(2 * M_PI) / 4 + 0.5) / 2);
        radius |= 1; // force radius to be odd so that the three box-blur methodology works.
        int iterations;
        if (blurRadius * scale < 0.5) iterations = 1;
        else if (blurRadius * scale < 1.5) iterations = 2;
        else iterations = 3;
        NSInteger tempSize = vImageBoxConvolve_ARGB8888(input, output, NULL, 0, 0, radius, radius, NULL, kvImageGetTempBufferSize | kvImageEdgeExtend);
        void *temp = malloc(tempSize);
        for (int i = 0; i < iterations; i++) {
            vImageBoxConvolve_ARGB8888(input, output, temp, 0, 0, radius, radius, NULL, kvImageEdgeExtend);
            vImage_Buffer *tmp = input;
            input = output;
            output = tmp;
        }
        free(temp);
    }

    CGImageRef effectCGImage = NULL;
    effectCGImage = vImageCreateCGImageFromBuffer(input, &format, NULL, NULL, kvImageNoAllocate, NULL);
    if (effectCGImage == NULL) {
        effectCGImage = vImageCreateCGImageFromBuffer(input, &format, NULL, NULL, kvImageNoFlags, NULL);
        free(input->data);
    }
    free(output->data);

    UIImage *outputImage = [UIImage imageWithCGImage:effectCGImage scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(effectCGImage);

    return outputImage;
}

- (UIImage *)xy_rotatedImageWithOrientation:(UIImageOrientation)orientation {
//    if (self.imageOrientation == orientation) return self;
    return [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:orientation];
}

- (UIImage *)xy_grayedImageWithType:(XYImageGrayType)type {
    int width, height;
    if (self.imageOrientation == UIImageOrientationUp ||
        self.imageOrientation == UIImageOrientationDown ||
        self.imageOrientation == UIImageOrientationUpMirrored ||
        self.imageOrientation == UIImageOrientationDownMirrored) {
        width = (int)(self.size.width * self.scale);
        height = (int)(self.size.height * self.scale);
    } else {
        width = (int)(self.size.height * self.scale);
        height = (int)(self.size.width * self.scale);
    }

    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *)malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    // color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    if (context == NULL) return nil;
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    
    // convert to grayscale
    int r = 1, g = 2, b = 3;
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *pixel = (uint8_t *)&pixels[y * width + x];
            uint32_t gray = 0;
            switch (type) {
                case XYImageGrayTypeWeightedAverage:
                    // http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
                    gray = 0.3 * pixel[r] + 0.59 * pixel[g] + 0.11 * pixel[b];
                    break;
                case XYImageGrayTypeAverage:
                    gray = (pixel[r] + pixel[g] + pixel[b]) / 3;
                    break;
                case XYImageGrayTypeMax:
                    gray = MAX(MAX(pixel[r], pixel[g]), pixel[b]);
                    break;
                case XYImageGrayTypeComponentRed:
                    gray = pixel[r];
                    break;
                case XYImageGrayTypeComponentGreen:
                    gray = pixel[g];
                    break;
                case XYImageGrayTypeComponentBlue:
                    gray = pixel[b];
                    break;
                default:
                    gray = 0.3 * pixel[r] + 0.59 * pixel[g] + 0.11 * pixel[b];
                    break;
            }
            // set the pixels to gray
            pixel[r] = gray;
            pixel[g] = gray;
            pixel[b] = gray;
        }
    }
    
    // make a grayed image to return
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGContextRelease(context);
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    return image;
}

- (UIImage *)xy_binarizedImageWithThreshold:(CGFloat)threshold {
    if (threshold < 0 || threshold > 1) threshold = 0.4;
    
    int width, height;
    if (self.imageOrientation == UIImageOrientationUp ||
        self.imageOrientation == UIImageOrientationDown ||
        self.imageOrientation == UIImageOrientationUpMirrored ||
        self.imageOrientation == UIImageOrientationDownMirrored) {
        width = (int)(self.size.width * self.scale);
        height = (int)(self.size.height * self.scale);
    } else {
        width = (int)(self.size.height * self.scale);
        height = (int)(self.size.width * self.scale);
    }
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *)malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    // color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    
    // binarize
    int r = 1, g = 2, b = 3;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            uint8_t *pixel = (uint8_t *)&pixels[y * width + x];
            uint32_t gray =  pixel[r] * 0.3  + pixel[g] * 0.59 + pixel[b] * 0.11;
            float intensity = gray / 255.0;
            int target = intensity > threshold ? 255 : 0;
            pixel[r] = target;
            pixel[g] = target;
            pixel[b] = target;
        }
    }
    
    // make a binarized image to return
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGContextRelease(context);
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    return image;
}

+ (UIImage *)xy_QRCodeImageWithData:(NSData *)data size:(CGFloat)size foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor {
    if (!data || size == 0) return nil;
    return [UIImage xy_QRCodeImageWithData:data size:size inset:0 foregroundColor:foregroundColor backgroundColor:backgroundColor logoImage:nil logoSize:CGSizeZero];
}

+ (UIImage *)xy_QRCodeImageWithData:(NSData *)data size:(CGFloat)size inset:(CGFloat)inset foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor logoImage:(UIImage *)logoImage logoSize:(CGSize)logoSize {
    if (!data || size == 0) return nil;
    if (!foregroundColor) foregroundColor = [UIColor blackColor];
    if (!backgroundColor) backgroundColor = [UIColor whiteColor];
    // code filter
    CIFilter *codeFileter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [codeFileter setValue:data forKey:@"inputMessage"];
    [codeFileter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *ciImage = codeFileter.outputImage;
    // color filter
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorFilter setValue:ciImage forKey:@"inputImage"];
    [colorFilter setValue:[CIColor colorWithCGColor:foregroundColor.CGColor] forKey:@"inputColor0"];
    [colorFilter setValue:[CIColor colorWithCGColor:backgroundColor.CGColor] forKey:@"inputColor1"];
    // create image
    CIImage *outImage = colorFilter.outputImage;
    CGFloat scale = size / outImage.extent.size.width;
    outImage = [outImage imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
    UIImage *codeImage = [UIImage imageWithCIImage:outImage];
    // inset
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size + inset * 2, size + inset * 2), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextFillRect(context, CGRectMake(0, 0, size + inset * 2, size + inset * 2));
    [codeImage drawInRect:CGRectMake(inset, inset, size, size)];
    // logo
    if (!logoImage) {
        codeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return codeImage;
    };
    CGRect logoRect = CGRectMake((size + inset * 2 - logoSize.width) / 2, (size + inset * 2 - logoSize.height) / 2, logoSize.width, logoSize.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:logoRect];
    [path fill];
    [logoImage drawInRect:logoRect];
    codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return codeImage;
}

- (NSArray<CIQRCodeFeature *> *)xy_detectQRCodeFeatures {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:self.CGImage]];
    return features;
}

@end

