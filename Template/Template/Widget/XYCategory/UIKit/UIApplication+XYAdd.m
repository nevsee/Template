//
//  UIApplication+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2017/4/12.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "UIApplication+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(UIApplication_XYAdd)

@implementation UIApplication (XYAdd)

- (UIWindowScene *)xy_windowSence {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                return windowScene;
            }
        }
    }
    return nil;
}

- (UIWindow *)xy_keyWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindow *window in self.xy_windowSence.windows) {
            if (window.isKeyWindow) return window;
        }
    }
    
    XYIGNORE_WDEPRECATED_DECLARATIONS_WARNING_BEGIN
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) window = [UIApplication sharedApplication].delegate.window;
    return window;
    XYIGNORE_WDEPRECATED_DECLARATIONS_WARNING_END
}

- (UIInterfaceOrientation)xy_interfaceOrientation {
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = [UIApplication sharedApplication].xy_windowSence;
        if (windowScene) return windowScene.interfaceOrientation;
    }
    
    XYIGNORE_WDEPRECATED_DECLARATIONS_WARNING_BEGIN
    return [UIApplication sharedApplication].statusBarOrientation;
    XYIGNORE_WDEPRECATED_DECLARATIONS_WARNING_END
}

- (BOOL)xy_isInterfaceLandscape {
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = [UIApplication sharedApplication].xy_windowSence;
        if (windowScene) return UIInterfaceOrientationIsLandscape(windowScene.interfaceOrientation);
    }
    
    XYIGNORE_WDEPRECATED_DECLARATIONS_WARNING_BEGIN
    return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation);
    XYIGNORE_WDEPRECATED_DECLARATIONS_WARNING_END
}

- (BOOL)xy_isDeviceLandscape {
    return UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
}

+ (NSString *)xy_appBundleIdentifier {
    return [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
}

+ (NSString *)xy_appVersion {
    return [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)xy_appBuildVersion {
    return [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleVersion"];
}

+ (NSString *)xy_appDisplayName {
    NSDictionary *info = [NSBundle mainBundle].localizedInfoDictionary;
    NSString *appName = nil;
    
    if (info.count > 0) {
        appName = [info objectForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [info valueForKey:@"CFBundleName"];
        if (!appName) appName = [info valueForKey:@"CFBundleExecutable"];
    }
    if (!appName) {
        info = [NSBundle mainBundle].infoDictionary;
        appName = [info objectForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [info valueForKey:@"CFBundleName"];
        if (!appName) appName = [info valueForKey:@"CFBundleExecutable"];
    }
    
    return appName;
}

+ (NSArray *)xy_appIcons {
    return [[NSBundle mainBundle].infoDictionary valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"];
}

+ (NSString *)xy_homePath {
    return NSHomeDirectory();
}

+ (NSString *)xy_documentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)xy_cachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)xy_libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)xy_tmpPath {
    return NSTemporaryDirectory();
}

+ (NSString *)xy_preferencePath {
    return [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)xy_applicationSupportPath {
    return [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
}

+ (void)xy_addDoNotBackupAttributeForPath:(NSString *)path error:(NSError **)error {
    NSURL *url = [NSURL fileURLWithPath:path];
    [url setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:error];
}

@end

