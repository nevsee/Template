//
//  UIButton+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2018/12/28.
//  Copyright © 2018年 nevsee. All rights reserved.
//

#import "UIButton+XYAdd.h"
#import "UIView+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(UIButton_XYAdd)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation UIButton (XYAdd)

- (void)xy_layoutForImagePosition:(XYButtonImagePosition)position space:(CGFloat)space {
    CGFloat imageWidth = self.imageView.xy_width;
    CGFloat imageHeight = self.imageView.xy_height;
    CGFloat titleWidth = self.titleLabel.xy_width;
    CGFloat titleHeight = self.titleLabel.xy_height;
    
    // title label intrinsic content width
    CGFloat intrinsicTitleWidth = self.titleLabel.intrinsicContentSize.width;
    
    // image inset's right (use for top and bottom position)
    CGFloat right = titleWidth;
    
    // limites space
    if (space < 0) space = 0;
    
    if (position == XYButtonImagePositionLeft || position == XYButtonImagePositionRight) {
        CGFloat totalWidth = titleWidth + imageWidth + space;
        if (totalWidth > self.xy_width) space = self.xy_width - titleWidth - imageWidth;
    }
    
    if (position == XYButtonImagePositionTop || position == XYButtonImagePositionBottom) {
        if (titleHeight + imageHeight > self.xy_height) return;
        CGFloat totalHeight = titleHeight + imageHeight + space;
        if (totalHeight > self.xy_height) space = self.xy_height - titleHeight - imageHeight;
        
        if (intrinsicTitleWidth > titleWidth) {
            right = intrinsicTitleWidth > self.xy_width ? self.xy_width : intrinsicTitleWidth;
        }
    }
    
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;

    switch (position) {
        case XYButtonImagePositionTop:
            imageEdgeInsets = UIEdgeInsetsMake(-titleHeight - space/2, 0, 0, -right);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, -imageHeight - space/2, 0);
            break;
        case XYButtonImagePositionLeft:
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2, 0, space/2);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2, 0, -space/2);
            break;
        case XYButtonImagePositionBottom:
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -titleHeight - space/2, -right);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight - space/2, -imageWidth, 0, 0);
            break;
        case XYButtonImagePositionRight:
            imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth + space/2, 0, -titleWidth - space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - space/2, 0, imageWidth + space/2.0);
            break;
    }

    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;

    // adjusts image position
    if (position == XYButtonImagePositionTop || position == XYButtonImagePositionBottom) {
        if (intrinsicTitleWidth > self.xy_width) {
            [self layoutIfNeeded];
            [self setNeedsLayout];
            
            CGRect frame = self.titleLabel.frame;
            UIEdgeInsets inset = self.imageEdgeInsets;
            self.imageEdgeInsets = UIEdgeInsetsMake(inset.top, inset.left, inset.bottom, -right + frame.origin.x / 2);
        }
    }
}

@end

#pragma clang diagnostic pop
