//
//  XYLoadash.m
//  XYWidget
//
//  Created by nevsee on 2022/7/4.
//

#import "XYLoadash.h"

@interface XYLoadash ()
@property (nonatomic, assign) XYLoadashMode mode;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

#pragma mark -

@interface XYLeadingThrottle : XYLoadash
@property (nonatomic, strong) NSDate *date;
@end

@implementation XYLeadingThrottle

- (void)invokeTask:(void (^)(void))task {
    if (_date && [[NSDate date] timeIntervalSinceDate:_date] <= self.interval) return;
    _date = [NSDate date];
    
    dispatch_async(self.queue, ^{
        if (task) task();
    });
}

@end

#pragma mark -

@interface XYTrailingThrottle : XYLoadash
@property (nonatomic, strong) NSDate *date;
@end

@implementation XYTrailingThrottle

- (void)invokeTask:(void (^)(void))task {
    if (_date && [[NSDate date] timeIntervalSinceDate:_date] <= self.interval) return;
    _date = [NSDate date];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.interval * NSEC_PER_SEC)), self.queue, ^{
        if (task) task();
    });
}

@end

#pragma mark -

@interface XYLeadingDebounce : XYLoadash
@property (nonatomic, strong) NSDate *date;
@end

@implementation XYLeadingDebounce

- (void)invokeTask:(void (^)(void))task {
    if (!_date || [[NSDate date] timeIntervalSinceDate:_date] > self.interval) {
        dispatch_async(self.queue, ^{
            if (task) task();
        });
    }
    _date = [NSDate date];
}

@end

#pragma mark -

@interface XYTrailingDebounce : XYLoadash
@property (nonatomic, strong) dispatch_block_t block;
@end

@implementation XYTrailingDebounce

- (void)invokeTask:(void (^)(void))task {
    if (_block) {
        dispatch_block_cancel(_block);
    }
    
    _block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
        if (task) task();
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.interval * NSEC_PER_SEC)), self.queue, _block);
}

@end

#pragma mark -

@implementation XYLoadash

- (instancetype)initWithMode:(XYLoadashMode)mode interval:(NSTimeInterval)interval {
    return [self initWithMode:mode interval:interval queue:nil];
}

- (instancetype)initWithMode:(XYLoadashMode)mode interval:(NSTimeInterval)interval queue:(dispatch_queue_t)queue {
    switch (mode) {
        case XYLoadashModeLeadingThrottle:
            self = [[XYLeadingThrottle alloc] init];
            break;
        case XYLoadashModeTrailingThrottle:
            self = [[XYTrailingThrottle alloc] init];
            break;
        case XYLoadashModeLeadingDebounce:
            self = [[XYLeadingDebounce alloc] init];
            break;
        case XYLoadashModeTrailingDebounce:
            self = [[XYTrailingDebounce alloc] init];
            break;
    }
    self.mode = mode;
    self.interval = interval;
    self.queue = queue ?: dispatch_get_main_queue();
    return self;
}

- (void)invokeTask:(void (^)(void))task {
}

@end


