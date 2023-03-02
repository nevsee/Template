//
//  YYRequest.m
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "YYRequest.h"
#import "YYGlobalUtility+Image.h"
#import "XYCipher.h"

static NSString * const kYYRequestAppKey = @"76900756ED64FE04F2AF8977DE0526D9";
static NSString * const kYYRequestAppSecrect = @"FC6NdmsfffjfUQewZGkvPN6bzZpUgIxZ03dmgXEu2uLBXeHmctrM9LqwJt98nDV";

@interface YYRequest ()
@property (nonatomic) Class classType;
@property (nonatomic, copy) NSString *customKey;
@property (nonatomic, strong) YYRequestCache *cache;
@property (nonatomic, assign, readwrite) BOOL dataFromCache;
@end

@implementation YYRequest

- (instancetype)init {
    return [self initWithType:NULL];
}

- (instancetype)initWithType:(Class)classType {
    return [self initWithType:classType customKey:nil];
}

- (instancetype)initWithType:(Class)classType customKey:(NSString *)customKey {
    self = [super init];
    if (self) {
        _classType = classType;
        _customKey = customKey;
        _cachePolicy = YYRequestCachePolicyUseCache;
        _cache = [YYRequestCache defaultCache];
    }
    return self;
}

// Override

- (NSString *)baseURL {
    return [[YYRequestDomin defaultDomin] getDominForApiType:YYApiTypeYes];
}

- (NSArray<NSString *> *)acceptableContentTypes {
    return @[@"text/plain", @"application/json", @"text/html",
             @"image/jpeg", @"image/png", @"application/octet-stream",
             @"text/json"];
}

- (XYRequestMethod)requestMethod {
    return XYRequestMethodGET;
}

- (NSTimeInterval)timeoutInterval {
    return 15;
}

- (XYRequestSerializerType)requestSerializerType {
    return XYRequestSerializerTypeJSON;
}

- (XYResponseSerializerType)reponseSerializerType {
    return XYResponseSerializerTypeJSON;
}

- (NSDictionary<NSString *, NSString *> *)requestHeaderField {
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers addEntriesFromDictionary:self.header];
    if (_headerInterceptor) _headerInterceptor(headers);
    return headers.copy;
}

- (NSDictionary *)requestParameter {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:self.parameter];
    // app key
    [parameters setObject:kYYRequestAppKey forKey:@"app_key"];
    // sign
    NSMutableArray *results = [self sortParameterValue:parameters];
    NSString *sign = [results componentsJoinedByString:@""];
    sign = [sign stringByAppendingString:kYYRequestAppSecrect];
    sign = [XYCipher md5HashedStringForData:sign];
    [parameters setObject:sign.uppercaseString forKey:@"sign"];
    // 外部处理请求头
    if (_parameterInterceptor) _parameterInterceptor(parameters);
    return parameters.copy;
}

- (void)requestFinishedPreprocessor {
    if (!self.responseObject) return;
    // 解析返回数据为YYRequestModel
    _originData = [YYRequestModel yy_modelWithJSON:self.responseObject];
    // 数据缓存
    if (_cachePolicy != YYRequestCachePolicyIgnoreCache) [_cache asyncSaveResponseDataForRequest:self];
    // 没有data
    if (!_originData.data || _classType == NULL) return;
    // 解析data
    id data = _customKey ? @{_customKey: _originData.data} : _originData.data;
    _originData.data = [_classType yy_modelWithJSON:data];
}

- (void)requestFailedPreprocessor {
    if (!self.responseObject) return;
    // 解析返回数据为YYRequestModel
    _originData = [YYRequestModel yy_modelWithJSON:self.responseObject];
    if (!_originData.data || _classType == NULL) return;
    // 解析data
    id data = _customKey ? @{_customKey: _originData.data} : _originData.data;
    _originData.data = [_classType yy_modelWithJSON:data];
}

