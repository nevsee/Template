//
//  XYWeakProxy.h
//  XYWidget
//
//  Created by nevsee on 2018/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYWeakProxy : NSProxy

/// The proxy target.
@property (nonatomic, weak, nullable, readonly) id target;

/**
 Creates a new weak proxy for target.
 */
- (instancetype)initWithTarget:(id)target;

/**
 Creates a new weak proxy for target.
 */
+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
