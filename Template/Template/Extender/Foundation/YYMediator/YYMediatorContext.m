//
//  YYMediatorContext.m
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "YYMediatorContext.h"
#import "YYMediatorErrorController.h"

@implementation YYMediatorContext

/// 远程链接格式
/// scheme://target/action?param1=xxx&param2=xxx
/// @example
/// nevsee://remote.news/fetchNewsController?newsId=123456
- (NSURL *)validateUrl:(NSURL *)url {
    // 验证scheme
    if (![url.scheme isEqualToString:@"nevsee"]) return nil;
    
    // 验证host
    NSString *host = url.host;
    BOOL remote = [host hasPrefix:@"remote."];
    if (!remote) return nil;
    
    // 转换host
    NSString *newHost = [host stringByReplacingOccurrencesOfString:@"remote." withString:@""];
    newHost = [NSString stringWithFormat:@"YY%@Connector", newHost.xy_firstLetterCapitalized];
    NSString *urlString = url.absoluteString;
    if (remote) {
        urlString = [urlString stringByReplacingOccurrencesOfString:host withString:newHost];
    }
    
    return [NSURL URLWithString:urlString];
}

- (void)processError:(NSError *)error {
    dispatch_main_async_safely(^{
        YYMediatorErrorController *vc = [[YYMediatorErrorController alloc] init];
        vc.error = error;
        YYBaseNavigationController *nvc = [[YYBaseNavigationController alloc] initWithRootViewController:vc];
        nvc.modalPresentationStyle = UIModalPresentationFullScreen;
        [XYNavigator presentViewController:nvc animated:YES completion:nil];
    });
}

@end
