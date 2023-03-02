//
//  UITableViewCell+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2020/12/29.
//

#import "UITableViewCell+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(UITableViewCell_XYAdd)

@implementation UITableViewCell (XYAdd)

- (void)setXy_selectedBackgroundColor:(UIColor *)xy_selectedBackgroundColor {
    objc_setAssociatedObject(self, _cmd, xy_selectedBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (xy_selectedBackgroundColor) {
        if (!self.selectedBackgroundView || [NSStringFromClass(self.selectedBackgroundView.class) hasPrefix:@"UITableViewCell"]) {
            self.selectedBackgroundView = [[UIView alloc] init];
        }
        self.selectedBackgroundView.backgroundColor = xy_selectedBackgroundColor;
    }
}

- (UIColor *)xy_selectedBackgroundColor {
    return (UIColor *)objc_getAssociatedObject(self, @selector(setXy_selectedBackgroundColor:));
}

@end
