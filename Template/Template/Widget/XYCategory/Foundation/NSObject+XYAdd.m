//
//  NSObject+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 06/07/2017.
//  Copyright © 2017 nevsee. All rights reserved.
//

#import "NSObject+XYAdd.h"
#import "XYCategoryMacro.h"
#import "NSString+XYAdd.h"

XYSYNTH_DUMMY_CLASS(NSObject_XYAdd)

@interface _XYObjectDeallocMonitor : NSObject
@property (nonatomic, copy) void (^block)(__unsafe_unretained id target);
@property (nonatomic, unsafe_unretained) id target;
@end

@implementation _XYObjectDeallocMonitor
- (void)dealloc {
    if (_block) _block(_target);
}
@end

#pragma mark -

@interface NSObject ()
@property (nonatomic, assign) BOOL _xy_triggerOnceValue;
@end

@implementation NSObject (XYAdd)

+ (NSString *)xy_className {
    return NSStringFromClass(self);
}

- (NSString *)xy_className {
    return [NSString stringWithUTF8String:class_getName(self.class)];
}

XYIGNORE_WARC_PERFORMSELECTOR_LEAKS_WARNING_BEGIN
- (NSString *)xy_methodList {
    return [self performSelector:NSSelectorFromString(@"_methodDescription")];
}

- (NSString *)xy_shortMethodList {
    return [self performSelector:NSSelectorFromString(@"_shortMethodDescription")];
}

- (NSString *)xy_ivarList {
    return [self performSelector:NSSelectorFromString(@"_ivarDescription")];
}
XYIGNORE_WARC_PERFORMSELECTOR_LEAKS_WARNING_END

- (void)xy_enumerateIvarsUsingBlock:(void (^)(Ivar ivar, NSString *ivarName))block {
    [NSObject xy_enumerateIvarsOfClass:self.class includingSuper:NO usingBlock:block];
}

+ (void)xy_enumerateIvarsOfClass:(Class)aClass includingSuper:(BOOL)includingSuper usingBlock:(void (^)(Ivar ivar, NSString *ivarName))block {
    if (!block) return;
    
    unsigned int ivarsCount = 0;
    Ivar *ivars = class_copyIvarList(aClass, &ivarsCount);
    
    for (unsigned int i = 0; i < ivarsCount; i++) {
        Ivar ivar = *(ivars + i);
        if (block) block(ivar, [NSString stringWithFormat:@"%s", ivar_getName(ivar)]);
    }
    free(ivars);
    
    if (includingSuper) {
        Class superclass = class_getSuperclass(aClass);
        if (superclass) {
            [NSObject xy_enumerateIvarsOfClass:superclass includingSuper:includingSuper usingBlock:block];
        }
    }
}

- (void)xy_enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, NSString *propertyName))block {
    [NSObject xy_enumeratePropertiesOfClass:self.class includingSuper:NO usingBlock:block];
}

+ (void)xy_enumeratePropertiesOfClass:(Class)aClass includingSuper:(BOOL)includingSuper usingBlock:(void (^)(objc_property_t property, NSString *propertyName))block {
    if (!block) return;
    
    unsigned int propertiesCount = 0;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertiesCount);
    
    for (unsigned int i = 0; i < propertiesCount; i++) {
        objc_property_t property = properties[i];
        if (block) block(property, [NSString stringWithFormat:@"%s", property_getName(property)]);
    }
    free(properties);
    
    if (includingSuper) {
        Class superclass = class_getSuperclass(aClass);
        if (superclass) {
            [NSObject xy_enumeratePropertiesOfClass:superclass includingSuper:includingSuper usingBlock:block];
        }
    }
}

- (void)xy_startDeallocMonitor:(void (^)(__unsafe_unretained id target))block {
    _XYObjectDeallocMonitor *monitor = objc_getAssociatedObject(self, _cmd);
    if (!monitor) {
        monitor = [[_XYObjectDeallocMonitor alloc] init];
        monitor.block = block;
        monitor.target = self;
        objc_setAssociatedObject(self, _cmd, monitor, OBJC_ASSOCIATION_RETAIN);
    }
}

+ (BOOL)xy_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self, originalSel, class_getMethodImplementation(self, originalSel), method_getTypeEncoding(originalMethod));
    class_addMethod(self, newSel, class_getMethodImplementation(self, newSel), method_getTypeEncoding(newMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel), class_getInstanceMethod(self, newSel));
    return YES;
}

+ (BOOL)xy_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}

- (void)xy_performSelector:(SEL)selector withPrimitiveReturnValue:(void *)returnValue {
    [self xy_performSelector:selector withPrimitiveReturnValue:returnValue arguments:nil];
}

- (void)xy_performSelector:(SEL)selector withPrimitiveReturnValue:(void *)returnValue arguments:(void *)firstArgument, ... {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    if (firstArgument) {
        va_list valist;
        va_start(valist, firstArgument);
        [invocation setArgument:firstArgument atIndex:2]; // 0->self, 1->_cmd
        
        void *currentArgument;
        NSInteger index = 3;
        while ((currentArgument = va_arg(valist, void *))) {
            [invocation setArgument:currentArgument atIndex:index];
            index++;
        }
        va_end(valist);
    }
    [invocation invoke];
    
    if (returnValue) {
        [invocation getReturnValue:returnValue];
    }
}

- (id)xy_performSelector:(SEL)selector withArguments:(void *)firstArgument, ... {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    if (firstArgument) {
        va_list valist;
        va_start(valist, firstArgument);
        [invocation setArgument:firstArgument atIndex:2]; // 0->self, 1->_cmd
        
        void *currentArgument;
        NSInteger index = 3;
        while ((currentArgument = va_arg(valist, void *))) {
            [invocation setArgument:currentArgument atIndex:index];
            index++;
        }
        va_end(valist);
    }
    
    [invocation invoke];
    
    const char *typeEncoding = method_getTypeEncoding(class_getInstanceMethod(object_getClass(self), selector));
    if (strncmp(typeEncoding, "@", 1) == 0) {
        __unsafe_unretained id returnValue;
        [invocation getReturnValue:&returnValue];
        return returnValue;
    }
    return nil;
}

XYSYNTH_DYNAMIC_PROPERTY_CTYPE(_xy_triggerOnceValue, set_xy_triggerOnceValue, BOOL)

- (BOOL)xy_triggerOnceValue {
    BOOL flag = self._xy_triggerOnceValue;
    self._xy_triggerOnceValue = YES;
    return flag;
}

@end
