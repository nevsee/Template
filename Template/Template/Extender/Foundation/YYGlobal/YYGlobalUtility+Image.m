//
//  YYGlobalUtility+Image.m
//  Template
//
//  Created by nevsee on 2022/1/25.
//

#import "YYGlobalUtility+Image.h"

@implementation YYGlobalUtility (Image)

+ (NSString *)getImageFormat:(id)image {
    if (!image) return nil;
    
    NSData *imageData = nil;
    if ([image isKindOfClass:NSData.class]) {
        imageData = image;
    } else if ([image isKindOfClass:UIImage.class]) {
        imageData = [((UIImage *)image) sd_imageData];
    }
    
    SDImageFormat format = [NSData sd_imageFormatForImageData:imageData];
    switch (format) {
        case SDImageFormatJPEG:
            return @"jpeg";
        case SDImageFormatPNG:
            return @"png";
        case SDImageFormatGIF:
            return @"gif";
        case SDImageFormatTIFF:
            return @"tiff";
        case SDImageFormatWebP:
            return @"webp";
        case SDImageFormatHEIC:
            return @"heic";
        case SDImageFormatHEIF:
            return @"heif";
        case SDImageFormatPDF:
            return @"pdf";
        case SDImageFormatSVG:
            return @"svg";
        case SDImageFormatUndefined:
        default:
            return nil;
    }
}

@end
