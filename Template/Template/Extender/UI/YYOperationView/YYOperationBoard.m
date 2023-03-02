//
//  YYOperationBoard.m
//  Template
//
//  Created by nevsee on 2021/11/29.
//

#import "YYOperationBoard.h"

@interface YYOperationBoard ()
@property (nonatomic, strong, readwrite) YYOperationView *operationView;
@property (nonatomic, strong) XYButton *cancelButton;
@property (nonatomic, strong) UIVisualEffectView *backgroundView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation YYOperationBoard

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didInitialize {
    [super didInitialize];
    self.xy_prompter.position = XYPromptPositionBottom;
    self.xy_prompter.animator.presentStyle = XYPromptAnimationStyleSlipBottom;
    self.xy_prompter.animator.dismissStyle = XYPromptAnimationStyleSlipBottom;
    self.xy_prompter.definesSafeAreaAdaptation = NO;
    _cancelButtonTopMargin = self.operationView.configuration.contentInsets.bottom;
}

- (void)parameterSetup {
    [super parameterSetup];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSizeDidChangeNotice:) name:XYPrompterContentSizeChangeNotification object:nil];
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    if (@available(iOS 13.0, *)) {
        [self.view xy_addCornerRadius:14 maskCorner:kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner curve:kCACornerCurveContinuous];
    } else {
        [self.view xy_addCornerRadius:14 maskCorner:kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner];
    }
    self.view.clipsToBounds = YES;

    [self.view addSubview:self.backgroundView];
    [self.backgroundView.contentView addSubview:self.operationView];
    [self.backgroundView.contentView addSubview:self.cancelButton];
    [self.backgroundView.contentView addSubview:self.lineView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _backgroundView.frame = self.view.bounds;
    _operationView.frame = XYRectSetWidth(_operationView.bounds, self.view.xy_width);
    _cancelButton.frame = CGRectMake(0, self.view.xy_height - _cancelButton.xy_height - YYSafeArea.bottom, self.view.xy_width, _cancelButton.xy_height);
    _lineView.frame = CGRectMake(0, XYFloatFlat(_cancelButton.xy_top), self.view.xy_width, YYOnePixel);
}

#pragma mark # Action

- (void)cancelAction {
    [self dismiss];
}

// 内容大小改变通知
- (void)contentSizeDidChangeNotice:(NSNotification *)sender {
    if (![sender.object isEqual:self]) return;
    NSTimeInterval duration = [sender.userInfo[XYPrompterAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [sender.userInfo[XYPrompterAnimationOptionUserInfoKey] integerValue];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self viewWillLayoutSubviews];
    } completion:nil];
}

#pragma mark # Method

- (void)preferredBoardContentSize {
    // 操作视图内容最大高度横竖屏适配
    CGFloat interval = [UIApplication sharedApplication].xy_isInterfaceLandscape ? 80 : 150;
    self.operationView.configuration.maximumHeight = YYScreenHeight - YYSafeArea.bottom - self.cancelButton.xy_height - interval;
    
    // 操作视图内容高度
    CGFloat operationHeight = self.operationView.xy_height;
    CGFloat cancelHeight = self.cancelButton.xy_height;
    CGSize contentSize = CGSizeMake(YYDeviceWidth, operationHeight + cancelHeight + YYSafeArea.bottom);
    self.xy_portraitContentSize = contentSize;
    self.xy_landscapeContentSize = contentSize;
}

#pragma mark # Access

- (YYOperationView *)operationView {
    if (!_operationView) {
        YYOperationView *view = [[YYOperationView alloc] init];
        @weakify(self)
        view.didChangeBlock = ^(YYOperationView *operationView, CGFloat height) {
            @strongify(self)
            [self preferredBoardContentSize];
        };
        view.didSelectItemBlock = ^(YYOperationView *operationView, YYOperationItem *item) {
            @strongify(self)
            [self dismiss];
        };
        _operationView = view;
    }
    return _operationView;
}

- (XYButton *)cancelButton {
    if (!_cancelButton) {
        XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = XYFontBoldMake(14);
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:YYNeutral9Color forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        CGSize size = [button.titleLabel sizeThatFits:CGSizeMake(HUGE, HUGE)];
        button.xy_size = XYSizeFlatMake(size.width, size.height + _cancelButtonTopMargin * 2);
        _cancelButton = button;
    }
    return _cancelButton;
}

- (UIVisualEffectView *)backgroundView {
    if (!_backgroundView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        view.contentView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.8];
        _backgroundView = view;
    }
    return _backgroundView;
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
