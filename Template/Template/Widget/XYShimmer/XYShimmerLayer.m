//
//  XYShimmerLayer.h
//  XYWidget
//
//  Created by nevsee on 2017/5/25.
//

#import "XYShimmerLayer.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAGradientLayer.h>
#import <QuartzCore/CATransaction.h>
#import <UIKit/UIGeometry.h>
#import <UIKit/UIColor.h>

#if TARGET_IPHONE_SIMULATOR
// UIKit private drag coeffient, use judiciously
UIKIT_EXTERN float UIAnimationDragCoefficient(void);
#endif

static CGFloat XYShimmerLayerDragCoefficient(void) {
#if TARGET_IPHONE_SIMULATOR
    return UIAnimationDragCoefficient();
#else
    return 1.0;
#endif
}

static void XYShimmerLayerAnimationApplyDragCoefficient(CAAnimation *animation) {
    CGFloat k = XYShimmerLayerDragCoefficient();
    if (k != 0 && k != 1) {
        animation.speed = 1 / k;
    }
}

static CABasicAnimation *XYShimmerFadeAnimation(CALayer *layer, CGFloat opacity, CFTimeInterval duration) {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @([(layer.presentationLayer ?: layer) opacity]);
    animation.toValue = @(opacity);
    animation.fillMode = kCAFillModeBoth;
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    XYShimmerLayerAnimationApplyDragCoefficient(animation);
    return animation;
}

static CABasicAnimation *XYShimmerSlideAnimation(CFTimeInterval duration, XYShimmerDirection direction) {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.toValue = [NSValue valueWithCGPoint:CGPointZero];
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    XYShimmerLayerAnimationApplyDragCoefficient(animation);
    if (direction == XYShimmerDirectionLeft || direction == XYShimmerDirectionUp) {
        animation.speed = -fabsf(animation.speed);
    }
    return animation;
}

// take a shimmer slide animation and turns into repeating
static CAAnimation *XYShimmerSlideRepeat(CAAnimation *a, CFTimeInterval duration, XYShimmerDirection direction) {
    CAAnimation *anim = [a copy];
    anim.repeatCount = HUGE_VALF;
    anim.duration = duration;
    anim.speed = (direction == XYShimmerDirectionRight || direction == XYShimmerDirectionDown) ? fabsf(anim.speed) : -fabsf(anim.speed);
    return anim;
}

// take a shimmer slide animation and turns into finish
static CAAnimation *XYShimmerSlideFinish(CAAnimation *a) {
    CAAnimation *anim = [a copy];
    anim.repeatCount = 0;
    return anim;
}

static NSString *const kXYShimmerSlideAnimationKey = @"slide";
static NSString *const kXYShimmerFadeAnimationKey = @"fade";
static NSString *const kXYShimmerEndFadeAnimationKey = @"endFade";

#pragma mark -

@interface XYShimmerMaskLayer : CAGradientLayer
@property (nonatomic, strong, readonly) CALayer *fadeLayer;
@end

@implementation XYShimmerMaskLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        _fadeLayer = [[CALayer alloc] init];
        _fadeLayer.backgroundColor = [UIColor whiteColor].CGColor;
        [self addSublayer:_fadeLayer];
    }
    return self;
}

