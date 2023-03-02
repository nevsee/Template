//
//  YYAppDispatcher.h
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "YYApplicationDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// 代理调度器
@interface YYAppDispatcher : NSObject <YYApplicationDelegate>
@property (nonatomic, strong, readonly) NSDictionary *objs;
+ (instancetype)defaultDispatcher;
@end

NS_ASSUME_NONNULL_END
