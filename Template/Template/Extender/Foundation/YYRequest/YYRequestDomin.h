//
//  YYRequestDomin.h
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 域名类型
typedef NS_ENUM(NSUInteger, YYApiType) {
    YYApiTypeYes,
};

/// 环境类型
typedef NS_ENUM(NSInteger, YYEnvType) {
    YYEnvTypeDev, ///< 开发
    YYEnvTypeTest, ///< 测试
    YYEnvTypeOffical ///< 正式
};

/// 请求域名
@interface YYRequestDomin : NSObject
@property (nonatomic, assign) YYEnvType envType;
+ (instancetype)defaultDomin;
- (NSString *)getDominForApiType:(YYApiType)apiType;
@end

NS_ASSUME_NONNULL_END
