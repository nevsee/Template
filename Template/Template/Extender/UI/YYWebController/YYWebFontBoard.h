//
//  YYWebFontBoard.h
//  Template
//
//  Created by nevsee on 2021/11/24.
//

#import "YYViewBoard.h"

@class YYWebFontContentView;
@class YYWebMenuController;

NS_ASSUME_NONNULL_BEGIN

/// 字体板
@interface YYWebFontBoard : YYViewBoard
@property (nonatomic, weak) YYWebMenuController *menuController;
@property (nonatomic, strong, readonly) YYWebFontContentView *contentView;
@end

/// 字体板内容视图
@interface YYWebFontContentView : UIView
@property (nonatomic, assign) NSInteger optionCount; ///< 选项个数 optionCount >= 3，默认7
@property (nonatomic, assign) CGFloat optionInterval; ///< 选项字体系数差值，默认0.1
@property (nonatomic, assign) NSInteger optionIndex; ///< 标准字体下标 0 < standardIndex < optionCount，默认1
@property (nonatomic, copy) void(^valueChangedBlock)(CGFloat value);
- (void)resetCurrentIndex;
@end

NS_ASSUME_NONNULL_END
