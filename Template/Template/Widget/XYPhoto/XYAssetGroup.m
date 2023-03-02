//
//  XYAssetGroup.m
//  XYPhoto
//
//  Created by nevsee on 2017/5/22.
//

#import "XYAssetGroup.h"
#import "XYAsset.h"
#import "XYAssetManager.h"

@implementation XYAssetGroup

- (instancetype)initWithPHCollection:(PHAssetCollection *)phAssetCollection {
    return [self initWithPHCollection:phAssetCollection fetchAssetsOptions:nil];
}

- (instancetype)initWithPHCollection:(PHAssetCollection *)phAssetCollection fetchAssetsOptions:(PHFetchOptions *)phFetchOptions {
    self = [super init];
    if (self) {
        _phAssetCollection = phAssetCollection;
        _phFetchOptions = phFetchOptions;
        _phFetchResult = [PHAsset fetchAssetsInAssetCollection:phAssetCollection options:phFetchOptions];
    }
    return self;
}

#pragma mark Public Method
- (UIImage *)posterImageWithSize:(CGSize)size {
    if (_phAssetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden) {
        return nil;
    }
    
    __block UIImage *resultImage;
    NSInteger count = _phFetchResult.count;
    if (count > 0) {
        CGSize pxSize = CGSizeMake(size.width * [UIScreen mainScreen].scale, size.height * [UIScreen mainScreen].scale);
        PHImageContentMode mode = PHImageContentModeAspectFill;
        PHAsset *asset = _phFetchResult[count - 1];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.synchronous = YES;

        [[XYAssetManager defaultManager].phCachingImageManager requestImageForAsset:asset targetSize:pxSize contentMode:mode options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            resultImage = result;
        }];
    }
    return resultImage;
}

- (void)enumerateAllAssetsWithOptions:(XYAlbumSortType)sortType usingBlock:(XYAssetEnumerationBlock)block {
    NSInteger count = _phFetchResult.count;
    if (sortType == XYAlbumSortTypeReverse) {
        for (NSInteger i = count - 1; i >= 0; i--) {
            PHAsset *phAsset = _phFetchResult[i];
            XYAsset *asset = [[XYAsset alloc] initWithPHAsset:phAsset];
            if (block) block(asset);
        }
    } else {
        for (NSInteger i = 0; i < count; i++) {
            PHAsset *phAsset = _phFetchResult[i];
            XYAsset *asset = [[XYAsset alloc] initWithPHAsset:phAsset];
            if (block) block(asset);
        }
    }

    if (block) block(nil);
}

#pragma mark Access
- (NSInteger)count {
    return _phFetchResult.count;
}

- (NSString *)name {
    NSString *title = _phAssetCollection.localizedTitle;
    return NSLocalizedString(title, title);
}

@end
