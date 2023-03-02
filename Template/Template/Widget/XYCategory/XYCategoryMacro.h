//
//  XYCategoryMacro.h
//  XYCategory
//
//  Created by nevsee on 2016/12/28.
//  Copyright © 2016年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#ifndef XYCategoryMacro_h
#define XYCategoryMacro_h

/**
 Add this macro before each category implementation, so we don't have to use
 -all_load or -force_load to load object files from static libraries that only
 contain categories and no classes.
 @see
 https://developer.apple.com/library/content/qa/qa1490/_index.html
 http://www.cnblogs.com/ygm900/archive/2013/07/15/3191003.html
 @example
 XYSYNTH_DUMMY_CLASS(UIColor_XYAdd)
 */
#ifndef XYSYNTH_DUMMY_CLASS
#define XYSYNTH_DUMMY_CLASS(_name_) \
@interface XYSYNTH_DUMMY_CLASS ## _name_ : NSObject @end \
@implementation XYSYNTH_DUMMY_CLASS ## _name_ @end
#endif

/**
 Uses `objc_setAssociatedObject` to associate an object with another object.
 It allows us to add custom properties to existing classes in categories.
 @param _association_  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @example
 @interface NSString (XYAdd)
 @property (nonatomic, strong) NSString *example;
 @property (nonatomic, assion) CGPoint point;
 @end
 
 @implementation NSString (XYAdd)
 XYSYNTH_DYNAMIC_PROPERTY_OBJECT(example, setExample, RETAIN_NONATOMIC, NSString *)
 XYSYNTH_DYNAMIC_PROPERTY_CTYPE(point, setPoint, CGPoint)
 @end
 */
#ifndef XYSYNTH_DYNAMIC_PROPERTY_OBJECT
#define XYSYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif

#ifndef XYSYNTH_DYNAMIC_PROPERTY_CTYPE
#define XYSYNTH_DYNAMIC_PROPERTY_CTYPE(_getter_, _setter_, _type_) \
- (void)_setter_ : (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
NSValue *value = [NSValue value:&object withObjCType:@encode(_type_)]; \
objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
_type_ cValue = { 0 }; \
NSValue *value = objc_getAssociatedObject(self, @selector(_setter_:)); \
[value getValue:&cValue]; \
return cValue; \
}
#endif

/**
 Synthsizes a weak or strong reference.
 */
#ifndef weakify
#define weakify(object) \
__keywordify \
__weak __typeof__(object) weak##_##object = object;
#endif

#ifndef strongify
#define strongify(object) \
__keywordify \
__strong __typeof__(object) object = weak##_##object;
#endif

#if DEBUG
#define __keywordify autoreleasepool {}
#else
#define __keywordify try {} @finally {}
#endif

#pragma mark - Clang

/**
 Ignores warnings
 @see https://clang.llvm.org/docs/DiagnosticsReference.html
 @example
 XYIGNORE_CLANG_WARNING_BEGIN(-Warc-performSelector-leaks)
 ...
 XYIGNORE_CLANG_WARNING_END
 */
#ifndef XYIGNORE_CLANG_WARNING_BEGIN
#define XYIGNORE_CLANG_WARNING_BEGIN(_name_) \
__clang_diagnostic(push) \
__clang_diagnostic_type(ignored, _name_)
#endif

#ifndef XYIGNORE_CLANG_WARNING_END
#define XYIGNORE_CLANG_WARNING_END \
__clang_diagnostic(pop)
#endif

/// -Warc-performSelector-leaks
#define XYIGNORE_WARC_PERFORMSELECTOR_LEAKS_WARNING_BEGIN XYIGNORE_CLANG_WARNING_BEGIN(-Warc-performSelector-leaks)
#define XYIGNORE_WARC_PERFORMSELECTOR_LEAKS_WARNING_END XYIGNORE_CLANG_WARNING_END

/// -Warc-retain-cycles
#define XYIGNORE_WARC_RETAIN_CYCLE_WARNING_BEGIN XYIGNORE_CLANG_WARNING_BEGIN(-Warc-retain-cycles)
#define XYIGNORE_WARC_RETAIN_CYCLE_WARNING_END XYIGNORE_CLANG_WARNING_END

/// -Wpartial-availability
#define XYIGNORE_WPARTIAL_AVAILABILITY_WARNING_BEGIN XYIGNORE_CLANG_WARNING_BEGIN(-Wpartial-availability)
#define XYIGNORE_WPARTIAL_AVAILABILITY_WARNING_END XYIGNORE_CLANG_WARNING_END

/// -Wdeprecated-declarations
#define XYIGNORE_WDEPRECATED_DECLARATIONS_WARNING_BEGIN XYIGNORE_CLANG_WARNING_BEGIN(-Wdeprecated-declarations)
#define XYIGNORE_WDEPRECATED_DECLARATIONS_WARNING_END XYIGNORE_CLANG_WARNING_END