- (void)layoutSublayers {
    [super layoutSublayers];
    CGRect bounds = self.bounds;
    _fadeLayer.bounds = bounds;
    _fadeLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

@end

#pragma mark -

@interface XYShimmerLayer () <CALayerDelegate, CAAnimationDelegate>
@property (nonatomic, strong) XYShimmerMaskLayer *maskLayer;
@end

@implementation XYShimmerLayer
@synthesize shimmering = _shimmering;
@synthesize shimmeringPauseDuration = _shimmeringPauseDuration;
@synthesize shimmeringAnimationOpacity = _shimmeringAnimationOpacity;
@synthesize shimmeringOriginOpacity = _shimmeringOriginOpacity;
@synthesize shimmeringSpeed = _shimmeringSpeed;
@synthesize shimmeringHighlightLength = _shimmeringHighlightLength;
@synthesize shimmeringDirection = _shimmeringDirection;
@synthesize shimmeringFadeTime = _shimmeringFadeTime;
@synthesize shimmeringBeginFadeDuration = _shimmeringBeginFadeDuration;
@synthesize shimmeringEndFadeDuration = _shimmeringEndFadeDuration;
@synthesize shimmeringBeginTime = _shimmeringBeginTime;

- (instancetype)init {
    self = [super init];
    if (self) {
        _shimmeringPauseDuration = 0.2;
        _shimmeringSpeed = 200;
        _shimmeringHighlightLength = 1.0;
        _shimmeringAnimationOpacity = 0.4;
        _shimmeringOriginOpacity = 1.0;
        _shimmeringDirection = XYShimmerDirectionRight;
        _shimmeringBeginFadeDuration = 0.1;
        _shimmeringEndFadeDuration = 0.2;
        _shimmeringBeginTime = -1;
    }
    return self;
}

- (void)layoutSublayers {
    [super layoutSublayers];
    
    CGRect bounds = self.bounds;
    _contentLayer.anchorPoint = CGPointMake(0.5, 0.5);
    _contentLayer.bounds = bounds;
    _contentLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    if (_maskLayer) [self updateMaskLayout];
}

- (void)setBounds:(CGRect)bounds {
    CGRect oldBounds = self.bounds;
    [super setBounds:bounds];
 
    if (!CGRectEqualToRect(oldBounds, bounds)) [self updateShimmer];
}

#pragma mark # Delegate

// CALayerDelegate
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    return (id)kCFNull;
}

// CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag && [[anim valueForKey:kXYShimmerEndFadeAnimationKey] boolValue]) {
        [_maskLayer.fadeLayer removeAnimationForKey:kXYShimmerFadeAnimationKey];
        [self clearMask];
    }
}

#pragma mark # Method

- (void)clearMask {
    if (!_maskLayer) return;

    BOOL disableActions = [CATransaction disableActions];
    [CATransaction setDisableActions:YES];
    self.maskLayer = nil;
    _contentLayer.mask = nil;
    [CATransaction setDisableActions:disableActions];
}

- (void)createMaskIfNeeded {
    if (_shimmering && !_maskLayer) {
        _maskLayer = [XYShimmerMaskLayer layer];
        _maskLayer.delegate = self;
        _contentLayer.mask = _maskLayer;
        [self updateMaskColors];
        [self updateMaskLayout];
    }
}

- (void)updateMaskColors {
    if (!_maskLayer) return;

    // We create a gradient to be used as a mask.
    // In a mask, the colors do not matter, it's the alpha that decides the degree of masking.
    UIColor *maskedColor = [UIColor colorWithWhite:1.0 alpha:_shimmeringOriginOpacity];
    UIColor *unmaskedColor = [UIColor colorWithWhite:1.0 alpha:_shimmeringAnimationOpacity];

    // Create a gradient from masked to unmasked to masked.
    _maskLayer.colors = @[(__bridge id)maskedColor.CGColor, (__bridge id)unmaskedColor.CGColor, (__bridge id)maskedColor.CGColor];
}

