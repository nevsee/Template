//
//  YYTestCodeController.m
//  Template
//
//  Created by nevsee on 2021/12/27.
//

#import "YYTestCodeController.h"
#import "YYTestDetectCodeResultHandler.h"
#import "YYCodeController.h"
#import "YYTestUtility.h"
#import "YYTipView.h"

@interface YYTestCodeController ()

@end

@implementation YYTestCodeController

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"XYCodeScanner/YYCodeController";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    XYButton *button = [YYTestUtility buttonWithTitle:@"扫描二维码" target:self action:@selector(tapAction:)];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(50);
        make.size.mas_equalTo(CGSizeMake(150, 34));
        make.centerX.mas_equalTo(0);
    }];
}

- (void)tapAction:(XYButton *)sender {
    if (UIDevice.xy_isSimulator) {
        [self.view showErrorWithText:@"请使用真机测试"];
        return;
    }
    
    YYCodeController *vc = [[YYCodeController alloc] init];
    vc.resultHandler = [[YYTestDetectCodeResultHandler alloc] init];
    [self xy_pushViewController:vc];
}

@end
