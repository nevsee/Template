//
//  XYPopupCarrierView.m
//  XYPopupView
//
//  Created by nevsee on 2017/12/11.
//

#import "XYPopupCarrierView.h"

@interface XYPopupCarrierView ()
@property (nonatomic, assign) CGRect oldArrowRect;
@property (nonatomic, assign) CGRect oldContainerRect;
@property (nonatomic, assign) CGFloat oldCornerRadius;
@property (nonatomic, assign) UIEdgeInsets position;
@end

@implementation XYPopupCarrierView

+ (Class)layerClass {
    return [CAShapeLayer class];
}

// Method
- (void)updatePathIfNeeded {
    if (CGRectEqualToRect(_containerRect, CGRectZero)) return;
    
    if (CGRectEqualToRect(_oldArrowRect, _arrowRect) &&
        CGRectEqualToRect(_oldContainerRect, _containerRect) &&
        _oldCornerRadius == _cornerRadius) return;
    
    _oldArrowRect = _arrowRect;
    _oldContainerRect = _containerRect;
    _oldCornerRadius = _cornerRadius;
    
    CGRect arrowRect = _arrowRect;
    CGRect containerRect = _containerRect;
    CGFloat cornerRadius = _cornerRadius;
    
    CGPoint leftTopArcCenter = CGPointMake(CGRectGetMinX(containerRect) + cornerRadius, CGRectGetMinY(containerRect) + cornerRadius);
    CGPoint leftBottomArcCenter = CGPointMake(leftTopArcCenter.x, CGRectGetMaxY(containerRect) - cornerRadius);
    CGPoint rightTopArcCenter = CGPointMake(CGRectGetMaxX(containerRect) - cornerRadius, leftTopArcCenter.y);
    CGPoint rightBottomArcCenter = CGPointMake(rightTopArcCenter.x, leftBottomArcCenter.y);
    
    // get the position of arrow
    UIEdgeInsets position = UIEdgeInsetsZero;
    if (arrowRect.size.width > 0 && arrowRect.size.height > 0) {
        if (containerRect.origin.x == 0 && containerRect.origin.y > 0) {
            position.top = 1;
        } else if (containerRect.origin.x > 0 && containerRect.origin.y == 0) {
            position.left = 1;
        } else if (arrowRect.origin.y == containerRect.size.height) {
            position.bottom = 1;
        } else {
            position.right = 1;
        }
        _position = position;
    }
    
    // draw path
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // arrow left
    [path moveToPoint:CGPointMake(leftTopArcCenter.x, CGRectGetMinY(containerRect))];
    [path addArcWithCenter:leftTopArcCenter radius:cornerRadius startAngle:M_PI * 1.5 endAngle:M_PI clockwise:NO];
    if (position.left) {
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(arrowRect), CGRectGetMinY(arrowRect))];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(arrowRect), CGRectGetMidY(arrowRect))];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(arrowRect), CGRectGetMaxY(arrowRect))];
    }
    
    // arrow bottom
    [path addLineToPoint:CGPointMake(CGRectGetMinX(containerRect), leftBottomArcCenter.y)];
    [path addArcWithCenter:leftBottomArcCenter radius:cornerRadius startAngle:M_PI endAngle:M_PI * 0.5 clockwise:NO];
    if (position.bottom) {
        [path addLineToPoint:CGPointMake(CGRectGetMinX(arrowRect), CGRectGetMinY(arrowRect))];
        [path addLineToPoint:CGPointMake(CGRectGetMidX(arrowRect), CGRectGetMaxY(arrowRect))];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(arrowRect), CGRectGetMinY(arrowRect))];
    }
    
    // arrow right
    [path addLineToPoint:CGPointMake(rightBottomArcCenter.x, CGRectGetMaxY(containerRect))];
    [path addArcWithCenter:rightBottomArcCenter radius:cornerRadius startAngle:M_PI * 0.5 endAngle:0.0 clockwise:NO];
    if (position.right) {
        [path addLineToPoint:CGPointMake(CGRectGetMinX(arrowRect), CGRectGetMaxY(arrowRect))];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(arrowRect), CGRectGetMidY(arrowRect))];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(arrowRect), CGRectGetMinY(arrowRect))];
    }
    
    // arrow top
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(containerRect), rightTopArcCenter.y)];
    [path addArcWithCenter:rightTopArcCenter radius:cornerRadius startAngle:0.0 endAngle:M_PI * 1.5 clockwise:NO];
    if (position.top) {
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(arrowRect), CGRectGetMaxY(arrowRect))];
        [path addLineToPoint:CGPointMake(CGRectGetMidX(arrowRect), CGRectGetMinY(arrowRect))];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(arrowRect), CGRectGetMaxY(arrowRect))];
    }
    [path closePath];
    
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.path = path.CGPath;
}

// Access
- (CGSize)targetSize {
    if (_position.top || _position.bottom) {
        return CGSizeMake(_containerRect.size.width, _arrowRect.size.height + _containerRect.size.height);
    } else {
        return CGSizeMake(_arrowRect.size.width + _containerRect.size.width, _containerRect.size.height);
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.fillColor = backgroundColor.CGColor;
}

@end
