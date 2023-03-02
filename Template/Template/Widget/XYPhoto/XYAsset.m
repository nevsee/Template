//
//  XYAsset.m
//  XYPhoto
//
//  Created by nevsee on 2017/5/22.
//

#import "XYAsset.h"
#import "XYAssetManager.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/UTCoreTypes.h>

XYAssetInfoKey XYAssetInfoImageDataKey = @"XYAssetInfoImageDataKey";
XYAssetInfoKey XYAssetInfoImageDataUTIKey = @"XYAssetInfoImageDataUTIKey";
XYAssetInfoKey XYAssetInfoImageOrientationKey = @"XYAssetInfoImageOrientationKey";
XYAssetInfoKey XYAssetInfoOriginInfoKey = @"XYAssetInfoOriginInfoKey";
XYAssetInfoKey XYAssetInfoSizeKey = @"XYAssetInfoSizeKey";

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation XYAsset

- (instancetype)initWithPHAsset:(PHAsset *)phAsset {
    self = [super init];
    if (self) {
        _phAsset = phAsset;
        
        switch (phAsset.mediaType) {
            case PHAssetMediaTypeImage: {
                _assetType = XYAssetTypeImage;
                if ([[phAsset valueForKey:@"uniformTypeIdentifier"] isEqualToString:(__bridge NSString *)kUTTypeGIF]) {
                    _assetSubType = XYAssetSubTypeGIF;
                } else {
                    if (phAsset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) {
                        _assetSubType = XYAssetSubTypeLivePhoto;
                    } else {
                        _assetSubType = XYAssetSubTypeImage;
                    }
                }
            }
                break;
            case PHAssetMediaTypeVideo:
                _assetType = XYAssetTypeVideo;
                break;
            case PHAssetMediaTypeAudio:
                _assetType = XYAssetTypeAudio;
                break;
            default:
                _assetType = XYAssetTypeUnknow;
                break;
        }
    }
    return self;
}

- (UIImage *)originImage {
    // When synchronous is set to YES, the deliveryMode property is ignored and considered to be set to HighQualityFormat.
    // And the result handler can be called by the image manager once time throughout the lifetime of the request.
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    
    __block UIImage *result = nil;
    
    if (@available(iOS 13, *)) {
        [[XYAssetManager defaultManager].phCachingImageManager requestImageDataAndOrientationForAsset:_phAsset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, CGImagePropertyOrientation orientation, NSDictionary *info) {
            result = [UIImage imageWithData:imageData];
        }];
    } else {
        [[XYAssetManager defaultManager].phCachingImageManager requestImageDataForAsset:_phAsset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            result = [UIImage imageWithData:imageData];
        }];
    }

    return result;
}

- (UIImage *)thumbnailImageWithSize:(CGSize)size {
    // When synchronous is set to YES, the deliveryMode property is ignored and considered to be set to HighQualityFormat.
    // And the result handler can be called by the image manager once time throughout the lifetime of the request.
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize pxSize = CGSizeMake(scale * size.width, scale * size.height);
    PHImageContentMode model = PHImageContentModeAspectFill;
    
    __block UIImage *result = nil;
    [[XYAssetManager defaultManager].phCachingImageManager requestImageForAsset:_phAsset targetSize:pxSize contentMode:model options:options resultHandler:^(UIImage *image, NSDictionary *info) {
        result = image;
    }];

    return result;
}

- (UIImage *)previewImage {
    // When synchronous is set to YES, the deliveryMode property is ignored and considered to be set to HighQualityFormat.
    // And the result handler can be called by the image manager once time throughout the lifetime of the request.
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    PHImageContentMode model = PHImageContentModeAspectFill;
    
    __block UIImage *result = nil;
    [[XYAssetManager defaultManager].phCachingImageManager requestImageForAsset:_phAsset targetSize:size contentMode:model options:options resultHandler:^(UIImage *image, NSDictionary *info) {
        result = image;
    }];

    return result;
}

- (NSInteger)requestOriginImageWithProgress:(PHAssetImageProgressHandler)progress completion:(XYAssetRequestCompletionBlock)completion {
    // When synchronous is set to NO, the result handler can be called by the image manager multiple times throughout the
    // lifetime of the request.
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.progressHandler = progress;
    
    if (@available(iOS 13, *)) {
        return [[XYAssetManager defaultManager].phCachingImageManager requestImageDataAndOrientationForAsset:_phAsset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, CGImagePropertyOrientation orientation, NSDictionary *info) {
            UIImage *image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(image, info);
            });
        }];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [[XYAssetManager defaultManager].phCachingImageManager requestImageDataForAsset:_phAsset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            UIImage *image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(image, info);
            });
        }];
#pragma clang dianostic pop
    }
}

- (NSInteger)requestThumbnailImageWithsize:(CGSize)size progress:(PHAssetImageProgressHandler)progress completion:(XYAssetRequestCompletionBlock)completion {
    // When synchronous is set to NO, the result handler can be called by the image manager multiple times throughout the
    // lifetime of the request.
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = YES;
    options.progressHandler = progress;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize pxSize = CGSizeMake(scale * size.width, scale * size.height);
    PHImageContentMode model = PHImageContentModeAspectFill;
    
    return [[XYAssetManager defaultManager].phCachingImageManager requestImageForAsset:_phAsset targetSize:pxSize contentMode:model options:options resultHandler:^(UIImage *image, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(image, info);
        });
    }];
}

