//
//  YYOperationBoard.h
//  Template
//
//  Created by nevsee on 2021/11/29.
//

#import "YYViewBoard.h"
#import "YYOperationView.h"

NS_ASSUME_NONNULL_BEGIN

/// 操作视图弹窗
@interface YYOperationBoard : YYViewBoard
@property (nonatomic, strong, readonly) YYOperationView *operationView;
@property (nonatomic, assign) CGFloat cancelButtonTopMargin; ///< 取消按钮上边距，默认和operationView.configuration.contentInsets.bottom一致
@end

NS_ASSUME_NONNULL_END
