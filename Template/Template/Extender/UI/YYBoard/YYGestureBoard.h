//
//  YYGestureBoard.h
//  Template
//
//  Created by nevsee on 2022/2/21.
//

#import "YYViewBoard.h"
#import "YYNavigationBoard.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, YYBoardGestureDirection) {
    YYBoardGestureDirectionUp = 1 << 0,
    YYBoardGestureDirectionDown = 1 << 1,
    YYBoardGestureDirectionLeft = 1 << 2,
    YYBoardGestureDirectionRight = 1 << 3
};

/**
 手势模态弹框
 */
@interface YYGestureViewBoard : YYViewBoard
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) YYBoardGestureDirection direction; ///< 手势方向，默认YYBoardGestureDirectionDown
@property (nonatomic, assign) CGFloat progressThreshold; ///< 滑动进度临界值，默认0.3
@property (nonatomic, assign) CGFloat speedThreshold; ///< 滑动速度临界值，默认900
@end

/**
 手势模态导航弹框
 */
@interface YYGestureNavigationBoard : YYNavigationBoard
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) YYBoardGestureDirection direction; ///< 手势方向，默认YYBoardGestureDirectionDown
@property (nonatomic, assign) CGFloat progressThreshold; ///< 滑动进度临界值，默认0.3
@property (nonatomic, assign) CGFloat speedThreshold; ///< 滑动速度临界值，默认900
@end

NS_ASSUME_NONNULL_END
