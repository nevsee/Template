//
//  XYRippleAnimationView.h
//  XYWidget
//
//  Created by nevsee on 2022/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYRippleAnimationView : UIView

/// Whether the animation is running or not.
@property (nonatomic, assign, readonly) BOOL animating;

/// The color of the ripple. Defaults to blueColor.
@property (nonatomic, strong) UIColor *rippleColor;

/// The width of the ripple. Defaults to 1.0.
@property (nonatomic, assign) CGFloat rippleWidth;

/// The count of the ripple. Defaults to 3.
@property (nonatomic, assign) NSUInteger rippleCount;

/// The running time of ripple from start to end. Defaults to 2.0.
@property (nonatomic, assign) NSTimeInterval rippleDuration;

/// The interval between two ripples. Defaults to `rippleDuration / rippleCount`.
@property (nonatomic, assign) NSTimeInterval rippleDelay;

/// The running distance of ripple from start to end. Defaults to 0.3.
@property (nonatomic, assign) CGFloat rippleDistanceRatio;

- (void)beginAnimation;
- (void)endAnimation;

@end

NS_ASSUME_NONNULL_END