- (void)updateMaskLayout {
    // Everything outside the mask layer is hidden, so we need to create a mask long enough for
    // the shimmered layer to be always covered by the mask.
    CGFloat length = 0.0f;
    if (_shimmeringDirection == XYShimmerDirectionDown || _shimmeringDirection == XYShimmerDirectionUp) {
        length = CGRectGetHeight(_contentLayer.bounds);
    } else {
        length = CGRectGetWidth(_contentLayer.bounds);
    }
    if (length == 0) return;

    // extra distance for the gradient to travel during the pause.
    CGFloat extraDistance = length + _shimmeringSpeed * _shimmeringPauseDuration;
    
    // compute how far the shimmering goes
    CGFloat fullShimmerLength = length * 3.0f + extraDistance;
    CGFloat travelDistance = length * 2.0f + extraDistance;
    
    // position the gradient for the desired width
    CGFloat highlightOutsideLength = (1.0 - _shimmeringHighlightLength) / 2.0;
    _maskLayer.locations = @[@(highlightOutsideLength), @(0.5), @(1.0 - highlightOutsideLength)];

    CGFloat startPoint = (length + extraDistance) / fullShimmerLength;
    CGFloat endPoint = travelDistance / fullShimmerLength;
  
    // position for the start of the animation
    _maskLayer.anchorPoint = CGPointZero;
    if (_shimmeringDirection == XYShimmerDirectionDown || _shimmeringDirection == XYShimmerDirectionUp) {
        _maskLayer.startPoint = CGPointMake(0.0, startPoint);
        _maskLayer.endPoint = CGPointMake(0.0, endPoint);
        _maskLayer.position = CGPointMake(0.0, -travelDistance);
        _maskLayer.bounds = CGRectMake(0.0, 0.0, CGRectGetWidth(_contentLayer.bounds), fullShimmerLength);
    } else {
        _maskLayer.startPoint = CGPointMake(startPoint, 0.0);
        _maskLayer.endPoint = CGPointMake(endPoint, 0.0);
        _maskLayer.position = CGPointMake(-travelDistance, 0.0);
        _maskLayer.bounds = CGRectMake(0.0, 0.0, fullShimmerLength, CGRectGetHeight(_contentLayer.bounds));
    }
}

- (void)updateShimmer {
    // create mask if needed
    [self createMaskIfNeeded];
    
    // if not shimmering and no mask, noop
    if (!_shimmering && !_maskLayer) return;
    
    // ensure layout
    [self layoutIfNeeded];

    BOOL disableActions = [CATransaction disableActions];
    if (!_shimmering) {
        if (disableActions) {
            // simply remove mask
            [self clearMask];
        } else {
            // end slide
            CFTimeInterval slideEndTime = 0;
            CAAnimation *slideAnimation = [_maskLayer animationForKey:kXYShimmerSlideAnimationKey];
            
            if (slideAnimation) {
                // determine total time sliding
                CFTimeInterval now = CACurrentMediaTime();
                CFTimeInterval slideTotalDuration = now - slideAnimation.beginTime;
                // determine time offset into current slide
                CFTimeInterval slideTimeOffset = fmod(slideTotalDuration, slideAnimation.duration);
                // transition to non-repeating slide
                CAAnimation *finishAnimation = XYShimmerSlideFinish(slideAnimation);
                // adjust begin time to now - offset
                finishAnimation.beginTime = now - slideTimeOffset;
                // note slide end time and begin
                slideEndTime = finishAnimation.beginTime + slideAnimation.duration;
                [_maskLayer addAnimation:finishAnimation forKey:kXYShimmerSlideAnimationKey];
            }

            // fade in text at slideEndTime
            CABasicAnimation *fadeInAnimation = XYShimmerFadeAnimation(_maskLayer.fadeLayer, 1.0, _shimmeringEndFadeDuration);
            fadeInAnimation.delegate = self;
            fadeInAnimation.beginTime = slideEndTime;
            [fadeInAnimation setValue:@YES forKey:kXYShimmerEndFadeAnimationKey];
            [_maskLayer.fadeLayer addAnimation:fadeInAnimation forKey:kXYShimmerFadeAnimationKey];

            // expose end time for synchronization
            _shimmeringFadeTime = slideEndTime;
        }
    } else {
        // fade out text, optionally animated
        CABasicAnimation *fadeOutAnimation = nil;
        if (_shimmeringBeginFadeDuration > 0.0 && !disableActions) {
            fadeOutAnimation = XYShimmerFadeAnimation(_maskLayer.fadeLayer, 0.0, _shimmeringBeginFadeDuration);
            [_maskLayer.fadeLayer addAnimation:fadeOutAnimation forKey:kXYShimmerFadeAnimationKey];
        } else {
            BOOL innerDisableActions = [CATransaction disableActions];
            [CATransaction setDisableActions:YES];
            _maskLayer.fadeLayer.opacity = 0.0;
            [_maskLayer.fadeLayer removeAllAnimations];
            [CATransaction setDisableActions:innerDisableActions];
        }

        // begin slide animation
        CAAnimation *slideAnimation = [_maskLayer animationForKey:kXYShimmerSlideAnimationKey];

        // compute shimmer duration
        CGFloat length = 0.0f;
        if (_shimmeringDirection == XYShimmerDirectionDown || _shimmeringDirection == XYShimmerDirectionUp) {
            length = CGRectGetHeight(_contentLayer.bounds);
        } else {
            length = CGRectGetWidth(_contentLayer.bounds);
        }
        CFTimeInterval animationDuration = (length / _shimmeringSpeed) + _shimmeringPauseDuration;

        if (slideAnimation) {
            // ensure existing slide animation repeats
            [_maskLayer addAnimation:XYShimmerSlideRepeat(slideAnimation, animationDuration, _shimmeringDirection) forKey:kXYShimmerSlideAnimationKey];
        } else {
            // add slide animation
            slideAnimation = XYShimmerSlideAnimation(animationDuration, _shimmeringDirection);
            slideAnimation.fillMode = kCAFillModeForwards;
            slideAnimation.removedOnCompletion = NO;
            if (_shimmeringBeginTime == -1) {
                _shimmeringBeginTime = CACurrentMediaTime() + fadeOutAnimation.duration;
            }
            slideAnimation.beginTime = _shimmeringBeginTime;
            [_maskLayer addAnimation:slideAnimation forKey:kXYShimmerSlideAnimationKey];
        }
    }
}

