//
//  AppDelegate.m
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "YYAppDelegate.h"
#import "YYAppDispatcher.h"

@implementation YYAppDelegate

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return _shouldAutorotate ? UIInterfaceOrientationMaskAllButUpsideDown : UIInterfaceOrientationMaskPortrait;
}

#pragma mark # App State

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return [[YYAppDispatcher defaultDispatcher] application:application willFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return [[YYAppDispatcher defaultDispatcher] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [[YYAppDispatcher defaultDispatcher] applicationDidFinishLaunching:application];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[YYAppDispatcher defaultDispatcher] applicationWillResignActive:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[YYAppDispatcher defaultDispatcher] applicationDidBecomeActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[YYAppDispatcher defaultDispatcher] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[YYAppDispatcher defaultDispatcher] applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[YYAppDispatcher defaultDispatcher] applicationWillTerminate:application];
}

#pragma mark # Open URL

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    return [[YYAppDispatcher defaultDispatcher] application:app openURL:url options:options];
}

#pragma mark # Local Notification

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [[YYAppDispatcher defaultDispatcher] userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    [[YYAppDispatcher defaultDispatcher] userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
}

#pragma mark # Background Session

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    [[YYAppDispatcher defaultDispatcher] application:application handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];
}


@end
