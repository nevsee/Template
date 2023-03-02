//
//  XYPhotoAssetController.h
//  XYPhotoPicker
//
//  Created by nevsee on 2017/6/10.
//

#import <UIKit/UIKit.h>
@class XYAsset, XYAssetGroup;
@class XYPhotoPickerConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface XYPhotoAssetController : UIViewController
@property (nonatomic, strong, readonly) XYAssetGroup *assetGroup; ///< 所属相册
@property (nonatomic, strong, readonly) NSMutableArray<XYAsset *> *allAssets; ///< 所有资源
@property (nonatomic, strong) NSMutableArray<XYAsset *> *selectedAssets; ///< 选中资源
@property (nonatomic, strong) NSMutableSet<NSString *> *selectedAssetIdentifiers; ///< 选中资源唯一标识
@property (nonatomic, strong) XYPhotoPickerConfiguration *configuration;
- (void)refreshWithAssetGroup:(XYAssetGroup *)assetGroup;
@end

NS_ASSUME_NONNULL_END
