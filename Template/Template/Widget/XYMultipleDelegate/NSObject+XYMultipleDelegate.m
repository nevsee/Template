//
//  NSObject+XYMultipleDelegate.m
//  XYMultipleDelegate
//
//  Created by nevsee on 2020/11/10.
//

#import "NSObject+XYMultipleDelegate.h"
#import "XYDelegateRepeater.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

static inline SEL XYMakeSetterFromGetter(SEL getter) {
    NSString *getterStr = NSStringFromSelector(getter);
    NSString *getterFirstStr = [getterStr substringToIndex:1].uppercaseString;
    NSString *getterOtherStr = [getterStr substringFromIndex:1];
    NSString *newGetterStr = [getterFirstStr stringByAppendingString:getterOtherStr];
    NSString *stterStr = [@"set" stringByAppendingFormat:@"%@:", newGetterStr];
    return NSSelectorFromString(stterStr);
}

static inline SEL XYMakeSwapSetterFromGetter(SEL getter) {
    SEL setter = XYMakeSetterFromGetter(getter);
    return NSSelectorFromString([NSString stringWithFormat:@"xy_multiple_%@", NSStringFromSelector(setter)]);
}

@interface NSObject ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, XYDelegateRepeater *> *xy_storage;
@end

@implementation NSObject (XYMultipleDelegate)

- (NSMutableDictionary<NSString *,XYDelegateRepeater *> *)xy_storage {
    return objc_getAssociatedObject(self, @selector(setXy_storage:));
}

- (void)setXy_storage:(NSMutableDictionary<NSString *,XYDelegateRepeater *> *)xy_storage {
    objc_setAssociatedObject(self, _cmd, xy_storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xy_multipleDelegateEnabled {
    NSNumber *value = objc_getAssociatedObject(self, @selector(setXy_multipleDelegateEnabled:));
    return value.boolValue;
}

- (void)setXy_multipleDelegateEnabled:(BOOL)xy_multipleDelegateEnabled {
    objc_setAssociatedObject(self, _cmd, @(xy_multipleDelegateEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (xy_multipleDelegateEnabled) {
        if (!self.xy_storage) {
            self.xy_storage = [NSMutableDictionary dictionary];
        }
        
        // delegate
        [self xy_registerDelegate:@selector(delegate)];
        
        // dataSource
        if ([self isKindOfClass:UITableView.class] || [self isKindOfClass:UICollectionView.class]) {
            [self xy_registerDelegate:@selector(dataSource)];
        }
    }
}

- (void)xy_registerDelegate:(SEL)getter {
    if (!self.xy_multipleDelegateEnabled) return;
    
    Class targetClass = self.class;
    SEL originSetter = XYMakeSetterFromGetter(getter);
    SEL swapSetter = XYMakeSwapSetterFromGetter(getter);
    Method originMethod = class_getInstanceMethod(targetClass, originSetter);
    if (!originMethod) return;
    
    // init repeater
    NSString *key = NSStringFromSelector(getter);
    if (!self.xy_storage[key]) {
        objc_property_t property = class_getProperty(targetClass, key.UTF8String);
        BOOL isStrong = property_copyAttributeValue(property, "&") != NULL;
        XYPropertyEncodingType type = isStrong ? XYPropertyEncodingTypeStrong : XYPropertyEncodingTypeWeak;
        XYDelegateRepeater *repeater = [XYDelegateRepeater repeaterWithType:type];
        self.xy_storage[key] = repeater;
    }
    
    // swap method
    [NSObject invokeOnce:^{
        IMP originIMP = method_getImplementation(originMethod);

        BOOL succeed = class_addMethod(targetClass, swapSetter, imp_implementationWithBlock(^(NSObject *object, id delegate){
            XYDelegateRepeater *repeater = object.xy_storage[key];

            // avoid swpping super class methods
            if (!object.xy_multipleDelegateEnabled || object.class != targetClass) {
                ((void (*)(id, SEL, id))originIMP)(object, originSetter, delegate);
                return;
            }

            // remove all delegate objects if delegate is set to nil
            if (!delegate) {
                [repeater removeAllDelegates];
                return;
            }

            // avoid retaining cycle
            if (![delegate isEqual:repeater]) {
                [repeater addDelegate:delegate];
            }

            // set delegate object
            ((void (*)(id, SEL, id))originIMP)(object, originSetter, nil);
            ((void (*)(id, SEL, id))originIMP)(object, originSetter, repeater);

        }), method_getTypeEncoding(originMethod));

        if (succeed) {
            Method swapMethod = class_getInstanceMethod(targetClass, swapSetter);
            method_exchangeImplementations(originMethod, swapMethod);
        }
    } forIndentifier:[NSString stringWithFormat:@"xy_multiple_%@_%@", NSStringFromClass(targetClass), key]];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    // delegate object has been setted
    id delegate = [self performSelector:getter];
    if (delegate && [delegate isEqual:self.xy_storage[key]]) {
        [self performSelector:originSetter withObject:delegate];
    }
#pragma clang diagnostic pop
}

- (void)xy_removeDelegate:(id)delegate {
    if (!self.xy_multipleDelegateEnabled) return;
    if (!self.xy_storage) return;
    
    [self.xy_storage enumerateKeysAndObjectsUsingBlock:^(NSString *key, XYDelegateRepeater *obj, BOOL *stop) {
        [obj removeDelegate:delegate];
    }];
}

static NSMutableSet *indentifierMap;
+ (void)invokeOnce:(void (NS_NOESCAPE ^)(void))block forIndentifier:(NSString *)indentifier {
    if (!indentifierMap) indentifierMap = [NSMutableSet set];
    
    @synchronized (self) {
        if (![indentifierMap containsObject:indentifier]) {
            [indentifierMap addObject:indentifier];
            if (block) block();
        }
    }
}

@end
