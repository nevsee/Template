//
//  XYLoadash.h
//  XYWidget
//
//  Created by nevsee on 2022/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYLoadashMode) {
    /// Throttle enforces a maximum number of times a function can be called over time.
    /// Invokes on the leading edge of the timeout.
    XYLoadashModeLeadingThrottle,
    
    /// Throttle enforces a maximum number of times a function can be called over time.
    /// Invokes on the trailing edge of the timeout.
    XYLoadashModeTrailingThrottle,
    
    /// Debounce enforces that a function not be called again until a certain amount of time has passed without it being called.
    /// Invokes on the leading edge of the timeout.
    XYLoadashModeLeadingDebounce,
    
    /// Debounce enforces that a function not be called again until a certain amount of time has passed without it being called.
    /// Invokes on the trailing edge of the timeout.
    XYLoadashModeTrailingDebounce,
};

@interface XYLoadash : NSObject
- (instancetype)initWithMode:(XYLoadashMode)mode interval:(NSTimeInterval)interval;
- (instancetype)initWithMode:(XYLoadashMode)mode interval:(NSTimeInterval)interval queue:(nullable dispatch_queue_t)queue;
- (void)invokeTask:(void (^)(void))task;
@end

NS_ASSUME_NONNULL_END
