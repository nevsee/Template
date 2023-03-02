//
//  XYAssetManager.m
//  XYPhoto
//
//  Created by nevsee on 2017/5/22.
//

#import "XYAssetManager.h"
#import "XYAsset.h"
#import <PhotosUI/PHPhotoLibrary+PhotosUISupport.h>

void XYImageWriteToSavedPhotosAlbum(UIImage *image, XYAssetGroup *assetGroup, XYWriteAssetCompletionBlock completion) {
    [[XYAssetManager defaultManager] writeImageToAlbum:image.CGImage orientation:image.imageOrientation assetGroup:assetGroup completion:completion];
}

void XYVideoWriteToSavedPhotosAlbum(NSURL *videoPathURL, XYAssetGroup *assetGroup, XYWriteAssetCompletionBlock completion) {
    [[XYAssetManager defaultManager] writeVideoToAlbum:videoPathURL assetGroup:assetGroup completion:completion];
}

@interface XYAssetManager ()
@property (nonatomic, strong, readwrite) PHCachingImageManager *phCachingImageManager;
@end

@implementation XYAssetManager

+ (instancetype)defaultManager {
    static XYAssetManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [XYAssetManager defaultManager] ;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [XYAssetManager defaultManager];
}

#pragma mark Public Method
+ (XYAuthorizationStatus)authorizationStatus {
    XYAuthorizationStatus status;
    PHAuthorizationStatus authorizationStatus;
    
    if (@available(iOS 14, *)) {
        authorizationStatus = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
        if (authorizationStatus == PHAuthorizationStatusLimited) {
            return XYAuthorizationStatusLimited;
        }
    } else {
        authorizationStatus = [PHPhotoLibrary authorizationStatus];
    }

    if (authorizationStatus == PHAuthorizationStatusRestricted || authorizationStatus == PHAuthorizationStatusDenied) {
        status = XYAuthorizationStatusNotAuthorized;
    } else if (authorizationStatus == PHAuthorizationStatusNotDetermined) {
        status = XYAuthorizationStatusNotDetermined;
    } else {
        status = XYAuthorizationStatusAuthorized;
    }
    return status;
}

+ (void)requestAuthorization:(void (^)(XYAuthorizationStatus))handler {
    __block XYAuthorizationStatus status;
    
    if (@available(iOS 14, *)) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus phStatus) {
            if (phStatus == PHAuthorizationStatusRestricted || phStatus == PHAuthorizationStatusDenied) {
                status = XYAuthorizationStatusNotAuthorized;
            } else if (phStatus == PHAuthorizationStatusNotDetermined) {
                status = XYAuthorizationStatusNotDetermined;
            } else if (phStatus == PHAuthorizationStatusLimited) {
                status = XYAuthorizationStatusLimited;
            } else {
                status = XYAuthorizationStatusAuthorized;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) handler(status);
            });
        }];
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus phStatus) {
            if (phStatus == PHAuthorizationStatusRestricted || phStatus == PHAuthorizationStatusDenied) {
                status = XYAuthorizationStatusNotAuthorized;
            } else if (phStatus == PHAuthorizationStatusNotDetermined) {
                status = XYAuthorizationStatusNotDetermined;
            } else {
                status = XYAuthorizationStatusAuthorized;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) handler(status);
            });
        }];
    }
}

- (XYAssetGroup *)userLibrarySmartAlbumWithAlbumContentType:(XYAlbumContentType)contentType showEmptyAlbum:(BOOL)showEmptyAlbum {
    PHAssetCollection *collection = [PHPhotoLibrary fetchUserLibrarySmartAlbumWithAlbumContentType:contentType showEmptyAlbum:showEmptyAlbum];
    PHFetchOptions *options = [PHPhotoLibrary createFetchOptionsWithAlbumContentType:contentType];
    if (collection) {
        return [[XYAssetGroup alloc] initWithPHCollection:collection fetchAssetsOptions:options];
    }
    return nil;
}

- (void)enumerateAllAlbumsWithAlbumContentType:(XYAlbumContentType)contentType showEmptyAlbum:(BOOL)showEmptyAlbum showSmartAlbum:(BOOL)showSmartAlbum usingBlock:(XYAssetGroupEnumerationBlock)block {
    // get all albums
    NSArray *allAlbums = [PHPhotoLibrary fetchAllAlbumsWithAlbumContentType:contentType showEmptyAlbum:showEmptyAlbum showSmartAlbum:showSmartAlbum];
    
    // get all groups
    PHFetchOptions *options = [PHPhotoLibrary createFetchOptionsWithAlbumContentType:contentType];
    
    for (NSInteger i = 0; i < allAlbums.count; i++) {
        PHAssetCollection *collection = allAlbums[i];
        XYAssetGroup *group = [[XYAssetGroup alloc] initWithPHCollection:collection fetchAssetsOptions:options];
        if (block) block(group);
    }
    
    if (block) block(nil);
}

