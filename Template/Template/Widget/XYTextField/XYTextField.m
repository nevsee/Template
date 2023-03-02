//
//  XYTextField.m
//  XYWidget
//
//  Created by nevsee on 2018/7/24.
//

#import "XYTextField.h"

@implementation XYTextField
@dynamic delegate;

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

- (void)initialization {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeNotice:) name:UITextFieldTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditingNotice:) name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditingNotice:) name:UITextFieldTextDidEndEditingNotification object:self];
}

// Action

- (void)textFieldDidChangeNotice:(NSNotification *)notice {
    if (![notice.object isEqual:self]) return;
    if ([self.delegate respondsToSelector:@selector(textFieldDidChange:)]) {
        [self.delegate textFieldDidChange:self];
    }
}

- (void)textFieldDidBeginEditingNotice:(NSNotification *)notice {
    if (![notice.object isEqual:self]) return;
    if (self.text.length > 0) return;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)textFieldDidEndEditingNotice:(NSNotification *)notice {
    if (![notice.object isEqual:self]) return;
    if (self.text.length > 0) return;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:nil];
}

// Override

- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds = UIEdgeInsetsInsetRect(bounds, _textInsets);
    return [super textRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    bounds = UIEdgeInsetsInsetRect(bounds, _textInsets);
    return [super editingRectForBounds:bounds];
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect rect = [super clearButtonRectForBounds:bounds];
    return CGRectOffset(rect, _clearButtonPositionAdjustment.horizontal, _clearButtonPositionAdjustment.vertical);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect rect = [super placeholderRectForBounds:bounds];
    CGSize placeholderSize = [self placeholderSizeThatFits:rect.size];
    CGFloat placeholderX = 0;

    XYTextFieldAlignment alignment = self.editing ? _placeholderAlignmentWhileEditing : _placeholderAlignmentUnlessEditing;
    switch (alignment) {
        case XYTextFieldAlignmentLeft:
            placeholderX = rect.origin.x + 1; // add cursor width
            break;
        case XYTextFieldAlignmentCenter:
            placeholderX = rect.origin.x + (rect.size.width - placeholderSize.width) / 2;
            break;
        case XYTextFieldAlignmentRight:
            placeholderX = rect.origin.x + (rect.size.width - placeholderSize.width);
            break;
    }
    return CGRectMake(placeholderX, rect.origin.y, placeholderSize.width, placeholderSize.height);
}

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

// Private

- (CGSize)placeholderSizeThatFits:(CGSize)size {
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    return [self.attributedPlaceholder boundingRectWithSize:size options:options context:nil].size;
}

- (void)updatePlaceholderAttributesIfNeeded {
    if (!self.attributedPlaceholder) return;
    if (!_placeholderColor && !_placeholderFont) return;
    
    NSRange range = NSMakeRange(0, self.placeholder.length);
    NSMutableAttributedString *result = self.attributedPlaceholder.mutableCopy;
    if (_placeholderColor) {
        [result addAttribute:NSForegroundColorAttributeName value:_placeholderColor range:range];
    }
    if (_placeholderFont) {
        [result addAttribute:NSFontAttributeName value:_placeholderFont range:range];
    }
    
    self.attributedPlaceholder = result;
}

// Access

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self updatePlaceholderAttributesIfNeeded];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    [self updatePlaceholderAttributesIfNeeded];
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    [self updatePlaceholderAttributesIfNeeded];
}

- (void)setText:(NSString *)text {
    NSString *textBeforeChange = self.text;
    [super setText:text];
    
    if (_shouldTriggerEventWhenTextChange && ![textBeforeChange isEqualToString:text]) {
        [self sendActionsForControlEvents:UIControlEventEditingChanged];
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    NSAttributedString *textBeforeChange = self.attributedText;
    [super setAttributedText:attributedText];
    
    if (_shouldTriggerEventWhenTextChange && ![textBeforeChange isEqualToAttributedString:attributedText]) {
        [self sendActionsForControlEvents:UIControlEventEditingChanged];
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self];
    }
}

@end