- (NSInteger)requestPreviewImageWithProgress:(PHAssetImageProgressHandler)progress completion:(XYAssetRequestCompletionBlock)completion {
    // When synchronous is set to NO, the result handler can be called by the image manager multiple times throughout the
    // lifetime of the request.
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.progressHandler = progress;
    
    CGSize size = PHImageManagerMaximumSize;
    PHImageContentMode model = PHImageContentModeAspectFill;

    return [[XYAssetManager defaultManager].phCachingImageManager requestImageForAsset:_phAsset targetSize:size contentMode:model options:options resultHandler:^(UIImage *image, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(image, info);
        });
    }];
}

- (NSInteger)requestLivePhotoWithProgress:(PHAssetImageProgressHandler)progress completion:(XYAssetLivePhotoRequestCompletionBlock)completion {
    PHLivePhotoRequestOptions *options = [[PHLivePhotoRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.progressHandler = progress;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    PHImageContentMode model = PHImageContentModeDefault;
    
    return [[XYAssetManager defaultManager].phCachingImageManager requestLivePhotoForAsset:_phAsset targetSize:size contentMode:model options:options resultHandler:^(PHLivePhoto *livePhoto, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(livePhoto, info);
        });
    }];
}

- (NSInteger)requestVideoItemWithProgress:(PHAssetVideoProgressHandler)progress completion:(XYAssetVideoRequestCompletionBlock)completion {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.progressHandler = progress;
    
    return [[XYAssetManager defaultManager].phCachingImageManager requestPlayerItemForVideo:_phAsset options:options resultHandler:^(AVPlayerItem *playerItem, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(playerItem, info);
        });
    }];
}

- (NSInteger)requestVideoAssetWithProgress:(PHAssetVideoProgressHandler)progress completion:(XYAssetVideoRequestCompletionBlock)completion {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.progressHandler = progress;
    
    return [[XYAssetManager defaultManager].phCachingImageManager requestAVAssetForVideo:_phAsset options:options resultHandler:^(AVAsset * asset, AVAudioMix *audioMix, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(asset, info);
        });
    }];
}

- (NSInteger)requestAssetImageInfoWithProgress:(PHAssetImageProgressHandler)progress completion:(XYAssetInfoRequestCompletionBlock)completion {
    if (_assetType != XYAssetTypeImage) {
        if (completion) completion(nil);
        return 0;
    };
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.progressHandler = progress;

    if (@available(iOS 13, *)) {
        return [[XYAssetManager defaultManager].phCachingImageManager requestImageDataAndOrientationForAsset:_phAsset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, CGImagePropertyOrientation orientation, NSDictionary *info) {
            NSMutableDictionary *tempInfo = nil;
            if (info) {
                tempInfo = [[NSMutableDictionary alloc] init];
                [tempInfo setObject:info forKey:XYAssetInfoOriginInfoKey];
                if (imageData) {
                    [tempInfo setObject:imageData forKey:XYAssetInfoImageDataKey];
                    [tempInfo setObject:@(imageData.length) forKey:XYAssetInfoSizeKey];
                }
                if (dataUTI) {
                    [tempInfo setObject:dataUTI forKey:XYAssetInfoImageDataUTIKey];
                }
                [tempInfo setObject:@(orientation) forKey:XYAssetInfoImageOrientationKey];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(tempInfo.copy);
            });
        }];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [[XYAssetManager defaultManager].phCachingImageManager requestImageDataForAsset:_phAsset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            NSMutableDictionary *tempInfo = nil;
            if (info) {
                tempInfo = [[NSMutableDictionary alloc] init];
                [tempInfo setObject:info forKey:XYAssetInfoOriginInfoKey];
                if (imageData) {
                    [tempInfo setObject:imageData forKey:XYAssetInfoImageDataKey];
                    [tempInfo setObject:@(imageData.length) forKey:XYAssetInfoSizeKey];
                }
                if (dataUTI) {
                    [tempInfo setObject:dataUTI forKey:XYAssetInfoImageDataUTIKey];
                }
                [tempInfo setObject:@(orientation) forKey:XYAssetInfoImageOrientationKey];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(tempInfo.copy);
            });
        }];
#pragma clang diagnostic pop
    }
}

- (NSInteger)requestAssetVideoInfoWithProgress:(PHAssetVideoProgressHandler)progress completion:(XYAssetInfoRequestCompletionBlock)completion {
    if (_assetType != XYAssetTypeVideo) {
        if (completion) completion(nil);
        return 0;
    };
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.progressHandler = progress;
    
    return [[XYAssetManager defaultManager].phCachingImageManager requestAVAssetForVideo:_phAsset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
        NSMutableDictionary *tempInfo = nil;
        if ([asset isKindOfClass:[AVURLAsset class]]) {
            tempInfo = [[NSMutableDictionary alloc] init];
            if (info) {
                [tempInfo setObject:info forKey:XYAssetInfoOriginInfoKey];
            }
            AVURLAsset *urlAsset = (AVURLAsset*)asset;
            NSNumber *size;
            [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
            [tempInfo setObject:size forKey:XYAssetInfoSizeKey];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(tempInfo.copy);
        });
    }];
}

- (void)cancelRequest:(NSInteger)requestId {
    [[XYAssetManager defaultManager].phCachingImageManager cancelImageRequest:(PHImageRequestID)requestId];
}

- (BOOL)isEqual:(id)object {
    if (!object) return NO;
    if (self == object) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return [self.identifier isEqualToString:((XYAsset *)object).identifier];
}

- (NSString *)identifier {
    return _phAsset.localIdentifier;
}

- (NSTimeInterval)duration {
    if (_assetType == XYAssetTypeVideo) {
        return _phAsset.duration;
    } else {
        return 0;
    }
}

@end

#pragma clang diagnostic pop
