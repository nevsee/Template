//
//  YYRequestCache.m
//  Template
//
//  Created by nevsee on 2021/11/19.
//

#import "YYRequestCache.h"
#import "YYRequest.h"
#import "YYCacheManager.h"
#import "YYGlobalUtility+Date.h"
#import "XYCipher.h"
#import <YYCache/YYCache.h>

@interface YYRequestCache ()
@property (nonatomic, strong) YYDiskCache *cache;
@end

@implementation YYRequestCache

+ (instancetype)defaultCache {
    static YYRequestCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[super allocWithZone:NULL] init];
    });
    return cache;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [YYRequestCache defaultCache] ;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [YYRequestCache defaultCache];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _cache = [[YYDiskCache alloc] initWithPath:[self cachePath]];
    }
    return self;
}

- (void)asyncSaveResponseDataForRequest:(YYRequest *)request {
    if (!request || !request.task || request.originData.code != YYResponseCodeSuccess) return;
    NSString *key = [self cacheKeyForRequest:request];
    [_cache setObject:request.responseObject forKey:key withBlock:^{}];
}

- (id)syncLoadCacheDataForRequest:(YYRequest *)request {
    if (!request) return nil;
    NSString *key = [self cacheKeyForRequest:request];
    return [_cache objectForKey:key];
}

- (NSString *)cachePath {
    NSString *path = [YYCacheManager.cachesPath stringByAppendingPathComponent:@"NetworkCache"];
    [YYCacheManager createCacheDirectoryAtPath:path backup:NO];
    return path;
}

- (NSString *)cacheKeyForRequest:(YYRequest *)request {
    NSString *requestUrl = [request relativeURL];
    NSString *baseUrl = [request baseURL];
    NSInteger method = [request requestMethod];
    NSDictionary *argument = [request requestParameter];
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%@_Host:%@_Url:%@_Argument:%@", @(method), baseUrl, requestUrl, argument];
    return [XYCipher md5HashedStringForData:requestInfo];
}

@end

