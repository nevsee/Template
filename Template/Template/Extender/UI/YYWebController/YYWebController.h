//
//  YYWebController.h
//  Template
//
//  Created by nevsee on 2021/11/24.
//

#import "YYBaseController.h"
#import "YYWebAdvertFilter.h"
#import "YYWebSchemeFilter.h"
#import "YYFakeProgressView.h"
#import "XYWebView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^YYWebLoadBlock) (XYWebView *webView);

/// 网页控制器
@interface YYWebController : YYBaseController <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, XYWebPropertyHandler>
@property (nonatomic, strong, readonly) XYWebView *webView;
@property (nonatomic, strong, readonly) YYFakeProgressView *progressView;
@property (nonatomic, strong, readonly) YYWebAdvertFilter *advertFilter;
@property (nonatomic, strong, readonly) YYWebSchemeFilter *schemeFilter;
@property (nonatomic, strong, readonly, nullable) NSURL *originURL; ///< 原始加载地址
@property (nonatomic, strong, nullable) id userInfo; ///< 接受参数
@property (nonatomic, strong, nullable) NSString *link; ///< 链接地址加载
@property (nonatomic, strong, nullable) NSString *path; ///< 本地地址加载
@property (nonatomic, strong, nullable) YYWebLoadBlock loadBlock; ///< 自定义加载
@property (nonatomic, assign) BOOL allowsWebpageTitle; ///< 是否显示网页标题，默认YES
@property (nonatomic, assign) BOOL allowsBackForwardNavigationGestures; ///< 是否允许手势返回上一页，默认YES
@property (nonatomic, assign) BOOL allowsBackForwardNavigationButtons; ///< 是否允许按钮返回上一页，默认YES
@end

@interface YYWebController (YYWebSupport)
- (BOOL)isHttpURL:(NSURL *)url;
- (BOOL)isFileURL:(NSURL *)url;
- (BOOL)isDataURL:(NSURL *)url; ///< base64 string
@end

NS_ASSUME_NONNULL_END
