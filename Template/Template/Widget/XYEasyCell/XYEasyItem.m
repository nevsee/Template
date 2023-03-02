//
//  XYEasyItem.m
//  XYEasyCell
//
//  Created by nevsee on 2019/11/5.
//  Copyright © 2019 nevsee. All rights reserved.
//

#import "XYEasyItem.h"

@implementation XYEasyItem

+ (instancetype)itemWithTitle:(NSString *)title {
    return [self itemWithTitle:title subtitle:nil iconName:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    return [self itemWithTitle:title subtitle:subtitle iconName:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title iconName:(NSString *)iconName {
    return [self itemWithTitle:title subtitle:nil iconName:iconName];
}

+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle iconName:(NSString *)iconName {
    XYEasyItem *item = [[XYEasyItem alloc] init];
    item.iconName = iconName;
    item.title = title;
    item.subtitle = subtitle;
    item.contentInsets = UIEdgeInsetsZero;
    item.iconMode = UIViewContentModeScaleToFill;
    item.iconSize = CGSizeZero;
    item.iconInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    item.titleWidth = 0;
    item.titleInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    item.titleLines = 1;
    item.titleAlignment = NSTextAlignmentLeft;
    item.subtitleInsets = UIEdgeInsetsMake(0, 12, 0, 12);
    item.subtitleLines = 1;
    item.subtitleAlignment = NSTextAlignmentRight;
    item.tailSize = CGSizeZero;
    item.tailInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    item.topSeparatorStyle = XYEasySeparatorStyleNone;
    item.bottomSeparatorStyle = XYEasySeparatorStyleTitle;
    item.topSeparatorInsets = UIEdgeInsetsZero;
    item.bottomSeparatorInsets = UIEdgeInsetsZero;
    item.separatorHeight = 0.5;
    item.separatorColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    item.selectedColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    return item;
}

@end
