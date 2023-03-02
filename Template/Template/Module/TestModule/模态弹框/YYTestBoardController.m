//
//  YYTestBoardController.m
//  Template
//
//  Created by nevsee on 2021/12/17.
//

#import "YYTestBoardController.h"
#import "YYTestBoardContentController.h"
#import "YYTestGestureBoard.h"
#import "YYTestBoard.h"
#import "YYTestUtility.h"

@implementation YYTestBoardController

- (void)didInitialize {
    [super didInitialize];
    self.xy_supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"XYPrompter/YYBoard";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    XYButton *button1 = [YYTestUtility buttonWithTitle:@"外部导航的弹窗" target:self action:@selector(tapAction:)];
    button1.tag = 1;
    [self.view addSubview:button1];
    
    XYButton *button2 = [YYTestUtility buttonWithTitle:@"内部导航的弹窗" target:self action:@selector(tapAction:)];
    button2.tag = 2;
    [self.view addSubview:button2];
    
    XYButton *button3 = [YYTestUtility buttonWithTitle:@"交互手势的弹窗" target:self action:@selector(tapAction:)];
    button3.tag = 3;
    [self.view addSubview:button3];
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(50);
        make.size.mas_equalTo(CGSizeMake(150, 34));
        make.centerX.mas_equalTo(0);
    }];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button1.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(150, 34));
        make.centerX.mas_equalTo(0);
    }];
    
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button2.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(150, 34));
        make.centerX.mas_equalTo(0);
    }];
}

- (void)tapAction:(XYButton *)sender {
    NSInteger tag = sender.tag;
    if (tag == 1) {
        YYTestBoard *board = [[YYTestBoard alloc] init];
        [board presentInController:self];
    } else if (tag == 2) {
        YYTestBoardContentController *vc = [[YYTestBoardContentController alloc] init];
        YYGestureNavigationBoard *navigationBoard = [[YYGestureNavigationBoard alloc] initWithRootViewController:vc];
        navigationBoard.view.layer.cornerRadius = 12;
        navigationBoard.view.layer.masksToBounds = YES;
        if (@available(iOS 13.0, *)) {
            navigationBoard.view.layer.cornerCurve = kCACornerCurveContinuous;
        }
        [navigationBoard presentInController:self];
    } else {
        YYTestGestureBoard *board = [[YYTestGestureBoard alloc] init];
        [board presentInController:self];
    }
}

@end
