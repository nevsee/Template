//
//  XYEasyGroup.m
//  XYEasyCell
//
//  Created by nevsee on 2019/11/5.
//  Copyright © 2019 nevsee. All rights reserved.
//

#import "XYEasyGroup.h"

@implementation XYEasyGroup

+ (instancetype)group {
    XYEasyGroup *group = [[XYEasyGroup alloc] init];
    group.easyItems = [NSMutableArray array];
    return group;
}

- (void)setGroupHeaderHeight:(CGFloat)groupHeaderHeight {
    _groupHeaderHeight = groupHeaderHeight;
    if (_groupHeaderHeight <= 0) {
        _groupHeaderHeight = CGFLOAT_MIN;
    }
}

- (void)setGroupFooterHeight:(CGFloat)groupFooterHeight {
    _groupFooterHeight = groupFooterHeight;
    if (_groupFooterHeight <= 0) {
        _groupFooterHeight = CGFLOAT_MIN;
    }
}

@end
