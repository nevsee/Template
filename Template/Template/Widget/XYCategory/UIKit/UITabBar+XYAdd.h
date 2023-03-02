//
//  UITabBar+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2017/3/26.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (XYAdd)

/**
 Makes the top split line hidden or shown.
 */
- (void)xy_showTopLine;
- (void)xy_hideTopLine;

/**
 Makes bar transparent or original appearance.
 */
- (void)xy_makeBarTransparent;
- (void)xy_makeBarOriginal;

@end

NS_ASSUME_NONNULL_END
