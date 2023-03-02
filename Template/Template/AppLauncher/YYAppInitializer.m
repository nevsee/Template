//
//  YYAppInitializer.m
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "YYAppInitializer.h"
#import "YYMediatorContext.h"

@implementation YYAppInitializer

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self mediatorSetup];
    [self networkSetup];
    return YES;
}

// 路由设置
- (void)mediatorSetup {
    YYMediatorContext *context = [[YYMediatorContext alloc] init];
    [XYMediator registerURLValidator:context];
    [XYMediator registerErrorProcessor:context];
}

// 网络设置
- (void)networkSetup {
    // 网络配置
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.allowsCellularAccess = YES;
    XYNetworkConfig *config = [XYNetworkConfig defaultConfig];
    config.sessionConfiguration = sessionConfiguration;
    config.debugLogEnabled = YES;
    // 网络监听
    XYNetworkReachabilityManager *manager = [XYNetworkReachabilityManager defaultManager];
    [manager startMonitoring];
}

@end
