//
//  YYRequestDomin.m
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "YYRequestDomin.h"

static inline NSString* YYGetLocalDomin(YYEnvType envType, YYApiType apiType) {
    static NSDictionary *dominMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 开发域名
        NSDictionary *devDomins = @{
            @(YYApiTypeYes): @"http://supplier.api.yesapi.cn",
        };
        // 测试域名
        NSDictionary *testDomins = @{
            @(YYApiTypeYes): @"http://supplier.api.yesapi.cn",
        };
        // 正式域名
        NSDictionary *officalDomins = @{
            @(YYApiTypeYes): @"http://hn216.api.yesapi.cn",
        };
        // 域名表
        dominMap = @{@(YYEnvTypeDev): devDomins, @(YYEnvTypeTest): testDomins, @(YYEnvTypeOffical): officalDomins};
    });
    return dominMap[@(envType)][@(apiType)];
}


@implementation YYRequestDomin

+ (instancetype)defaultDomin {
    static YYRequestDomin *domin;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        domin = [[super allocWithZone:NULL] init];
    });
    return domin;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [YYRequestDomin defaultDomin] ;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [YYRequestDomin defaultDomin];
}

- (NSString *)getDominForApiType:(YYApiType)apiType {
    return YYGetLocalDomin(_envType, apiType);
}

@end
