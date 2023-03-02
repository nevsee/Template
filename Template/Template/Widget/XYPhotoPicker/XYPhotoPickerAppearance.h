//
//  XYPhotoPickerAppearance.h
//  XYPhotoPicker
//
//  Created by nevsee on 2017/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYPhotoPickerStyle) {
    XYPhotoPickerStyleWhite = UIBarStyleDefault,
    XYPhotoPickerStyleBlack = UIBarStyleBlack,
};

@interface XYPhotoPickerAppearance : UIView

///-------------------------------
/// @name Picker
///-------------------------------

@property (nonatomic, assign) XYPhotoPickerStyle pickerStyle UI_APPEARANCE_SELECTOR; ///< 相册风格，默认XYPhotoPickerStyleWhite
@property (nonatomic, strong) UIColor *pickerBackgroundColor UI_APPEARANCE_SELECTOR; ///< 相册背景颜色
@property (nonatomic, strong, nullable) UIColor *pickerNavigationBarColor UI_APPEARANCE_SELECTOR; ///< 相册导航栏颜色, 默认nil，与系统导航栏一致
@property (nonatomic, strong) NSDictionary *pickerNavigationBarTitleAttributes UI_APPEARANCE_SELECTOR; ///< 相册导航栏标题属性
@property (nonatomic, strong) NSDictionary *pickerNavigationBarTextAttributes UI_APPEARANCE_SELECTOR; ///< 相册导航栏左右按钮属性
@property (nonatomic, strong) NSString *pickerNavigationBarBackImage UI_APPEARANCE_SELECTOR; ///< 相册导航栏返回按钮图片

///-------------------------------
/// @name Authorize
///-------------------------------

@property (nonatomic, strong) NSDictionary *authorizedNoteTitleAttributes UI_APPEARANCE_SELECTOR; ///< 授权提示标题属性
@property (nonatomic, strong) NSDictionary *authorizedNoteDetailAttributes UI_APPEARANCE_SELECTOR; ///< 授权提示详情属性
@property (nonatomic, strong) NSDictionary *authorizedJumpTitleAttributes UI_APPEARANCE_SELECTOR; ///< 授权跳转按钮标题属性
@property (nonatomic, strong) NSDictionary *authorizedLimitedNoteAttributes UI_APPEARANCE_SELECTOR; ///< 受限访问提示属性
@property (nonatomic, strong) NSDictionary *authorizedLimitedJumpTitleAttributes UI_APPEARANCE_SELECTOR; ///< 受限访问跳转按钮标题属性
@property (nonatomic, strong) NSDictionary *authorizedLimitedAddTitleAttributes UI_APPEARANCE_SELECTOR; ///< 受限访问添加按钮标题属性

///-------------------------------
/// @name Album
///-------------------------------

@property (nonatomic, assign) CGFloat albumCellHeight UI_APPEARANCE_SELECTOR; ///< cell高度
@property (nonatomic, strong) UIColor *albumSelectedColor UI_APPEARANCE_SELECTOR; ///< 选中颜色
@property (nonatomic, assign) CGFloat albumImageSize UI_APPEARANCE_SELECTOR; ///< 缩略图大小
@property (nonatomic, assign) CGFloat albumImageLeftMargin UI_APPEARANCE_SELECTOR; ///< 缩略图左间距
@property (nonatomic, assign) CGFloat albumImageCornerRadius UI_APPEARANCE_SELECTOR; ///< 缩略图圆角
@property (nonatomic, assign) UIEdgeInsets albumNameInsets UI_APPEARANCE_SELECTOR; ///< 相册名下左右间距
@property (nonatomic, strong) NSDictionary *albumNameAttributes UI_APPEARANCE_SELECTOR; ///< 相册名属性
@property (nonatomic, assign) UIEdgeInsets albumNumberInsets UI_APPEARANCE_SELECTOR; ///< 相册资源数量上左右间距
@property (nonatomic, strong) NSDictionary *albumNumberAttributes UI_APPEARANCE_SELECTOR; ///< 相册资源数量属性
@property (nonatomic, assign) CGFloat albumArrowRightMargin UI_APPEARANCE_SELECTOR; ///< 箭头图标右间距
@property (nonatomic, strong) NSString *albumArrowImage UI_APPEARANCE_SELECTOR; ///< 箭头图片
@property (nonatomic, assign) UIEdgeInsets albumSeparatorInsets UI_APPEARANCE_SELECTOR; ///< 分割线左右间距
@property (nonatomic, assign) CGFloat albumSepratorHeight UI_APPEARANCE_SELECTOR; ///< 分割线高度
@property (nonatomic, strong) UIColor *albumSeparatorColor UI_APPEARANCE_SELECTOR; ///< 分割线颜色

///-------------------------------
/// @name Asset
///-------------------------------

