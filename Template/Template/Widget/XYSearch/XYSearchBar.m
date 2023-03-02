//
//  XYSearchBar.m
//  XYWidget
//
//  Created by nevsee on 2020/11/12.
//

#import "XYSearchBar.h"

@implementation XYSearchBar

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _forbidsInput = NO;
        _adjustsSafeArea = YES;
        _animatesWhenEditing = YES;
        _executesAnimation = YES;
        _cancelButtonMode = XYSearchBarModeAlways;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:gesture];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChangeNotice:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
        
        XYSearchBackgroundView *backgroundView = [[XYSearchBackgroundView alloc] init];
        backgroundView.backgroundColor = UIColor.whiteColor;
        [self addSubview:backgroundView];
        _backgroundView = backgroundView;
        
        XYSearchTextField *textField = [[XYSearchTextField alloc] init];
        textField.returnKeyType = UIReturnKeySearch;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.enablesReturnKeyAutomatically = YES;
        textField.centersPlaceholder = YES;
        textField.delegate = self;
        textField.placeholder = @"搜索";
        [self addSubview:textField];
        _textField = textField;
        
        XYSearchButton *cancelButton = [XYSearchButton buttonWithType:UIButtonTypeSystem];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        _cancelButton = cancelButton;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if ([self respondsToSelector:@selector(safeAreaInsets)] && _adjustsSafeArea) {
        safeAreaInsets = self.safeAreaInsets;
    }
    
    CGFloat contentWidth = self.bounds.size.width;
    CGFloat contentHeight = self.bounds.size.height - safeAreaInsets.top - safeAreaInsets.bottom;
    
    _backgroundView.frame = self.bounds;
    
    CGSize cancelSize = [_cancelButton.titleLabel sizeThatFits:self.bounds.size];
    CGFloat cancelWidth = cancelSize.width + _cancelButtonInsets.left + _cancelButtonInsets.right;
    CGFloat cancelX = self.isCancelButtonVisible ? contentWidth - cancelWidth - safeAreaInsets.right : contentWidth;
    CGFloat cancelY = safeAreaInsets.top;
    _cancelButton.frame = CGRectMake(cancelX, cancelY, cancelWidth, contentHeight);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    _cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, _cancelButtonInsets.right - _cancelButtonInsets.left);
#pragma clang diagnostic pop
    
    CGFloat textX = _textFieldInsets.left + safeAreaInsets.left;
    CGFloat textY = _textFieldInsets.top + safeAreaInsets.top;
    CGFloat textWidth = self.isCancelButtonVisible ? cancelX - textX : contentWidth - textX - _textFieldInsets.right - safeAreaInsets.right;
    CGFloat textHeight = contentHeight - _textFieldInsets.top - _textFieldInsets.bottom;
    _textField.frame = CGRectMake(textX, textY, textWidth, textHeight);
}

// Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        return [_delegate searchBarShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        return [_delegate searchBarShouldEndEditing:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(searchBarDidBeginEditing:)]) {
        [_delegate searchBarDidBeginEditing:self];
    }
    [self layoutAnimated:_animatesWhenEditing && _executesAnimation];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(searchBarDidEndEditing:)]) {
        [_delegate searchBarDidEndEditing:self];
    }
    [self layoutAnimated:_animatesWhenEditing && _executesAnimation];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)]) {
        [_delegate searchBarSearchButtonClicked:self];
    }
    return YES;
}

