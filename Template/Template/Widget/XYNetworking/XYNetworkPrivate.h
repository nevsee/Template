//
//  XYNetworkPrivate.h
//  XYNetworking
//
//  Created by nevsee on 2018/8/21.
//  Copyright © 2018年 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYBaseRequest (XYSetter)
@property (nonatomic, strong, readwrite) NSURLSessionTask *task;
@property (nonatomic, strong, readwrite, nullable) NSURLSessionTaskMetrics *metrics;
@property (nonatomic, strong, readwrite, nullable) id responseObject;
@property (nonatomic, strong, readwrite, nullable) NSData *responseData;
@property (nonatomic, strong, readwrite, nullable) NSString *responseString;
@property (nonatomic, strong, readwrite, nullable) NSError *error;
@end

NS_ASSUME_NONNULL_END
