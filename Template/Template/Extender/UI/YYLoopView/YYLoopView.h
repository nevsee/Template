//
//  YYLoopView.h
//  Template
//
//  Created by nevsee on 2022/1/4.
//

#import <UIKit/UIKit.h>
#import "XYCycleScrollView.h"

@class YYLoopView;

NS_ASSUME_NONNULL_BEGIN

/// 滚动样式
typedef NS_ENUM(NSInteger, YYLoopViewScrollStyle) {
    YYLoopViewScrollStyleSlide = 1,
    YYLoopViewScrollStyleZoom,
};

/// 滚动方向
typedef NS_ENUM(NSInteger, YYLoopViewScrollDirection) {
    YYLoopViewScrollDirectionVertical = 1,
    YYLoopViewScrollDirectionHorizontal,
};

typedef void (^YYLoopViewWillScrollBlock)(YYLoopView *loopView, NSUInteger index);
typedef void (^YYLoopViewDidScrollBlock)(YYLoopView *loopView, NSUInteger index);
typedef void (^YYLoopViewDidSelectItemBlock)(YYLoopView *loopView, NSUInteger index);
typedef void (^YYLoopViewSetContentAttributeBlock)(YYLoopView *loopView, __kindof UIView *contentView, NSUInteger index);
typedef Class<XYCycleDataParser> _Nonnull (^YYLoopViewSetContentClassBlock)(YYLoopView *loopView, NSUInteger index);

/**
 轮播视图
 1.支持展示多个自定义内容视图，需要注册内容视图并实现YYLoopViewSetContentClassBlock，默认使用YYLoopImageContentView；
 2.支持修改内容视图属性，使用YYLoopViewSetContentAttributeBlock；
 3.内容视图需要实现XYCycleDataParser协议；
 */
@interface YYLoopView : UIView
@property (nonatomic, strong, readonly) XYCycleScrollView *scrollView;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
@property (nonatomic, assign) YYLoopViewScrollStyle scrollStyle; ///< 默认YYLoopViewScrollStyleSlide
@property (nonatomic, assign) YYLoopViewScrollDirection scrollDirection; ///< 默认YYLoopViewScrollDirectionHorizontal
@property (nonatomic, assign) CGFloat itemSpacing; ///< item间距，默认20
@property (nonatomic, assign) UIEdgeInsets sectionInsets; ///< 边距，默认UIEdgeInsetsZero
@property (nonatomic, assign) CGFloat pageControlBottom; ///< 分页控件下边距，默认5
@property (nonatomic, assign) NSUInteger defaultIndex; ///< 初始显示下标，默认0
@property (nonatomic, strong) NSArray *datas; ///< 数据
@property (nonatomic, strong, nullable) NSDictionary *userInfo; ///< 附加参数
@property (nonatomic, strong, nullable) YYLoopViewSetContentClassBlock setContentClassBlock; ///< 注册内容视图
@property (nonatomic, strong, nullable) YYLoopViewSetContentAttributeBlock setContentAttributeBlock; ///< 设置内容视图
@property (nonatomic, strong, nullable) YYLoopViewWillScrollBlock willScrollBlock;
@property (nonatomic, strong, nullable) YYLoopViewDidScrollBlock didScrollBlock;
@property (nonatomic, strong, nullable) YYLoopViewDidSelectItemBlock didSelectItemBlock;
- (void)registerCellWithReuseIdentifier:(NSString *)identifier;
- (__kindof UIView *)contentViewForIndex:(NSInteger)index;
@end

/**
 图片内容视图
 datas支持：NSString/NSURL/UIImage/UIColor/NSData
 userInfo支持：placeholderImage
 */
@interface YYLoopImageContentView : UIView <XYCycleDataParser>
@property (nonatomic, strong, readonly) UIImageView *imageView;
@end

/**
 文字内容视图
 datas支持：NSString/NSAttributeString
 */
@interface YYLoopTextContentView : UIView <XYCycleDataParser>
@property (nonatomic, strong, readonly) XYLabel *textLabel;
@end

NS_ASSUME_NONNULL_END
