//
//  XYRequestAgent.m
//  XYNetworking
//
//  Created by nevsee on 2018/8/9.
//  Copyright © 2018年 nevsee. All rights reserved.

#import "XYRequestAgent.h"
#import "XYBaseRequest.h"
#import "XYNetworkPrivate.h"
#import "XYNetworkConfig.h"
#import "XYNetworkUtility.h"
#import <pthread/pthread.h>

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

static inline id XYResponseObjectByRemovingKeysWithNullValues(id responseObject, NSJSONReadingOptions options) {
    BOOL mutable = options & NSJSONReadingMutableContainers;
    
    if ([responseObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)responseObject count]];
        for (id value in (NSArray *)responseObject) {
            [mutableArray addObject:XYResponseObjectByRemovingKeysWithNullValues(value, options)];
        }
        return mutable ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        for (id key in [(NSDictionary *)responseObject allKeys]) {
            id value = (NSDictionary *)responseObject[key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                mutableDictionary[key] = XYResponseObjectByRemovingKeysWithNullValues(value, options);
            }
        }
        return mutable ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }
    return responseObject;
}

static inline NSString * XYRequestMethodName(XYRequestMethod method) {
    switch (method) {
        case XYRequestMethodGET: return @"GET";
        case XYRequestMethodPOST: return @"POST";
        case XYRequestMethodHEAD: return @"HEAD";
        case XYRequestMethodPUT: return @"PUT";
        case XYRequestMethodDELETE: return @"DELETE";
        case XYRequestMethodPATCH: return @"PATCH";
    }
}

static const char *kXYCompletionQueueKey = "com.nevsee.networking.base.completionQueue";

@interface XYRequestAgent ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) XYNetworkConfig *config;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, XYBaseRequest *> *requestStorage;
@property (nonatomic) pthread_mutex_t lock;
@end

@implementation XYRequestAgent

#pragma mark # Life

+ (instancetype)defaultProxy {
    static XYRequestAgent *proxy;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        proxy = [[super allocWithZone:NULL] init];
    });
    return proxy;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [XYRequestAgent defaultProxy] ;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [XYRequestAgent defaultProxy];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        _config = [XYNetworkConfig defaultConfig];
        _requestStorage = [NSMutableDictionary dictionary];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:_config.sessionConfiguration];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy = _config.securityPolicy;
        _sessionManager.completionQueue = dispatch_queue_create(kXYCompletionQueueKey, DISPATCH_QUEUE_CONCURRENT);
        
        __weak typeof(self) weak = self;
        [_sessionManager setTaskDidFinishCollectingMetricsBlock:^(NSURLSession *session, NSURLSessionTask *task, NSURLSessionTaskMetrics *metrics) {
            __strong typeof(weak) self = weak;
            [self requestDidFinishCollectingMetrics:metrics task:task];
        }];
    }
    return self;
}

#pragma mark # Task

- (void)addRequest:(XYBaseRequest *)request {
    if (!request) return;
    NSError * __autoreleasing error = nil;
    request.task = [self createSessionTask:request error:&error];
    if (error) {
        [self requestFailure:request error:error];
    } else {
        XYLog(@"[XYNetworking] Request start: %@", NSStringFromClass(request.class));
        [self addRequestToStorage:request];
        [request.task resume];
    }
}

- (void)removeRequest:(XYBaseRequest *)request {
    if (!request) return;
    [request.task cancel];
    [self removeRequestFromStorage:request];
}

- (void)removeAllRequests {
    Lock();
    NSArray *allKeys = [_requestStorage allKeys];
    Unlock();
    if (allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for (NSNumber *key in copiedKeys) {
            Lock();
            XYBaseRequest *request = _requestStorage[key];
            Unlock();
            [request stop];
        }
    }
}

- (void)addRequestToStorage:(XYBaseRequest *)request {
    Lock();
    _requestStorage[@(request.task.taskIdentifier)] = request;
    Unlock();
}

- (void)removeRequestFromStorage:(XYBaseRequest *)request {
    Lock();
    [_requestStorage removeObjectForKey:@(request.task.taskIdentifier)];
    Unlock();
}

#pragma mark # Request

- (NSString *)createRequestURLString:(XYBaseRequest *)request error:(NSError *__autoreleasing *)error {
    NSString *baseURLString = nil;
    if ([request allowsCdnAccess]) {
        baseURLString = [request cdnURL] ?: _config.cdnURL;
    } else {
        baseURLString = [request baseURL] ?: _config.baseURL;
    }
    
    NSString *URLString = [NSURL URLWithString:[request relativeURL] relativeToURL:[NSURL URLWithString:baseURLString]].absoluteString;
    
    if (!URLString || [URLString isEqualToString:@""]) {
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"The URL can not be nil", @"XYNetworking", nil)};
        *error = [[NSError alloc] initWithDomain:AFURLRequestSerializationErrorDomain code:NSURLErrorBadURL userInfo:userInfo];
    }
    
    return URLString;
}

