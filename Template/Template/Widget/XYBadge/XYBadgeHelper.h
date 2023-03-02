//
//  XYBadgeHelper.h
//  XYWidget
//
//  Created by nevsee on 2022/11/28.
//

#import <Foundation/Foundation.h>
#import <Objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

static inline BOOL XYBadgeHasOverrideSuperclassMethod(Class targetClass, SEL targetSelector) {
    Method targetMethod = class_getInstanceMethod(targetClass, targetSelector);
    if (!targetMethod) return NO;
    Method superMethod = class_getInstanceMethod(class_getSuperclass(targetClass), targetSelector);
    if (!superMethod) return YES;
    return targetMethod != superMethod;
}

static inline BOOL XYBadgeOverrideImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(__unsafe_unretained Class originClass, SEL originSEL, IMP (^originIMPProvider)(void))) {
    Method targetMethod = class_getInstanceMethod(targetClass, targetSelector);
    IMP targetIMP = method_getImplementation(targetMethod);
    BOOL hasOverride = XYBadgeHasOverrideSuperclassMethod(targetClass, targetSelector);
    
    IMP (^originIMPProvider)(void) = ^IMP(void) {
        IMP result = NULL;
        if (hasOverride) {
            result = targetIMP;
        } else {
            Class superclass = class_getSuperclass(targetClass);
            result = class_getMethodImplementation(superclass, targetSelector);
        }
        if (!result) {
            result = imp_implementationWithBlock(^(id selfObject){});
        }
        return result;
    };
    
    if (hasOverride) {
        method_setImplementation(targetMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originIMPProvider)));
    } else {
        const char *typeEncoding = method_getTypeEncoding(targetMethod);
        if (!typeEncoding) {
            NSMethodSignature *methodSignature = [targetClass instanceMethodSignatureForSelector:targetSelector];
            NSString *typeString = [methodSignature performSelector:NSSelectorFromString(@"_typeString")];
            typeEncoding = typeString.UTF8String;
        }
        class_addMethod(targetClass, targetSelector, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originIMPProvider)), typeEncoding);
    }
    
    return YES;
}

#pragma clang diagnostic pop
