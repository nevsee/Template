//
//  YYTestAlertController.m
//  Template
//
//  Created by nevsee on 2022/2/24.
//

#import "YYTestAlertController.h"
#import "YYAlertImageContent.h"
#import "YYTestUtility.h"

@interface YYTestAlertController ()
@property (nonatomic, strong) UISegmentedControl *styleSegment;
@end

@implementation YYTestAlertController

- (void)didInitialize {
    [super didInitialize];
    self.xy_supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"XYAlertController";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    UISegmentedControl *styleSegment = [[UISegmentedControl alloc] initWithItems:@[@"Sheet", @"Alert"]];
    styleSegment.selectedSegmentIndex = 1;
    [self.view addSubview:styleSegment];
    _styleSegment = styleSegment;
    
    XYButton *button1 = [YYTestUtility buttonWithTitle:@"普通弹窗" target:self action:@selector(tapAction:)];
    button1.tag = 1;
    [self.view addSubview:button1];
    
    XYButton *button2 = [YYTestUtility buttonWithTitle:@"倒计时弹窗" target:self action:@selector(tapAction:)];
    button2.tag = 2;
    [self.view addSubview:button2];
    
    XYButton *button3 = [YYTestUtility buttonWithTitle:@"交互弹窗" target:self action:@selector(tapAction:)];
    button3.tag = 3;
    [self.view addSubview:button3];
    
    XYButton *button4 = [YYTestUtility buttonWithTitle:@"自定义弹窗" target:self action:@selector(tapAction:)];
    button4.tag = 4;
    [self.view addSubview:button4];
    
    [styleSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(50);
        make.centerX.mas_equalTo(0);
    }];
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(styleSegment.mas_bottom).offset(30);
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
    
    [button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button3.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(150, 34));
        make.centerX.mas_equalTo(0);
    }];
}

- (void)tapAction:(XYButton *)sender {
    NSInteger tag = sender.tag;
    XYAlertController *vc = nil;
    NSString *title = @"清平调";
    NSString *message = @"云想衣裳花想容\n春风拂槛露华浓\n若非群玉山头见\n会向瑶台月下逢";
    XYAlertControllerStyle style = _styleSegment.selectedSegmentIndex;
    
    if (tag == 1) {
        vc = [XYAlertController alertWithTitle:title message:message cancel:@"取消" actions:@[@"查看作者"] preferredStyle:style];
        vc.beforeHandler = ^(__kindof XYAlertAction *action) {
            if (action.tag == 1) {
                [self.view showInfoWithText:@"作者：李白"];
            }
        };
    } else if (tag == 2) {
        vc = [XYAlertController alertWithTitle:title message:message cancel:@"取消" actions:nil preferredStyle:style];
        XYAlertTimerAction *action = [[XYAlertTimerAction alloc] initWithTitle:@"查看作者" style:XYAlertActionStyleDefault alerter:vc];
        action.format = @"请仔细阅读%@秒";
        action.duration = 5;
        vc.prompter.willPresentBlock = ^{
            [action startCounter];
        };
        vc.beforeHandler = ^(__kindof XYAlertAction *action) {
            if (action.tag == 1) {
                [self.view showInfoWithText:@"作者：李白"];
            }
        };
        [vc addActions:@[action]];
    } else if (tag == 3) {
        UIImage *image = [XYImageMake(@"search_1") xy_tintedImageWithColor:YYNeutral9Color];
        vc = [XYAlertController alertWithTitle:title message:message cancel:@"取消" actions:nil preferredStyle:style];
        XYAlertSketchAction *action = [[XYAlertSketchAction alloc] initWithTitle:@"查看作者" image:image spacing:10 style:XYAlertActionStyleDefault alerter:vc];
        action.dismissEnabled = NO;
        action.beforeHandler = ^(__kindof XYAlertAction *action) {
            XYAlertTextContent *content = [[XYAlertTextContent alloc] initWithText:@"作者：李白" style:XYAlertContentStyleMessage alerter:action.alerter];
            [action.alerter addContents:@[content]];
            [action.alerter removeActions:@[action]];
        };
        [vc addActions:@[action]];
    } else {
        YYAlertImageContent *content = [[YYAlertImageContent alloc] init];
        content.targetImage = XYImageMake(@"image3.jpeg");
        vc = [XYAlertController alertWithTitle:@"自定义" message:@"添加一个图片" cancel:@"取消" actions:nil preferredStyle:style];
        [vc addContents:@[content]];
    }
    [vc presentInController:self];
}

@end
