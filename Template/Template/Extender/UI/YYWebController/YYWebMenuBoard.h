//
//  YYWebMenuBoard.h
//  Template
//
//  Created by nevsee on 2021/11/24.
//

#import "YYOperationBoard.h"

@class YYWebMenuController;
@protocol YYWebMenuSupplementaryViewDescriber;

NS_ASSUME_NONNULL_BEGIN

/// 菜单板
@interface YYWebMenuBoard : YYOperationBoard
@property (nonatomic, weak) YYWebMenuController *menuController;
@property (nonatomic, strong, nullable) UIView<YYWebMenuSupplementaryViewDescriber> *headerView;
@property (nonatomic, strong, nullable) UIView<YYWebMenuSupplementaryViewDescriber> *footerView;
@end

/// 菜单头尾视图协议
@protocol YYWebMenuSupplementaryViewDescriber <NSObject>
@required
@property (nonatomic, weak) YYWebMenuBoard *menuBoard;
- (void)updateViewWithData:(id)data userInfo:(nullable id)userInfo;
@end

/// 网页链接提示头视图
@interface YYWebMenuLinkHeaderView : UIView <YYWebMenuSupplementaryViewDescriber>
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, assign) UIEdgeInsets textInsets;
@end

/// 菜单操作项供应者
@interface YYWebMenuItemProvider : NSObject
+ (YYOperationItem *)obainItemForType:(YYOperationType)type;
+ (NSArray<YYOperationItem *> *)obtainItemsForTypes:(NSArray<YYOperationType> *)types;
@end

UIKIT_EXTERN YYOperationType const YYOperationTypeWebCopyLink; ///< 复制链接
UIKIT_EXTERN YYOperationType const YYOperationTypeWebRefresh; ///< 刷新
UIKIT_EXTERN YYOperationType const YYOperationTypeWebFont; ///< 调整字体大小
UIKIT_EXTERN YYOperationType const YYOperationTypeWebSearch; ///< 搜索页面内容
UIKIT_EXTERN YYOperationType const YYOperationTypeWebCollect; ///< 收藏
UIKIT_EXTERN YYOperationType const YYOperationTypeWebSafari; ///< 在默认浏览器中打开
UIKIT_EXTERN YYOperationType const YYOperationTypeWebSystemShare; ///< 用其他应用打开

NS_ASSUME_NONNULL_END
