//
//  XYPhotoPreviewController.h
//  XYPhotoPicker
//
//  Created by nevsee on 2017/6/10.
//

#import <UIKit/UIKit.h>
@class XYAsset;
@class XYPhotoPickerConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface XYPhotoPreviewController : UIViewController
@property (nonatomic, strong) NSArray<XYAsset *> *allAssets; ///< 所有资源
@property (nonatomic, strong) NSMutableArray<XYAsset *> *selectedAssets; ///< 选中资源
@property (nonatomic, strong) NSMutableSet<NSString *> *selectedAssetIdentifiers; ///< 选中资源唯一标识
@property (nonatomic, strong) XYPhotoPickerConfiguration *configuration;
@property (nonatomic, assign) NSUInteger currentIndex; ///< 当前页码，不设置默认为0
@property (nonatomic, strong) void (^didUpdateBlock)(NSInteger index, NSString *identifier); ///< 选中资源已经更新
- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
