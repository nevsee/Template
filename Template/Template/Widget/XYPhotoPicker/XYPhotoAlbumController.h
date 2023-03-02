//
//  XYAlbumViewController.h
//  XYPhotoPicker
//
//  Created by nevsee on 2017/6/10.
//

#import <UIKit/UIKit.h>
@class XYAsset, XYAssetGroup;
@class XYPhotoPickerConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface XYPhotoAlbumController : UIViewController
@property (nonatomic, strong, readonly) NSMutableArray<XYAssetGroup *> *allAlbums; ///< 所有相册
@property (nonatomic, strong) NSMutableArray<XYAsset *> *selectedAssets; ///< 选中资源
@property (nonatomic, strong) NSMutableSet<NSString *> *selectedAssetIdentifiers; ///< 选中资源唯一标识
@property (nonatomic, strong) XYPhotoPickerConfiguration *configuration;
@end

NS_ASSUME_NONNULL_END