#pragma mark # Access

- (void)setContentLayer:(CALayer *)contentLayer {
    self.maskLayer = nil;
    _contentLayer = contentLayer;
    self.sublayers = contentLayer ? @[contentLayer] : nil;
    [self updateShimmer];
}

- (void)setShimmering:(BOOL)shimmering {
    if (shimmering != _shimmering) {
      _shimmering = shimmering;
      [self updateShimmer];
    }
}

- (void)setShimmeringSpeed:(CGFloat)velocity {
    if (velocity != _shimmeringSpeed) {
        _shimmeringSpeed = velocity;
        [self updateShimmer];
    }
}

- (void)setHighlightLength:(CGFloat)highlightLength {
    if (highlightLength != _shimmeringHighlightLength) {
        _shimmeringHighlightLength = highlightLength;
        [self updateShimmer];
    }
}

- (void)setDirection:(XYShimmerDirection)direction {
    if (direction != _shimmeringDirection) {
        _shimmeringDirection = direction;
        [self updateShimmer];
    }
}

- (void)setPauseDuration:(CFTimeInterval)pauseDuration {
    if (pauseDuration != _shimmeringPauseDuration) {
        _shimmeringPauseDuration = pauseDuration;
        [self updateShimmer];
    }
}

- (void)setAnimationOpacity:(CGFloat)animationOpacity {
    if (animationOpacity != _shimmeringAnimationOpacity) {
        _shimmeringAnimationOpacity = animationOpacity;
        [self updateMaskColors];
    }
}

- (void)setOriginOpacity:(CGFloat)originOpacity {
    if (originOpacity != _shimmeringOriginOpacity) {
        _shimmeringOriginOpacity = originOpacity;
        [self updateMaskColors];
    }
}

- (void)setBeginTime:(CFTimeInterval)beginTime {
    if (beginTime != _shimmeringBeginTime) {
        _shimmeringBeginTime = beginTime;
        [self updateShimmer];
    }
}

@end
