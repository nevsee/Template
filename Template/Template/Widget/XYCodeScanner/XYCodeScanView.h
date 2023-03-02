//
//  XYCodeScanView.h
//  XYCodeScanner
//
//  Created by nevsee on 2021/10/8.
//

#import <UIKit/UIKit.h>
#import "XYCodeScanResult.h"
#import "XYCodeScanAnimator.h"
#import "XYCodeScanIndicator.h"

@class XYCodeScanView;

NS_ASSUME_NONNULL_BEGIN

typedef void (^XYCodeScanDidInitBlock)(XYCodeScanView *scanView, BOOL succeed, BOOL authorized);
typedef void (^XYCodeScanBrightnessBlock)(XYCodeScanView *scanView, CGFloat brightness);
typedef void (^XYCodeScanResultBlock)(XYCodeScanView *scanView, NSArray<XYCodeScanResult *> *results);

@interface XYCodeScanView : UIView

/// Indicates the maximum zoom factor available for the videoZoomFactor property.
/// Values can only be obtained when initialization is complete.
@property (nonatomic, assign, readonly) CGFloat videoMaxZoomFactor;

/// Provides a pinch gesture for image zooming.
@property (nonatomic, strong, readonly) UIPinchGestureRecognizer *pinchGesture;

/// Provides a tap gesture for image zooming.
@property (nonatomic, strong, readonly) UITapGestureRecognizer *tapGesture;

/// Whether the camera permission is authorized.
@property (nonatomic, assign, getter=isAuthorized, readonly) BOOL authorized;

/// Specifies a rectangle of interest for limiting the search area for visual metadata.
/// The default value for this property is CGRectZero.
@property (nonatomic, assign) CGRect rectOfInterest;

/// Controls zoom level of image outputs. Defaults to 3.
@property (nonatomic, assign) CGFloat videoZoomFactor;

/// The audio played when the search is successful. Defaults to nil.
@property (nonatomic, strong, nullable) NSURL *audioUrl;

/// Gives user a feedback when the search is successful. Defaults to UIImpactFeedbackStyleMedium.
/// When the search is successful, the audio will be played first.
@property (nonatomic, assign) UIImpactFeedbackStyle feedbackStyle;

/// Scan animation view.
@property (nonatomic, strong, nullable) XYCodeScanAnimator *animator;

/// Scan result indication view.
@property (nonatomic, strong, nullable) XYCodeScanIndicator *indicator;

@property (nonatomic, strong, nullable) XYCodeScanDidInitBlock didInitBlock;
@property (nonatomic, strong, nullable) XYCodeScanBrightnessBlock brightnessBlock;
@property (nonatomic, strong, nullable) XYCodeScanResultBlock resultBlock;

- (void)startRunning;
- (void)stopRunning;
- (void)restartRunning;

/**
 This method provides a change in zoom by compounding magnification at the specified rate over time.
 @param factor Controls zoom level of image outputs.
 @param rate Controls zoom rate of image outputs.
 */
- (void)rampToVideoZoomFactor:(CGFloat)factor withRate:(CGFloat)rate;

/**
 This method allows a smooth stop to any changes in zoom which were in progress.
 */
- (void)cancelVideoZoomRamp;

@end

NS_ASSUME_NONNULL_END
