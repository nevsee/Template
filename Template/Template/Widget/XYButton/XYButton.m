//
//  XYButton.m
//  XYWidget
//
//  Created by nevsee on 2018/2/12.
//

#import "XYButton.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface XYButton ()
@property (nonatomic, strong) CALayer *backgroundLayer;
@property (nonatomic, strong) UIColor *originBorderColor;
@end

@implementation XYButton

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
    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;
    
    _dimsButtonWhenHighlighted = YES;
    _highlightedAlpha = 0.7;
    _dimsButtonWhenDisabled = YES;
    _disabledAlpha = 0.5;
}

// Override

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    // border color
    if (_highlightedBorderColor) {
        if (!_originBorderColor) {
            _originBorderColor = [UIColor colorWithCGColor:self.layer.borderColor];
        }
        self.layer.borderColor = highlighted ? _highlightedBorderColor.CGColor : _originBorderColor.CGColor;
    }
    
    // background color
    if (_highlightedBackgroundColor) {
        if (!_backgroundLayer) {
            _backgroundLayer = [CALayer layer];
            [self.layer insertSublayer:_backgroundLayer atIndex:0];
        }
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _backgroundLayer.frame = self.bounds;
        _backgroundLayer.cornerRadius = self.layer.cornerRadius;
        _backgroundLayer.backgroundColor = highlighted ? _highlightedBackgroundColor.CGColor : UIColor.clearColor.CGColor;
        [CATransaction commit];
    }
    
    if (!self.enabled) {
        return;
    }
    if (_dimsButtonWhenHighlighted) {
        if (highlighted) {
            self.alpha = _highlightedAlpha;
        } else {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                self.alpha = 1;
            } completion:nil];
        }
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    if (!enabled && _dimsButtonWhenDisabled) {
        self.alpha = _disabledAlpha;
    } else {
        self.alpha = 1;
    }
}

// Access

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    _highlightedBackgroundColor = highlightedBackgroundColor;
    if (highlightedBackgroundColor) {
        _dimsButtonWhenHighlighted = NO;
    }
}

- (void)setHighlightedBorderColor:(UIColor *)highlightedBorderColor {
    _highlightedBorderColor = highlightedBorderColor;
    if (highlightedBorderColor) {
        _dimsButtonWhenHighlighted = NO;
    }
}

@end

#pragma clang diagnostic pop
