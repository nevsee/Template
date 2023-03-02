//
//  XYLoadingButton.h
//  XYWidget
//
//  Created by nevsee on 2021/2/25.
//

#import "XYButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYLoadingResultState) {
    XYLoadingResultStateDefault,
    XYLoadingResultStateSuccess,
    XYLoadingResultStateFailure,
};

@protocol XYLoadingButtonAnimator <NSObject>
@required
- (void)startAnimation;
- (void)stopAnimation:(XYLoadingResultState)state completion:(void (^)(void))completion;
@end

@interface XYLoadingButton : XYButton

/// The animation view
@property (nonatomic, weak, readonly) UIView<XYLoadingButtonAnimator> *animator;

/// Whether the animation is finished or not.
@property (nonatomic, assign, readonly, getter=isAnimating) BOOL animating;

/// A mask will be added to the source view to avoid user interaction.
@property (nonatomic, weak, nullable) UIView *sourceView;

/// Maximum loading time
@property (nonatomic, assign) NSUInteger maximumLoadingTime;

/// This is the designated initializer for XYLoadingButton.
+ (instancetype)buttonWithType:(UIButtonType)buttonType animator:(UIView<XYLoadingButtonAnimator> *)animator;

/// Starts loading animation
- (void)startAnimation;

/**
 Stops loading animation
 @param completion A block invoked when the aimation is finished.
 */
- (void)stopAnimation:(XYLoadingResultState)state completion:(void (^ __nullable)(void))completion;
- (void)stopAnimation;
- (void)stopSuccessAnimation;
- (void)stopFailureAnimation;

@end

@interface XYLoadingButtonIndicatorView : UIView <XYLoadingButtonAnimator>

/// The style of the indicator. Defaults to UIActivityIndicatorViewStyleMedium (iOS 13.0) \ UIActivityIndicatorViewStyleWhite.
@property (nonatomic, assign) UIActivityIndicatorViewStyle indicatorStyle UI_APPEARANCE_SELECTOR;

/// The color of the indicator. Defaults to white color.
@property (nonatomic, strong) UIColor *indicatorColor UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END
