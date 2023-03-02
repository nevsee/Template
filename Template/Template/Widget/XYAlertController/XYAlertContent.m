//
//  XYAlertContent.m
//  XYAlertController
//
//  Created by nevsee on 2018/10/12.
//

#import "XYAlertContent.h"
#import "XYAlertController.h"

@interface XYAlertContent ()
@property (nonatomic, strong, readwrite) UIView *contentView;
@end

@implementation XYAlertContent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = UIColor.clearColor;
        [self addSubview:contentView];
        _contentView = contentView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.frame = UIEdgeInsetsInsetRect(self.bounds, _contentInsets);
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, _preferredHeight);
}

@end

#pragma mark -

@implementation XYAlertFixedSpaceContent

+ (instancetype)fixedSpaceContent {
    XYAlertFixedSpaceContent *content = [[XYAlertFixedSpaceContent alloc] init];
    content.contentInsets = UIEdgeInsetsZero;
    return content;
}

@end

#pragma mark -

@interface XYAlertTextContent ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation XYAlertTextContent

- (instancetype)initWithText:(NSString *)text style:(XYAlertContentStyle)style alerter:(XYAlertController *)alerter {
    self = [super init];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _label = label;
        
        self.style = style;
        self.alerter = alerter;
        self.text = text;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _label.frame = self.contentView.bounds;
}

// Method
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat width = size.width - self.contentInsets.left - self.contentInsets.right;
    CGFloat height = [_label sizeThatFits:CGSizeMake(width, HUGE)].height;
    self.preferredHeight = height + self.contentInsets.top + self.contentInsets.bottom;
    return [super sizeThatFits:size];
}

// Access
- (void)setTextAttributes:(NSDictionary *)textAttributes {
    _textAttributes = textAttributes;
    NSAttributedString *attributedText = _text ? [[NSAttributedString alloc] initWithString:_text attributes:textAttributes] : nil;
    _label.attributedText = attributedText;
}

- (void)setText:(NSString *)text {
    _text = text;
    NSAttributedString *attributedText = text ? [[NSAttributedString alloc] initWithString:text attributes:_textAttributes] : nil;
    _label.attributedText = attributedText;
}

- (void)setAlerter:(XYAlertController *)alerter {
    if (self.alerter) return;
    [super setAlerter:alerter];
    
    XYAlertAppearance *appearance = [XYAlertAppearance appearance];
    if (alerter.preferredStyle == XYAlertControllerStyleAlert) {
        self.contentInsets = appearance.contentInsetsForAlert;
        if (self.style == XYAlertContentStyleTitle) self.textAttributes = appearance.contentTitleAttributesForAlert;
        else self.textAttributes = appearance.contentMessageAttributesForAlert;
    } else {
        self.contentInsets = appearance.contentInsetsForSheet;
        if (self.style == XYAlertContentStyleTitle) self.textAttributes = appearance.contentTitleAttributesForSheet;
        else self.textAttributes = appearance.contentMessageAttributesForSheet;
    }
}

@end

