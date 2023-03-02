//
//  XYNetworkConfig.m
//  XYNetworking
//
//  Created by nevsee on 2018/8/9.
//  Copyright © 2018年 nevsee. All rights reserved.
//

#import "XYNetworkConfig.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFSecurityPolicy.h>
#else
#import "AFSecurityPolicy.h"
#endif

@implementation XYNetworkConfig

+ (instancetype)defaultConfig {
    static XYNetworkConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[super allocWithZone:NULL] init];
    });
    return config;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [XYNetworkConfig defaultConfig] ;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [XYNetworkConfig defaultConfig];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
        _securityPolicy.allowInvalidCertificates = YES;
        _securityPolicy.validatesDomainName = NO;
    }
    return self;
}


@end
