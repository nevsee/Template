//
//  NSObject+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 06/07/2017.
//  Copyright © 2017 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XYAdd)

#pragma mark Info

/**
 Returns the string name of the class
 */
+ (NSString *)xy_className;
- (NSString *)xy_className;

/**
 Returns all methods and properties of the class
 */
- (NSString *)xy_methodList;

/**
 Returns all methods and properties of the class, excluding its super class.
 */
- (NSString *)xy_shortMethodList;

/**
 Returns all Ivars of the class
 */
- (NSString *)xy_ivarList;

/**
 Enumerates all ivars, excluding its super class.
 */
- (void)xy_enumerateIvarsUsingBlock:(void (^)(Ivar ivar, NSString *ivarName))block;

/**
 Enumerates all ivars of a class.
 @param aClass A class to be enumerated
 @param includingSuper Super class to be enumerated if setting `YES`
 @param block A block object to be executed when enumerating ivars
 */
+ (void)xy_enumerateIvarsOfClass:(Class)aClass includingSuper:(BOOL)includingSuper usingBlock:(void (^)(Ivar ivar, NSString *ivarName))block;

/**
 Enumerates all properties, excluding its super class.
 */
- (void)xy_enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, NSString *propertyName))block;

/**
 Enumerates all properties of a class.
 @param aClass A class to be enumerated
 @param includingSuper Super class to be enumerated if setting `YES`
 @param block A block object to be executed when enumerating properties
 */
+ (void)xy_enumeratePropertiesOfClass:(Class)aClass includingSuper:(BOOL)includingSuper usingBlock:(void (^)(objc_property_t property, NSString *propertyName))block;

#pragma mark Dealloc monitor

/**
 A block to be executed when the object is released.
 */
- (void)xy_startDeallocMonitor:(void (^)(__unsafe_unretained id target))block;

#pragma mark Swap method

+ (BOOL)xy_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;
+ (BOOL)xy_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;


#pragma mark Perform selector

/**
 Calls a selector with non-parameter whose return value type is non-object.
 @example
 CGFloat alpha = xxx;
 [view xy_performSelector:@selector(alpha) withPrimitiveReturnValue:&alpha];
 */
- (void)xy_performSelector:(SEL)selector withPrimitiveReturnValue:(nullable void *)returnValue;

/**
 Calls a selector with parameter whose return value type is non-object.
 The parameter type supports object and non-object, and there is no quantity limit.
 @note
 'returnValue' is POINTER ADDRESS.
 @example
 CGPoint point = xxx;
 UIEvent *event = xxx;
 BOOL isInside;
 [view xy_performSelector:@selector(pointInside:withEvent:) withPrimitiveReturnValue:&isInside arguments:&point, &event, nil];
 */
- (void)xy_performSelector:(SEL)selector withPrimitiveReturnValue:(nullable void *)returnValue arguments:(nullable void *)firstArgument, ...;

/**
 Calls a selector with parameter whose return value type is non-object.
 The parameter type supports object and non-object, and there is no quantity limit.
 @return Return nil or object.
 @example
 id target = xxx;
 SEL action = xxx;
 UIControlEvents events = xxx;
 [control xy_performSelector:@selector(addTarget:action:forControlEvents:) withArguments:&target, &action, &events, nil];
*/
- (nullable id)xy_performSelector:(SEL)selector withArguments:(nullable void *)firstArgument, ...;

#pragma mark Other

/// The return value of the first call is NO, and it will be YES after first call.
@property (nonatomic, assign, readonly) BOOL xy_triggerOnceValue;

@end

NS_ASSUME_NONNULL_END
