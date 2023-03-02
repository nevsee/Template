//
//  XYAsset.h
//  XYPhoto
//
//  Created by nevsee on 2017/5/22.
//

#import <Foundation/Foundation.h>
#import <Photos/PHImageManager.h>
#import <Photos/PHAsset.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYAssetType) {
    XYAssetTypeUnknow,
    XYAssetTypeImage,
    XYAssetTypeVideo,
    XYAssetTypeAudio
};

typedef NS_ENUM(NSUInteger, XYAssetSubType) {
    XYAssetSubTypeUnknow,
    XYAssetSubTypeImage,
    XYAssetSubTypeLivePhoto,
    XYAssetSubTypeGIF
};

/// Info keys
typedef NSString *XYAssetInfoKey;
extern XYAssetInfoKey XYAssetInfoImageDataKey;
extern XYAssetInfoKey XYAssetInfoImageDataUTIKey;
extern XYAssetInfoKey XYAssetInfoImageOrientationKey;
extern XYAssetInfoKey XYAssetInfoOriginInfoKey;
extern XYAssetInfoKey XYAssetInfoSizeKey;

typedef void (^XYAssetRequestCompletionBlock)(UIImage * _Nullable result, NSDictionary * _Nullable info);
typedef void (^XYAssetLivePhotoRequestCompletionBlock)(PHLivePhoto * _Nullable result, NSDictionary * _Nullable info);
typedef void (^XYAssetVideoRequestCompletionBlock)(id _Nullable result, NSDictionary * _Nullable info);
typedef void (^XYAssetInfoRequestCompletionBlock)(NSDictionary<XYAssetInfoKey, id> * _Nullable info);

@interface XYAsset : NSObject

@property (nonatomic, assign, readonly) XYAssetType assetType;
@property (nonatomic, assign, readonly) XYAssetSubType assetSubType;
@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, assign, readonly) NSTimeInterval duration; ///< Only use for the video asset
@property (nonatomic, strong, readonly) PHAsset *phAsset;

- (instancetype)initWithPHAsset:(PHAsset *)phAsset;

///-------------------------------
/// @name Image
///-------------------------------

/**
 Requests an origin image for the specified asset.
 */
- (UIImage *)originImage;

/**
 Requests a thumbnail image for the specified asset with the given size.
 */
- (UIImage *)thumbnailImageWithSize:(CGSize)size;

/**
 Requests a preview image for the specified asset with the current screen size.
 */
- (UIImage *)previewImage;

/**
 Asynchronously requests an origin image for the specified asset.
 A block is invoked on main-thread.
 */
- (NSInteger)requestOriginImageWithProgress:(nullable PHAssetImageProgressHandler)progress
                                 completion:(nullable XYAssetRequestCompletionBlock)completion;

/**
 Asynchronously requests a thumbnail image for the specified asset with the given size.
 A block is invoked on main-thread.
 */
- (NSInteger)requestThumbnailImageWithsize:(CGSize)size
                                  progress:(nullable PHAssetImageProgressHandler)progress
                                completion:(nullable XYAssetRequestCompletionBlock)completion;

/**
 Asynchronously requests a preview image for the specified asset with the current screen size.
 A block is invoked on main-thread.
 */
- (NSInteger)requestPreviewImageWithProgress:(nullable PHAssetImageProgressHandler)progress
                                  completion:(nullable XYAssetRequestCompletionBlock)completion;

///-------------------------------
/// @name Live Photo
///-------------------------------

/**
 Asynchronously requests a live photo for the specified asset.
 A block is invoked on main-thread.
 */
- (NSInteger)requestLivePhotoWithProgress:(nullable PHAssetImageProgressHandler)progress
                               completion:(nullable XYAssetLivePhotoRequestCompletionBlock)completion;

///-------------------------------
/// @name Video
///-------------------------------

/**
 Asynchronously requests an AVPlayerItem object for the specified asset.
 A block is invoked on main-thread.
 */
- (NSInteger)requestVideoItemWithProgress:(nullable PHAssetVideoProgressHandler)progress
                               completion:(nullable XYAssetVideoRequestCompletionBlock)completion;

/**
 Asynchronously requests an AVAsset object for the specified asset.
 A block is invoked on main-thread.
 */
- (NSInteger)requestVideoAssetWithProgress:(nullable PHAssetVideoProgressHandler)progress
                                completion:(nullable XYAssetVideoRequestCompletionBlock)completion;

///-------------------------------
/// @name Asset Info
///-------------------------------

/**
 Asynchronously requests the infomation for the specified asset.
 A block is invoked on main-thread.
 */
- (NSInteger)requestAssetImageInfoWithProgress:(nullable PHAssetImageProgressHandler)progress
                                    completion:(nullable XYAssetInfoRequestCompletionBlock)completion;
                          
/**
 Asynchronously requests the infomation for the video asset.
 A block is invoked on main-thread.
 */
- (NSInteger)requestAssetVideoInfoWithProgress:(nullable PHAssetVideoProgressHandler)progress
                                    completion:(nullable XYAssetInfoRequestCompletionBlock)completion;

///-------------------------------
/// @name Cancel Request
///-------------------------------

- (void)cancelRequest:(NSInteger)requestId;

@end

NS_ASSUME_NONNULL_END