- (AFHTTPRequestSerializer *)createRequestSerializer:(XYBaseRequest *)request {
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    switch ([request requestSerializerType]) {
        case XYRequestSerializerTypeJSON:
            requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case XYRequestSerializerTypePropertyList:
            requestSerializer = [AFPropertyListRequestSerializer serializer];
            break;
        default:
            break;
    }
    
    requestSerializer.timeoutInterval = [request timeoutInterval];
    requestSerializer.allowsCellularAccess = [request allowsCellularAccess];
    requestSerializer.cachePolicy = [request requestCachePolicy];
    
    NSDictionary *headerField = [request requestHeaderField];
    if (headerField) {
        for (NSString *key in headerField.allKeys) {
            [requestSerializer setValue:headerField[key] forHTTPHeaderField:key];
        }
    }
    
    NSArray *authorizationHeaderField = [request requestAuthorizationHeaderField];
    if (authorizationHeaderField) {
        [requestSerializer setAuthorizationHeaderFieldWithUsername:authorizationHeaderField.firstObject password:authorizationHeaderField.lastObject];
    }
    
    return requestSerializer;
}

- (NSDictionary *)createRequestParameter:(XYBaseRequest *)request {
    NSDictionary *parameter = [request requestParameter] ?: @{};
    return parameter;
}

- (NSURLSessionDataTask *)createSessionTask:(XYBaseRequest *)request error:(NSError * __autoreleasing *)error {
    NSString *URLString = [self createRequestURLString:request error:error];
    NSDictionary *parameter = [self createRequestParameter:request];
    XYRequestProgressBlock uploadProgress = [request uploadProgressBlock];
    XYRequestProgressBlock downloadProgress = [request downloadProgressBlock];
    XYRequestConstructingBodyBlock constructingBody = [request constructingBodyBlock];
    XYRequestUploadDataBodyBlock dataBody = [request dataBodyBlock];
    XYRequestDownloadDestinationBlock destination = [request destinationBlock];
    XYRequestMethod method = [request requestMethod];
    AFHTTPRequestSerializer *requestSerializer = [self createRequestSerializer:request];
    
    // Request serialization error
    if (*error) return nil;
    
    id sessionTask = nil;

    if (constructingBody) {
        sessionTask = [self formDataTaskWithMethod:XYRequestMethodName(method) URLString:URLString parameter:parameter requestSerializer:requestSerializer uploadProgress:uploadProgress constructingBody:constructingBody error:error];
    } else if (dataBody) {
        sessionTask = [self uploadDataTaskWithMethod:XYRequestMethodName(method) URLString:URLString parameter:parameter requestSerializer:requestSerializer uploadProgress:uploadProgress dataBody:dataBody error:error];
    } else if (destination) {
        sessionTask = [self downloadDataTaskWithMethod:XYRequestMethodName(method) URLString:URLString parameter:parameter requestSerializer:requestSerializer downloadProgress:downloadProgress destination:destination error:error];
    } else {
        sessionTask = [self dataTaskWithMethod:XYRequestMethodName(method) URLString:URLString parameter:parameter requestSerializer:requestSerializer error:error];
    }
    return sessionTask;
}

- (NSURLSessionDataTask *)dataTaskWithMethod:(NSString *)method URLString:(NSString *)URLString parameter:(id)parameter requestSerializer:(AFHTTPRequestSerializer *)requestSerializer error:(NSError * __autoreleasing *)error {
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameter error:error];
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self handleRequestResult:dataTask responseObject:responseObject error:error];
    }];
    return dataTask;
}

- (NSURLSessionDataTask *)formDataTaskWithMethod:(NSString *)method URLString:(NSString *)URLString parameter:(id)parameter requestSerializer:(AFHTTPRequestSerializer *)requestSerializer uploadProgress:(XYRequestProgressBlock)uploadProgress constructingBody:(XYRequestConstructingBodyBlock)constructingBody error:(NSError * __autoreleasing *)error {
    
    NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameter constructingBodyWithBlock:constructingBody error:error];

    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_sessionManager dataTaskWithRequest:request uploadProgress:uploadProgress downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self handleRequestResult:dataTask responseObject:responseObject error:error];
    }];
    return dataTask;
}

- (NSURLSessionUploadTask *)uploadDataTaskWithMethod:(NSString *)method URLString:(NSString *)URLString parameter:(id)parameter requestSerializer:(AFHTTPRequestSerializer *)requestSerializer uploadProgress:(XYRequestProgressBlock)uploadProgress dataBody:(XYRequestUploadDataBodyBlock)dataBody error:(NSError * __autoreleasing *)error {

    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameter error:error];
    id data = dataBody();
    
    __block NSURLSessionUploadTask *dataTask = nil;
    if ([data isKindOfClass:NSURL.class]) {
        dataTask = [_sessionManager uploadTaskWithRequest:request fromFile:data progress:uploadProgress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            [self handleRequestResult:dataTask responseObject:responseObject error:error];
        }];
    } else if ([data isKindOfClass:NSData.class]) {
        dataTask = [_sessionManager uploadTaskWithRequest:request fromData:data progress:uploadProgress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            [self handleRequestResult:dataTask responseObject:responseObject error:error];
        }];
    }
    return dataTask;
}

