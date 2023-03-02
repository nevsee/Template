//
//  XYCodeScanAnimator.m
//  XYCodeScanner
//
//  Created by nevsee on 2021/10/9.
//

#import "XYCodeScanAnimator.h"

@implementation XYCodeScanAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        _animationArea = CGRectMake(0, 0.3, 1, 0.4);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActiveAction) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundAction) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)becomeActiveAction {

}

- (void)enterBackgroundAction {

}

- (void)startAnimation {
    
}

- (void)stopAnimation {
    
}

@end

#pragma mark -

@interface XYCodeScanDefaultAnimator ()
@property (nonatomic, strong) CALayer *lineImageLayer;
@property (nonatomic, assign) CGSize lineImageSize;
@property (nonatomic, assign) BOOL didStopAnimation;
@end

@implementation XYCodeScanDefaultAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"XYCodeScanner" withExtension:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithURL:url];
        _lineImage = [UIImage imageNamed:@"xy_scan_line" inBundle:bundle compatibleWithTraitCollection:nil];
        _lineImageSize = _lineImage.size;
        _didStopAnimation = YES;
        
        CALayer *lineImageLayer = [CALayer layer];
        lineImageLayer.contents = (id)_lineImage.CGImage;
        _lineImageLayer = lineImageLayer;
        [self addSublayer:lineImageLayer];
    }
    return self;
}

- (void)layoutSublayers {
    [super layoutSublayers];
    if (_lineImageSize.height == 0 || _lineImageSize.width == 0) return;
    
    CGFloat radio = _lineImageSize.height / _lineImageSize.width;
    CGFloat lineX = self.animationArea.origin.x * self.bounds.size.width;
    CGFloat lineY = self.animationArea.origin.y * self.bounds.size.height;
    CGFloat lineW = self.animationArea.size.width * self.bounds.size.width;
    _lineImageLayer.frame = CGRectMake(lineX, lineY - lineW * radio, lineW, lineW * radio);
}

- (void)becomeActiveAction {
    if (_didStopAnimation) return;
    [self startAnimation];
}

- (void)enterBackgroundAction {
    _lineImageLayer.opacity = 0;
    [_lineImageLayer removeAllAnimations];
}

- (void)startAnimation {
    _didStopAnimation = NO;
    _lineImageLayer.opacity = 1;
    
    CABasicAnimation *slipAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    slipAnimation.toValue = @((self.animationArea.size.height + self.animationArea.origin.y) * self.frame.size.height);
    slipAnimation.duration = 1.8;
    slipAnimation.repeatCount = HUGE;
    slipAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_lineImageLayer addAnimation:slipAnimation forKey:@"slip"];

    CAKeyframeAnimation *fadeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.values = @[@(0), @(1), @(1), @(0)];
    fadeAnimation.keyTimes = @[@(0), @(0.075), @(0.9), @(1)];
    fadeAnimation.duration = 1.8;
    fadeAnimation.repeatCount = HUGE;
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_lineImageLayer addAnimation:fadeAnimation forKey:@"fade"];
}

- (void)stopAnimation {
    _didStopAnimation = YES;
    _lineImageLayer.opacity = 0;
    [_lineImageLayer removeAllAnimations];
    
}

- (void)setLineImage:(UIImage *)lineImage {
    _lineImage = lineImage;
    _lineImageSize = lineImage.size;
    _lineImageLayer.contents = (id)lineImage.CGImage;
}

@end
