//
//  YYTestWebController.m
//  Template
//
//  Created by nevsee on 2021/12/2.
//

#import "YYTestWebController.h"
#import "YYWebMenuController.h"
#import "YYTestFakeProgressController.h"
#import "YYTestUtility.h"

@interface YYTestWebController () <XYTextFieldDelegate>
@property (nonatomic, strong) XYTextField *textField;
@property (nonatomic, strong) XYButton *button;
@end

@implementation YYTestWebController

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"YYWebController";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    XYTextField *textField = [YYTestUtility textFieldWithPlaceholder:@"输入网页地址"];
    textField.delegate = self;
    textField.text = @"m.douyu.com";
    [self.view addSubview:textField];
    _textField = textField;
    
    XYButton *button = [YYTestUtility buttonWithTitle:@"打开链接" target:self action:@selector(tapAction)];
    [self.view addSubview:button];
    _button = button;
    
    XYButton *button2 = [YYTestUtility buttonWithTitle:@"打开本地文件" target:self action:@selector(tap2Action)];
    [self.view addSubview:button2];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(100);
        make.size.mas_equalTo(CGSizeMake(250, 50));
        make.centerX.mas_equalTo(0);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textField.mas_bottom).offset(80);
        make.size.mas_equalTo(CGSizeMake(120, 34));
        make.centerX.mas_equalTo(0);
    }];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 34));
        make.centerX.mas_equalTo(0);
    }];
}

- (void)textFieldDidChange:(XYTextField *)textField {
    if ([textField isEqual:_textField]) {
        _button.enabled = [textField.text xy_stringByTrimmingAll].length > 0;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self tapAction];
    return YES;
}

- (void)tapAction {
    [_textField resignFirstResponder];
    
    NSString *link = _textField.text;
    
    if (![link containsString:@"://"]) {
        link = [@"https://" stringByAppendingString:link];
    }

    YYWebMenuController *vc = [[YYWebMenuController alloc] init];
    vc.link = link;
    vc.userInfo = _textField.text;
    [self xy_pushViewController:vc];
}

- (void)tap2Action {
    [_textField resignFirstResponder];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"yy_insurance" ofType:@"pdf"];

    YYWebMenuController *vc = [[YYWebMenuController alloc] init];
    vc.allowsWebpageTitle = NO;
    vc.title = @"保险协议";
    vc.path = filePath;
    [self xy_pushViewController:vc];
}

@end
