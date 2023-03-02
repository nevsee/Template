//
//  XYWebPropertyHandler.h
//  XYWidget
//
//  Created by nevsee on 2019/8/19.
//

#import <Foundation/Foundation.h>
@class XYWebView;

NS_ASSUME_NONNULL_BEGIN

typedef NSString *XYWebPropertyKey;
FOUNDATION_EXTERN XYWebPropertyKey const XYWebPropertyTitleKey; ///< title
FOUNDATION_EXTERN XYWebPropertyKey const XYWebPropertyUrlKey; ///< url
FOUNDATION_EXTERN XYWebPropertyKey const XYWebPropertyLoadingKey; ///< loading
FOUNDATION_EXTERN XYWebPropertyKey const XYWebPropertyProgressKey; ///< estimatedProgress
FOUNDATION_EXTERN XYWebPropertyKey const XYWebPropertySecureContentKey; ///< hasOnlySecureContent
FOUNDATION_EXTERN XYWebPropertyKey const XYWebPropertyServerTrustKey; ///< serverTrust
FOUNDATION_EXTERN XYWebPropertyKey const XYWebPropertyGoBackKey; ///< canGoBack
FOUNDATION_EXTERN XYWebPropertyKey const XYWebPropertyGoForwardKey; ///< canGoForward

@interface XYWebPropertyMessage : NSObject
@property (nonatomic, strong) XYWebPropertyKey key;
@property (nonatomic, strong, nullable) id value;
@end

@protocol XYWebPropertyHandler <NSObject>
@optional
- (void)webview:(XYWebView *)webview didReceivePropertyMessage:(XYWebPropertyMessage *)propertyMessage;
@end



NS_ASSUME_NONNULL_END