/// -Wdeprecated-implementations
#define XYIGNORE_WDEPRECATED_IMPLEMENTATIONS_WARNING_BEGIN XYIGNORE_CLANG_WARNING_BEGIN(-Wdeprecated-implementations)
#define XYIGNORE_WDEPRECATED_IMPLEMENTATIONS_WARNING_END XYIGNORE_CLANG_WARNING_END

#ifndef __clang_diagnostic
#define __clang_diagnostic(mode) \
__clang_pragma(clang diagnostic mode)
#endif

#ifndef __clang_diagnostic_type
#define __clang_diagnostic_type(mode, type) \
__clang_pragma(clang diagnostic mode #type)
#endif

#ifndef __clang_pragma
#define __clang_pragma(name) \
_Pragma(#name)
#endif

#pragma mark - GCD

/**
 Submits a function for asynchronous/synchronous execution on main queue safely.
 @see http://blog.benjamin-encz.de/post/main-queue-vs-main-thread
 */
static inline void dispatch_main_async_safely(dispatch_block_t block) {
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

static inline void dispatch_main_sync_safely(dispatch_block_t block) {
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

#pragma mark - Runtime

static inline BOOL XYHasOverrideSuperclassMethod(Class targetClass, SEL targetSelector) {
    Method targetMethod = class_getInstanceMethod(targetClass, targetSelector);
    if (!targetMethod) return NO;
    
    Method superMethod = class_getInstanceMethod(class_getSuperclass(targetClass), targetSelector);
    if (!superMethod) return YES;
    
    /// The address of the two methods is not the same when the subclass overrides the superclass method
    return targetMethod != superMethod;
}

/**
 Overrides the specified method of a class, if needed, calls super method by yourself.
 @param targetClass The target class
 @param targetSelector The target selector
 @param implementationBlock The block provides a new implementation
 @example
 
 XYOverrideImplementation([UIViewController class], @selector(viewWillAppear:), ^id(__unsafe_unretained Class originClass, SEL originSEL, IMP (^originIMPProvider)(void)) {
     return ^(UIViewController *selfObject, BOOL animated) {
         NSLog(@"viewWillAppear");
         
         /// call super method
         void (*originIMP)(id, SEL, BOOL);
         originIMP = (void (*)(id, SEL, BOOL))originIMPProvider();
         originIMP(originClass, originSEL, animated);
     };
 });
 */
static inline void XYOverrideImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(__unsafe_unretained Class originClass, SEL originSEL, IMP (^originIMPProvider)(void))) {
    Method targetMethod = class_getInstanceMethod(targetClass, targetSelector);
    IMP targetIMP = method_getImplementation(targetMethod);
    BOOL hasOverride = XYHasOverrideSuperclassMethod(targetClass, targetSelector);
    
    IMP (^originIMPProvider)(void) = ^IMP(void) {
        IMP result = NULL;
        if (hasOverride) {
            result = targetIMP;
        } else {
            Class superclass = class_getSuperclass(targetClass);
            /// Returns an '_objc_msgForward' imp if the target selector does not exsit
            result = class_getMethodImplementation(superclass, targetSelector);
        }
        
        /// Avoids crash
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
            XYIGNORE_WARC_PERFORMSELECTOR_LEAKS_WARNING_BEGIN
            NSString *typeString = [methodSignature performSelector:NSSelectorFromString(@"_typeString")];
            XYIGNORE_WARC_PERFORMSELECTOR_LEAKS_WARNING_END
            typeEncoding = typeString.UTF8String;
        }
        
        class_addMethod(targetClass, targetSelector, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originIMPProvider)), typeEncoding);
    }
}

/**
 Method with no return type and no arguments.
 @note
 The implementationBlock format: ^(NSObject *selfObject){}
 */
#ifndef XYOverrideVoidImplementationWithoutArguments
#define XYOverrideVoidImplementationWithoutArguments(targetClass, targetSelector, implementationBlock) \
XYOverrideImplementation(targetClass, targetSelector, ^id(__unsafe_unretained Class originClass, SEL originSEL, IMP (^originIMPProvider)(void)) { \
    return ^(__unsafe_unretained __kindof NSObject *selfObject) { \
        void (*originIMP)(id, SEL); \
        originIMP = (void (*)(id, SEL))originIMPProvider(); \
        originIMP(selfObject, originSEL); \
        \
        implementationBlock(selfObject); \
    }; \
});
#endif

/**
 Method with no return type and one argument.
 @note
 The implementationBlock format: ^(NSObject *selfObject, argType arg){}
 */