- (void)start {
    // 忽略缓存
    if (_cachePolicy == YYRequestCachePolicyIgnoreCache) {
        [self startWithoutCache];
        return;
    }
    
    // 没有缓存
    id cacheObject = [_cache syncLoadCacheDataForRequest:self];
    if (!cacheObject) {
        [self startWithoutCache];
        return;
    }
    
    // 验证缓存
    id<YYRequestCacheValidation> validator = [self requestCacheValidator];
    if (validator && ![validator validateCache:cacheObject]) {
        [self startWithoutCache];
        return;
    }
    
    // 加载缓存
    dispatch_main_sync_safely(^{
        self.dataFromCache = YES;
        [self requestFinishedPreprocessor];
        [self requestFinishedAccessory];
        if ([self.delegate respondsToSelector:@selector(requestFinished:)]) {
            [self.delegate requestFinished:self];
        }
        if (self.successBlock) self.successBlock(self);
        if (self.cachePolicy == YYRequestCachePolicyUseCache) {
            [self startWithoutCache];
        }
    });
}

- (id)responseObject {
    return [_cache syncLoadCacheDataForRequest:self] ?: [super responseObject];
}

- (id<YYRequestCacheValidation>)requestCacheValidator {
    return nil;
}

// Private

- (void)clearCacheVariables {
    _dataFromCache = NO;
}

- (void)startWithoutCache {
    [self clearCacheVariables];
    [super start];
}

