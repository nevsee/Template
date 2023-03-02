//
//  UIBarButtonItem+XYCustom.h
//  XYConstructor
//
//  Created by nevsee on 2018/8/7.
//  Copyright © 2018年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (XYCustom)

@property (nonatomic, strong, readonly, nullable) NSDictionary *xy_normalAttributes;
@property (nonatomic, strong, readonly, nullable) NSDictionary *xy_highlightedAttributes;

+ (instancetype)xy_itemWithTitle:(NSString *)title
                          target:(nullable id)target
                          action:(nullable SEL)action;

+ (instancetype)xy_itemWithTitle:(NSString *)title
                       alignment:(UIControlContentHorizontalAlignment)alignment
                          target:(nullable id)target
                          action:(nullable SEL)action;

+ (instancetype)xy_itemWithImage:(UIImage *)image
                          target:(nullable id)target
                          action:(nullable SEL)action;

+ (instancetype)xy_itemWithImage:(UIImage *)image
                       alignment:(UIControlContentHorizontalAlignment)alignment
                          target:(nullable id)target
                          action:(nullable SEL)action;

+ (instancetype)xy_itemWithTitle:(nullable NSString *)title
                           image:(nullable UIImage *)image
                       alignment:(UIControlContentHorizontalAlignment)alignment
                          target:(nullable id)target
                          action:(nullable SEL)action;

+ (instancetype)xy_itemWithTitle:(nullable NSString *)title
                           image:(nullable UIImage *)image
                normalAttributes:(nullable NSDictionary *)normalAttributes
           highlightedAttributes:(nullable NSDictionary *)highlightedAttributes
                       alignment:(UIControlContentHorizontalAlignment)alignment
                          target:(nullable id)target
                          action:(nullable SEL)action;
@end


NS_ASSUME_NONNULL_END