#ifndef XYOverrideVoidImplementationWithOneArgument
#define XYOverrideVoidImplementationWithOneArgument(targetClass, targetSelector, argType, implementationBlock) \
XYOverrideImplementation(targetClass, targetSelector, ^id(__unsafe_unretained Class originClass, SEL originSEL, IMP (^originIMPProvider)(void)) { \
    return ^(__unsafe_unretained __kindof NSObject *selfObject, argType arg) { \
        void (*originIMP)(id, SEL, argType); \
        originIMP = (void (*)(id, SEL, argType))originIMPProvider(); \
        originIMP(selfObject, originSEL, arg); \
        \
        implementationBlock(selfObject, arg); \
    }; \
});
#endif

/**
 Method with no return type and two arguments.
 @note
 The implementationBlock format: ^(NSObject *selfObject, argType1 arg1, argType2 arg2){}
 */
#ifndef XYOverrideVoidImplementationWithTwoArgument
#define XYOverrideVoidImplementationWithTwoArgument(targetClass, targetSelector, argType1, argType2, implementationBlock) \
XYOverrideImplementation(targetClass, targetSelector, ^id(__unsafe_unretained Class originClass, SEL originSEL, IMP (^originIMPProvider)(void)) { \
    return ^(__unsafe_unretained __kindof NSObject *selfObject, argType1 arg1, argType2 arg2) { \
        void (*originIMP)(id, SEL, argType1, argType2); \
        originIMP = (void (*)(id, SEL, argType1, argType2))originIMPProvider(); \
        originIMP(selfObject, originSEL, arg1, arg2); \
        \
        implementationBlock(selfObject, arg1, arg2); \
    }; \
});
#endif

/**
 Method with a return type and no arguments.
 @note
 The implementationBlock format: ^returnType (NSObject *selfObject, returnType superResult){}
 */
#ifndef XYOverrideImplementationWithoutArguments
#define XYOverrideImplementationWithoutArguments(targetClass, targetSelector, returnType, implementationBlock) \
XYOverrideImplementation(targetClass, targetSelector, ^id(__unsafe_unretained Class originClass, SEL originSEL, IMP (^originIMPProvider)(void)) { \
    return ^returnType (__unsafe_unretained __kindof NSObject *selfObject) { \
        returnType superResult; \
        \
        returnType (*originIMP)(id, SEL); \
        originIMP = (returnType (*)(id, SEL))originIMPProvider(); \
        superResult = originIMP(selfObject, originSEL); \
        \
        XYIGNORE_CLANG_WARNING_BEGIN(-Wuninitialized) \
        return implementationBlock(selfObject, superResult); \
        XYIGNORE_CLANG_WARNING_END \
    }; \
});
#endif

/**
 Method with a return type and one argument.
 @note
 The implementationBlock format: ^returnType (NSObject *selfObject, argType arg, returnType superResult){}
 */
#ifndef XYOverrideImplementationWithOneArgument
#define XYOverrideImplementationWithOneArgument(targetClass, targetSelector, returnType, argType, implementationBlock) \
XYOverrideImplementation(targetClass, targetSelector, ^id(__unsafe_unretained Class originClass, SEL originSEL, IMP (^originIMPProvider)(void)) { \
    return ^returnType (__unsafe_unretained __kindof NSObject *selfObject, argType arg) { \
        returnType superResult; \
        \
        returnType (*originIMP)(id, SEL, argType); \
        originIMP = (returnType (*)(id, SEL, argType))originIMPProvider(); \
        superResult = originIMP(selfObject, originSEL, arg); \
        \
        XYIGNORE_CLANG_WARNING_BEGIN(-Wuninitialized) \
        return implementationBlock(selfObject, arg, superResult); \
        XYIGNORE_CLANG_WARNING_END \
    }; \
});
#endif

/**
 Method with a return type and two arguments.
 @note
 The implementationBlock format: ^returnType (NSObject *selfObject, argType1 arg1, argType2 arg2, returnType superResult){}
 */
#ifndef XYOverrideImplementationWithTwoArgument
#define XYOverrideImplementationWithTwoArgument(targetClass, targetSelector, returnType, argType1, argType2, implementationBlock) \
XYOverrideImplementation(targetClass, targetSelector, ^id(__unsafe_unretained Class originClass, SEL originSEL, IMP (^originIMPProvider)(void)) { \
    return ^returnType (__unsafe_unretained __kindof NSObject *selfObject, argType1 arg1, argType2 arg2) { \
        returnType superResult; \
        \
        returnType (*originIMP)(id, SEL, argType1, argType2); \
        originIMP = (returnType (*)(id, SEL, argType1, argType2))originIMPProvider(); \
        superResult = originIMP(selfObject, originSEL, arg1, arg2); \
        \
        XYIGNORE_CLANG_WARNING_BEGIN(-Wuninitialized) \
        return implementationBlock(selfObject, arg1, arg2, superResult); \
        XYIGNORE_CLANG_WARNING_END \
    }; \
});
#endif


#endif
