//
//  XYWebView.m
//  XYWidget
//
//  Created by nevsee on 2019/8/19.
//

#import "XYWebView.h"
#import "XYWeakProxy.h"

@interface XYWebView ()
@property (nonatomic, strong) NSMutableSet *scriptMessageHanderNameMap;
@property (nonatomic, strong) NSMapTable *propertyHandlerMap;
@end

@implementation XYWebView

#pragma mark # Method
- (void)addUserScript:(WKUserScript *)userScript {
    if (!userScript) return;
    [self.userContentController addUserScript:userScript];
}

- (void)removeAllUserScripts {
    [self.userContentController removeAllUserScripts];
}

- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)handler forName:(NSString *)name {
    if (!handler || !name) return;
    [self.scriptMessageHanderNameMap addObject:name];
    // Avoid retain cycle
    [self.userContentController addScriptMessageHandler:(id)[XYWeakProxy proxyWithTarget:handler] name:name];
}

- (void)removeScriptMessageHandlerForName:(NSString *)name {
    if (!name) return;
    [self.scriptMessageHanderNameMap removeObject:name];
    [self.userContentController removeScriptMessageHandlerForName:name];
}

- (void)removeAllScriptMessageHandlers {
    if (self.scriptMessageHanderNameMap.count == 0) return;
    for (NSString *name in self.scriptMessageHanderNameMap) {
        [self.userContentController removeScriptMessageHandlerForName:name];
    }
    [self.scriptMessageHanderNameMap removeAllObjects];
}

- (void)addPropertyHandler:(id<XYWebPropertyHandler>)handler forKey:(XYWebPropertyKey)key {
    if (!handler || !key) return;
    [self.propertyHandlerMap setObject:handler forKey:key];
    [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)removePropertyHandlerForKey:(XYWebPropertyKey)key {
    if (!key) return;
    [self.propertyHandlerMap removeObjectForKey:key];
    [self removeObserver:self forKeyPath:key];
}

- (void)removeAllPropertyHandlers {
    if (self.propertyHandlerMap.count == 0) return;
    for (NSString *key in self.propertyHandlerMap.keyEnumerator.allObjects) {
        [self removeObserver:self forKeyPath:key];
    }
    [self.propertyHandlerMap removeAllObjects];
}

- (BOOL)registerURLSchemeHandler:(id<WKURLSchemeHandler>)handler forURLScheme:(NSString *)scheme {
    if (!scheme || scheme.length == 0) return NO;
    BOOL defaultScheme = [WKWebView handlesURLScheme:scheme];
    if (!defaultScheme) [self.configuration setURLSchemeHandler:handler forURLScheme:scheme];
    return defaultScheme;
}

- (void)takeSnapshotInRect:(CGRect)rect snapshotWidth:(CGFloat)snapshotWidth completion:(XYWebViewSnapshotCompletion)completion {
    WKSnapshotConfiguration *config = [[WKSnapshotConfiguration alloc] init];
    if (rect.size.width > 0 && rect.size.height > 0) config.rect = rect;
    if (snapshotWidth > 0) config.snapshotWidth = [NSNumber numberWithFloat:snapshotWidth];
    
    [self takeSnapshotWithConfiguration:config completionHandler:^(UIImage *snapshotImage, NSError *error) {
        if (completion) completion(snapshotImage, error);
    }];
}

- (void)takeSnapshotInRect:(CGRect)rect snapshotWidth:(CGFloat)snapshotWidth afterScreenUpdates:(BOOL)afterScreenUpdates completion:(XYWebViewSnapshotCompletion)completion {
    WKSnapshotConfiguration *config = [[WKSnapshotConfiguration alloc] init];
    if (rect.size.width > 0 && rect.size.height > 0) config.rect = rect;
    if (snapshotWidth > 0) config.snapshotWidth = [NSNumber numberWithFloat:snapshotWidth];
    if (@available(iOS 13.0, *)) config.afterScreenUpdates = afterScreenUpdates;
    
    [self takeSnapshotWithConfiguration:config completionHandler:^(UIImage *snapshotImage, NSError *error) {
        if (completion) completion(snapshotImage, error);
    }];
}

+ (void)cleanCachesForTypes:(NSSet<NSString *> *)types completion:(XYWebViewCacheCompletion)completion {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    if (!completion) completion = ^{};
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:types modifiedSince:date completionHandler:completion];
}

