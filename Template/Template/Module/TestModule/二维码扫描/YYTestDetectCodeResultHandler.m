//
//  YYTestDetectCodeResultHandler.m
//  Template
//
//  Created by nevsee on 2023/2/22.
//

#import "YYTestDetectCodeResultHandler.h"
#import "YYGlobalUtility+Validation.h"
#import "YYCodeController.h"
#import "YYWebMenuController.h"

@implementation YYTestDetectCodeResultHandler

- (void)codeController:(YYCodeController *)codeController didHandleMessage:(NSString *)message {
    NSArray *actions = nil;
    if ([YYGlobalUtility validateLink:message]) {
        actions = @[@"复制", @"分享", @"浏览器打开"];
    } else {
        actions = @[@"复制", @"分享"];
    }
    
    XYAlertController *vc = [XYAlertController alertWithTitle:message message:nil cancel:@"取消" actions:actions preferredStyle:XYAlertControllerStyleSheet];
    vc.beforeHandler = ^(__kindof XYAlertAction * _Nonnull action) {
        if (action.tag == 0) { // 取消
            [codeController restartIfNeeded];
        }
        else if (action.tag == 1) { // 复制
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = message ?: @"";
            [codeController.view showSuccessWithText:@"复制成功"];
            [codeController restartIfNeeded];
        }
        else if (action.tag == 2) { // 分享
            UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[message] applicationActivities:nil];
            vc.completionWithItemsHandler = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
                if (!completed && activityType) return; // 未完成状态
                [codeController restartIfNeeded];
            };
            [codeController presentViewController:vc animated:YES completion:nil];
        }
        else if (action.tag == 3) { // 浏览器打开
            YYWebMenuController *vc = [[YYWebMenuController alloc] init];
            vc.link = message;
            [vc xy_startDeallocMonitor:^(__unsafe_unretained id  _Nonnull target) {
                [codeController restartIfNeeded];
            }];
            [codeController xy_pushViewController:vc];
        }
    };
    vc.prompter.definesDismissalTouch = NO;
    [vc presentInController:codeController];
}


@end
