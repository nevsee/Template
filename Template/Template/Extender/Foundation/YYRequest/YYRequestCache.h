//
//  YYRequestCache.h
//  Template
//
//  Created by nevsee on 2021/11/19.
//

#import <Foundation/Foundation.h>

@class YYRequest;

NS_ASSUME_NONNULL_BEGIN

/// 缓存
@interface YYRequestCache : NSObject
+ (instancetype)defaultCache;
- (void)asyncSaveResponseDataForRequest:(YYRequest *)request;
- (id)syncLoadCacheDataForRequest:(YYRequest *)request;
@end

/// 缓存验证
@protocol YYRequestCacheValidation <NSObject>
@required
- (BOOL)validateCache:(id)cacheObject;
@end

NS_ASSUME_NONNULL_END
