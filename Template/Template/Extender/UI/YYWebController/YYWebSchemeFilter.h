//
//  YYWebSchemeFilter.h
//  Ferry
//
//  Created by nevsee on 2022/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 过滤结果
typedef NS_ENUM(NSUInteger, YYWebSchemeFilterResult) {
    /// 有效scheme，可跳转
    YYWebSchemeFilterResultValid,
    /// 无效scheme，忽略
    YYWebSchemeFilterResultInvalid,
};

@interface YYWebSchemeFilter : NSObject
+ (instancetype)defaultFilter;
- (void)addSchemes:(NSArray *)schemes;
- (void)removeSchemes:(NSArray *)schemes;
- (void)removeAllSchemes;
- (YYWebSchemeFilterResult)filterScheme:(NSString *)scheme;
@end

NS_ASSUME_NONNULL_END
