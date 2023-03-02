//
//  YYWebController.m
//  Template
//
//  Created by nevsee on 2021/11/24.
//

#import "YYWebController.h"
#import "YYGlobalUtility+Date.h"
#import "YYCacheManager.h"
#import "XYStorage.h"

@interface YYWebController () <WKHTTPCookieStoreObserver, UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong, readwrite) XYWebView *webView;
@property (nonatomic, strong, readwrite) YYFakeProgressView *progressView;
@property (nonatomic, strong, readwrite) YYWebAdvertFilter *advertFilter;
@property (nonatomic, strong, readwrite) YYWebSchemeFilter *schemeFilter;
@property (nonatomic, strong) XYArchiver *archiver;
@property (nonatomic, strong) UIBarButtonItem *closeItem;
@end

@implementation YYWebController

- (void)didInitialize {
    [super didInitialize];
    self.xy_supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
    _allowsWebpageTitle = YES;
    _allowsBackForwardNavigationGestures = YES;
    _allowsBackForwardNavigationButtons = YES;
}

- (void)parameterSetup {
    [super parameterSetup];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(advertDidChangeNotice)
                                                 name:YYWebAdvertDidChangeNotification
                                               object:nil];
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
}

- (void)startLoading {
    @weakify(self)
    [self fetchCookiesWithCompletion:^{
        @strongify(self)
        if (self.link || self.path) {
            NSURL *url = self.link ? [NSURL URLWithString:self.link] : [NSURL fileURLWithPath:self.path];
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
            [self.webView loadRequest:request];
        } else if (self.loadBlock) {
            self.loadBlock(self.webView);
        }
        self->_originURL = self.webView.URL;
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat y = self.xy_navigationBarHidden ? 0 : self.navigationController.navigationBar.xy_bottom;
    _webView.frame = CGRectMake(0, y, self.view.xy_width, self.view.xy_height - y);
    _progressView.frame = CGRectMake(0, y, self.view.xy_width, 0);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_webView.configuration.websiteDataStore.httpCookieStore removeObserver:self];
    [_webView removeAllPropertyHandlers];
    [_webView removeAllUserScripts];
    [_webView removeAllScriptMessageHandlers];
    _webView.delegate = nil;
    _webView = nil;
}

#pragma mark # Delegate

// WKNavigationDelegate
- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    WKNavigationActionPolicy policy = WKNavigationActionPolicyCancel;
    
    // data url
    if ([self isDataURL:url]) {
        NSString *base64String = url.absoluteString;
        NSData *fileData = [NSData dataWithContentsOfURL:url];
        NSString *timestamp = [YYGlobalUtility getCurrentMillisecondTimestamp];
        NSString *fileExtension = [NSURL xy_getFileExtensionForMimeType:base64String.xy_mimeTypeForBase64String];
        NSString *filePath = [YYCacheManager.tmpPath stringByAppendingFormat:@"/translate_%@.%@", timestamp, fileExtension];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        [fileData writeToURL:fileURL atomically:YES];
        UIDocumentInteractionController *document = [[UIDocumentInteractionController alloc] init];
        document.URL = fileURL;
        document.delegate = self;
        [document presentPreviewAnimated:YES];
        decisionHandler(policy);
        return;
    }
    
    // check scheme
    YYWebSchemeFilterResult retult = [self.schemeFilter filterScheme:url.scheme];
    if (retult == YYWebSchemeFilterResultValid) {
        XYAlertController *vc = [XYAlertController alertWithTitle:@"即将跳转到第三方应用" message:nil cancel:@"取消" actions:@[@"确定"] preferredStyle:XYAlertControllerStyleAlert];
        vc.afterHandler = ^(__kindof XYAlertAction *action) {
            if (action.tag == 0) return;
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:nil];
        };
        [vc presentInController:self];
    }  else {
        policy = WKNavigationActionPolicyAllow;
    }
    decisionHandler(policy);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [_progressView begin];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [_progressView commit];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [_progressView end];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [_progressView end];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

}

// WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame || !navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

// XYWebPropertyHandler
- (void)webview:(XYWebView *)webview didReceivePropertyMessage:(XYWebPropertyMessage *)propertyMessage {
    if (propertyMessage.key == XYWebPropertyTitleKey) {
        if (!_allowsWebpageTitle) return;
        self.title = propertyMessage.value;
    } else if (propertyMessage.key == XYWebPropertyGoBackKey || propertyMessage.key == XYWebPropertyGoForwardKey) {
        if (!_allowsBackForwardNavigationButtons) return;
        if (webview.canGoBack) {
            [self.navigationItem setLeftBarButtonItems:@[self.xy_backItem, self.closeItem]];
        } else {
            [self.navigationItem setLeftBarButtonItems:@[self.xy_backItem]];
        }
    }
}

// WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
}

// WKHTTPCookieStoreObserver
- (void)cookiesDidChangeInCookieStore:(WKHTTPCookieStore *)cookieStore {
    [cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> *cookies) {
        [self.archiver saveObject:cookies forKey:@"Cookies.ferrycookies"];
    }];
}

// UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
    [YYCacheManager deleteCacheAtPath:controller.URL];
}

#pragma mark # Action

