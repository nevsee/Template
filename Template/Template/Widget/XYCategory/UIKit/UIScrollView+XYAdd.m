//
//  UIScrollView+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2019/11/15.
//  Copyright © 2019 yimai. All rights reserved.
//

#import "UIScrollView+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(UIScrollView_XYAdd)

@implementation UIScrollView (XYAdd)

- (UIEdgeInsets)xy_contentInsets {
    if (@available(iOS 11, *)) {
        return self.adjustedContentInset;
    } else {
        return self.contentInset;
    }
}

- (BOOL)xy_canScroll {
    return self.xy_canScrollVertical || self.xy_canScrollHorizontal;
}

- (BOOL)xy_canScrollVertical {
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) return NO;
    return self.contentSize.height + self.xy_contentInsets.top + self.xy_contentInsets.bottom > self.bounds.size.height;
}

- (BOOL)xy_canScrollHorizontal {
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) return NO;
    return self.contentSize.width + self.xy_contentInsets.left + self.xy_contentInsets.right > self.bounds.size.width;
}

- (void)xy_scrollToTop {
    [self xy_scrollToTopAnimated:YES];
}

- (void)xy_scrollToBottom {
    [self xy_scrollToBottomAnimated:YES];
}

- (void)xy_scrollToLeft {
    [self xy_scrollToLeftAnimated:YES];
}

- (void)xy_scrollToRight {
    [self xy_scrollToRightAnimated:YES];
}

- (void)xy_scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)xy_scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)xy_scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)xy_scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end
