//
//  XYAssetManager.h
//  XYPhoto
//
//  Created by nevsee on 2017/5/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAssetChangeRequest.h>
#import <Photos/PHAssetCollectionChangeRequest.h>
#import "XYAssetGroup.h"

NS_ASSUME_NONNULL_BEGIN

/// Authorization status
typedef NS_ENUM(NSUInteger, XYAuthorizationStatus) {
    XYAuthorizationStatusNotDetermined,
    XYAuthorizationStatusAuthorized,
    XYAuthorizationStatusNotAuthorized,
    XYAuthorizationStatusLimited API_AVAILABLE(ios(14))
};

typedef void (^XYAssetGroupEnumerationBlock)(XYAssetGroup * _Nullable group);
typedef void (^XYWriteAssetCompletionBlock)(XYAsset * _Nullable asset, NSError * _Nullable error);
typedef void (^XYSaveAssetCompletionBlock)(BOOL success, NSDate * _Nullable creationDate, NSError * _Nullable error);

/// Saves a asset to the given asset collection.
/// The block is invoked on main-thread.
extern void XYImageWriteToSavedPhotosAlbum(UIImage *image,
                                           XYAssetGroup * _Nullable assetGroup,
                                           XYWriteAssetCompletionBlock _Nullable completion);

extern void XYVideoWriteToSavedPhotosAlbum(NSURL *videoPathURL,
                                           XYAssetGroup * _Nullable assetGroup,
                                           XYWriteAssetCompletionBlock _Nullable completion);


@interface XYAssetManager : NSObject

@property (nonatomic, strong, readonly) PHCachingImageManager *phCachingImageManager;

+ (instancetype)defaultManager;

/**
 Returns information about your app’s authorization to access the user’s photo library.
 */
+ (XYAuthorizationStatus)authorizationStatus;

/**
 Requests the user’s permission, if needed, to access the photo library.
 @param handler The block invoked on main-thread
 */
+ (void)requestAuthorization:(void(^)(XYAuthorizationStatus status))handler;

/**
 Returns `PHAssetCollectionSubtypeSmartAlbumUserLibrary` collection of the specified media type.
 @param contentType The asset media type
 @param showEmptyAlbum if NO, empty album will be ignored
 */
- (nullable XYAssetGroup *)userLibrarySmartAlbumWithAlbumContentType:(XYAlbumContentType)contentType
                                                      showEmptyAlbum:(BOOL)showEmptyAlbum;

/**
 Retrieves all asset collections of the specified media type.
 @param contentType The asset media type.
 @param showEmptyAlbum if NO, empty album will be ignored.
 @param showSmartAlbum if NO, smart album will be ignored.
 @param block The block invoked on main-thread.
 */
- (void)enumerateAllAlbumsWithAlbumContentType:(XYAlbumContentType)contentType
                                showEmptyAlbum:(BOOL)showEmptyAlbum
                                showSmartAlbum:(BOOL)showSmartAlbum
                                    usingBlock:(XYAssetGroupEnumerationBlock)block;

/**
 Retrieves all asset collections of the specified media type except empty one.
 @param contentType The asset media type.
 @param block The block invoked on main-thread.
 */
- (void)enumerateAllAlbumsWithAlbumContentType:(XYAlbumContentType)contentType
                                    usingBlock:(XYAssetGroupEnumerationBlock)block;

/**
 Asynchronously saves a image to the photo library.
 @param imageRef The target image.
 @param orientation The orientation of the target image.
 @param assetGroup The asset collection from which to save assets.
 @param completion The block invoked on main-thread.
 */
- (void)writeImageToAlbum:(CGImageRef)imageRef
              orientation:(UIImageOrientation)orientation
               assetGroup:(nullable XYAssetGroup *)assetGroup
               completion:(nullable XYWriteAssetCompletionBlock)completion;

/**
 Asynchronously saves a image to the photo library.
 @param imagePathURL The target image path.
 @param assetGroup The asset collection from which to save assets.
 @param completion The block invoked on main-thread.
 */
- (void)writeImageToAlbum:(NSURL *)imagePathURL
               assetGroup:(nullable XYAssetGroup *)assetGroup
               completion:(nullable XYWriteAssetCompletionBlock)completion;

/**
 Asynchronously saves a vedio to the photo library.
 @param videoPathURL The target vedio path.
 @param assetGroup The asset collection from which to save assets.
 @param completion The block invoked on main-thread.
 */
- (void)writeVideoToAlbum:(NSURL *)videoPathURL
               assetGroup:(nullable XYAssetGroup *)assetGroup
               completion:(nullable XYWriteAssetCompletionBlock)completion;

@end

@interface PHPhotoLibrary (XYPhoto)

/**
 Returns a PHFetchOptions object with the specified media type.
 */
+ (PHFetchOptions *)createFetchOptionsWithAlbumContentType:(XYAlbumContentType)contentType;

/**
 Retrieves all asset collections of the specified media type.
 */
+ (NSArray<PHAssetCollection *> *)fetchAllAlbumsWithAlbumContentType:(XYAlbumContentType)contentType
                                                      showEmptyAlbum:(BOOL)showEmptyAlbum
                                                      showSmartAlbum:(BOOL)showSmartAlbum;

/**
 Returns `PHAssetCollectionSubtypeSmartAlbumUserLibrary` collection of the specified media type.
 */

+ (PHAssetCollection *)fetchUserLibrarySmartAlbumWithAlbumContentType:(XYAlbumContentType)contentType
                                                       showEmptyAlbum:(BOOL)showEmptyAlbum;
/**
 Returns a PHAsset object with the specified asset collection.
 */
+ (PHAsset *)fetchLatestAssetWithAssetCollection:(PHAssetCollection *)assetCollection;

/**
 Asynchronously saves a image to the photo library.
 */
- (void)saveImageToAlbum:(CGImageRef)imageRef
             orientation:(UIImageOrientation)orientation
         assetCollection:(nullable PHAssetCollection *)assetCollection
              completion:(nullable XYSaveAssetCompletionBlock)completion;

/**
 Asynchronously saves a image to the photo library.
 */
- (void)saveImageToAlbum:(NSURL *)imagePathURL
         assetCollection:(nullable PHAssetCollection *)assetCollection
              completion:(nullable XYSaveAssetCompletionBlock)completion;

/**
 Asynchronously saves a vedio to the photo library.
 */
- (void)saveVideoToAlbum:(NSURL *)videoPathURL
         assetCollection:(nullable PHAssetCollection *)assetCollection
              completion:(nullable XYSaveAssetCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
