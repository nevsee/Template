//
//  XYRippleAnimationView.m
//  XYWidget
//
//  Created by nevsee on 2022/9/23.
//

#import "XYRippleAnimationView.h"

@implementation XYRippleAnimationView {
    CAShapeLayer *_shapeLayer;
    CAReplicatorLayer *_replicatorLayer;
    UIBezierPath *_fromPath;
    UIBezierPath *_toPath;
    BOOL _paused;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _rippleColor = UIColor.blueColor;
        _rippleCount = 3;
        _rippleWidth = 1.0;
        _rippleDuration = 2.0;
        _rippleDelay = _rippleDuration / _rippleCount;
        _rippleDistanceRatio = 0.3;
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = UIColor.clearColor.CGColor;
        _shapeLayer = shapeLayer;
        
        CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
        [replicatorLayer addSublayer:shapeLayer];
        [self.layer addSublayer:replicatorLayer];
        _replicatorLayer = replicatorLayer;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterBackgroundNotice)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterForegroundNotice)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_fromPath) return;
    
    CGFloat rippleDistance = self.bounds.size.width * _rippleDistanceRatio;
    CGFloat fromWidth = self.bounds.size.width - rippleDistance * 2;
    CGFloat toWidth = self.bounds.size.width;
    _fromPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(0, 0, fromWidth, fromWidth), _rippleWidth, _rippleWidth)];
    _toPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(-rippleDistance, -rippleDistance, toWidth, toWidth), _rippleWidth, _rippleWidth)];
    
    _shapeLayer.bounds = _fromPath.bounds;
    _shapeLayer.position = CGPointMake(toWidth / 2.0, toWidth / 2.0);
    _shapeLayer.strokeColor = _rippleColor.CGColor;
    _shapeLayer.lineWidth = _rippleWidth;
    _shapeLayer.path = _fromPath.CGPath;
    
    _replicatorLayer.instanceCount = _rippleCount;
    _replicatorLayer.instanceDelay = _rippleDelay;
    
    if (_animating) [_shapeLayer addAnimation:[self getRippleAnimation] forKey:@"rippleAnimation"];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window) {
        if (_paused) [self resume];
    } else {
        [self stop];
    }
}

// Action

- (void)enterBackgroundNotice {
    [self stop];
}

- (void)enterForegroundNotice {
    if (_paused) [self resume];
}

// Method

- (CAAnimationGroup *)getRippleAnimation {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (id)_fromPath.CGPath;
    pathAnimation.toValue = (id)_toPath.CGPath;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[pathAnimation, opacityAnimation];
    groupAnimation.duration = _rippleDuration;
    groupAnimation.repeatCount = HUGE_VALF;
    
    return groupAnimation;
}

- (void)resume {
    _paused = false;
    [self beginAnimation];
}

- (void)stop {
    _paused = true;
    [self endAnimation];
}

- (void)beginAnimation {
    if (_animating) return;
    _animating = true;
    [_shapeLayer addAnimation:[self getRippleAnimation] forKey:@"rippleAnimation"];
}

- (void)endAnimation {
    if (!_animating) return;
    _animating = false;
    [_shapeLayer removeAllAnimations];
}

@end
