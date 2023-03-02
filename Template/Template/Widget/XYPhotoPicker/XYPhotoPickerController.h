//
//  XYPhotoPickerController.h
//  XYPhotoPicker
//
//  Created by nevsee on 2017/6/10.
//

#import <UIKit/UIKit.h>

#if __has_include(<XYPhoto/XYPhoto.h>)
#import <XYPhoto/XYPhoto.h>
#else
#import "XYPhoto.h"
#endif

@class XYPhotoPickerController;

NS_ASSUME_NONNULL_BEGIN

@interface XYPhotoPickerConfiguration : NSObject
@property (nonatomic, assign) XYAlbumContentType contentType; ///< 资源类型，默认XYAlbumContentTypeAll
@property (nonatomic, assign) XYAlbumSortType sortType; ///< 资源排序，默认XYAlbumSortTypePositive
@property (nonatomic, assign) NSInteger maximumSelectionLimit; ///< 最大选中数，默认INT_MAX
@property (nonatomic, assign) BOOL allowMultipleSelection; ///< 是否允许多选，默认YES
@property (nonatomic, assign) BOOL allowPickingGif; ///< 是否允许选择gif，默认YES
@property (nonatomic, assign) BOOL needsOriginPhoto; ///< 是否需要原图，默认NO
@property (nonatomic, assign) BOOL needsLimitedNote; ///< 是否需要访问限制提示，默认YES
@end

@protocol XYPhotoPickerControllerDelegate <NSObject>
@optional
- (void)picker:(XYPhotoPickerController *)picker didFinishPicking:(NSArray<XYAsset *> *)results; ///< 完成
- (void)pickerWillCancelPicking:(XYPhotoPickerController *)picker; ///< 即将取消
- (void)pickerDidCancelPicking:(XYPhotoPickerController *)picker; ///< 已经取消
- (void)pickerDidOverMaximumSelectionLimit:(XYPhotoPickerController *)picker; /// 超过最大选中数量
@end

@interface XYPhotoPickerController : UINavigationController
@property (nonatomic, strong, readonly) XYPhotoPickerConfiguration *configuration;
@property (nonatomic, weak, nullable) id<XYPhotoPickerControllerDelegate> pickerDelegate;
- (instancetype)init;
- (instancetype)initWithConfiguration:(XYPhotoPickerConfiguration *)configuration;
@end

NS_ASSUME_NONNULL_END
