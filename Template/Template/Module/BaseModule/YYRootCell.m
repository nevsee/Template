//
//  YYRootCell.m
//  Template
//
//  Created by nevsee on 2022/2/22.
//

#import "YYRootCell.h"

@implementation YYRootCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.numberOfLines = 0;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = XYFontMake(16);
        textLabel.textColor = YYNeutral9Color;
        [self.contentView addSubview:textLabel];
        _textLabel = textLabel;
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

@end
