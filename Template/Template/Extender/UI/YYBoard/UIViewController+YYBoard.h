//
//  UIViewController+YYBoard.h
//  Template
//
//  Created by nevsee on 2022/1/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (YYBoard)

/**
 设置弹框大小，子类重写
 @example
 - (void)preferredBoardContentSize {
    xy_portraitContentSize = CGSizeMake(100, 100);
    xy_landscapeContentSize = CGSizeMake(100, 100);
 }
 */
- (void)preferredBoardContentSize;

@end

NS_ASSUME_NONNULL_END
