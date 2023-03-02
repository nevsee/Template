//
//  XYLabel.m
//  XYWidget
//
//  Created by nevsee on 2018/3/11.
//

#import "XYLabel.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface XYLabel ()
@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;
@property (nonatomic, strong) UIColor *originalBackgroundColor;
@property (nonatomic, assign) BOOL highlightedFlag;
@end

@implementation XYLabel

#pragma mark # Text Inset

- (void)setTextInsets:(UIEdgeInsets)textInsets {
    _textInsets = textInsets;
    [self setNeedsDisplay];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat horizontalInterval = _textInsets.left + _textInsets.right;
    CGFloat verticalInterval = _textInsets.top + _textInsets.bottom;
    
    size = [super sizeThatFits:CGSizeMake(size.width - horizontalInterval, size.height - verticalInterval)];
    return CGSizeMake(size.width + horizontalInterval, size.height + verticalInterval);
}

- (CGSize)intrinsicContentSize {
    CGFloat preferredMaxLayoutWidth = self.preferredMaxLayoutWidth;
    if (preferredMaxLayoutWidth <= 0) {
        preferredMaxLayoutWidth = CGFLOAT_MAX;
    }
    return [self sizeThatFits:CGSizeMake(preferredMaxLayoutWidth, CGFLOAT_MAX)];
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

#pragma mark # Highlighted Color

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (_highlightedBackgroundColor) {
        _highlightedFlag = YES;
        [super setBackgroundColor:highlighted ? _highlightedBackgroundColor : _originalBackgroundColor];
        _highlightedFlag = NO;
    }
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    _highlightedBackgroundColor = highlightedBackgroundColor;
    [self setHighlighted:self.highlighted];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (!_highlightedFlag) {
        _originalBackgroundColor = backgroundColor;
    }
    
    if (self.highlighted && !_highlightedFlag) return;
    
    [super setBackgroundColor:backgroundColor];
}

- (UIColor *)backgroundColor {
    return _originalBackgroundColor;
}

#pragma mark # Copy

- (void)setCanPerformCopyAction:(BOOL)canPerformCopyAction {
    _canPerformCopyAction = canPerformCopyAction;
    
    if (canPerformCopyAction && !_longGesture) {
        self.userInteractionEnabled = YES;
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:_longGesture];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillHideNotice:) name:UIMenuControllerWillHideMenuNotification object:nil];
    } else if (!canPerformCopyAction && _longGesture) {
        self.userInteractionEnabled = NO;
        [self removeGestureRecognizer:_longGesture];
        _longGesture = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
    if (!_canPerformCopyAction) return;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        NSString *title = _menuCopyItemTitle ?: @"复制";
        UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:title action:@selector(copyString:)];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        menuController.menuItems = @[copyMenuItem];
        if (@available(iOS 13.0, *)) {
            [menuController showMenuFromView:self rect:self.bounds];
        } else {
            [menuController setTargetRect:self.frame inView:self.superview];
            [menuController setMenuVisible:YES animated:YES];
        }
        [self setHighlighted:YES];
    } else if (sender.state == UIGestureRecognizerStatePossible) {
        [self setHighlighted:NO];
    }
}

- (void)menuWillHideNotice:(NSNotification *)notice {
    if (!_canPerformCopyAction) return;
    [self setHighlighted:NO];
}

- (void)copyString:(id)sender {
    if (!_canPerformCopyAction) return;
    if (!self.text) return;
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.text;
    if (_copyBlock) {
        _copyBlock(self, self.text);
    }
}

- (BOOL)canBecomeFirstResponder {
    return _canPerformCopyAction;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if ([self canBecomeFirstResponder]) {
        return action == @selector(copyString:);
    }
    return NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

#pragma clang diagnostic pop
