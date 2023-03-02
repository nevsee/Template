//
//  XYMarqueeLabel.m
//  XYWidget
//
//  Created by nevsee on 2018/5/4.
//

#import "XYMarqueeLabel.h"

@interface XYMarqueeLabel ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat textOffsetX;
@property (nonatomic, assign) CGSize textSize;
@property (nonatomic, assign) BOOL isFirstDisplay;
@property (nonatomic, strong) CAGradientLayer *fadeLayer;
@property (nonatomic, assign) CGRect prevBounds;
@end

@implementation XYMarqueeLabel

- (void)dealloc {
    [_displayLink invalidate];
    _displayLink = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    _speed = 1;
    _pauseDurationWhenMoveToHead = 2.5;
    _spacingBetweenHeadToTail = 40;
    _shouldFadeAtEdge = YES;
    _fadeWidthPercent = 0.2;
    _isFirstDisplay = YES;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTextDrawingAction:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    } else {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_fadeLayer) {
        _fadeLayer.frame = self.bounds;
    }
    
    if (!CGSizeEqualToSize(_prevBounds.size, self.bounds.size)) {
        _textOffsetX = 0;
        _displayLink.paused = ![self shouldStartDisplayLink];
        _prevBounds = self.bounds;
        [self shouldShowGradientLayer];
    }
}

- (void)drawTextInRect:(CGRect)rect {
    CGFloat textX = 0;
    if (self.textAlignment == NSTextAlignmentLeft) textX = 0;
    else if (self.textAlignment == NSTextAlignmentCenter) textX = MAX(0, (self.bounds.size.width - _textSize.width) / 2);
    else if (self.textAlignment == NSTextAlignmentRight) textX = MAX(0, self.bounds.size.width - _textSize.width);

    CGFloat textY = CGRectGetMinY(rect) + (CGRectGetHeight(rect) - _textSize.height) / 2;
    CGFloat interval = _textSize.width + _spacingBetweenHeadToTail;
    
    for (NSInteger i = 0; i < self.textRepeatCount; i++) {
        CGRect drawRect = CGRectMake(_textOffsetX + textX + interval * i, textY, _textSize.width, _textSize.height);
        [self.attributedText drawInRect:drawRect];
    }
}

- (void)updateTextDrawingAction:(CADisplayLink *)displayLink {
    if (_textOffsetX == 0) {
        displayLink.paused = YES;
        [self setNeedsDisplay];
        
        int64_t delay = (_isFirstDisplay || self.textRepeatCount <= 1) ? _pauseDurationWhenMoveToHead : 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            displayLink.paused = ![self shouldStartDisplayLink];
            if (!displayLink.paused) {
                self.textOffsetX -= self.speed;
            }
        });
        
        if (delay > 0 && self.textRepeatCount > 1) {
            _isFirstDisplay = NO;
        }
        
        return;
    }
    
    _textOffsetX -= _speed;
    [self setNeedsDisplay];
    
    if (-_textOffsetX >= _textSize.width + (self.textRepeatCount > 1 ? _spacingBetweenHeadToTail : 0)) {
        displayLink.paused = YES;
        int64_t delay = self.textRepeatCount > 1 ? _pauseDurationWhenMoveToHead : 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.textOffsetX = 0;
            [self updateTextDrawingAction:displayLink];
        });
    }
}

- (NSInteger)textRepeatCount {
    if (_textSize.width < self.bounds.size.width) return 1;
    return 2;
}

- (BOOL)shouldStartDisplayLink {
    return self.window && self.bounds.size.width > 0 && _textSize.width > self.bounds.size.width;
}

- (void)shouldShowGradientLayer {
    BOOL shouldShowFadeLayer = self.window && _shouldFadeAtEdge && self.bounds.size.width > 0 && _textSize.width > self.bounds.size.width;
    
    if (shouldShowFadeLayer) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.locations = @[@(0), @(_fadeWidthPercent), @(1 - _fadeWidthPercent), @(1)];
        layer.startPoint = CGPointMake(0, 0.5);
        layer.endPoint = CGPointMake(1, 0.5);
        layer.colors = @[(id)[UIColor colorWithWhite:1 alpha:0].CGColor, (id)[UIColor colorWithWhite:1 alpha:1].CGColor, (id)[UIColor colorWithWhite:1 alpha:1].CGColor, (id)[UIColor colorWithWhite:1 alpha:0].CGColor];
        _fadeLayer = layer;
        self.layer.mask = layer;
        [self setNeedsLayout];
    } else {
        if (self.layer.mask == _fadeLayer) {
            self.layer.mask = nil;
        }
    }
}

- (BOOL)startAnimation {
    BOOL shouldPlayDisplayLink = [self shouldStartDisplayLink];
    if (shouldPlayDisplayLink) {
        _displayLink.paused = NO;
    }
    return shouldPlayDisplayLink;
}

- (BOOL)stopAnimation {
    _displayLink.paused = YES;
    return YES;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    _textOffsetX = 0;
    _textSize = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    _displayLink.paused = ![self shouldStartDisplayLink];
    [self shouldShowGradientLayer];
    [self setNeedsLayout];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    _textOffsetX = 0;
    _textSize = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    _displayLink.paused = ![self shouldStartDisplayLink];
    [self shouldShowGradientLayer];
    [self setNeedsLayout];
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    numberOfLines = 1;
    [super setNumberOfLines:numberOfLines];
}

- (void)setShouldFadeAtEdge:(BOOL)shouldFadeAtEdge {
    _shouldFadeAtEdge = shouldFadeAtEdge;
    [self shouldShowGradientLayer];
    [self setNeedsLayout];
}

@end