- (void)enumerateAllAlbumsWithAlbumContentType:(XYAlbumContentType)contentType usingBlock:(XYAssetGroupEnumerationBlock)block {
    [self enumerateAllAlbumsWithAlbumContentType:contentType showEmptyAlbum:NO showSmartAlbum:YES usingBlock:block];
}

- (void)writeImageToAlbum:(CGImageRef)imageRef orientation:(UIImageOrientation)orientation assetGroup:(XYAssetGroup *)assetGroup completion:(XYWriteAssetCompletionBlock)completion {
    PHAssetCollection *collection = assetGroup.phAssetCollection;
    [[PHPhotoLibrary sharedPhotoLibrary] saveImageToAlbum:imageRef orientation:orientation assetCollection:collection completion:^(BOOL success, NSDate *creationDate, NSError *error) {
        if (success) {
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.predicate = [NSPredicate predicateWithFormat:@"creationDate = %@", creationDate];
            PHFetchResult *result;
            if (collection) {
                result = [PHAsset fetchAssetsInAssetCollection:collection options:options];
            } else {
                // Fetches PHAssetSourceTypeUserLibrary assets
                result = [PHAsset fetchAssetsWithOptions:options];
            }
            
            PHAsset *phAsset = result.lastObject;
            XYAsset *asset = [[XYAsset alloc] initWithPHAsset:phAsset];
            if (completion) completion(asset, nil);
        } else {
            if (completion) completion(nil, error);
        }
    }];
}

- (void)writeImageToAlbum:(NSURL *)imagePathURL assetGroup:(XYAssetGroup *)assetGroup completion:(XYWriteAssetCompletionBlock)completion {
    PHAssetCollection *collection = assetGroup.phAssetCollection;
    [[PHPhotoLibrary sharedPhotoLibrary] saveImageToAlbum:imagePathURL assetCollection:collection completion:^(BOOL success, NSDate *creationDate, NSError *error) {
        if (success) {
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.predicate = [NSPredicate predicateWithFormat:@"creationDate = %@", creationDate];
            PHFetchResult *result;
            if (collection) {
                result = [PHAsset fetchAssetsInAssetCollection:collection options:options];
            } else {
                // Fetches PHAssetSourceTypeUserLibrary assets
                result = [PHAsset fetchAssetsWithOptions:options];
            }
            PHAsset *phAsset = result.lastObject;
            XYAsset *asset = [[XYAsset alloc] initWithPHAsset:phAsset];
            if (completion) completion(asset, nil);
        } else {
            if (completion) completion(nil, error);
        }
    }];
}

- (void)writeVideoToAlbum:(NSURL *)videoPathURL assetGroup:(XYAssetGroup *)assetGroup completion:(XYWriteAssetCompletionBlock)completion {
    PHAssetCollection *collection = assetGroup.phAssetCollection;
    [[PHPhotoLibrary sharedPhotoLibrary] saveVideoToAlbum:videoPathURL assetCollection:collection completion:^(BOOL success, NSDate *creationDate, NSError *error) {
        if (success) {
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.predicate = [NSPredicate predicateWithFormat:@"creationDate = %@", creationDate];
            PHFetchResult *result;
            if (collection) {
                result = [PHAsset fetchAssetsInAssetCollection:collection options:options];
            } else {
                // Fetches PHAssetSourceTypeUserLibrary assets
                result = [PHAsset fetchAssetsWithOptions:options];
            }
            PHAsset *phAsset = result.lastObject;
            XYAsset *asset = [[XYAsset alloc] initWithPHAsset:phAsset];
            if (completion) completion(asset, nil);
        } else {
            if (completion) completion(nil, error);
        }
    }];
}


#pragma mark Access
- (PHCachingImageManager *)phCachingImageManager {
    if (!_phCachingImageManager) {
        _phCachingImageManager = [[PHCachingImageManager alloc] init];
    }
    return _phCachingImageManager;
}

@end

#pragma mark -

@implementation PHPhotoLibrary (XYPhoto)

+ (PHFetchOptions *)createFetchOptionsWithAlbumContentType:(XYAlbumContentType)contentType {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    
    switch (contentType) {
        case XYAlbumContentTypeOnlyPhoto:
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", PHAssetMediaTypeImage];
            break;
        case XYAlbumContentTypeOnlyVideo:
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i",PHAssetMediaTypeVideo];
            break;
        case XYAlbumContentTypeOnlyAudio:
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i",PHAssetMediaTypeAudio];
            break;
        default:
            break;
    }
    return options;
}

