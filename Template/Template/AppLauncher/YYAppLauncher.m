//
//  YYAppLauncher.m
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "YYAppLauncher.h"
#import "YYAppDelegate.h"

@implementation YYRootWindow

@end

#pragma mark -

@implementation YYAppLauncher

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self windowSetup];
    [self rootControllerSetup];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    return YES;
}

- (UIWindow *)window {
    return [UIApplication sharedApplication].delegate.window;
}

- (void)windowSetup {
    YYAppDelegate *delegate = (YYAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.shouldAutorotate = YES;
    delegate.window = [[YYRootWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    delegate.window.backgroundColor = UIColor.whiteColor;
    [delegate.window makeKeyAndVisible];
    
    NSLog(@"%@", NSTemporaryDirectory());
}

- (void)rootControllerSetup {
    UIViewController *vc = [[NSClassFromString(@"YYRootController") alloc] init];
    YYBaseNavigationController *nvc = [[YYBaseNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nvc;
}

@end

