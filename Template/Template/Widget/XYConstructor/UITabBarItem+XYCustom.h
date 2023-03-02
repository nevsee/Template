//
//  UITabBarItem+XYCustom.h
//  XYConstructor
//
//  Created by nevsee on 2018/8/7.
//  Copyright © 2018年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarItem (XYCustom)

+ (instancetype)xy_itemWithTitle:(nullable NSString *)title
                           image:(nullable NSString *)image
                             tag:(NSInteger)tag;

+ (instancetype)xy_itemWithTitle:(nullable NSString *)title
                           image:(nullable NSString *)image
                   selectedImage:(nullable NSString *)selectedImage;

@end

NS_ASSUME_NONNULL_END