+ (NSArray<PHAssetCollection *> *)fetchAllAlbumsWithAlbumContentType:(XYAlbumContentType)contentType showEmptyAlbum:(BOOL)showEmptyAlbum showSmartAlbum:(BOOL)showSmartAlbum {
    NSMutableArray *tempAlbums = [[NSMutableArray alloc] init];
    PHFetchOptions *options = [PHPhotoLibrary createFetchOptionsWithAlbumContentType:contentType];
    
    // get smart albums
    PHFetchResult *smartFetchResult;
    if (showSmartAlbum) {
        smartFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    } else {
        smartFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    }
    
    for (NSInteger i = 0; i < smartFetchResult.count; i++) {
        PHAssetCollection *collection = smartFetchResult[i];
        if (![collection isKindOfClass:[PHAssetCollection class]]) break;
        
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        if (fetchResult.count > 0 || showEmptyAlbum) {
            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                [tempAlbums insertObject:collection atIndex:0];
            } else {
                [tempAlbums addObject:collection];
            }
        }
    }
    
    // get user albums
    PHFetchResult *topLevelUserFetchResult = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    for (NSInteger i = 0; i < topLevelUserFetchResult.count; i++) {
        PHAssetCollection *collection = topLevelUserFetchResult[i];
        if (![collection isKindOfClass:[PHAssetCollection class]]) break;
        
        if (showEmptyAlbum) {
            [tempAlbums addObject:collection];
        } else {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
            if (fetchResult.count > 0) [tempAlbums addObject:collection];
        }
    }
    
    // get synced albums
    PHFetchResult *syncedFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    
    for (NSInteger i = 0; i < syncedFetchResult.count; i++) {
        PHAssetCollection *collection = syncedFetchResult[i];
        if (![collection isKindOfClass:[PHAssetCollection class]]) break;
        [tempAlbums addObject:collection];
    }
    
    return tempAlbums.copy;
}

+ (PHAssetCollection *)fetchUserLibrarySmartAlbumWithAlbumContentType:(XYAlbumContentType)contentType showEmptyAlbum:(BOOL)showEmptyAlbum {
    PHFetchOptions *options = [PHPhotoLibrary createFetchOptionsWithAlbumContentType:contentType];
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    PHAssetCollection *smartCollection = nil;
    for (NSInteger i = 0; i < result.count; i++) {
        PHAssetCollection *collection = result[i];
        if (![collection isKindOfClass:[PHAssetCollection class]]) break;
        
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        if (fetchResult.count > 0 || showEmptyAlbum) {
            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                smartCollection = collection;
                break;
            }
        }
    }
    return smartCollection;
}

+ (PHAsset *)fetchLatestAssetWithAssetCollection:(PHAssetCollection *)assetCollection {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    return [PHAsset fetchAssetsInAssetCollection:assetCollection options:options].lastObject;
}

- (void)saveImageToAlbum:(CGImageRef)imageRef orientation:(UIImageOrientation)orientation assetCollection:(PHAssetCollection *)assetCollection completion:(XYSaveAssetCompletionBlock)completion {
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:orientation];
    [self saveImageToAlbum:image imagePathURL:nil assetCollection:assetCollection completion:completion];
}

- (void)saveImageToAlbum:(NSURL *)imagePathURL assetCollection:(PHAssetCollection *)assetCollection completion:(XYSaveAssetCompletionBlock)completion {
    [self saveImageToAlbum:nil imagePathURL:imagePathURL assetCollection:assetCollection completion:completion];
}

- (void)saveImageToAlbum:(UIImage *)image imagePathURL:(NSURL *)imagePathURL assetCollection:(PHAssetCollection *)assetCollection completion:(XYSaveAssetCompletionBlock)completion {
    
    __block NSDate *creationDate = nil;
    
    [self performChanges:^{
        PHAssetChangeRequest *acr;
        if (image) {
            acr = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } else if (imagePathURL) {
            acr = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:imagePathURL];
        }
        acr.creationDate = [NSDate date];
        creationDate = acr.creationDate;
        
        if (assetCollection.assetCollectionType == PHAssetCollectionTypeAlbum) {
            PHAssetCollectionChangeRequest *accr = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            [accr addAssets:@[[acr placeholderForCreatedAsset]]];
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        BOOL creatingSuccess = success && creationDate;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(creatingSuccess, creationDate, error);
        });
    }];
}

- (void)saveVideoToAlbum:(NSURL *)videoPathURL assetCollection:(PHAssetCollection *)assetCollection completion:(XYSaveAssetCompletionBlock)completion {
    
    __block NSDate *creationDate = nil;
    
    [self performChanges:^{
        PHAssetChangeRequest *acr = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoPathURL];;
        acr.creationDate = [NSDate date];
        creationDate = acr.creationDate;
        
        if (assetCollection.assetCollectionType == PHAssetCollectionTypeAlbum) {
            PHAssetCollectionChangeRequest *accr = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            [accr addAssets:@[[acr placeholderForCreatedAsset]]];
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        BOOL creatingSuccess = success && creationDate;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(creatingSuccess, creationDate, error);
        });
    }];
}

@end
