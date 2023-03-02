//
//  XYWebView.h
//  XYWidget
//
//  Created by nevsee on 2019/8/19.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "XYWebPropertyHandler.h"
#import "XYWebFindConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^XYWebViewSnapshotCompletion)(UIImage * _Nullable result, NSError * _Nullable error);
typedef void(^XYWebViewCacheCompletion)(void);

@interface XYWebView : WKWebView

/// The preference settings to be used by the web view.
@property (nonatomic, strong, readonly) WKPreferences *preferences;

/// The user content controller to associate with the web view.
@property (nonatomic, strong, readonly) WKUserContentController *userContentController;

/// The web view's navigation and user interface delegate.
@property (nonatomic, weak, nullable) id<WKNavigationDelegate, WKUIDelegate> delegate;

/**
 Adds a user script.
 @param userScript The user script to add.
 */
- (void)addUserScript:(WKUserScript *)userScript;

/**
 Removes all associated user scripts.
 */
- (void)removeAllUserScripts;

/**
 Adds a script message handler to the main world used by page content itself.
 @param handler The script message handler to add.
 @param name The name of the message handler.
 */
- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)handler forName:(NSString *)name;

/**
 Removes a script message handler.
 @param name The name of the message handler.
 */
- (void)removeScriptMessageHandlerForName:(NSString *)name;

/**
 Removes all associated script message handlers.
 */
- (void)removeAllScriptMessageHandlers;

/**
 Adds a property handler.
 @param handler The property handler to add.
 @param key The name of the property handler.
 */
- (void)addPropertyHandler:(id<XYWebPropertyHandler>)handler forKey:(XYWebPropertyKey)key;

/**
 Removes an associated property handler.
 @param key The name of the property handler.
 */
- (void)removePropertyHandlerForKey:(XYWebPropertyKey)key;

/**
 Removes all associated property handlers.
 */
- (void)removeAllPropertyHandlers;

/**
 Registers the URL scheme handler object for the given URL scheme.
 @param handler The object to register.
 @param scheme The URL scheme the object will handle.
 @returns NO if WKWebViews handle the given URL scheme by default.
 @discussion
 1.URL schemes are case insensitive.
 2.Each URL scheme can only have one URL scheme handler object registered. Otherwise an exception will be thrown.
 3.Valid URL schemes must start with an ASCII letter and can only contain ASCII letters, numbers, the '+' character,
 the '-' character, and the '.' character. Otherwise an exception will be thrown.
 */
- (BOOL)registerURLSchemeHandler:(id<WKURLSchemeHandler>)handler forURLScheme:(NSString *)scheme;

/**
 Gets a snapshot for the visible viewport of the webView.
 @param rect The rect to snapshot in view coordinates.
 @param snapshotWidth Specify a custom width to control the size of image you get back.
 @param completion A block to invoke when the snapshot is ready.
 @discussion
 1.This rect should be contained within the webView's bounds. If the rect is set to CGRectZero, the view's bounds will be used.
 2.If the snapshotWidth is 0, rect's width will be used.
 */
- (void)takeSnapshotInRect:(CGRect)rect
             snapshotWidth:(CGFloat)snapshotWidth
                completion:(XYWebViewSnapshotCompletion)completion;

/**
 Gets a snapshot for the visible viewport of the webView.
 @param rect The rect to snapshot in view coordinates.
 @param snapshotWidth Specify a custom width to control the size of image you get back.
 @param afterScreenUpdates A Boolean value that specifies whether the snapshot should be taken after recent changes have been incorporated.
 @param completion A block to invoke when the snapshot is ready.
 @discussion
 1.This rect should be contained within the webView's bounds. If the rect is set to CGRectZero, the view's bounds will be used.
 2.If the snapshotWidth is 0, rect's width will be used.
 */
- (void)takeSnapshotInRect:(CGRect)rect
             snapshotWidth:(CGFloat)snapshotWidth
        afterScreenUpdates:(BOOL)afterScreenUpdates
                completion:(XYWebViewSnapshotCompletion)completion API_AVAILABLE(ios(13.0));

/**
 Removes all website data of the given types that has been modified since the given date.
 @param types The website data types that should be removed.
 @param completion A block to invoke when the cleaning completes.
 @see <WebKit/WKWebsiteDataRecord.h>
 */
+ (void)cleanCachesForTypes:(NSSet<NSString *> *)types completion:(nullable XYWebViewCacheCompletion)completion;

/**
 Removes all website data of the given types.
 @param completion A block to invoke when the cleaning completes.
 */
+ (void)cleanAllCachesWithCompletion:(nullable XYWebViewCacheCompletion)completion;

@end

@interface WKWebView (XYWebSupport)

/**
 Updates the text font of the web page.
 @param scale The text font to change. (0~1 reduce, 1~∞ magnify)
 */
- (void)xy_updateTextSize:(CGFloat)scale;

/**
 Updates the text color of the web page.
 @param color The text color to change. (HEX #FFFFFF)
 */
- (void)xy_updateTextColor:(NSString *)color;

/**
 Updates the background color of the web page.
 @param color The background color to change. (HEX #FFFFFF)
 */
- (void)xy_updateBackgroundColor:(NSString *)color;

/**
 Searches the page contents for the given string.
 @param keyword The string to search for.
 @param configuration  A set of options configuring the search.
 @param completion A block to invoke when the search completes.
 @discussion
 The first match is selected and the page is scrolled to reveal the selection.
 */
- (void)xy_findAll:(NSString *)keyword
     configuration:(nullable XYWebFindConfiguration *)configuration
        completion:(void (^ __nullable)(NSInteger count, NSError * _Nullable error))completion;

/**
 Highlights and scrolls to the next match.
 @param forward The direction to search.
 @param completion A block to invoke when the search completes.
 */
- (void)xy_findNext:(BOOL)forward completion:(void (^ __nullable)(NSInteger index, NSError * _Nullable error))completion;

/**
 Clears the highlighting surrounding text matches.
 @param completion A block to invoke when the clear completes.
 */
- (void)xy_clearMatchs:(void (^ __nullable)(NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