// 参数排序
- (NSMutableArray *)sortParameterValue:(NSDictionary *)parameter {
    if (parameter.count == 0) return [NSMutableArray array];
    
    NSArray *sortedKeys = [parameter.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableArray *sortedValues = [NSMutableArray array];
    for (NSString *key in sortedKeys) {
        id value = parameter[key];
        NSString *valueString = [NSString stringWithFormat:@"%@", value];
        [sortedValues addObject:valueString];
    }
    return sortedValues;
};

@end

#pragma mark -

@interface YYPageRequest ()
@property (nonatomic, assign, readwrite) YYRequestPageMode pageMode;
@property (nonatomic, assign, readwrite) YYRequestPageDataType pageDataType;
@end

@implementation YYPageRequest

- (void)startWithPageMode:(YYRequestPageMode)pageMode success:(XYRequestCompletionBlock)success failure:(XYRequestCompletionBlock)failure dataDescriber:(YYRequestPageDataDescriberBlock)dataDescriber {
    @weakify(self)
    [self startWithPageMode:pageMode success:success failure:failure dataHandler:^YYRequestPageDataType(id data) {
        @strongify(self)
        NSUInteger total = dataDescriber(data);
        if (total == 0) {
            return YYRequestPageDataTypeEmptyData;
        } else if (self.pageNo * self.pageSize < total) {
            return YYRequestPageDataTypeHasMoreData;
        } else {
            return YYRequestPageDataTypeNoMoreData;
        }
    }];
}

- (void)startWithPageMode:(YYRequestPageMode)pageMode success:(XYRequestCompletionBlock)success failure:(XYRequestCompletionBlock)failure dataHandler:(YYRequestPageDataHandlerBlock)dataHandler {
    // 终止上次请求，对应关闭加载动画
    if (self.isExecuting) {
        [self stop];
        if (_bindingListView) {
            if (pageMode == YYRequestPageModeRefresh) {
                [_bindingListView.mj_footer endRefreshing];
            } else {
                [_bindingListView.mj_header endRefreshing];
            }
        }
    }
    
    _pageMode = pageMode;
    
    if (pageMode == YYRequestPageModeRefresh) {
        // 记录上次页码，防止请求失败需要还原到上次页码
        NSUInteger tempPageNo = _pageNo;
        // 页码重置
        _pageNo = 1;
        /// 开始请求
        @weakify(self)
        [self startWithSuccess:^(XYBaseRequest * request) {
            @strongify(self)
            if (self.dataFromCache) {
                self.pageDataType = YYRequestPageDataTypeCacheData;
            } else if (self.originData.code != YYResponseCodeSuccess) {
                // 还原页码
                self.pageNo = tempPageNo;
                // 触发KVO
                self.pageDataType = self.pageDataType;
            } else {
                self.pageDataType = dataHandler(self.originData.data);
            }
            if (success) success(request);
        } failure:^(XYBaseRequest * _Nonnull request) {
            self.pageNo = tempPageNo;
            self.pageDataType = self.pageDataType;
            if (failure) failure(request);
        }];
    } else {
        // 页码增加
        _pageNo++;
        // 开始请求
        @weakify(self)
        [self startWithSuccess:^(XYBaseRequest * request) {
            @strongify(self)
            if (self.originData.code != YYResponseCodeSuccess) {
                // 触发KVO
                self.pageDataType = self.pageDataType;
            } else {
                self.pageDataType = dataHandler(self.originData.data);
            }
            if (self.pageDataType != YYRequestPageDataTypeHasMoreData) self.pageNo--;
            if (success) success(request);
        } failure:^(XYBaseRequest * _Nonnull request) {
            @strongify(self)
            self.pageNo--;
            self.pageDataType = self.pageDataType;
            if (failure) failure(request);
        }];
    }
}

- (void)start {
    // 加载更多忽略缓存
    if (_pageMode == YYRequestPageModeLoadMore) {
        [self startWithoutCache];
        return;
    }
    
    [super start];
}

@end

#pragma mark -

@implementation YYTransferRequest

- (void)uploadWithDatas:(NSArray *)datas names:(NSArray *)names types:(NSArray *)types progress:(XYRequestProgressBlock)progress success:(XYRequestCompletionBlock)success failure:(XYRequestCompletionBlock)failure {
    NSMutableArray *fileNames = [NSMutableArray array];
    for (NSInteger i = 0; i < datas.count; i++) {
        id data = datas[i];
        // 文件类型
        NSString *type = nil;
        if (types) {
            type = types[i];
        } else {
            if ([data isKindOfClass:[NSData class]]) { // 图片
                type = [YYGlobalUtility getImageFormat:data] ?: @"png";
            } else if ([data isKindOfClass:[NSURL class]]) { // 视频
                NSURL *path = data;
                type = path.pathExtension ?: @"mov";
            }
        }
        // 文件名称
        NSString *name = nil;
        if (names) {
            name = names[i];
        } else {
            name = [NSString stringWithFormat:@"%@_%@", NSString.xy_stringWithUUID, [[NSDate date] xy_stringWithFormat:@"yyyyMMddHHmmss"]];
        }
        [fileNames addObject:[NSString stringWithFormat:@"%@.%@", name, type]];
    }
    
    self.constructingBodyBlock = ^(id<AFMultipartFormData> formData) {
        for (NSInteger i = 0; i < datas.count; i++) {
            [formData appendPartWithFileData:datas[i] name:@"file" fileName:fileNames[i] mimeType:@"application/octet-stream"];
        }
    };
    self.uploadProgressBlock = progress;
    self.successBlock = success;
    self.failureBlock = failure;
    [self start];
}

- (void)uploadWithBody:(id)body progress:(XYRequestProgressBlock)progress success:(XYRequestCompletionBlock)success failure:(XYRequestCompletionBlock)failure {
    self.dataBodyBlock = ^id {
        return body;
    };
    self.uploadProgressBlock = progress;
    self.successBlock = success;
    self.failureBlock = failure;
    [self start];
}

- (void)downloadWithFilePath:(id)filePath progress:(XYRequestProgressBlock)progress success:(XYRequestCompletionBlock)success failure:(XYRequestCompletionBlock)failure {
    self.destinationBlock = ^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [filePath isKindOfClass:NSString.class] ? [NSURL fileURLWithPath:filePath] : filePath;
    };
    self.downloadProgressBlock = progress;
    self.successBlock = success;
    self.failureBlock = failure;
    [self start];
}

@end
