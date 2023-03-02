//
//  YYTestOperationHeaderView.m
//  Template
//
//  Created by nevsee on 2022/9/7.
//

#import "YYTestOperationHeaderView.h"

@interface YYTestOperationHeaderView ()
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation YYTestOperationHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = XYFontMake(10);
        textLabel.textColor = YYNeutral7Color;
        textLabel.text = @"* 这是一个提示";
        [self addSubview:textLabel];
        _textLabel = textLabel;
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 0, 15));
        }];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize textSize = [_textLabel sizeThatFits:CGSizeMake(size.width - 30, HUGE)];
    return CGSizeMake(size.width, textSize.height + 15);
}

@end
