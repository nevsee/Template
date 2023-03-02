//
//  XYBrowserPlayer.h
//  XYBrowser
//
//  Created by nevsee on 2022/10/11.
//

#if __has_include(<SDWebImage/SDWebImage.h>)
#import <SDWebImage/SDWebImage.h>
#else
#import "SDWebImage.h"
#endif

#if __has_include(<VIMediaCache/VIMediaCache.h>)
#import <VIMediaCache/VIMediaCache.h>
#else
#import "VIMediaCache.h"
#endif

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class XYBrowserVideoPlayerView;

typedef NS_ENUM(NSUInteger, XYBrowserAssetState) {
    XYBrowserAssetStateNone,
    XYBrowserAssetStateDownloading,
    XYBrowserAssetStateCompleted,
    XYBrowserAssetStateFailed,
    XYBrowserAssetStateLocal,
};

NS_ASSUME_NONNULL_BEGIN

@interface XYBrowserImagePlayer : UIView <UIScrollViewDelegate>
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) SDAnimatedImageView *imageView;
@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic, strong, readonly, nullable) NSURL *imageURL;
@property (nonatomic, strong, readonly, nullable) UIImage *thumbImage;
@property (nonatomic, assign, readonly) XYBrowserAssetState state;

/// The cached image path.
@property (nonatomic, strong, readonly, nullable) NSString *cachedImagePath;

/// The maximum zoom scale of the image. Defaults to 2.
@property (nonatomic, assign) CGFloat maximumZoomScale;

/// The maximum limited size of the image (width and height). Defaults to 3966.
@property (nonatomic, assign) CGFloat maximumLimitedSize;

/// If the height of the image is more than `tooHighRatio` times the width, the display effect will be optimized.  Defaults to 3.
@property (nonatomic, assign) NSUInteger tooHighRatio;

/// The cache path of the image player.
@property (nonatomic, strong) NSString *cachePath;

/// Indicates whether the image begin to load.
@property (nonatomic, strong, nullable) void (^beginToLoad)(void);

/// Indicates whether the image can successfully be played.
@property (nonatomic, strong, nullable) void (^readyToPlay)(BOOL succeed);

/// Indicates the progress of loading the image.
@property (nonatomic, strong, nullable) void (^progressDidChange)(CGFloat progress);

- (void)loadImageWithURL:(nullable NSURL *)url thumbImage:(nullable UIImage *)thumbImage;
- (void)revertZooming;
- (void)startAnimatedImage;
- (void)stopAnimatedImage;
@end

@interface XYBrowserVideoPlayer : UIView
@property (nonatomic, strong, readonly) XYBrowserVideoPlayerView *playerView;
@property (nonatomic, strong, readonly) NSURL *videoURL;
@property (nonatomic, strong, readonly, nullable) UIImage *thumbImage;
@property (nonatomic, assign, readonly) XYBrowserAssetState state;

/// Indicates the duration of the playback.
@property (nonatomic, assign, readonly) NSTimeInterval duration;

/// Indicates the current time of the playback.
@property (nonatomic, assign, readonly) NSTimeInterval time;

/// The size of the receiver as presented by the player.
@property (nonatomic, assign, readonly) CGSize presentationSize;

/// Indicates whether playback is currently paused indefinitely, suspended while waiting
/// for appropriate conditions, or in progress.
@property (nonatomic, assign, readonly) AVPlayerTimeControlStatus timeControlStatus;

/// This value is set to YES upon receipt of a `-play` message.
@property (nonatomic, assign, readonly) BOOL playEnabled;

/// The cached video path.
@property (nonatomic, strong, readonly, nullable) NSString *cachedVideoPath;

/// Plays the video automatically. Defaults to NO.
@property (nonatomic, assign) BOOL autoplay;

/// The cache path of the video player.
@property (nonatomic, strong) NSString *cachePath;

/// Indicates whether the video begin to load.
@property (nonatomic, strong, nullable) void (^beginToLoad)(void);

/// Indicates whether the video can successfully be played.
@property (nonatomic, strong, nullable) void (^readyToPlay)(BOOL succeed);

/// Indicates whether the playback has finished palying.
@property (nonatomic, strong, nullable) void (^playToEnd)(void);

/// Indicates the progress of the playback.
@property (nonatomic, strong, nullable) void (^timeDidChange)(NSTimeInterval time);

/// Indicates whether playback is currently paused indefinitely, suspended while waiting
/// for appropriate conditions, or in progress.
@property (nonatomic, strong, nullable) void (^timeControlStatusDidChange)(AVPlayerTimeControlStatus status);

- (void)loadVideoWithURL:(nullable NSURL *)url thumbImage:(nullable UIImage *)thumbImage;
- (void)play;
- (void)pause;
- (void)seekToTime:(NSTimeInterval)time completion:(nullable void (^)(BOOL finished))completion;
- (void)stopAndBackToBegin;
- (void)addVideoTimeObserver;
- (void)removeVideoTimeObserver;
@end

@interface XYBrowserVideoPlayerView : UIView
@property (nonatomic, strong, readonly) AVPlayerLayer *playerLayer;
@property (nonatomic, strong, readonly, nullable) UIImage *image; ///< thumb image
@end

NS_ASSUME_NONNULL_END
