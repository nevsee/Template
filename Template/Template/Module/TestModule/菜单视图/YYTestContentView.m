//
//  YYTestContentView.m
//  Template
//
//  Created by nevsee on 2022/1/27.
//

#import "YYTestContentView.h"

@interface YYTestContentView ()
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation YYTestContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.font = XYFontMake(13);
        label.textColor = UIColor.blackColor;
        label.numberOfLines = 0;
        [self addSubview:label];
        _textLabel = label;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    _textLabel.text = text;
}

@end
