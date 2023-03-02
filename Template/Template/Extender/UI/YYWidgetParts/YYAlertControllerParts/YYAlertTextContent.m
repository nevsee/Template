//
//  YYAlertTextContent.m
//  Ferry
//
//  Created by nevsee on 2022/5/24.
//

#import "YYAlertTextContent.h"

@interface YYAlertTextContent ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation YYAlertTextContent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self.contentView addSubview:scrollView];
        _scrollView = scrollView;
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = XYFontMake(16);
        textLabel.textColor = YYNeutral8Color;
        textLabel.numberOfLines = 0;
        [scrollView addSubview:textLabel];
        _textLabel = textLabel;
        
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
            make.width.mas_equalTo(scrollView.mas_width);
        }];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat width = size.width - XYEdgeInsetsMaxX(self.contentInsets);
    CGFloat height = [_textLabel sizeThatFits:CGSizeMake(width, HUGE)].height;
    _scrollView.contentSize = CGSizeMake(width, height);
    height = MIN(height + XYEdgeInsetsMaxY(self.contentInsets), YYScreenHeight * 0.4);
    self.preferredHeight = height;
    return [super sizeThatFits:size];
}

- (void)setText:(id)text {
    if ([text isKindOfClass:NSString.class]) {
        _textLabel.text = text;
    } else if ([text isKindOfClass:NSAttributedString.class]) {
        _textLabel.attributedText = text;
    }
}

@end
