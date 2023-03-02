//
//  UIButton+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2018/12/28.
//  Copyright © 2018年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYButtonImagePosition) {
    XYButtonImagePositionTop,
    XYButtonImagePositionLeft,
    XYButtonImagePositionBottom,
    XYButtonImagePositionRight
};

@interface UIButton (XYAdd)

/**
 Layouts image's position in the button.
 @param position Layout type of image
 @param space Spacing between title and image
 @note The size of the button must be set in advance.
 */
- (void)xy_layoutForImagePosition:(XYButtonImagePosition)position space:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