// Action
- (void)cancelAction {
    if ([_delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
        [_delegate searchBarCancelButtonClicked:self];
    }
    [self resignFirstResponder];
}

- (void)tapAction {
    if (!_forbidsInput) return;
    if ([_delegate respondsToSelector:@selector(searchBarDidClickedOnBackground:)]) {
        [_delegate searchBarDidClickedOnBackground:self];
    }
}

- (void)textFieldDidChangeNotice:(NSNotification *)notice {
    if (![_textField isEqual:notice.object]) return;
    if ([_delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [_delegate searchBar:self textDidChange:_textField.text];
    }
}

// Method
- (void)layoutAnimated:(BOOL)animated {
    if (animated) {
        if (_textField.text.length > 0) { // fix iOS 13 bug
            [_textField layoutIfNeeded];
        }
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:nil];
    } else {
        [self setNeedsLayout];
    }
    _executesAnimation = YES;
}

- (BOOL)becomeFirstResponder {
    return [_textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [_textField resignFirstResponder];
}

// Access
- (BOOL)isEditing {
    return _textField.isEditing;
}

- (BOOL)isCancelButtonVisible {
    if (_cancelButtonMode == XYSearchBarModeNever) return NO;
    else if (_cancelButtonMode == XYSearchBarModeAlways) return YES;
    else return _textField.isEditing;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:UIColor.clearColor];
}

- (void)setTextFieldBackgroundColor:(UIColor *)textFieldBackgroundColor {
    _textFieldBackgroundColor = textFieldBackgroundColor;
    _textField.backgroundColor = textFieldBackgroundColor;
}

- (void)setTextFieldCornerRadius:(CGFloat)textFieldCornerRadius {
    _textFieldCornerRadius = textFieldCornerRadius;
    _textField.layer.cornerRadius = textFieldCornerRadius;
}

- (void)setTextFieldInsets:(UIEdgeInsets)textFieldInsets {
    _textFieldInsets = textFieldInsets;
    [self setNeedsLayout];
}

- (void)setCancelButtonInsets:(UIEdgeInsets)cancelButtonInsets {
    _cancelButtonInsets = cancelButtonInsets;
    [self setNeedsLayout];
}

- (void)setCancelButtonMode:(XYSearchBarMode)cancelButtonMode {
    _cancelButtonMode = cancelButtonMode;
    [self setNeedsLayout];
}

- (void)setSearchIcon:(UIImage *)searchIcon {
    _searchIcon = searchIcon;
    if (searchIcon) {
        UIImageView *view = [[UIImageView alloc] initWithImage:searchIcon];
        _textField.leftView = view;
    } else {
        _textField.leftView = nil;
    }
}

@end

@interface XYSearchBackgroundView ()
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@end

@implementation XYSearchBackgroundView

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat onePixel = 1 / [UIScreen mainScreen].scale;
    _seperatorView.frame = CGRectMake(0, self.frame.size.height - onePixel, self.frame.size.width, onePixel);
    _effectView.frame = self.bounds;
}

// Method
- (void)transformBackgroundColor {
    if (_effectView) {
        if (CGColorGetAlpha(_styleColor.CGColor) > 0.83) {
            _styleColor = [_styleColor colorWithAlphaComponent:0.83];
        }
        _effectView.contentView.backgroundColor = _styleColor;
        self.backgroundColor = UIColor.clearColor;
    } else {
        self.backgroundColor = _styleColor;
    }
}

// Access
- (void)setBlurEffect:(UIBlurEffect *)blurEffect {
    _blurEffect = blurEffect;
    
    if (blurEffect) {
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        if (_seperatorView) {
            [self insertSubview:effectView belowSubview:_seperatorView];
        } else {
            [self addSubview:effectView];
        }
        _effectView = effectView;
        [self transformBackgroundColor];
    } else {
        [_effectView removeFromSuperview];
        _effectView = nil;
    }
}

- (void)setSeperatorColor:(UIColor *)seperatorColor {
    _seperatorColor = seperatorColor;
    
    if (seperatorColor) {
        UIView *seperatorView = [[UIView alloc] init];
        seperatorView.backgroundColor = seperatorColor;
        if (_effectView) {
            [self insertSubview:seperatorView aboveSubview:_effectView];
        } else {
            [self addSubview:seperatorView];
        }
        _seperatorView = seperatorView;
    } else {
        [_seperatorView removeFromSuperview];
        _seperatorView = nil;
    }
}

- (void)setStyleColor:(UIColor *)styleColor {
    _styleColor = styleColor;
    [self transformBackgroundColor];
}

@end

@implementation XYSearchTextField

