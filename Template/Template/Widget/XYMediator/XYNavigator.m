//
//  XYNavigator.m
//  XYMediator
//
//  Created by nevsee on 2021/1/17.
//

#import "XYNavigator.h"

@implementation XYNavigator

+ (UIWindow *)keyWindow {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) window = [UIApplication sharedApplication].delegate.window;
    return window;
#pragma clang diagnostic pop
}

+ (UIViewController *)topViewController {
    UIViewController *vc = [self keyWindow].rootViewController;
    
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UINavigationController *nc = (UINavigationController *)[self topViewController];
    
    // find navigation controller
    if (![nc isKindOfClass:[UINavigationController class]]) {
        if ([nc isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tc = (UITabBarController *)nc;
            nc = tc.selectedViewController;
            if (![nc isKindOfClass:[UINavigationController class]]) {
                nc = tc.selectedViewController.navigationController;
            }
        } else {
            nc = nc.navigationController;
        }
    }
    
    if ([nc isKindOfClass:[UINavigationController class]]) {
        [nc pushViewController:viewController animated:animated];
    }
}

+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    UIViewController *vc = [self topViewController];
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nc = (UINavigationController *)vc;
        vc = nc.topViewController;
    }
    
    if ([vc isKindOfClass:[UIAlertController class]]) {
        UIViewController *presentingvc = vc.presentingViewController;
        [vc dismissViewControllerAnimated:NO completion:nil];
        vc = presentingvc;
    }
    
    if (vc) {
        [vc presentViewController:viewController animated:animated completion:completion];
    }
}

@end
