//
//  YYAppDispatcher.m
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "YYAppDispatcher.h"

#define YYDispatchDelegate(stuff) \
    do { \
        for (NSString *name in _names) { \
            id<YYApplicationDelegate> obj = _objs[name]; \
            if ([obj respondsToSelector:_cmd]) { \
                stuff; \
            } \
        } \
    } while (0)

@interface YYAppDispatcher ()
@property (nonatomic, strong) NSArray *names;
@end

@implementation YYAppDispatcher

+ (instancetype)defaultDispatcher {
    static YYAppDispatcher *dispatcher;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatcher = [[super allocWithZone:NULL] init];
        [dispatcher obtainObjects];
    });
    return dispatcher;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [YYAppDispatcher defaultDispatcher];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [YYAppDispatcher defaultDispatcher];
}

- (void)obtainObjects {
    if (_objs) return;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"YYAppInfo" ofType:@"plist"];
    NSArray *names = [NSArray arrayWithContentsOfFile:path];
    NSMutableDictionary *objs = [NSMutableDictionary dictionary];
    for (NSString *name in names) {
        id<YYApplicationDelegate> obj = [[NSClassFromString(name) alloc] init];
        if (!obj) continue;
        [objs setObject:obj forKey:name];
    }
    _objs = objs.copy;
    _names = names;
}

#pragma mark # App State

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    YYDispatchDelegate([obj application:application willFinishLaunchingWithOptions:launchOptions]);
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    YYDispatchDelegate([obj application:application didFinishLaunchingWithOptions:launchOptions]);
    return YES;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    YYDispatchDelegate([obj applicationDidFinishLaunching:application]);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    YYDispatchDelegate([obj applicationWillResignActive:application]);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    YYDispatchDelegate([obj applicationDidBecomeActive:application]);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    YYDispatchDelegate([obj applicationDidEnterBackground:application]);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    YYDispatchDelegate([obj applicationWillEnterForeground:application]);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    YYDispatchDelegate([obj applicationWillTerminate:application]);
}

#pragma mark # Open URL

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options {
    YYDispatchDelegate([obj application:application openURL:url options:options]);
    return YES;
}

#pragma mark # Local Notification

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    YYDispatchDelegate([obj userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler]);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    YYDispatchDelegate([obj userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler]);
}

#pragma mark # Background Session

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    YYDispatchDelegate([obj application:application handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler]);
}


@end
