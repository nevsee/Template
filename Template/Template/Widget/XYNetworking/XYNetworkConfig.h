//
//  XYNetworkConfig.h
//  XYNetworking
//
//  Created by nevsee on 2018/8/9.
//  Copyright © 2018年 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AFSecurityPolicy;

@interface XYNetworkConfig : NSObject
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *cdnURL;
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;
@property (nonatomic, strong, nullable) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, assign) BOOL debugLogEnabled;
+ (instancetype)defaultConfig;
@end

NS_ASSUME_NONNULL_END