+ (void)cleanAllCachesWithCompletion:(XYWebViewCacheCompletion)completion {
    NSSet *types = [WKWebsiteDataStore allWebsiteDataTypes];
    [self cleanCachesForTypes:types completion:completion];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id<XYWebPropertyHandler> handler = [self.propertyHandlerMap objectForKey:keyPath];
    if (handler) {
        XYWebPropertyMessage *message = [[XYWebPropertyMessage alloc] init];
        message.key = keyPath;
        message.value = change[NSKeyValueChangeNewKey];
        [handler webview:self didReceivePropertyMessage:message];
    }
}

#pragma mark # Access

- (WKPreferences *)preferences {
    return self.configuration.preferences;
}

- (WKUserContentController *)userContentController {
    return self.configuration.userContentController;
}

- (void)setDelegate:(id<WKNavigationDelegate,WKUIDelegate>)delegate {
    self.navigationDelegate = delegate;
    self.UIDelegate = delegate;
}

- (NSMutableSet *)scriptMessageHanderNameMap {
    if (!_scriptMessageHanderNameMap) {
        _scriptMessageHanderNameMap = [NSMutableSet set];
    }
    return _scriptMessageHanderNameMap;
}

- (NSMapTable *)propertyHandlerMap {
    if (!_propertyHandlerMap) {
        _propertyHandlerMap = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory
                                                        valueOptions:NSPointerFunctionsWeakMemory
                                                            capacity:0];
    }
    return _propertyHandlerMap;
}

@end


@implementation WKWebView (XYWebSupport)

- (void)xy_updateTextSize:(CGFloat)scale {
    if (scale <= 0) return;
    NSString *js = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='%@%%'";
    js = [NSString stringWithFormat:js, @((int)(scale * 100))];
    [self evaluateJavaScript:js completionHandler:nil];
}

- (void)xy_updateTextColor:(NSString *)color {
    if (!color) return;
    NSString *js = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor='%@'";
    js = [NSString stringWithFormat:js, color];
    [self evaluateJavaScript:js completionHandler:nil];
}

- (void)xy_updateBackgroundColor:(NSString *)color {
    if (!color) return;
    NSString *js = @"document.getElementsByTagName('body')[0].style.background='%@'";
    js = [NSString stringWithFormat:js, color];
    [self evaluateJavaScript:js completionHandler:nil];
}

- (void)xy_findAll:(NSString *)keyword configuration:(XYWebFindConfiguration *)configuration completion:(void (^)(NSInteger, NSError *))completion {
    if (!keyword) return;

    static dispatch_once_t onceToken;
    static NSString *jsCode;
    dispatch_once(&onceToken, ^{
        NSURL *jsPath = [[NSBundle mainBundle] URLForResource:@"XYWebFinder" withExtension:@"js"];
        NSData *jsData = [NSData dataWithContentsOfURL:jsPath];
        jsCode = [[NSString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
    });
    [self evaluateJavaScript:jsCode completionHandler:nil];
    
    // set find configuration
    if (!configuration) configuration = [[XYWebFindConfiguration alloc] init];
    [self _xy_setAppearance:configuration];
    
    NSString *js = @"xy_findAll('%@')";
    js = [NSString stringWithFormat:js, keyword];
    [self evaluateJavaScript:js completionHandler:^(id result, NSError * _Nullable error) {
        if (!completion) return;
        NSInteger count = result && [result isKindOfClass:NSNumber.class] ? [result integerValue] : 0;
        completion(count, error);
    }];
}

- (void)xy_findNext:(BOOL)forward completion:(void (^)(NSInteger, NSError *))completion {
    NSString *js = forward ? @"xy_findNext()" : @"xy_findPrevious()";
    [self evaluateJavaScript:js completionHandler:^(id result, NSError *error) {
        if (!completion) return;
        NSInteger index = result && [result isKindOfClass:NSNumber.class] ? [result integerValue] : 0;
        completion(index, error);
    }];
}

- (void)xy_clearMatchs:(void (^)(NSError *))completion {
    NSString *js = @"xy_clear()";
    [self evaluateJavaScript:js completionHandler:^(id result, NSError *error) {
        if (!completion) return;
        completion(error);
    }];
}

- (void)_xy_setAppearance:(XYWebFindConfiguration *)configuration {
    NSString *js = @"xy_setAppearance('%@', '%@', '%@', '%@', %@, %@)";
    js = [NSString stringWithFormat:js, configuration.normalBackgroundColor, configuration.normalTextColor, configuration.selectedBackgroundColor, configuration.selectedTextColor, @(configuration.caseSensitive), @(configuration.selectsFirstMatch)];
    [self evaluateJavaScript:js completionHandler:nil];
}

@end
