//
//  YYTestButtonController.m
//  Template
//
//  Created by nevsee on 2022/11/30.
//

#import "YYTestButtonController.h"
#import "YYLottieIndicatorView.h"

@interface YYTestButtonController ()

@end

@implementation YYTestButtonController

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"XYButton";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    // 高亮按钮
    XYButton *button1 = [XYButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = YYTheme1Color;
    button1.highlightedBackgroundColor = YYTheme3Color;
    button1.titleLabel.font = XYFontMake(15);
    [button1 xy_addContinuousCornerRadius:4];
    [button1 setTitle:@"高亮背景按钮" forState:UIControlStateNormal];
    [self.view addSubview:button1];
    
    XYButton *button2 = [XYButton buttonWithType:UIButtonTypeCustom];
    button2.layer.borderColor = YYNeutral9Color.CGColor;
    button2.layer.borderWidth = YYOnePixel;
    button2.highlightedBorderColor = YYWarning2Color;
    button2.titleLabel.font = XYFontMake(15);
    [button2 xy_addContinuousCornerRadius:4];
    [button2 setTitleColor:YYNeutral9Color forState:UIControlStateNormal];
    [button2 setTitleColor:YYWarning2Color forState:UIControlStateHighlighted];
    [button2 setTitle:@"高亮边框按钮" forState:UIControlStateNormal];
    [self.view addSubview:button2];
    
    // 加载按钮
    XYLoadingButtonIndicatorView *indicator1 = [[XYLoadingButtonIndicatorView alloc] init];
    XYLoadingButton *loadingButton1 = [XYLoadingButton buttonWithType:UIButtonTypeCustom animator:indicator1];
    loadingButton1.backgroundColor = YYTheme1Color;
    loadingButton1.titleLabel.font = XYFontMake(15);
    [loadingButton1 xy_addContinuousCornerRadius:4];
    [loadingButton1 setTitle:@"加载按钮" forState:UIControlStateNormal];
    [loadingButton1 addTarget:self action:@selector(loadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadingButton1];
    
    YYLottieIndicatorView *indicator2 = [[YYLottieIndicatorView alloc] init];
    XYLoadingButton *loadingButton2 = [XYLoadingButton buttonWithType:UIButtonTypeCustom animator:indicator2];
    loadingButton2.backgroundColor = YYTheme1Color;
    loadingButton2.titleLabel.font = XYFontMake(15);
    [loadingButton2 xy_addContinuousCornerRadius:4];
    [loadingButton2 setTitle:@"自定义动画" forState:UIControlStateNormal];
    [loadingButton2 addTarget:self action:@selector(loadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadingButton2];
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(30);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(160, 45));
    }];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button1.mas_bottom).offset(30);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(160, 45));
    }];
    
    [loadingButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button2.mas_bottom).offset(30);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(160, 45));
    }];
    
    [loadingButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loadingButton1.mas_bottom).offset(30);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(160, 45));
    }];
}

- (void)loadAction:(XYLoadingButton *)sender {
    [sender startAnimation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender stopAnimation];
        [self.view showSuccessWithText:@"加载成功"];
    });
}

@end
