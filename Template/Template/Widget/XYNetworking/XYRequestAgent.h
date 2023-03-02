//
//  XYRequestAgent.h
//  XYNetworking
//
//  Created by nevsee on 2018/8/9.
//  Copyright © 2018年 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XYBaseRequest;

NS_ASSUME_NONNULL_BEGIN

@interface XYRequestAgent : NSObject
+ (instancetype)defaultProxy;
- (void)addRequest:(XYBaseRequest *)request;
- (void)removeRequest:(XYBaseRequest *)request;
- (void)removeAllRequests;
@end

NS_ASSUME_NONNULL_END
