//
//  XYPhotoPickerHelper.h
//  XYPhotoPicker
//
//  Created by nevsee on 2017/6/10.
//

#import "XYPhotoPickerHelper.h"
#import "XYPhotoPickerAppearance.h"
#import "XYPhoto.h"

@implementation XYPhotoPickerHelper

+ (NSString *)transformTimeIntervalWithSecond:(NSTimeInterval)second {
    if (second <= 0) return @"00:00";

    // 是否大于等于一小时
    NSInteger time = lround(second); // 向上取整
    BOOL greaterThanOrEqualToOneHour = time > (59 * 60 + 59);
    if (greaterThanOrEqualToOneHour) {
        NSInteger hour = time / (60 * 60); // 时
        NSInteger min = time % (60 * 60) / 60; // 分
        NSInteger sec = time % (60 * 60) % 60; // 秒
        NSString *format = hour < 10 ? @"%02ld:%02ld:%02ld" : @"%ld:%02ld:%02ld";
        return [NSString stringWithFormat:format, hour, min, sec];
    } else {
        NSInteger min = time / 60;
        NSInteger sec = time% 60;
        NSString *format = @"%02ld:%02ld";
        return [NSString stringWithFormat:format, min, sec];
    }
}

+ (void)addAnimationForCheckBoxButton:(UIButton *)button {
    [self addAnimationForView:button];
}

+ (void)removeAnimationForCheckBoxButton:(UIButton *)button {
    [button.layer removeAnimationForKey:@"animation"];
}

+ (void)addAnimationForView:(UIView *)view {
    NSTimeInterval duration = 0.6;
    CAKeyframeAnimation *springAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    springAnimation.values = @[@.85, @1.15, @.9, @1.0,];
    springAnimation.keyTimes = @[@(0.0 / duration), @(0.15 / duration) , @(0.3 / duration), @(0.45 / duration),];
    springAnimation.duration = duration;
    [view.layer addAnimation:springAnimation forKey:@"animation"];
}

+ (BOOL)isInterfaceLandscape {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                return UIInterfaceOrientationIsLandscape(windowScene.interfaceOrientation);
            }
        }
        return NO;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation);
#pragma clang dianostic pop
    }
}

+ (NSString *)localizedStringForKey:(NSString *)key {
    NSString *table = [XYPhotoPickerAppearance appearance].localizedTable;
    NSBundle *bundle = [XYPhotoPickerAppearance appearance].localizedBundle;
    if (!table && !bundle) return key;
    return NSLocalizedStringFromTableInBundle(key, table, bundle, nil);
}

+ (NSString *)obtainAppDisplayName {
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

+ (UIImage *)imageNamed:(NSString *)name {
    if (!name) return nil;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"XYPhotoPicker" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

@end
