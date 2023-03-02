//
//  YYCodeResultHandler.m
//  Template
//
//  Created by nevsee on 2021/12/28.
//

#import "YYCodeResultHandler.h"
#import "YYCodeController.h"
#import "YYWebMenuController.h"
#import "YYGlobalUtility+Validation.h"

@implementation YYCodeResultHandler

- (void)codeController:(YYCodeController *)codeController didHandleMessage:(NSString *)message {
    // 清除扫码页面
    codeController.cleanWorkflow = YES;
    // 使用网页加载
    YYWebMenuController *vc = [[YYWebMenuController alloc] init];
    vc.allowsWebpageTitle = NO;
    vc.title = @"扫码结果";
    if ([YYGlobalUtility validateLink:message]) {
        vc.link = message;
    } else {
        vc.loadBlock = ^(XYWebView *webView) {
            [webView loadHTMLString:message baseURL:nil];
        };
    }
    [codeController xy_pushViewController:vc];
}

@end
