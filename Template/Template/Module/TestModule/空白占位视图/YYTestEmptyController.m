//
//  YYTestEmptyController.m
//  Template
//
//  Created by nevsee on 2021/12/27.
//

#import "YYTestEmptyController.h"
#import "YYTestUtility.h"

@implementation YYTestEmptyController

- (void)didInitialize {
    [super didInitialize];
    self.xy_supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"YYEmptyView";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];

    XYButton *button1 = [YYTestUtility buttonWithTitle:@"请求有数据" target:self action:@selector(tapAction:)];
    button1.tag = 1;
    [self.view addSubview:button1];
    
    XYButton *button2 = [YYTestUtility buttonWithTitle:@"请求无数据" target:self action:@selector(tapAction:)];
    button2.tag = 2;
    [self.view addSubview:button2];
    
    XYButton *button3 = [YYTestUtility buttonWithTitle:@"请求无网络" target:self action:@selector(tapAction:)];
    button3.tag = 3;
    [self.view addSubview:button3];

    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(50);
        make.size.mas_equalTo(CGSizeMake(100, 34));
        make.centerX.mas_equalTo(0);
    }];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button1.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 34));
        make.centerX.mas_equalTo(0);
    }];
    
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button2.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 34));
        make.centerX.mas_equalTo(0);
    }];
}

- (void)tapAction:(XYButton *)sender {
    NSInteger tag = sender.tag;
    self.emptyView.mode = YYEmptyContentModeLoading;
    
    if (tag == 1) {
        [self showEmptyView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideEmptyView];
        });
    } else if (tag == 2) {
        [self showEmptyView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.emptyView.mode = YYEmptyContentModeResult;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hideEmptyView];
            });
        });
    } else {
        [self showEmptyView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.emptyView.mode = YYEmptyContentModeError;
        });
    }
}

- (void)emptyViewRetryAction {
    self.emptyView.mode = YYEmptyContentModeLoading;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideEmptyView];
    });
}

@end
