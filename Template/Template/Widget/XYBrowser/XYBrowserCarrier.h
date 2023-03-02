//
//  XYBrowserCarrier.h
//  XYBrowser
//
//  Created by nevsee on 2022/10/11.
//

#import <UIKit/UIKit.h>
#import "XYBrowserPlayer.h"
#import "XYBrowserIndicator.h"

@class XYBrowserController;
@class XYBrowserAsset;
@class XYBrowserVideoToolBar;

NS_ASSUME_NONNULL_BEGIN

@protocol XYBrowserCarrierDescriber <NSObject>
@required
@property (nonatomic, assign, readonly) NSUInteger index;
@property (nonatomic, strong, readonly) XYBrowserAsset *asset;
@property (nonatomic, strong, readonly) __kindof UIView *playerView;
@property (nonatomic, strong, readonly) __kindof UIView *contentView;
- (void)startDisplay;
- (void)stopDisplay;
- (void)loadContentWithAsset:(XYBrowserAsset *)asset index:(NSUInteger)index;
- (void)updateSubviewAlphaExceptPlayer:(CGFloat)alpha;
- (void)updateClipsToBounds:(BOOL)clipsToBounds; // image carrier
@end

@interface XYBrowserImageCarrier : UIView <XYBrowserCarrierDescriber>
@property (nonatomic, assign, readonly) NSUInteger index;
@property (nonatomic, strong, readonly) XYBrowserAsset *asset;
@property (nonatomic, strong, readonly) XYBrowserImagePlayer *imagePlayer;
@property (nonatomic, strong, readonly, nullable) __kindof UIView<XYBrowserIndicatorDescriber> *loadingIndicator;
@property (nonatomic, strong, readonly, nullable) __kindof UIView<XYBrowserIndicatorDescriber> *errorIndicator;
@property (nonatomic, strong, readonly) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (nonatomic, weak, nullable) XYBrowserController *browserController;
@end

@interface XYBrowserVideoCarrier : UIView <XYBrowserCarrierDescriber>
@property (nonatomic, assign, readonly) NSUInteger index;
@property (nonatomic, strong, readonly) XYBrowserAsset *asset;
@property (nonatomic, strong, readonly) XYBrowserVideoPlayer *videoPlayer;
@property (nonatomic, strong, readonly) XYBrowserVideoToolBar *toolBar;
@property (nonatomic, strong, readonly) UIButton *playButton;
@property (nonatomic, strong, readonly, nullable) __kindof UIView<XYBrowserIndicatorDescriber> *loadingIndicator;
@property (nonatomic, strong, readonly, nullable) __kindof UIView<XYBrowserIndicatorDescriber> *errorIndicator;
@property (nonatomic, strong, readonly) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (nonatomic, assign) UIEdgeInsets toolBarInsets UI_APPEARANCE_SELECTOR;
@end

@interface XYBrowserVideoToolBar : UIView
@property (nonatomic, strong, readonly) UIButton *playButton;
@property (nonatomic, strong, readonly) UIButton *pauseButton;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UILabel *durationLabel;
@property (nonatomic, strong, readonly) UISlider *progressSlider;
@property (nonatomic, assign) UIEdgeInsets contentInsets UI_APPEARANCE_SELECTOR;
@end

NS_ASSUME_NONNULL_END
