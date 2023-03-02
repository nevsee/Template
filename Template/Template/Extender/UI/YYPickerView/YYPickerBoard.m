//
//  YYPickerBoard.m
//  Template
//
//  Created by nevsee on 2022/1/5.
//

#import "YYPickerBoard.h"

@interface YYPickerBoard ()
@property (nonatomic, strong, readwrite) YYPickerView *pickerView;
@property (nonatomic, strong) XYButton *cancelButton;
@property (nonatomic, strong) XYButton *confirmButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIVisualEffectView *backgroundView;
@end

@implementation YYPickerBoard

- (void)didInitialize {
    [super didInitialize];
    self.xy_prompter.position = XYPromptPositionBottom;
    self.xy_prompter.animator.presentStyle = XYPromptAnimationStyleSlipBottom;
    self.xy_prompter.animator.dismissStyle = XYPromptAnimationStyleSlipBottom;
    self.xy_prompter.definesSafeAreaAdaptation = NO;
    
    _topBarHeight = 50;
    _totalHeight = 320;
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    [self.view xy_addContinuousCornerRadius:14 maskCorner:kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner];
    self.view.clipsToBounds = YES;
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.confirmButton];
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.lineView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat cancelWidth = MIN([_cancelButton.titleLabel sizeThatFits:CGSizeMake(HUGE, HUGE)].width, self.view.xy_width / 2);
    CGFloat confirmWidth = MIN([_confirmButton.titleLabel sizeThatFits:CGSizeMake(HUGE, HUGE)].width, self.view.xy_width / 2);
    
    _backgroundView.frame = self.view.bounds;
    _cancelButton.frame = CGRectMake(0, 0, cancelWidth + 40, _topBarHeight);
    _confirmButton.frame = CGRectMake(self.view.xy_width - confirmWidth - 40, 0, confirmWidth + 40, _topBarHeight);
    _pickerView.frame = CGRectMake(0, _topBarHeight + YYOnePixel, self.view.xy_width, _totalHeight - _topBarHeight - YYOnePixel);
    _lineView.frame = CGRectMake(0, _topBarHeight, self.view.xy_width, YYOnePixel);
}

#pragma mark # Action

- (void)cancelAction {
    [self dismiss];
    if (_cancelBlock) _cancelBlock();
}

- (void)confirmAction {
    [self dismiss];
    if (_confirmBlock) _confirmBlock(_pickerView.selectedValues, _pickerView.selectedNames);
}

#pragma mark # Method

- (void)preferredBoardContentSize {
    self.xy_portraitContentSize = CGSizeMake(YYDeviceWidth, _totalHeight);
    self.xy_landscapeContentSize = CGSizeMake(YYDeviceWidth, _totalHeight);
}

#pragma mark # Access

- (UIVisualEffectView *)backgroundView {
    if (!_backgroundView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        view.contentView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.8];
        _backgroundView = view;
    }
    return _backgroundView;
}

- (XYButton *)cancelButton {
    if (!_cancelButton) {
        XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = XYFontMake(17);
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:YYNeutral8Color forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = button;
    }
    return _cancelButton;
}

- (XYButton *)confirmButton {
    if (!_confirmButton) {
        XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = XYFontMake(17);
        [button setTitle:@"确认" forState:UIControlStateNormal];
        [button setTitleColor:YYTheme3Color forState:UIControlStateNormal];
        [button addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton = button;
    }
    return _confirmButton;
}

- (YYPickerView *)pickerView {
    if (!_pickerView) {
        YYPickerView *view = [[YYPickerView alloc] init];
        _pickerView = view;
    }
    return _pickerView;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = YYNeutral4Color;
        _lineView = view;
    }
    return _lineView;
}

@end
