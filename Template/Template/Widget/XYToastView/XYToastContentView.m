//
//  XYToastContentView.m
//  XYToastView
//
//  Created by nevsee on 2017/3/13.
//

#import "XYToastContentView.h"
#import "XYToastView.h"

@implementation XYToastContentView
@end

#pragma mark -

@interface XYToastDefaultContentView ()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, assign) BOOL hasCustom;
@property (nonatomic, assign) BOOL hasText;
@property (nonatomic, assign) BOOL hasDetailText;
@property (nonatomic, assign) CGSize customSize;
@property (nonatomic, assign) CGSize textSize;
@property (nonatomic, assign) CGSize detailTextSize;
@end

@implementation XYToastDefaultContentView

#pragma mark # Life

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self userInterfaceSetup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self calculateLayouts];
}

- (void)userInterfaceSetup {
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    [self addSubview:textLabel];
    _textLabel = textLabel;
    
    UILabel *detailTextLabel = [[UILabel alloc] init];
    detailTextLabel.numberOfLines = 0;
    [self addSubview:detailTextLabel];
    _detailTextLabel = detailTextLabel;
}

#pragma mark # Method

- (CGSize)sizeThatFits:(CGSize)size {
    if (_maximumSizeOffset.horizontal > 0) size.width -= _maximumSizeOffset.horizontal * 2;
    if (_maximumSizeOffset.vertical > 0) size.height -= _maximumSizeOffset.vertical * 2;
    CGFloat maxWidth = size.width - _contentInsets.left - _contentInsets.right;
    CGFloat maxHeight = size.height - _contentInsets.top - _contentInsets.bottom;
    CGFloat width = 0, height = 0;
    
    if (self.hasCustom) {
        _customSize = [_customView sizeThatFits:CGSizeMake(maxWidth, maxHeight)];
        if (CGSizeEqualToSize(_customSize, CGSizeZero)) {
            _customSize = _customView.bounds.size;
        }
        if (!CGSizeEqualToSize(_customSize, CGSizeZero)) {
            width = MIN(maxWidth, _customSize.width);
            height = _customSize.height + (self.hasText || self.hasDetailText ? _customBottomMargin : 0);
        }
    }
    
    if (self.hasText) {
        _textSize = [_textLabel sizeThatFits:CGSizeMake(maxWidth, maxHeight)];
        width = MIN(maxWidth, MAX(width, _textSize.width));
        height += _textSize.height + (self.hasDetailText ? _textBottomMargin : 0);
    }
    
    if (self.hasDetailText) {
        _detailTextSize = [_detailTextLabel sizeThatFits:CGSizeMake(maxWidth, maxHeight)];
        width = MIN(maxWidth, MAX(width, _detailTextSize.width));
        height += _detailTextSize.height;
    }
    
    width += _contentInsets.left + _contentInsets.right;
    height += _contentInsets.top + _contentInsets.bottom;

    if (_adjustsWidthAutomatically && width < height) {
        width = MIN(height, maxWidth);
    }
    
    return CGSizeMake(width, height);
}

- (void)calculateLayouts {
    CGFloat x = 0, y = _contentInsets.top;

    if (self.hasCustom && !CGSizeEqualToSize(_customSize, CGSizeZero)) {
        x = (self.bounds.size.width - _customSize.width) / 2;
        _customView.frame = (CGRect){x, y, _customSize};
        y += _customSize.height + (self.hasText || self.hasDetailText ? _customBottomMargin : 0);
    }

    if (self.hasText) {
        x = (self.bounds.size.width - _textSize.width) / 2;
        _textLabel.frame = (CGRect){x, y, _textSize};
        y += _textSize.height + (self.hasDetailText ? _textBottomMargin : 0);
    }

    if (self.hasDetailText) {
        x = (self.bounds.size.width - _detailTextSize.width) / 2;
        _detailTextLabel.frame = (CGRect){x, y, _detailTextSize};
    }
}

#pragma mark # Access

// Appearance
- (void)setCustomView:(UIView *)customView {
    if (_customView) {
        [_customView removeFromSuperview];
        _customView = nil;
    }
    
    _customView = customView;
    [self addSubview:customView];
    [self.toastView setNeedsLayout];
}

- (void)setText:(NSString *)text {
    _text = text;
    if (text) {
        _textLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:_textAttributes];
    }
    [self.toastView setNeedsLayout];
}

- (void)setDetailText:(NSString *)detailText {
    _detailText = detailText;
    if (detailText) {
        _detailTextLabel.attributedText = [[NSAttributedString alloc] initWithString:detailText attributes:_detailTextAttributes];
    }
    [self.toastView setNeedsLayout];
}

- (void)setMaximumSizeOffset:(UIOffset)maximumSizeOffset {
    _maximumSizeOffset = maximumSizeOffset;
    [self.toastView setNeedsLayout];
}

- (void)setAdjustsWidthAutomatically:(BOOL)adjustsWidthAutomatically {
    _adjustsWidthAutomatically = adjustsWidthAutomatically;
    [self.toastView setNeedsLayout];
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    [self.toastView setNeedsLayout];
}

- (void)setCustomBottomMargin:(CGFloat)customBottomMargin {
    _customBottomMargin = customBottomMargin;
    [self.toastView setNeedsLayout];
}

- (void)setTextBottomMargin:(CGFloat)textBottomMargin {
    _textBottomMargin = textBottomMargin;
    [self.toastView setNeedsLayout];
}

- (void)setTextAttributes:(NSDictionary *)textAttributes {
    _textAttributes = textAttributes;
    if (_text) self.text = _text;
    [self.toastView setNeedsLayout];
}

- (void)setDetailTextAttributes:(NSDictionary *)detailTextAttributes {
    _detailTextAttributes = detailTextAttributes;
    if (_detailText) self.detailText = _detailText;
    [self.toastView setNeedsLayout];
}

- (BOOL)hasCustom {
    return _customView != nil;
}

- (BOOL)hasText {
    return _text.length > 0;
}

- (BOOL)hasDetailText {
    return _detailText.length > 0;
}

@end


#pragma mark -

@interface XYToastDefaultContentView (XYAppearance)
@end

@implementation XYToastDefaultContentView (XYAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XYToastDefaultContentView *appearance = [XYToastDefaultContentView appearance];
        appearance.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        appearance.customBottomMargin = 15;
        appearance.textBottomMargin = 5;
        appearance.textAttributes = @{
            NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.95],
            NSFontAttributeName: [UIFont systemFontOfSize:18 weight:UIFontWeightRegular],
        };
        appearance.detailTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.9],
            NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightRegular]
        };
    });
}

@end

