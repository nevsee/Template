//
//  UITabBarItem+XYCustom.m
//  XYConstructor
//
//  Created by nevsee on 2018/8/7.
//  Copyright © 2018年 nevsee. All rights reserved.
//

#import "UITabBarItem+XYCustom.h"

@implementation UITabBarItem (XYCustom)

+ (instancetype)xy_itemWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag {
    UIImage *originalImage = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return [[UITabBarItem alloc] initWithTitle:title image:originalImage tag:tag];
}

+ (instancetype)xy_itemWithTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    UIImage *originalImage = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *originalSelectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return [[UITabBarItem alloc] initWithTitle:title image:originalImage selectedImage:originalSelectedImage];
}

@end
