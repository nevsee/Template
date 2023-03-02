//
//  UITabBar+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2017/3/26.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "UITabBar+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(UITabBar_XYAdd)

@implementation UITabBar (XYAdd)

- (void)xy_showTopLine {
    [self setShadowImage:[UINavigationBar appearance].shadowImage];
}

- (void)xy_hideTopLine {
    [self setShadowImage:[UIImage new]];
}

- (void)xy_makeBarTransparent {
    [self setBackgroundImage:[UIImage new]];
    [self setShadowImage:[UIImage new]];
}

- (void)xy_makeBarOriginal {
    [self setBackgroundImage:[[UITabBar appearance] backgroundImage]];
    [self setShadowImage:[UINavigationBar appearance].shadowImage];
}

@end
