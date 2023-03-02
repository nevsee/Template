//
//  UINavigationBar+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2017/1/5.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "UINavigationBar+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(UINavigationBar_XYAdd)

@implementation UINavigationBar (XYAdd)

- (void)xy_showBottomLine {
    [self setShadowImage:[UINavigationBar appearance].shadowImage];
}

- (void)xy_hideBottomLine {
    [self setShadowImage:[UIImage new]];
}

- (void)xy_makeBarTransparent {
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]];
}

- (void)xy_makeBarOriginal {
    [self setBackgroundImage:[[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UINavigationBar appearance].shadowImage];
}

@end
