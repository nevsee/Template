//
//  XYTextView.m
//  XYWidget
//
//  Created by nevsee on 2018/2/15.
//

#import "XYTextView.h"

static CGFloat const kXYTextViewDefaultPlaceholderFontSize = 12; // Same to system default font size

@interface XYTextView ()
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, assign, readonly) UIEdgeInsets placeholderInset;
@end

@implementation XYTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat top = self.placeholderInset.top + _placeholderOffset.vertical;
    CGFloat bottom = self.placeholderInset.bottom;
    CGFloat left = self.placeholderInset.left + _placeholderOffset.horizontal;
    CGFloat right = self.placeholderInset.right;
    
    CGFloat limitWidth = self.bounds.size.width - left - right;
    CGFloat limitHeight = self.bounds.size.height - top - bottom;
    CGSize size = [_placeholderLabel sizeThatFits:CGSizeMake(limitWidth, limitHeight)];
    
    _placeholderLabel.frame = CGRectMake(left, top, limitWidth, fmin(size.height, limitHeight));
}

- (void)initialization {
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.font = [UIFont systemFontOfSize:kXYTextViewDefaultPlaceholderFontSize];
    placeholderLabel.textColor = _placeholderColor;
    placeholderLabel.numberOfLines = 0;
    [self addSubview:placeholderLabel];
    _placeholderLabel = placeholderLabel;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeNotice:) name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark # Notification

- (void)textViewDidChangeNotice:(NSNotification *)notice {
    if (![notice.object isEqual:self]) return;
    _placeholderLabel.alpha = (self.text.length == 0 || _placeholder.length == 0);
}

// Override

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    BOOL superReturnValue = [super canPerformAction:action withSender:sender];
    if (_canPerformActionBlock) {
        return _canPerformActionBlock(sender, action, superReturnValue);
    }
    if (action == @selector(paste:) && _canPerformPasteActionBlock) {
        return _canPerformPasteActionBlock(sender, superReturnValue);
    }
    return superReturnValue;
}

- (void)paste:(id)sender {
    BOOL shouldCallSuper = YES;
    if (_pasteBlock) {
        shouldCallSuper = _pasteBlock(sender);
    }
    if (shouldCallSuper) {
        [super paste:sender];
    }
}

//Private

- (void)updatePlaceholderLabelStyle {
    if (_placeholder) {
        _placeholderLabel.attributedText = [[NSAttributedString alloc] initWithString:_placeholder attributes:self.typingAttributes];
    }
    if (_placeholderColor) {
        _placeholderLabel.textColor = _placeholderColor;
    }
    if (_placeholderFont) {
        _placeholderLabel.font = _placeholderFont;
    }
    _placeholderLabel.alpha = (self.text.length == 0 || _placeholder.length == 0);
    
    [self setNeedsLayout];
}

// Access

- (void)setTypingAttributes:(NSDictionary<NSAttributedStringKey,id> *)typingAttributes {
    [super setTypingAttributes:typingAttributes];
    [self updatePlaceholderLabelStyle];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self updatePlaceholderLabelStyle];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self updatePlaceholderLabelStyle];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self updatePlaceholderLabelStyle];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    [super setTextContainerInset:textContainerInset];
    [self updatePlaceholderLabelStyle];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    [self updatePlaceholderLabelStyle];
}

- (void)setPlaceholderOffset:(UIOffset)placeholderOffset {
    _placeholderOffset = placeholderOffset;
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self updatePlaceholderLabelStyle];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    [self updatePlaceholderLabelStyle];
}

- (UIEdgeInsets)placeholderInset {
    UIEdgeInsets inset = self.textContainerInset;
    CGFloat padding = self.textContainer.lineFragmentPadding;
    return UIEdgeInsetsMake(inset.top, inset.left + padding, inset.bottom, inset.right + padding);
}

@end
