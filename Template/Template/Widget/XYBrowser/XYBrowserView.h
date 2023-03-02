//
//  XYBrowserView.h
//  XYBrowser
//
//  Created by nevsee on 2022/9/21.
//

#import <UIKit/UIKit.h>
#import "XYBrowserCarrier.h"
#import "XYBrowserPlayer.h"
#import "XYBrowserIndicator.h"

@class XYBrowserAsset;
@protocol XYBrowserViewDataSource;
@protocol XYBrowserViewDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYBrowserViewMediaType) {
    XYBrowserViewMediaTypeImage,
    XYBrowserViewMediaTypeVideo,
};

@interface XYBrowserView : UIView

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

/// The spacing of the list item. Defaults to 20.
@property (nonatomic, assign) CGFloat itemSpacing UI_APPEARANCE_SELECTOR;

/// The maximum zoom scale of the image. Defaults to 2.
@property (nonatomic, assign) CGFloat maximumZoomScale UI_APPEARANCE_SELECTOR;

/// The maximum limited size of the image (width and height). Defaults to 3966.
@property (nonatomic, assign) CGFloat maximumLimitedSize UI_APPEARANCE_SELECTOR;

/// If the height of the image is more than `tooHighRatio` times the width, the display effect will be optimized. Defaults to 3.
@property (nonatomic, assign) NSUInteger tooHighRatio UI_APPEARANCE_SELECTOR;

/// Whether or not to reset the animated image's current frame index when animation stopped. Defaults to NO.
@property (nonatomic, assign) BOOL resetFrameIndexWhenStopped UI_APPEARANCE_SELECTOR;

/// Autoplay when the first displayed asset is video. Defaults to YES.
@property (nonatomic, assign) BOOL autoplayVideoWhenDisplayFirstly UI_APPEARANCE_SELECTOR;

/// Uses for displaying the image and video.
/// By default we use `XYBrowserImageCarrier`/ `XYBrowserVideoCarrier` class, and you can also customize carrier class by inheriting them.
@property (nonatomic, strong, null_resettable) Class imageCarrierClass UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong, null_resettable) Class videoCarrierClass UI_APPEARANCE_SELECTOR;

/// The cache path of the image and video. Defaults to `.../Caches/com.nevsee.XYBrowserCahce`.
@property (nonatomic, strong, null_resettable) NSString *cachePath UI_APPEARANCE_SELECTOR;
@property (class, nonatomic, strong, null_resettable) NSString *defaultCachePath;

@property (nonatomic, strong, nullable) void (^didScrollToIndexBlock)(NSInteger index);
@property (nonatomic, strong, nullable) void (^willScrollHalfToIndexBlock)(NSInteger index);

@property (nonatomic, weak, nullable) id<XYBrowserViewDelegate> delegate;
@property (nonatomic, weak, nullable) id<XYBrowserViewDataSource> dataSource;
@property (nonatomic, strong, nullable) NSArray<XYBrowserAsset *> *datas;

@property (nonatomic, assign) NSUInteger totalIndex;
@property (nonatomic, assign) NSUInteger currentIndex;
- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated;

/**
 Returns the carrier view / asset at the given index.
 */
- (UIView<XYBrowserCarrierDescriber> *)carrierViewAtIndex:(NSInteger)index;
- (UIView<XYBrowserCarrierDescriber> *)currentCarrierView;
- (XYBrowserAsset *)assetAtIndex:(NSInteger)index;
- (XYBrowserAsset *)currentAsset;

/**
 Updates subview's info. (Subclass override)
 */
- (void)updateSubviewAlphaExceptCarrier:(CGFloat)alpha;
- (void)updateSubviewValue;

@end

@protocol XYBrowserViewDataSource <NSObject>
@required
- (NSUInteger)numberOfAssetsInBrowserView:(XYBrowserView *)browserView;
- (XYBrowserAsset *)browserView:(XYBrowserView *)browserView assetAtIndex:(NSUInteger)index;
@end

@protocol XYBrowserViewDelegate <NSObject>
@optional
- (void)browserView:(XYBrowserView *)browserView didScrollToIndex:(NSUInteger)index;
- (void)browserView:(XYBrowserView *)browserView willScrollHalfToIndex:(NSUInteger)index;
@end

@interface XYBrowserAsset : NSObject
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) NSURL *originURL; ///< support file url
@property (nonatomic, assign) XYBrowserViewMediaType mediaType;
@end

@interface XYBrowserAsset (XYImageSupport)
+ (UIImage *)imageWithContentsOfFile:(NSString *)path; ///< support animated image
+ (UIImage *)imageWithContentsOfURL:(NSURL *)url; ///< support animated image
@end


NS_ASSUME_NONNULL_END