@property (nonatomic, assign) NSInteger assetColumnCount UI_APPEARANCE_SELECTOR; ///< 资源列数
@property (nonatomic, assign) UIEdgeInsets assetSectionInsets UI_APPEARANCE_SELECTOR; ///< 资源组间距
@property (nonatomic, assign) CGFloat assetSpacing UI_APPEARANCE_SELECTOR; ///< 资源行列间隔
@property (nonatomic, strong) NSString *assetNotSelectedImage UI_APPEARANCE_SELECTOR; ///< 资源未选中图片
@property (nonatomic, strong) NSString *assetSelectedImage UI_APPEARANCE_SELECTOR; ///< 资源选中图片
@property (nonatomic, strong) UIFont *assetNoteFont UI_APPEARANCE_SELECTOR; ///< 资源描述文字字体
@property (nonatomic, strong) UIColor *assetNoteColor UI_APPEARANCE_SELECTOR; ///< 资源描述文字颜色
@property (nonatomic, strong) NSDictionary *assetToolBarItemNormalAttributes UI_APPEARANCE_SELECTOR; ///< 工具栏按钮标题属性
@property (nonatomic, strong) NSDictionary *assetToolBarItemDisabledAttributes UI_APPEARANCE_SELECTOR; ///< 工具栏按钮标题属性
@property (nonatomic, strong) NSDictionary *assetToolBarDoneItemNormalAttributes UI_APPEARANCE_SELECTOR; ///< 工具栏完成按钮标题属性
@property (nonatomic, strong) NSDictionary *assetToolBarDoneItemDisabledAttributes UI_APPEARANCE_SELECTOR; ///< 工具栏完成按钮标题属性
@property (nonatomic, strong) UIColor *assetToolBarDoneItemNormalBackgroundColor UI_APPEARANCE_SELECTOR; ///< 工具栏完成按钮背景颜色
@property (nonatomic, strong) UIColor *assetToolBarDoneItemDisabledBackgroundColor UI_APPEARANCE_SELECTOR; ///< 工具栏完成按钮背景颜色

///-------------------------------
/// @name Preview
///-------------------------------

@property (nonatomic, strong) NSString *previewTopBarBackImage UI_APPEARANCE_SELECTOR; ///< 导航栏返回图片
@property (nonatomic, strong) NSString *previewTopBarNotSelectedImage UI_APPEARANCE_SELECTOR; ///< 导航栏未选中图片
@property (nonatomic, strong) NSString *previewTopBarSelectedImage UI_APPEARANCE_SELECTOR; ///< 导航栏选中图片
@property (nonatomic, strong) NSString *previewToolBarOriginNotSelectedImage UI_APPEARANCE_SELECTOR; ///< 工具栏原图未选中图片
@property (nonatomic, strong) NSString *previewToolBarOriginSelectedImage UI_APPEARANCE_SELECTOR; ///< 工具栏原图选中图片
@property (nonatomic, strong) NSDictionary *previewToolBarItemNormalAttributes UI_APPEARANCE_SELECTOR; ///< 工具栏按钮标题属性
@property (nonatomic, strong) NSDictionary *previewToolBarItemDisabledAttributes UI_APPEARANCE_SELECTOR; ///< 工具栏按钮标题属性
@property (nonatomic, strong) UIColor *previewToolBarItemNormalBackgroundColor UI_APPEARANCE_SELECTOR; ///< 工具栏按钮背景颜色
@property (nonatomic, strong) UIColor *previewToolBarItemDisabledBackgroundColor UI_APPEARANCE_SELECTOR; ///< 工具栏按钮背景颜色

///-------------------------------
/// @name Name
///-------------------------------

@property (nonatomic, strong) NSString *pickerName UI_APPEARANCE_SELECTOR; ///< 相册名称
@property (nonatomic, strong) NSString *cancelName UI_APPEARANCE_SELECTOR; ///< 取消名称
@property (nonatomic, strong) NSString *previewName UI_APPEARANCE_SELECTOR; ///< 预览名称
@property (nonatomic, strong) NSString *doneName UI_APPEARANCE_SELECTOR; ///< 完成名称
@property (nonatomic, strong) NSString *originName UI_APPEARANCE_SELECTOR; ///< 原图名称
@property (nonatomic, strong, nullable) NSString *authorizedNoteTitleName UI_APPEARANCE_SELECTOR; ///< 授权提示标题名称
@property (nonatomic, strong, nullable) NSString *authorizedNoteDetailName UI_APPEARANCE_SELECTOR; ///< 授权提示详情名称
@property (nonatomic, strong, nullable) NSString *authorizedJumpTitleName UI_APPEARANCE_SELECTOR; ///< 授权跳转按钮标题名称
@property (nonatomic, strong, nullable) NSString *authorizedLimitedNoteName UI_APPEARANCE_SELECTOR; ///< 受限访问提示名称
@property (nonatomic, strong, nullable) NSString *authorizedLimitedJumpTitleName UI_APPEARANCE_SELECTOR; ///< 受限访问跳转按钮标题名称
@property (nonatomic, strong, nullable) NSString *authorizedLimitedAddTitleName UI_APPEARANCE_SELECTOR; ///< 受限访问添加按钮标题名称

///-------------------------------
/// @name Localized
///-------------------------------

@property (nonatomic, strong, nullable) NSString *localizedTable UI_APPEARANCE_SELECTOR; ///< 国际化文件名称
@property (nonatomic, strong, nullable) NSBundle *localizedBundle UI_APPEARANCE_SELECTOR; ///< 国际化文件地址，默认nil

///-------------------------------
/// @name Autorotate
///-------------------------------

@property (nonatomic, assign) BOOL shouldAutorotate UI_APPEARANCE_SELECTOR; ///< 是否允许旋转，默认NO

@end

NS_ASSUME_NONNULL_END
