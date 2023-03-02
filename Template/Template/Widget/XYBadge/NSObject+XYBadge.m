//
//  NSObject+XYBadge.m
//  XYWidget
//
//  Created by nevsee on 2022/11/28.
//

#import "NSObject+XYBadge.h"
#import <Objc/runtime.h>

#define _XYBadgeBeginIgnoreUIKVCAccessProhibited if (@available(iOS 13.0, *)) NSThread.currentThread.xy_badgeShouldIgnoreUIKVCAccessProhibited = YES;
#define _XYBadgeEndIgnoreUIKVCAccessProhibited if (@available(iOS 13.0, *)) NSThread.currentThread.xy_badgeShouldIgnoreUIKVCAccessProhibited = NO;

@interface NSThread (XYBadge)
@property(nonatomic, assign) BOOL xy_badgeShouldIgnoreUIKVCAccessProhibited;
@end

@implementation NSThread (XYBadge)

- (void)setXy_badgeShouldIgnoreUIKVCAccessProhibited:(BOOL)xy_badgeShouldIgnoreUIKVCAccessProhibited {
    objc_setAssociatedObject(self, _cmd, @(xy_badgeShouldIgnoreUIKVCAccessProhibited), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xy_badgeShouldIgnoreUIKVCAccessProhibited {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeShouldIgnoreUIKVCAccessProhibited:));
    return value.boolValue;
}

@end

@interface NSException (XYBadge)
@end

@implementation NSException (XYBadge)

+ (void)load {
    if (@available(iOS 13.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            XYBadgeOverrideImplementation(object_getClass([NSException class]), @selector(raise:format:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^(NSObject *selfObject, NSExceptionName raise, NSString *format, ...) {
                    if (raise == NSGenericException && [format isEqualToString:@"Access to %@'s %@ ivar is prohibited. This is an application bug"]) {
                        if (NSThread.currentThread.xy_badgeShouldIgnoreUIKVCAccessProhibited) {
                            return;
                        }
                    }
                    id (*originSelectorIMP)(id, SEL, NSExceptionName name, NSString *, ...);
                    originSelectorIMP = (id (*)(id, SEL, NSExceptionName name, NSString *, ...))originalIMPProvider();
                    va_list args;
                    va_start(args, format);
                    NSString *reason =  [[NSString alloc] initWithFormat:format arguments:args];
                    originSelectorIMP(selfObject, originCMD, raise, reason);
                    va_end(args);
                };
            });
        });
    }
}

@end

@implementation NSObject (XYBadge)

- (id)xy_badgeValueForKey:(NSString *)key {
    if (@available(iOS 13.0, *)) {
        if ([self isKindOfClass:[UIView class]]) {
            _XYBadgeBeginIgnoreUIKVCAccessProhibited
            id value = [self valueForKey:key];
            _XYBadgeEndIgnoreUIKVCAccessProhibited
            return value;
        }
    }
    return [self valueForKey:key];
}

@end
