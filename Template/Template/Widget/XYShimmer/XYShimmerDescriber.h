//
//  XYShimmerDescriber.h
//  XYWidget
//
//  Created by nevsee on 2017/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYShimmerDirection) {
    XYShimmerDirectionUp,
    XYShimmerDirectionDown,
    XYShimmerDirectionLeft,
    XYShimmerDirectionRight
};

@protocol XYShimmerDescriber <NSObject>

/// Set this to YES to start shimming and NO to stop. Defaults to NO.
@property (nonatomic, assign, getter=isShimmering) BOOL shimmering;

/// The time interval between shimmerings in seconds. Defaults to 0.2.
@property (nonatomic, assign) CFTimeInterval shimmeringPauseDuration;

/// The opacity of the content while it is shimmering. Defaults to 0.4.
@property (nonatomic, assign) CGFloat shimmeringAnimationOpacity;

/// The opacity of the content before it is shimmering. Defaults to 1.0.
@property (nonatomic, assign) CGFloat shimmeringOriginOpacity;

/// The velocity of shimmering, in points per second. Defaults to 200.
@property (nonatomic, assign) CGFloat shimmeringSpeed;

/// The highlight length of shimmering. Range of [0,1], defaults to 1.0.
@property (nonatomic, assign) CGFloat shimmeringHighlightLength;

/// The direction of shimmering animation. Defaults to FBShimmerDirectionRight.
@property (nonatomic, assign) XYShimmerDirection shimmeringDirection;

/// The duration of the fade used when shimmer begins. Defaults to 0.1
@property (nonatomic, assign) CFTimeInterval shimmeringBeginFadeDuration;

/// The duration of the fade used when shimmer ends. Defaults to 0.2.
@property (nonatomic, assign) CFTimeInterval shimmeringEndFadeDuration;

/// The absolute CoreAnimation media time when the shimmer will begin.
/// Only valid after setting shimmering to YES.
@property (nonatomic, assign) CFTimeInterval shimmeringBeginTime;

/// The absolute CoreAnimation media time when the shimmer will fade in.
/// Only valid after setting shimmering to NO.
@property (nonatomic, assign, readonly) CFTimeInterval shimmeringFadeTime;

@end

NS_ASSUME_NONNULL_END
