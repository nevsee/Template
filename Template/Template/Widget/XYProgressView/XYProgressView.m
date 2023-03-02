//
//  XYProgressView.h
//  XYWidget
//
//  Created by nevsee on 2018/9/10.
//

#import "XYProgressView.h"

@implementation XYProgressLayer
@dynamic shape;
@dynamic borderInsets;
@dynamic fillColor;
@dynamic strokeColor;
@dynamic previewColor;
@dynamic progress;

- (instancetype)init {
    if (self = [super init]) {
        _shouldChangeProgressWithAnimation = YES;
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    return [key isEqualToString:@"progress"] || [super needsDisplayForKey:key];
}

- (id<CAAction>)actionForKey:(NSString *)event {
    if ([event isEqualToString:@"progress"] && _shouldChangeProgressWithAnimation) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
        animation.fromValue = [self.presentationLayer valueForKey:event];
        animation.duration = _animationDuration;
        return animation;
    }
    return [super actionForKey:event];
}

- (void)drawInContext:(CGContextRef)context {
    if (CGRectIsEmpty(self.bounds)) return;
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = M_PI * 2 * self.progress + startAngle;
    
    // XYProgressShapeSector
    CGFloat sectorRadius = MIN(center.x, center.y) - self.borderWidth - self.borderInsets;
    
    // XYProgressShapeRing
    CGFloat ringRadius = MIN(center.x, center.y) - self.borderWidth - self.borderInsets / 2;
    
    // XYProgressShapeLine
    CGFloat lineWidth = self.bounds.size.height - (self.borderWidth + self.borderInsets) * 2;
    CGFloat startX = self.borderWidth + self.borderInsets + lineWidth / 2;
    CGFloat endX = (self.bounds.size.width - startX * 2) * self.progress + startX;
    
    switch (self.shape) {
        case XYProgressShapeSector: {
            if (self.previewColor) {
                CGContextSetFillColorWithColor(context, self.previewColor.CGColor);
                CGContextMoveToPoint(context, center.x, center.y);
                CGContextAddArc(context, center.x, center.y, sectorRadius, startAngle, M_PI * 2, 0);
                CGContextClosePath(context);
                CGContextFillPath(context);
            }
            CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
            CGContextMoveToPoint(context, center.x, center.y);
            CGContextAddArc(context, center.x, center.y, sectorRadius, startAngle, endAngle, 0);
            CGContextClosePath(context);
            CGContextFillPath(context);
        }
            break;
        case XYProgressShapeRing: {
            if (self.previewColor) {
                CGContextSetLineCap(context, kCGLineCapRound);
                CGContextSetLineWidth(context, self.borderInsets);
                CGContextSetStrokeColorWithColor(context, self.previewColor.CGColor);
                CGContextAddArc(context, center.x, center.y, ringRadius, startAngle, M_PI * 2, 0);
                CGContextStrokePath(context);
            }
            CGContextSetLineCap(context, self.progress > __FLT_EPSILON__ ? kCGLineCapRound : kCGLineCapButt);
            CGContextSetLineWidth(context, self.borderInsets);
            CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
            CGContextAddArc(context, center.x, center.y, ringRadius, startAngle, endAngle, 0);
            CGContextStrokePath(context);
        }
            break;
        case XYProgressShapeLine: {
            if (self.previewColor) {
                CGContextSetLineCap(context, kCGLineCapRound);
                CGContextSetLineWidth(context, lineWidth);
                CGContextSetStrokeColorWithColor(context, self.previewColor.CGColor);
                CGContextMoveToPoint(context, startX, center.y);
                CGContextAddLineToPoint(context, self.bounds.size.width - startX, center.y);
                CGContextStrokePath(context);
            }
            CGContextSetLineCap(context, self.progress > __FLT_EPSILON__ ? kCGLineCapRound : kCGLineCapButt);
            CGContextSetLineWidth(context, lineWidth);
            CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
            CGContextMoveToPoint(context, startX, center.y);
            CGContextAddLineToPoint(context, endX, center.y);
            CGContextStrokePath(context);
        }
            break;
    }
    [super drawInContext:context];
}

- (void)layoutSublayers {
    [super layoutSublayers];
    self.cornerRadius = self.bounds.size.height / 2;
}

@end

#pragma mark -

@implementation XYProgressView

+ (Class)layerClass {
    return [XYProgressLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
        [self tintColorDidChange];
    }
    return self;
}

- (void)initialization {
    self.progress = 0.0;
    self.animationDuration = 0.5;
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer setNeedsDisplay];
}

// Override
- (void)tintColorDidChange {
    [super tintColorDidChange];
    self.progressLayer.fillColor = self.tintColor;
    self.progressLayer.strokeColor = self.tintColor;
    self.progressLayer.borderColor = self.tintColor.CGColor;
}

// Access
- (void)setShape:(XYProgressShape)shape {
    _shape = shape;
    self.progressLayer.shape = shape;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.progressLayer.borderWidth = borderWidth;
}

- (void)setBorderInsets:(CGFloat)borderInsets {
    _borderInsets = borderInsets;
    self.progressLayer.borderInsets = borderInsets;
}

- (void)setPreviewColor:(UIColor *)previewColor {
    _previewColor = previewColor;
    self.progressLayer.previewColor = previewColor;
}

- (void)setAnimationDuration:(CFTimeInterval)progressAnimationDuration {
    _animationDuration = progressAnimationDuration;
    self.progressLayer.animationDuration = progressAnimationDuration;
}

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    _progress = fmax(0.0, fmin(1.0, progress));
    self.progressLayer.shouldChangeProgressWithAnimation = animated;
    self.progressLayer.progress = _progress;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (XYProgressLayer *)progressLayer {
    return (XYProgressLayer *)self.layer;
}

@end
