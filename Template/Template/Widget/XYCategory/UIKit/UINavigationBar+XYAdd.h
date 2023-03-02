//
//  UINavigationBar+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2017/1/5.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (XYAdd)

/**
 Makes the bottom split line hidden or shown.
 */
- (void)xy_showBottomLine;
- (void)xy_hideBottomLine;

/**
 Makes the bar transparent or original appearance.
 */
- (void)xy_makeBarTransparent;
- (void)xy_makeBarOriginal;

@end

NS_ASSUME_NONNULL_END

