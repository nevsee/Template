//
//  XYDelegateRepeater.m
//  XYMultipleDelegate
//
//  Created by nevsee on 2020/11/10.
//

#import "XYDelegateRepeater.h"
#import <objc/runtime.h>

@interface XYDelegateRepeater ()
@property (nonatomic, strong) NSPointerArray *delegates;
@end

@implementation XYDelegateRepeater

+ (instancetype)repeaterWithType:(XYPropertyEncodingType)type {
    XYDelegateRepeater *repeater = [[XYDelegateRepeater alloc] init];
    switch (type) {
        case XYPropertyEncodingTypeWeak:
            repeater.delegates = [NSPointerArray weakObjectsPointerArray];
            break;
        case XYPropertyEncodingTypeStrong:
            repeater.delegates = [NSPointerArray strongObjectsPointerArray];
            break;
    }
    return repeater;
}

- (void)addDelegate:(id)delegate {
    if ([self containsDelegate:delegate]) return;
    if ([delegate isEqual:self]) return;
    
    [_delegates addPointer:(__bridge void *)delegate];
}

- (BOOL)removeDelegate:(id)delegate {
    if (!delegate) return NO;
    
    NSPointerArray *copy = _delegates.copy;
    for (NSUInteger i = 0; i < copy.count; i++) {
        if ([copy pointerAtIndex:i] == (__bridge void *)delegate) {
            [_delegates removePointerAtIndex:i];
            return YES;
        }
    }
    
    return NO;
}

- (void)removeAllDelegates {
    for (NSInteger i = _delegates.count - 1; i >= 0; i--) {
        [_delegates removePointerAtIndex:i];
    }
}

- (BOOL)containsDelegate:(id)delegate {
    if (!delegate) return NO;
    
    NSPointerArray *copy = _delegates.copy;
    for (NSUInteger i = 0; i < copy.count; i++) {
        if ([copy pointerAtIndex:i] == (__bridge void *)delegate) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark # Method Forward

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = nil;
    NSPointerArray *copy = _delegates.copy;
    
    for (id delegate in copy) {
        signature = [delegate methodSignatureForSelector:aSelector];
        if (signature && [signature respondsToSelector:aSelector]) {
            return signature;
        }
    }
    
    return [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL selector = anInvocation.selector;

    NSPointerArray *copy = _delegates.copy;
    for (id delegate in copy) {
        if ([delegate respondsToSelector:selector]) {
            [anInvocation invokeWithTarget:delegate];
        }
    }
}

#pragma mark # Override

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) return YES;

    NSPointerArray *copy = _delegates.copy;
    for (id delegate in copy) {
        if (class_respondsToSelector(self.class, aSelector)) return YES;
        
        BOOL delegateCanRespondToSelector = NO;
    
        if ([delegate isKindOfClass:XYDelegateRepeater.class]) {
            delegateCanRespondToSelector = [delegate respondsToSelector:aSelector];
        } else {
            delegateCanRespondToSelector = class_respondsToSelector(object_getClass(delegate), aSelector);
        }
        if (delegateCanRespondToSelector) return YES;
    }
    return NO;
}

- (BOOL)isKindOfClass:(Class)aClass {
    BOOL result = [super isKindOfClass:aClass];
    if (result) return YES;
    
    NSPointerArray *copy = _delegates.copy;
    for (id delegate in copy) {
        if ([delegate isKindOfClass:aClass]) return YES;
    }
    
    return NO;
}

- (BOOL)isMemberOfClass:(Class)aClass {
    BOOL result = [super isMemberOfClass:aClass];
    if (result) return YES;
    
    NSPointerArray *copy = _delegates.copy;
    for (id delegate in copy) {
        if ([delegate isMemberOfClass:aClass]) return YES;
    }
    
    return NO;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    BOOL result = [super conformsToProtocol:aProtocol];
    if (result) return YES;
    
    NSPointerArray *copy = _delegates.copy;
    for (id delegate in copy) {
        if ([delegate conformsToProtocol:aProtocol]) return YES;
    }
    
    return NO;
}

@end