// Method
- (CGFloat)placeholderWidthForBounds:(CGRect)bounds {
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    return ceilf([self.attributedPlaceholder boundingRectWithSize:bounds.size options:options context:nil].size.width);
}

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

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    if (self.isEditing || self.text.length > 0 || !_centersPlaceholder) {
        CGRect rect = [super leftViewRectForBounds:bounds];
        return CGRectOffset(rect, _leftViewPositionAdjustment.horizontal, _leftViewPositionAdjustment.vertical);
    } else {
        CGRect rect = [super leftViewRectForBounds:bounds];
        CGFloat placeholderWidth = [self placeholderWidthForBounds:bounds];
        CGFloat textInsetsLeft = placeholderWidth > 0 ? _textInsets.left : 0;
        CGFloat x = (self.bounds.size.width - rect.size.width - textInsetsLeft - placeholderWidth) / 2;
        CGFloat y = rect.origin.y + _leftViewPositionAdjustment.vertical;
        return CGRectMake(x, y, rect.size.width, rect.size.height);
    }
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    if (self.isEditing || self.text.length > 0 || !_centersPlaceholder || self.leftView.superview) {
        return [super placeholderRectForBounds:bounds];
    } else {
        CGRect rect = [super placeholderRectForBounds:bounds];
        CGFloat width = [self placeholderWidthForBounds:bounds];
        CGFloat x = (self.bounds.size.width - width) / 2;
        return CGRectMake(x, rect.origin.y, width, rect.size.height);
    }
}

// Access
- (void)setTextInsets:(UIEdgeInsets)textInsets {
    _textInsets = textInsets;
    [self setNeedsLayout];
}

- (void)setClearButtonPositionAdjustment:(UIOffset)clearButtonPositionAdjustment {
    _clearButtonPositionAdjustment = clearButtonPositionAdjustment;
    [self setNeedsLayout];
}

- (void)setLeftViewPositionAdjustment:(UIOffset)leftViewPositionAdjustment {
    _leftViewPositionAdjustment = leftViewPositionAdjustment;
    [self setNeedsLayout];
}

- (void)setSearchTextFont:(UIFont *)searchTextFont {
    _searchTextFont = searchTextFont;
    self.font = searchTextFont;
}

- (void)setSearchTextColor:(UIColor *)searchTextColor {
    _searchTextColor = searchTextColor;
    self.textColor = searchTextColor;
}

- (void)setSearchPlaceholderColor:(UIColor *)searchPlaceholderColor {
    _searchPlaceholderColor = searchPlaceholderColor;
    NSMutableAttributedString *placeholder = self.attributedPlaceholder.mutableCopy;
    [placeholder addAttribute:NSForegroundColorAttributeName value:searchPlaceholderColor range:NSMakeRange(0, placeholder.length)];
    self.attributedPlaceholder = placeholder;
}

- (void)setSearchTintColor:(UIColor *)searchTintColor {
    _searchTintColor = searchTintColor;
    self.tintColor = searchTintColor;
}

- (void)setCentersPlaceholder:(BOOL)centersPlaceholder {
    _centersPlaceholder = centersPlaceholder;
    [self setNeedsLayout];
}

@end

@implementation XYSearchButton

- (void)setTitleNormalColor:(UIColor *)titleNormalColor {
    _titleNormalColor = titleNormalColor;
    [self setTitleColor:titleNormalColor forState:UIControlStateNormal];
}

- (void)setTitleHighlightedColor:(UIColor *)titleHighlightedColor {
    _titleHighlightedColor = titleHighlightedColor;
    [self setTitleColor:titleHighlightedColor forState:UIControlStateHighlighted];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

@end

@interface XYSearchBar (XYAppearance)

@end

@implementation XYSearchBar (XYAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XYSearchBar *bar = [XYSearchBar appearance];
        bar.textFieldCornerRadius = 5;
        bar.textFieldBackgroundColor = [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1];
        bar.textFieldInsets = UIEdgeInsetsMake(6, 16, 6, 16);
        bar.cancelButtonInsets = UIEdgeInsetsMake(0, 16, 0, 16);
        
        XYSearchBackgroundView *backgroundView = [XYSearchBackgroundView appearance];
        backgroundView.styleColor = [UIColor whiteColor];
        
        XYSearchTextField *textField = [XYSearchTextField appearance];
        textField.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        textField.leftViewPositionAdjustment = UIOffsetMake(10, 0);
        textField.searchTextFont = [UIFont systemFontOfSize:16];
        textField.searchTextColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
        textField.searchPlaceholderColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1];
        
        XYSearchButton *cancelButton = [XYSearchButton appearance];
        cancelButton.titleFont = [UIFont systemFontOfSize:16];
        cancelButton.titleNormalColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
    });
}

@end
