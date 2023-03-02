//
//  XYBaseRequest.h
//  XYNetworking
//
//  Created by nevsee on 2018/8/9.
//  Copyright © 2018年 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class XYBaseRequest;
@protocol AFMultipartFormData;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, XYRequestMethod) {
    XYRequestMethodGET = 0,
    XYRequestMethodPOST,
    XYRequestMethodHEAD,
    XYRequestMethodPUT,
    XYRequestMethodDELETE,
    XYRequestMethodPATCH,
};

typedef NS_ENUM (NSInteger, XYRequestSerializerType) {
    XYRequestSerializerTypeHTTP = 0,
    XYRequestSerializerTypeJSON,
    XYRequestSerializerTypePropertyList,
};

typedef NS_ENUM (NSInteger, XYResponseSerializerType) {
    XYResponseSerializerTypeHTTP = 0,
    XYResponseSerializerTypeJSON,
    XYResponseSerializerTypeXMLParser,
    XYResponseSerializerTypePropertyList,
    XYResponseSerializerTypeImage,
};

typedef id _Nonnull (^XYRequestUploadDataBodyBlock)(void); ///< Returns file path (NSURL) or file data (NSData)
typedef NSURL* _Nonnull (^XYRequestDownloadDestinationBlock)(NSURL *targetPath, NSURLResponse *response);
typedef void (^XYRequestConstructingBodyBlock)(id<AFMultipartFormData> formData);

typedef void (^XYRequestProgressBlock)(NSProgress *progress);
typedef void (^XYRequestDidFinishCollectingMetricsBlock)(__kindof XYBaseRequest *request);
typedef void (^XYRequestCompletionBlock)(__kindof XYBaseRequest *request);

@protocol XYRequestDelegate <NSObject>
@optional
- (void)requestFinished:(__kindof XYBaseRequest *)request;
- (void)requestFailed:(__kindof XYBaseRequest *)request;
- (void)requestDidFinishCollectingMetrics:(__kindof XYBaseRequest *)request;
@end

@interface XYBaseRequest : NSObject

///----------------------------------------
/// @name Request Infomation
///----------------------------------------

/// The request task.
@property (nonatomic, strong, readonly) NSURLSessionTask *task;

/// The request metrics created during the task execution.
@property (nonatomic, strong, readonly, nullable) NSURLSessionTaskMetrics *metrics;

/// Shortcut for `requestTask.response`.
@property (nonatomic, strong, readonly, nullable) NSHTTPURLResponse *response;

/// This serialized response object.
@property (nonatomic, strong, readonly, nullable) id responseObject;

/// The raw data representation of response.
@property (nonatomic, strong, readonly, nullable) NSData *responseData;

/// The string representation of response.
@property (nonatomic, strong, readonly, nullable) NSString *responseString;

/// The response status code.
@property (nonatomic, assign, readonly) NSInteger responseStatusCode;

/// This error can be either serialization error or network error.
@property (nonatomic, strong, readonly, nullable) NSError *error;

/// Return cancelled state of request task.
@property (nonatomic, readonly, getter=isCancelled) BOOL cancelled;

/// Return executing state of request task.
@property (nonatomic, readonly, getter=isExecuting) BOOL executing;

/// Return completed state of request task.
@property (nonatomic, readonly, getter=isCompleted) BOOL completed;

///----------------------------------------
/// @name Request Configuration
///----------------------------------------

/// Tag can be used to identify request. Default value is 0.
@property (nonatomic, assign) NSInteger tag;

/// The userInfo can be used to store additional info about the request. Default is nil.
@property (nonatomic, strong, nullable) NSDictionary *userInfo;

/// The delegate object of the request.
@property (nonatomic, weak, nullable) id<XYRequestDelegate> delegate;

/// The success callback. This block will be called on the main queue.
@property (nonatomic, copy, nullable) XYRequestCompletionBlock successBlock;

/// The failure callback. This block will be called on the main queue.
@property (nonatomic, copy, nullable) XYRequestCompletionBlock failureBlock;

/// A block object to be executed during the task execution.
@property (nonatomic, copy, nullable) XYRequestDidFinishCollectingMetricsBlock metricsBlock;

/// A block object to be executed when the upload progress is updated. Default is nil.
@property (nonatomic, copy, nullable) XYRequestProgressBlock uploadProgressBlock;

/// A block object to be executed when the download progress is updated. Default is nil.
@property (nonatomic, copy, nullable) XYRequestProgressBlock downloadProgressBlock;

/// A block that takes a single argument and appends data to the POST/PUT HTTP body. Default is nil.
@property (nonatomic, copy, nullable) XYRequestConstructingBodyBlock constructingBodyBlock;

/// A block that appends data to the HTTP body to be uploaded.
@property (nonatomic, copy, nullable) XYRequestUploadDataBodyBlock dataBodyBlock;

/// A block object to be executed in order to determine the destination of the downloaded file.
/// This block takes two arguments, the target path & the server response, and returns the desired file URL of the resulting download.
/// The temporary file used during the download will be automatically deleted after being moved to the returned URL.
@property (nonatomic, copy, nullable) XYRequestDownloadDestinationBlock destinationBlock;

- (void)start;
- (void)startWithSuccess:(nullable XYRequestCompletionBlock)success failure:(nullable XYRequestCompletionBlock)failure;
- (void)stop;
- (void)clear;

///----------------------------------------
/// @name Subclass Override
///----------------------------------------

- (void)requestFinishedPreprocessor;
- (void)requestFailedPreprocessor;
- (void)requestFinishedAccessory;
- (void)requestFailedAccessory;

- (nullable NSString *)baseURL;
- (nullable NSString *)cdnURL;
- (NSString *)relativeURL;
- (NSDictionary *)requestParameter;
- (NSTimeInterval)timeoutInterval;
- (XYRequestMethod)requestMethod;
- (XYRequestSerializerType)requestSerializerType;
- (XYResponseSerializerType)responseSerializerType;
- (NSURLRequestCachePolicy)requestCachePolicy;
- (nullable NSArray<NSString *> *)acceptableContentTypes;
- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderField;
- (nullable NSArray<NSString *> *)requestAuthorizationHeaderField;
- (BOOL)allowsCellularAccess;
- (BOOL)allowsCdnAccess;

/// Only use for XYResponseSerializerTypeJSON
- (NSJSONReadingOptions)readingOptions;
- (BOOL)removesKeysWithNullValues;

@end

NS_ASSUME_NONNULL_END




