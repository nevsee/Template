//
//  YYWebSearchBoard.m
//  Template
//
//  Created by nevsee on 2021/12/14.
//

#import "YYWebSearchBoard.h"

static CGFloat const kBoardHeight = 60;

@interface YYWebSearchBoard () <XYTextFieldDelegate>
@property (nonatomic, strong) XYTextField *textField;
@property (nonatomic, strong) XYButton *cancelButton;
@property (nonatomic, strong) XYButton *previousButton;
@property (nonatomic, strong) XYButton *nextButton;
@property (nonatomic, strong) XYLabel *numberLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) NSUInteger number;
@property (nonatomic, assign) NSUInteger index;
@end

@implementation YYWebSearchBoard

- (void)didInitialize {
    [super didInitialize];
    self.xy_prompter.position = XYPromptPositionBottom;
    self.xy_prompter.animator.presentStyle = XYPromptAnimationStyleSlipBottom;
    self.xy_prompter.animator.dismissStyle = XYPromptAnimationStyleSlipBottom;
    self.xy_prompter.keyboardSpacing = 0;
    self.xy_prompter.definesSafeAreaAdaptation = NO;
    self.xy_prompter.definesDismissalTouch = NO;
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    self.view.backgroundColor = YYNeutral1Color;
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.cancelButton];
    [self.containerView addSubview:self.textField];
    [self.containerView addSubview:self.numberLabel];
    [self.view addSubview:self.previousButton];
    [self.view addSubview:self.nextButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_textField becomeFirstResponder];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat cancelTextWidth = [_cancelButton.titleLabel sizeThatFits:CGSizeMake(HUGE, HUGE)].width;
    CGFloat numberTextWidth = [_numberLabel sizeThatFits:CGSizeMake(HUGE, HUGE)].width;
    CGFloat previousWidth = _previousButton.imageView.image.size.width;
    CGFloat nextWidth = _nextButton.imageView.image.size.width;
    _cancelButton.frame = CGRectMake(YYSafeArea.left, 0, cancelTextWidth + 15, kBoardHeight);
    _nextButton.frame = CGRectMake(self.view.xy_width - YYSafeArea.right - nextWidth - 15, 0, nextWidth, kBoardHeight);
    _previousButton.frame = CGRectMake(_nextButton.xy_left - previousWidth - 20, 0, previousWidth, kBoardHeight);
    _containerView.frame = CGRectMake(_cancelButton.xy_right + 15, 10, _previousButton.xy_left - _cancelButton.xy_right - 30, kBoardHeight - 20);
    _numberLabel.frame = CGRectMake(_containerView.xy_width - numberTextWidth - 10, 0, numberTextWidth, _containerView.xy_height);
    _textField.frame = CGRectMake(0, 0, _numberLabel.xy_left - 5, _containerView.xy_height);
}

#pragma mark # Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *keyword = [textField.text xy_stringByTrimmingAll];
    if (keyword.length == 0) return YES;
    if (_findBlock) _findBlock(keyword, self);
    return YES;
}

#pragma mark # Action

- (void)cancelAction {
    _textField.text = nil;
    if (_clearBlock) _clearBlock(self);
    [self dismiss];
}

- (void)findAction:(XYButton *)sender {
    BOOL next = sender.tag == 2;
    if (_findNextBlock) _findNextBlock(next, self);
}

#pragma mark # Method

- (void)preferredBoardContentSize {
    self.xy_portraitContentSize = CGSizeMake(YYDeviceWidth, YYSafeArea.bottom + kBoardHeight);
    self.xy_landscapeContentSize = CGSizeMake(YYDeviceHeight, YYSafeArea.bottom + kBoardHeight);
}

- (void)updateSearchNumber:(NSInteger)number index:(NSInteger)index {
    if (number == _number && index == _index) return;
    if (number >= 0) _number = number;
    if (index >= 0) _index = index;
    if (_number == 0) _index = 0;
    _previousButton.enabled = _number > 1;
    _nextButton.enabled = _number > 1;
    _numberLabel.text = [NSString stringWithFormat:@"%@/%@", @(_index), @(_number)];
    [self.view setNeedsLayout];
}

#pragma mark # Access

- (XYButton *)cancelButton {
    if (!_cancelButton) {
        XYButton *cancelButton = [XYButton buttonWithType:UIButtonTypeCustom];
        cancelButton.titleLabel.font = XYFontMake(16);
        cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [cancelButton setTitle:@"完成" forState:UIControlStateNormal];
        [cancelButton setTitleColor:YYNeutral9Color forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancelButton];
        _cancelButton = cancelButton;
    }
    return _cancelButton;
}

- (XYTextField *)textField {
    if (!_textField) {
        XYTextField *textField = [[XYTextField alloc] init];
        textField.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        textField.font = XYFontMake(16);
        textField.textColor = YYNeutral8Color;
        textField.returnKeyType = UIReturnKeySearch;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.enablesReturnKeyAutomatically = YES;
        textField.layer.cornerRadius = 3;
        textField.delegate = self;
        [self.view addSubview:textField];
        _textField = textField;
    }
    return _textField;
}

- (XYButton *)previousButton {
    if (!_previousButton) {
        XYButton *previousButton = [XYButton buttonWithType:UIButtonTypeCustom];
        previousButton.tag = 1;
        previousButton.enabled = NO;
        [previousButton setImage:XYImageMake(@"web_search_previous") forState:UIControlStateNormal];
        [previousButton addTarget:self action:@selector(findAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:previousButton];
        _previousButton = previousButton;
    }
    return _previousButton;
}

- (XYButton *)nextButton {
    if (!_nextButton) {
        XYButton *nextButton = [XYButton buttonWithType:UIButtonTypeCustom];
        nextButton.tag = 2;
        nextButton.enabled = NO;
        [nextButton setImage:XYImageMake(@"web_search_next") forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(findAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nextButton];
        _nextButton = nextButton;
    }
    return _nextButton;
}

- (XYLabel *)numberLabel {
    if (!_numberLabel) {
        XYLabel *numberLabel = [[XYLabel alloc] init];
        numberLabel.font = XYFontMake(14);
        numberLabel.textColor = YYNeutral5Color;
        numberLabel.textAlignment = NSTextAlignmentRight;
        numberLabel.text = @"0/0";
        _numberLabel = numberLabel;
    }
    return _numberLabel;
}

- (UIView *)containerView {
    if (!_containerView) {
        UIView *view = [[UIView alloc] init];
        view.layer.cornerRadius = 3;
        view.layer.masksToBounds = YES;
        view.backgroundColor = YYNeutral2Color;
        _containerView = view;
    }
    return _containerView;
}

@end
