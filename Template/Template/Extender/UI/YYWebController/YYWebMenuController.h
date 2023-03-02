//
//  YYWebMenuController.h
//  Template
//
//  Created by nevsee on 2021/12/9.
//

#import "YYWebController.h"
#import "YYWebMenuBoard.h"
#import "YYWebFontBoard.h"
#import "YYWebSearchBoard.h"

NS_ASSUME_NONNULL_BEGIN

/// 带菜单的网页控制器
@interface YYWebMenuController : YYWebController
@property (nonatomic, strong, readonly) YYWebMenuBoard *menuBoard;
@property (nonatomic, strong, readonly) YYWebFontBoard *fontBoard;
@property (nonatomic, strong, readonly) YYWebSearchBoard *searchBoard;
@end

NS_ASSUME_NONNULL_END
