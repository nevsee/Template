//
//  YYEmptyView.h
//  Template
//
//  Created by nevsee on 2021/11/25.
//

#import <UIKit/UIKit.h>
#import "Template-Swift.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>

@class YYEmptyLoadingContentView;
@class YYEmptyPlaceholderContentView;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YYEmptyContentMode) {
    YYEmptyContentModeLoading,
    YYEmptyContentModeResult,
    YYEmptyContentModeError,
};

/**
 空界面提示视图
 1.支持加载提示、结果提示、错误提示，可通过mode来切换内容视图；
 2.内容视图居中显示，可通过loadingOffset / resultOffset / errorOffset设置偏移量；
 3.内容视图可自定义，必须实现sizeThatFits方法；
 4.当视图hidden = yes / alpha = 0 / superview = nil或者加载内容视图alpha = 0时，停止加载动画，否则开启；
 */
@interface YYEmptyView : UIView
@property (nonatomic, strong, nullable) __kindof YYEmptyLoadingContentView *loadingContentView;
@property (nonatomic, strong, nullable) __kindof YYEmptyPlaceholderContentView *resultContentView;
@property (nonatomic, strong, nullable) __kindof YYEmptyPlaceholderContentView *errorContentView;
@property (nonatomic, assign) UIOffset loadingOffset;
@property (nonatomic, assign) UIOffset resultOffset;
@property (nonatomic, assign) UIOffset errorOffset;
@property (nonatomic, assign) YYEmptyContentMode mode;
@end

@interface YYEmptyView (YYConvenient)
+ (instancetype)defaultView; ///< 创建所有内容视图
+ (instancetype)defaultViewWithTarget:(nullable id)target retryAction:(nullable SEL)retryAction;
+ (instancetype)viewWithMode:(YYEmptyContentMode)mode;
+ (instancetype)viewWithMode:(YYEmptyContentMode)mode target:(nullable id)target retryAction:(nullable SEL)retryAction;
@end

/// 加载内容视图
@interface YYEmptyLoadingContentView : UIView
@property (nonatomic, strong) YYLottieAnimationView *animationView;
@property (nonatomic, assign) CGSize animationSize;
- (void)startLoading;
- (void)stopLoading;
@end

/// 占位内容视图
@interface YYEmptyPlaceholderContentView : UIView
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) TTTAttributedLabel *textLabel;
@property (nonatomic, strong, readonly) XYButton *operationButton;
@property (nonatomic, assign) CGFloat minimumHorizontalPadding; ///< 最小水平外边距，默认40
@property (nonatomic, assign) CGSize fixedImageSize; ///< 图片固定大小，未指定则采用图片本身大小
@property (nonatomic, assign) CGFloat textTopMargin; ///< 文字上边距，默认10
@property (nonatomic, assign) CGFloat buttonTopMargin; ///< 按钮上边距，默认0
@property (nonatomic, assign) CGSize buttonExpansion; ///< 按钮扩张大小，默认(30, 6)
@end

NS_ASSUME_NONNULL_END
