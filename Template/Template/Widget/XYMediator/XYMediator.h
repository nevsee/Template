//
//  XYMediator.h
//  XYMediator
//
//  Created by nevsee on 2021/1/15.
//

#import <Foundation/Foundation.h>

#if __has_include(<XYMediator/XYMediator.h>)
FOUNDATION_EXPORT double XYMediatorVersionNumber;
FOUNDATION_EXPORT const unsigned char XYMediatorVersionString[];
#import <XYMediator/XYNavigator.h>
#else
#import "XYNavigator.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/// Error domain
FOUNDATION_EXTERN NSErrorDomain const XYMediatorIllegalURLErrorDomain;
FOUNDATION_EXTERN NSErrorDomain const XYMediatorExcessArgumentErrorDomain;
FOUNDATION_EXTERN NSErrorDomain const XYMediatorNoTargetErrorDomain;
FOUNDATION_EXTERN NSErrorDomain const XYMediatorNoActionErrorDomain;
FOUNDATION_EXTERN NSErrorDomain const XYMediatorUnsupportedReturnTypeErrorDomain;

/// Error key
FOUNDATION_EXTERN NSErrorUserInfoKey const XYMediatorErrorKey;


@protocol XYSafetyURLValidator <NSObject>
@required
- (nullable NSURL *)validateUrl:(NSURL *)url; ///< Returns nil if an error occurs.
@end

@protocol XYErrorProcessor <NSObject>
@required
- (void)processError:(NSError *)error; ///< handle error.
@end

@interface XYMediator : NSObject

+ (instancetype)defaultMediator;

/**
 Registers url validator.
 */
+ (void)registerURLValidator:(id<XYSafetyURLValidator>)validator;

/**
 Registers error processor.
 */
+ (void)registerErrorProcessor:(id<XYErrorProcessor>)processor;

/**
 Remote call entrance.
 @param url Standard format url
 @return Returns an error if url is illegal. (url scheme...)
 @example url : scheme://target/action?param=xxx
 */
- (nullable id)performActionWithUrl:(NSURL *)url;

/**
 Local call entrance.
 @param actionName The method name
 @param targetName The object name
 @param param The method parameter
 @return Returns an error if something is illegal. (method name...)
 */
- (nullable id)performAction:(NSString *)actionName
                   forTarget:(NSString *)targetName
                   withParam:(nullable NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
