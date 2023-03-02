//
//  UIScrollView+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2019/11/15.
//  Copyright © 2019 yimai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (XYAdd)

/// The scroll view content insets.
@property (nonatomic, readonly) UIEdgeInsets xy_contentInsets;

/// Whether the scroll view can scroll.
@property (nonatomic, readonly) BOOL xy_canScroll;
@property (nonatomic, readonly) BOOL xy_canScrollVertical;
@property (nonatomic, readonly) BOOL xy_canScrollHorizontal;

- (void)xy_scrollToTop;
- (void)xy_scrollToTopAnimated:(BOOL)animated;

- (void)xy_scrollToBottom;
- (void)xy_scrollToBottomAnimated:(BOOL)animated;

- (void)xy_scrollToLeft;
- (void)xy_scrollToLeftAnimated:(BOOL)animated;

- (void)xy_scrollToRight;
- (void)xy_scrollToRightAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