- (void)backAction {
    if (_allowsBackForwardNavigationButtons && [_webView canGoBack]) {
        [_webView goBack];
    } else {
        [self closeAction];
    }
}

- (void)closeAction {
    if (self.navigationController.viewControllers.count > 1) {
        [self xy_popViewController];
    } else {
        [self xy_dismissViewController];
    }
}

- (void)advertDidChangeNotice {
    WKContentRuleListStore *ruleListStore = [WKContentRuleListStore defaultStore];
    NSString *encodedContentRuleList = [self.advertFilter getEncodedContentRuleString];
    [ruleListStore compileContentRuleListForIdentifier:@"rule" encodedContentRuleList:encodedContentRuleList completionHandler:^(WKContentRuleList *ruleList, NSError *error) {
        if (!ruleList) return;
        [self.webView.userContentController addContentRuleList:ruleList];
    }];
}

#pragma mark # Method

- (BOOL)xy_poppingByInteractiveGestureRecognizer {
    // 横屏禁止手势返回
    return ![UIApplication sharedApplication].xy_isInterfaceLandscape;
}

- (void)fetchCookiesWithCompletion:(void (^)(void))completion {
    [self.archiver objectForKey:@"Cookies.ferrycookies" classes:@[NSArray.class, NSHTTPCookie.class] completion:^(BOOL succeed, NSArray *results) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSHTTPCookie *cookie in results.firstObject) {
                [[WKWebsiteDataStore defaultDataStore].httpCookieStore setCookie:cookie completionHandler:nil];
            }
            if (completion) completion();
        });
    }];
}

#pragma mark # Access

- (XYWebView *)webView {
    if (!_webView) {
        WKPreferences *preferences = [[WKPreferences alloc] init];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;

        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = preferences;
        configuration.websiteDataStore = [WKWebsiteDataStore defaultDataStore];

        WKContentRuleListStore *ruleListStore = [WKContentRuleListStore defaultStore];
        NSString *encodedContentRuleList = [self.advertFilter getEncodedContentRuleString];
        [ruleListStore compileContentRuleListForIdentifier:@"advert.filter" encodedContentRuleList:encodedContentRuleList completionHandler:^(WKContentRuleList *ruleList, NSError *error) {
            if (!ruleList) return;
            [configuration.userContentController addContentRuleList:ruleList];
        }];

        XYWebView *webView = [[XYWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        webView.delegate = self;
        webView.allowsBackForwardNavigationGestures = _allowsBackForwardNavigationGestures;
        webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [webView.configuration.websiteDataStore.httpCookieStore addObserver:self];
        [webView addPropertyHandler:self forKey:XYWebPropertyTitleKey];
        [webView addPropertyHandler:self forKey:XYWebPropertyGoBackKey];
        [webView addPropertyHandler:self forKey:XYWebPropertyGoForwardKey];
        _webView = webView;
    }
    return _webView;
}

- (YYFakeProgressView *)progressView {
    if (!_progressView) {
        YYFakeProgressView *progressView = [[YYFakeProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        progressView.hidesWhenCommitted = YES;
        progressView.progressTintColor = YYTheme1Color;
        progressView.trackTintColor = UIColor.clearColor;
        _progressView = progressView;
    }
    return _progressView;
}

- (YYWebAdvertFilter *)advertFilter {
    if (!_advertFilter) {
        YYWebAdvertFilter *advertFilter = [YYWebAdvertFilter defaultFilter];
        _advertFilter = advertFilter;
    }
    return _advertFilter;
}

- (YYWebSchemeFilter *)schemeFilter {
    if (!_schemeFilter) {
        YYWebSchemeFilter *schemeFilter = [YYWebSchemeFilter defaultFilter];
        _schemeFilter = schemeFilter;
    }
    return _schemeFilter;
}

- (XYArchiver *)archiver {
    if (!_archiver) {
        NSString *path = [YYCacheManager.libraryPath stringByAppendingPathComponent:@"Cookies"];
        XYArchiver *archiver = [[XYArchiver alloc] initWithPath:path];
        _archiver = archiver;
    }
    return _archiver;
}

- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        UIBarButtonItem *item = [UIBarButtonItem xy_itemWithImage:XYImageMake(@"close_1")
                                                        alignment:UIControlContentHorizontalAlignmentLeft
                                                           target:self
                                                           action:@selector(closeAction)];
        _closeItem = item;
    }
    return _closeItem;
}

- (void)setAllowsBackForwardNavigationGestures:(BOOL)allowsBackForwardNavigationGestures {
    _allowsBackForwardNavigationGestures = allowsBackForwardNavigationGestures;
    self.webView.allowsBackForwardNavigationGestures = allowsBackForwardNavigationGestures;
}

@end

#pragma mark -

@implementation YYWebController (YYWebSupport)

- (BOOL)isHttpURL:(NSURL *)url {
    BOOL isHttp = [url.scheme.lowercaseString isEqualToString:@"http"];
    BOOL isHttps = [url.scheme.lowercaseString isEqualToString:@"https"];
    return isHttp|| isHttps;
}

- (BOOL)isFileURL:(NSURL *)url {
    return [url isFileURL];
}

- (BOOL)isDataURL:(NSURL *)url {
    return [url.scheme.lowercaseString isEqualToString:@"data"];
}

@end
