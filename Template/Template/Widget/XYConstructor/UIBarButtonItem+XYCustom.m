//
//  UIBarButtonItem+XYCustom.m
//  XYConstructor
//
//  Created by nevsee on 2018/8/7.
//  Copyright © 2018年 nevsee. All rights reserved.
//

#import "UIBarButtonItem+XYCustom.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface _XYBarButton : UIButton
@property (nonatomic, assign) BOOL dimsButtonWhenHighlighted;
@property (nonatomic, assign) BOOL dimsButtonWhenDisabled;
@end

@implementation _XYBarButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;
    
    self.dimsButtonWhenHighlighted = YES;
    self.dimsButtonWhenDisabled = YES;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (!self.enabled) {
        return;
    }
    if (self.dimsButtonWhenHighlighted) {
        if (highlighted) {
            self.alpha = 0.5;
        } else {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                self.alpha = 1;
            } completion:nil];
        }
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    if (!enabled && self.dimsButtonWhenDisabled) {
        self.alpha = 0.3;
    } else {
        self.alpha = 1;
    }
}

@end

#pragma mark -

@implementation UIBarButtonItem (XYCustom)

- (void)setXy_normalAttributes:(NSDictionary *)xy_normalAttributes {
    if (!xy_normalAttributes) return;
    objc_setAssociatedObject(self, _cmd, xy_normalAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)xy_normalAttributes {
    return objc_getAssociatedObject(self, @selector(setXy_normalAttributes:));
}

- (void)setXy_highlightedAttributes:(NSDictionary *)xy_highlightedAttributes {
    if (!xy_highlightedAttributes) return;
    objc_setAssociatedObject(self, _cmd, xy_highlightedAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)xy_highlightedAttributes {
    return objc_getAssociatedObject(self, @selector(setXy_highlightedAttributes:));
}

+ (instancetype)xy_itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [self xy_itemWithTitle:title alignment:UIControlContentHorizontalAlignmentRight target:target action:action];
}

+ (instancetype)xy_itemWithTitle:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment target:(id)target action:(SEL)action {
    return [self xy_itemWithTitle:title image:nil alignment:alignment target:target action:action];
}

+ (instancetype)xy_itemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    return [self xy_itemWithImage:image alignment:UIControlContentHorizontalAlignmentRight target:target action:action];
}

+ (instancetype)xy_itemWithImage:(UIImage *)image alignment:(UIControlContentHorizontalAlignment)alignment target:(id)target action:(SEL)action {
    return [self xy_itemWithTitle:nil image:image alignment:alignment target:target action:action];
}

+ (instancetype)xy_itemWithTitle:(NSString *)title image:(UIImage *)image alignment:(UIControlContentHorizontalAlignment)alignment target:(id)target action:(SEL)action {
    return [self xy_itemWithTitle:title image:image normalAttributes:nil highlightedAttributes:nil alignment:alignment target:target action:action];
}

+ (instancetype)xy_itemWithTitle:(NSString *)title image:(UIImage *)image normalAttributes:(NSDictionary *)normalAttributes highlightedAttributes:(NSDictionary *)highlightedAttributes alignment:(UIControlContentHorizontalAlignment)alignment target:(id)target action:(SEL)action {
    if (!normalAttributes) {
        normalAttributes = [[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateNormal];
    }
    if (!highlightedAttributes) {
        highlightedAttributes = [[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateHighlighted];
    }
    
    // image
    UIImage *normalImage = image;
    UIImage *highlightedImage = [self changeImage:normalImage color:highlightedAttributes[NSForegroundColorAttributeName]];
    
    // title
    NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithString:title ?: @"" attributes:normalAttributes];
    NSAttributedString *highlightedTitle = [[NSAttributedString alloc] initWithString:title ?: @"" attributes:highlightedAttributes];

    _XYBarButton *button = [_XYBarButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button setAttributedTitle:normalTitle forState:UIControlStateNormal];
    [button setAttributedTitle:highlightedTitle forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setContentHorizontalAlignment:alignment];
    if (normalImage && normalTitle.length > 0) {
        if (alignment == UIControlContentHorizontalAlignmentLeft) {
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        } else {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        }
    }
    CGSize size = [button sizeThatFits:CGSizeMake(CGFLOAT_MAX, 44)];
    CGFloat width = size.width + 15;
    button.frame = (CGRect){0, 0, width, 44};
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    item.xy_normalAttributes = normalAttributes;
    item.xy_highlightedAttributes = highlightedAttributes;
    return item;
}

#pragma mark # Private

+ (UIImage *)changeImage:(UIImage *)image color:(UIColor *)color {
    if (!color || !image) return nil;
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

#pragma clang diagnostic pop