- (NSURLSessionDownloadTask *)downloadDataTaskWithMethod:(NSString *)method URLString:(NSString *)URLString parameter:(id)parameter requestSerializer:(AFHTTPRequestSerializer *)requestSerializer downloadProgress:(XYRequestProgressBlock)downloadProgress destination:(XYRequestDownloadDestinationBlock)destination error:(NSError * __autoreleasing *)error {
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameter error:error];

    __block NSURLSessionDownloadTask *dataTask = nil;
    dataTask = [_sessionManager downloadTaskWithRequest:request progress:downloadProgress destination:destination completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [self handleRequestResult:dataTask responseObject:filePath error:error];
    }];
    return dataTask;
}

#pragma mark # Response

- (AFHTTPResponseSerializer *)createResponseSerializer:(XYBaseRequest *)request {
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    switch (request.responseSerializerType) {
        case XYResponseSerializerTypeJSON: {
            AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
            serializer.readingOptions = [request readingOptions];
            responseSerializer = serializer;
        }
            break;
        case XYResponseSerializerTypeXMLParser:
            responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case XYResponseSerializerTypePropertyList:
            responseSerializer = [AFPropertyListResponseSerializer serializer];
            break;
        case XYResponseSerializerTypeImage:
            responseSerializer = [AFImageResponseSerializer serializer];
            break;
        default:
            break;
    }
    
    if (request.acceptableContentTypes) {
        NSMutableSet *t = responseSerializer.acceptableContentTypes.mutableCopy;
        [t addObjectsFromArray:request.acceptableContentTypes];
        responseSerializer.acceptableContentTypes = t.copy;
    }
    
    return responseSerializer;
}

- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error {
    Lock();
    XYBaseRequest *request = [_requestStorage objectForKey:@(task.taskIdentifier)];
    Unlock();
    if (!request) return;
    
    NSError * __autoreleasing serializationError = nil;
    NSError *requestError = nil;
    BOOL result = NO;
    request.responseObject = responseObject;
    AFHTTPResponseSerializer *responseSerializer = [self createResponseSerializer:request];
    if ([request.responseObject isKindOfClass:[NSData class]]) {
        NSStringEncoding encoding = [XYNetworkUtility stringEncodingWithResponse:request.response];
        request.responseString = [[NSString alloc] initWithData:responseObject encoding:encoding];
        request.responseData = responseObject;
        request.responseObject = [responseSerializer responseObjectForResponse:request.response
                                                                          data:request.responseObject
                                                                         error:&serializationError];
        
        if ([request responseSerializerType] == XYResponseSerializerTypeJSON && [request removesKeysWithNullValues]) {
            request.responseObject = XYResponseObjectByRemovingKeysWithNullValues(request.responseObject, [request readingOptions]);
        }
    }
    if (error) {
        result = NO;
        requestError = error;
    } else if (serializationError) {
        result = NO;
        requestError = serializationError;
    } else {
        result = YES;
    }
    
    if (result) {
        [self requestSuccess:request];
    } else {
        [self requestFailure:request error:requestError];
    }
}

- (void)requestSuccess:(XYBaseRequest *)request {
    XYLog(@"[XYNetworking] Request successful \nurl: %@ \nparameter: %@ \nresponseObject: %@", request.response.URL.absoluteString, request.requestParameter, request.responseObject);
    
    @autoreleasepool {
        [request requestFinishedPreprocessor];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [request requestFinishedAccessory];
        if (request.delegate && [request.delegate respondsToSelector:@selector(requestFinished:)]) {
            [request.delegate requestFinished:request];
        }
        if (request.successBlock) request.successBlock(request);
        
        [self removeRequestFromStorage:request];
    });
}

- (void)requestFailure:(XYBaseRequest *)request error:(NSError *)error {
    request.error = error;
    XYLog(@"[XYNetworking] Request failed \nurl: %@ \nparameter: %@ \nstatus code: %ld \nerror: %@", request.response.URL.absoluteString, request.requestParameter, (long)request.responseStatusCode, error.localizedDescription);
    
    @autoreleasepool {
        [request requestFailedPreprocessor];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [request requestFailedAccessory];
        if (request.delegate && [request.delegate respondsToSelector:@selector(requestFailed:)]) {
            [request.delegate requestFailed:request];
        }
        if (request.failureBlock) request.failureBlock(request);
        
        [self removeRequestFromStorage:request];
    });
}

- (void)requestDidFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics task:(NSURLSessionTask *)task {
    Lock();
    XYBaseRequest *request = [self.requestStorage objectForKey:@(task.taskIdentifier)];
    Unlock();
    if (!request) return;
    request.metrics = metrics;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.delegate && [request.delegate respondsToSelector:@selector(requestDidFinishCollectingMetrics:)]) {
            [request.delegate requestDidFinishCollectingMetrics:request];
        }
        if (request.metricsBlock) request.metricsBlock(request);
    });
}

@end
