//
//  XYWebFindConfiguration.m
//  XYWidget
//
//  Created by nevsee on 2021/12/10.
//

#import "XYWebFindConfiguration.h"

@implementation XYWebFindConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _normalBackgroundColor = @"#FCF3CF";
        _normalTextColor = @"#000000";
        _selectedBackgroundColor = @"#F0B27A";
        _selectedTextColor = @"#000000";
        _caseSensitive = NO;
        _selectsFirstMatch = YES;
    }
    return self;
}

@end
