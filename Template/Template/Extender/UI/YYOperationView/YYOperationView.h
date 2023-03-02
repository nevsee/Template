//
//  YYOperationView.h
//  Template
//
//  Created by nevsee on 2021/11/25.
//

#import <UIKit/UIKit.h>

@class YYOperationView;
@class YYOperationItem;
@class YYOperationConfiguration;

NS_ASSUME_NONNULL_BEGIN

typedef void (^YYOperationViewDidChangeBlock)(YYOperationView *operationView, CGFloat height);
typedef void (^YYOperationViewDidScrollBlock)(YYOperationView *operationView, CGPoint offset);
typedef void (^YYOperationViewDidSelectItemBlock)(YYOperationView *operationView, YYOperationItem *item);

typedef NSString *YYOperationType NS_EXTENSIBLE_STRING_ENUM;

/**
 二维列表操作视图
 1.根据给定的数据动态计算视图的高度，忽略设置的高度；
 2.当视图宽度变化时，会自动更新视图高度；
 3.当最大高度限制变化时，会自动更新视图高度；
 4.当超过最大设置高度时，视图可以上下滚动；
 5.可以手动调用updateViewLayoutIfNeeded更新布局，比如头尾视图内容变化时；
 6.头/尾视图必须实现sizeThatFits方法；
 */
@interface YYOperationView : UIView
@property (nonatomic, strong, readonly) NSArray<NSArray<YYOperationItem *> *> *items;
@property (nonatomic, strong, readonly) YYOperationConfiguration *configuration;
@property (nonatomic, strong, nullable) __kindof UIView *headerView;
@property (nonatomic, strong, nullable) __kindof UIView *footerView;
@property (nonatomic, strong, nullable) YYOperationViewDidChangeBlock didChangeBlock; ///< 视图高度改变
@property (nonatomic, strong, nullable) YYOperationViewDidScrollBlock didScrollBlock; ///< 视图上下滚动
@property (nonatomic, strong, nullable) YYOperationViewDidSelectItemBlock didSelectItemBlock;
- (instancetype)initWithFrame:(CGRect)frame configuration:(nullable YYOperationConfiguration *)configuration;
- (void)insertItem:(YYOperationItem *)item inSection:(NSInteger)section; ///< section取值范围[0, 1]
- (void)insertItems:(NSArray *)items inSection:(NSInteger)section;
- (void)insertItem:(YYOperationItem *)item atIndexPath:(NSIndexPath *)indexPath;
- (void)insertItems:(NSArray *)items atIndexPath:(NSIndexPath *)indexPath;
- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateViewLayoutIfNeeded;
@end

/// 操作视图配置
@interface YYOperationConfiguration : NSObject
@property (nonatomic, assign) CGFloat maximumHeight; ///< 操作视图最大高度，超过可上下滑动，默认CGFLOAT_MAX
@property (nonatomic, assign) UIEdgeInsets contentInsets; ///< 内容边距，默认(15, 15, 15, 15)
@property (nonatomic, assign) CGFloat listMargin; ///< 列表间距，默认15
@property (nonatomic, assign) CGFloat listItemSpacing; ///< 列表项间距，默认15
@property (nonatomic, assign) CGFloat imageHorizontalMargin; ///< 图片水平间距，默认0
@property (nonatomic, assign) CGFloat imageSize; ///< 图片大小，默认50
@property (nonatomic, assign) CGFloat imageCornerRadius; ///< 图片圆角，默认14
@property (nonatomic, strong) UIColor *imageNormalColor; ///< 图片正常背景色
@property (nonatomic, strong) UIColor *imageHighlightedColor; ///< 图片高亮背景色
@property (nonatomic, assign) CGFloat textTopMargin; ///< 文字上间距，默认5
@property (nonatomic, strong) NSDictionary *textAttributes; ///< 文字属性
@end

/// 操作项
@interface YYOperationItem : NSObject
@property (nonatomic, assign) NSInteger tag; ///< 默认-1
@property (nonatomic, strong, nullable) YYOperationType type; ///< 操作项类型，默认nil
@property (nonatomic, strong) UIImage *image; ///< 操作项图片
@property (nonatomic, strong) NSString *text; ///< 操作项文字
@property (nonatomic, strong, nullable) void (^handler)(void); ///< 操作项点击处理
@end

NS_ASSUME_NONNULL_END
