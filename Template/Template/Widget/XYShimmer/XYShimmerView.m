//
//  XYShimmerLayer.h
//  XYWidget
//
//  Created by nevsee on 2017/5/25.
//

#import "XYShimmerView.h"
#import "XYShimmerLayer.h"

@interface XYShimmerView ()
@property (nonatomic, readonly) XYShimmerLayer *shimmerLayer;
@end

@implementation XYShimmerView

+ (Class)layerClass {
    return [XYShimmerLayer class];
}

- (void)layoutSubviews {
    // Autolayout requires these to be set on the UIView, not the CALayer.
    // Do this *before* the layer has a chance to set the properties, as the
    // setters would be ignored (even for autolayout) if set to the same value.
    _contentView.bounds = self.bounds;
    _contentView.center = self.center;
    [super layoutSubviews];
}

- (void)setContentView:(UIView *)contentView {
    if (contentView != _contentView) {
        _contentView = contentView;
        [self addSubview:contentView];
        self.shimmerLayer.contentLayer = contentView.layer;
    }
}

- (void)setShimmering:(BOOL)shimmering {
    [self.shimmerLayer setShimmering:shimmering];
}

- (BOOL)isShimmering {
    return self.shimmerLayer.isShimmering;
}

- (void)setShimmeringPauseDuration:(CFTimeInterval)shimmeringPauseDuration {
    [self.shimmerLayer setShimmeringPauseDuration:shimmeringPauseDuration];
}

- (CFTimeInterval)shimmeringPauseDuration {
    return self.shimmerLayer.shimmeringPauseDuration;
}

- (void)setShimmeringAnimationOpacity:(CGFloat)shimmeringAnimationOpacity {
    [self.shimmerLayer setShimmeringAnimationOpacity:shimmeringAnimationOpacity];
}

- (CGFloat)shimmeringAnimationOpacity {
    return self.shimmerLayer.shimmeringAnimationOpacity;
}

- (void)setShimmeringOriginOpacity:(CGFloat)shimmeringOriginOpacity {
    [self.shimmerLayer setShimmeringOriginOpacity:shimmeringOriginOpacity];
}

- (CGFloat)shimmeringOriginOpacity {
    return self.shimmerLayer.shimmeringOriginOpacity;
}

- (void)setShimmeringSpeed:(CGFloat)shimmeringSpeed {
    [self.shimmerLayer setShimmeringSpeed:shimmeringSpeed];
}

- (CGFloat)shimmeringSpeed {
    return self.shimmerLayer.shimmeringSpeed;
}

- (void)setShimmeringHighlightLength:(CGFloat)shimmeringHighlightLength {
    [self.shimmerLayer setShimmeringHighlightLength:shimmeringHighlightLength];
}

- (CGFloat)shimmeringHighlightLength {
    return self.shimmerLayer.shimmeringHighlightLength;
}

- (void)setShimmeringDirection:(XYShimmerDirection)shimmeringDirection {
    [self.shimmerLayer setShimmeringDirection:shimmeringDirection];
}

- (XYShimmerDirection)shimmeringDirection {
    return self.shimmerLayer.shimmeringDirection;
}

- (void)setShimmeringBeginFadeDuration:(CFTimeInterval)shimmeringBeginFadeDuration {
    [self.shimmerLayer setShimmeringBeginFadeDuration:shimmeringBeginFadeDuration];
}

- (CFTimeInterval)shimmeringBeginFadeDuration {
    return self.shimmerLayer.shimmeringBeginFadeDuration;
}

- (void)setShimmeringEndFadeDuration:(CFTimeInterval)shimmeringEndFadeDuration {
    [self.shimmerLayer setShimmeringEndFadeDuration:shimmeringEndFadeDuration];
}

- (CFTimeInterval)shimmeringEndFadeDuration {
    return self.shimmerLayer.shimmeringEndFadeDuration;
}

- (void)setShimmeringBeginTime:(CFTimeInterval)shimmeringBeginTime {
    [self.shimmerLayer setShimmeringBeginTime:shimmeringBeginTime];
}

- (CFTimeInterval)shimmeringBeginTime {
    return self.shimmerLayer.shimmeringBeginTime;
}

- (CFTimeInterval)shimmeringFadeTime {
    return self.shimmerLayer.shimmeringFadeTime;
}

- (XYShimmerLayer *)shimmerLayer {
    return (XYShimmerLayer *)self.layer;
}

@end
