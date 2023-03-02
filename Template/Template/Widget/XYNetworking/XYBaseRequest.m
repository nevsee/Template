//
//  XYBaseRequest.m
//  XYNetworking
//
//  Created by nevsee on 2018/8/9.
//  Copyright © 2018年 nevsee. All rights reserved.
//

#import "XYBaseRequest.h"
#import "XYRequestAgent.h"

@interface XYBaseRequest ()
@property (nonatomic, strong, readwrite) NSURLSessionTask *task;
@property (nonatomic, strong, readwrite) NSURLSessionTaskMetrics *metrics;
@property (nonatomic, strong, readwrite) id responseObject;
@property (nonatomic, strong, readwrite) NSData *responseData;
@property (nonatomic, strong, readwrite) NSString *responseString;
@property (nonatomic, strong, readwrite, nullable) NSError *error;
@end

@implementation XYBaseRequest

#pragma mark # Request & Reponse Infomation

- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *)_task.response;
}

- (NSInteger)responseStatusCode {
    return self.response.statusCode;
}

- (BOOL)isCancelled {
    if (!_task) return NO;
    return (_task.state == NSURLSessionTaskStateCanceling);
}

- (BOOL)isExecuting {
    if (!_task) return NO;
    return (_task.state == NSURLSessionTaskStateRunning);
}

- (BOOL)isCompleted {
    if (!_task) return NO;
    return (_task.state == NSURLSessionTaskStateCompleted);
}

#pragma mark # Request Method

- (void)start {
    [[XYRequestAgent defaultProxy] addRequest:self];
}

- (void)startWithSuccess:(XYRequestCompletionBlock)success failure:(XYRequestCompletionBlock)failure {
    _successBlock = success;
    _failureBlock = failure;
    [self start];
}

- (void)stop {
    [self clear];
    [[XYRequestAgent defaultProxy] removeRequest:self];
}

- (void)clear {
    _delegate = nil;
    _successBlock = nil;
    _failureBlock = nil;
}

#pragma mark # Subclass Override

- (void)requestFinishedPreprocessor {
}

- (void)requestFailedPreprocessor {
}

- (void)requestFinishedAccessory {
}

- (void)requestFailedAccessory {
}

- (NSString *)baseURL {
    return nil;
}

- (NSString *)cdnURL {
    return nil;
}

- (NSString *)relativeURL {
    return @"";
}

- (NSDictionary *)requestParameter {
    return @{};
}

- (NSTimeInterval)timeoutInterval {
    return 60;
}

- (XYRequestMethod)requestMethod {
    return XYRequestMethodPOST;
}

- (XYRequestSerializerType)requestSerializerType {
    return XYRequestSerializerTypeHTTP;
}

- (XYResponseSerializerType)responseSerializerType {
    return XYResponseSerializerTypeJSON;
}

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestUseProtocolCachePolicy;
}

- (NSArray<NSString *> *)acceptableContentTypes {
    return nil;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderField {
    return nil;
}

- (NSArray<NSString *> *)requestAuthorizationHeaderField {
    return nil;
}

- (BOOL)allowsCellularAccess {
    return YES;
}

- (BOOL)allowsCdnAccess {
    return NO;
}

- (NSJSONReadingOptions)readingOptions {
    return (NSJSONReadingOptions)0;
}

- (BOOL)removesKeysWithNullValues {
    return NO;
}

@end
