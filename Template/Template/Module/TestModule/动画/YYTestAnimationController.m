//
//  YYTestAnimationController.m
//  Template
//
//  Created by nevsee on 2022/11/30.
//

#import "YYTestAnimationController.h"
#import "XYRippleAnimationView.h"

@interface YYTestAnimationController ()

@end

@implementation YYTestAnimationController

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"XYAnimationView";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    XYRippleAnimationView *rippleView = [[XYRippleAnimationView alloc] init];
    rippleView.rippleColor = YYTheme1Color;
    rippleView.rippleWidth = 2;
    [rippleView beginAnimation];
    [self.view addSubview:rippleView];
    
    UIView *portraitView = [[UIView alloc] init];
    portraitView.backgroundColor = YYTheme1Color;
    [portraitView xy_addContinuousCornerRadius:20];
    [self.view addSubview:portraitView];
    
    [rippleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(30);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(rippleView.mas_centerX);
        make.centerY.mas_equalTo(rippleView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

@end
