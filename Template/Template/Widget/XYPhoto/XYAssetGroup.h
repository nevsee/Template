//
//  XYAssetGroup.h
//  XYPhoto
//
//  Created by nevsee on 2017/5/22.
//

#import <Foundation/Foundation.h>
#import <Photos/PHFetchOptions.h>
#import <Photos/PHCollection.h>
#import <Photos/PHFetchResult.h>
#import "XYAsset.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYAlbumContentType) {
    XYAlbumContentTypeAll,
    XYAlbumContentTypeOnlyPhoto,
    XYAlbumContentTypeOnlyVideo,
    XYAlbumContentTypeOnlyAudio
};

typedef NS_ENUM(NSUInteger, XYAlbumSortType) {
    XYAlbumSortTypePositive,
    XYAlbumSortTypeReverse
};

typedef void(^XYAssetEnumerationBlock)(XYAsset * _Nullable asset);

@interface XYAssetGroup : NSObject

@property (nonatomic, strong, readonly) PHAssetCollection *phAssetCollection;
@property (nonatomic, strong, readonly) PHFetchOptions *phFetchOptions;
@property (nonatomic, strong, readonly) PHFetchResult *phFetchResult;
@property (nonatomic, assign, readonly) NSInteger count; ///< The count of assets in the album
@property (nonatomic, strong, readonly) NSString *name; ///< The album name

- (instancetype)initWithPHCollection:(PHAssetCollection *)phAssetCollection;
- (instancetype)initWithPHCollection:(PHAssetCollection *)phAssetCollection fetchAssetsOptions:(nullable PHFetchOptions *)phFetchOptions;

/**
 Returns a poster image of the asset collection.
 @warning Returns nil if asset collection’s subtype is PHAssetCollectionSubtypeSmartAlbumAllHidden.
 */
- (nullable UIImage *)posterImageWithSize:(CGSize)size;

/**
 Retrieves all assets of the specified sort type.
 @param sortType The enumeration type.
 @param block The block invoked on main-thread.
 */
- (void)enumerateAllAssetsWithOptions:(XYAlbumSortType)sortType
                           usingBlock:(XYAssetEnumerationBlock)block;

@end

NS_ASSUME_NONNULL_END
