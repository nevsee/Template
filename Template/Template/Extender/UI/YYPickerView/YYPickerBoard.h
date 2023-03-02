//
//  YYPickerBoard.h
//  Template
//
//  Created by nevsee on 2022/1/5.
//

#import "YYViewBoard.h"
#import "YYPickerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^YYPickerBoardConfirmBlock)(NSArray *values, NSArray *names);
typedef void(^YYPickerBoardCancelBlock)(void);

/// 选择器弹窗
@interface YYPickerBoard : YYViewBoard
@property (nonatomic, strong, readonly) YYPickerView *pickerView;
@property (nonatomic, assign) CGFloat topBarHeight; ///< 顶部工具条高度，默认50
@property (nonatomic, assign) CGFloat totalHeight; ///< 默认300
@property (nonatomic, strong, nullable) YYPickerBoardConfirmBlock confirmBlock;
@property (nonatomic, strong, nullable) YYPickerBoardCancelBlock cancelBlock;
@end

NS_ASSUME_NONNULL_END
