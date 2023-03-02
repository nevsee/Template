//
//  XYPopupView.m
//  XYPopupView
//
//  Created by nevsee on 2017/12/11.
//

#import "XYPopupView.h"
#import <objc/runtime.h>

@interface XYPopupView ()
@property (nonatomic, strong, readwrite) XYPopupCarrierView *carrierView;
@property (nonatomic, strong, readwrite) UIView *maskView;
@property (nonatomic, assign, readwrite) BOOL isVisible;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) UIEdgeInsets inset;
@end

@implementation XYPopupView

#pragma mark # Life

- (instancetype)initWithContentView:(UIView *)contentView {
    return [self initWithContentView:contentView parentView:nil];
}

- (instancetype)initWithContentView:(UIView *)contentView parentView:(UIView *)parentView {
    self = [super init];
    if (self) {
        if (!contentView) return nil;
        [self paramterSetup:contentView parentView:parentView ?: [self obtainWindow]];
        [self userInterfaceSetup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self calculateLayouts];
}

- (void)paramterSetup:(UIView *)contentView parentView:(UIView *)parentView {
    _contentView = contentView;
    _contentView.xy_popup = self;
    _parentView = parentView;
    _sourceRect = CGRectMake(-1, -1, -1, -1);
    _preferredDirection = XYPopupDirectionBottom;
    _seekRule = XYPopupSeekRuleSymmetryAnticlockwise;
    _animator = [[XYPopupAnimator alloc] init];
    _animator.showStyle = XYPopupAnimationStyleBounce;
    _animator.hideStyle = XYPopupAnimationStyleBounce;
    _animator.popupView = self;
    _definesDismissalTouch = YES;
    _definesSafeAreaAdaptation = YES;
}

- (void)userInterfaceSetup {
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)];
    
    UIView *maskView = [[UIView alloc] init];
    [maskView addGestureRecognizer:ges];
    [self addSubview:maskView];
    _maskView = maskView;
    
    UIView *containerView = [[UIView alloc] init];
    containerView.layer.masksToBounds = YES;
    [containerView addSubview:_contentView];
    [self addSubview:containerView];
    _containerView = containerView;
    
    XYPopupCarrierView *carrierView = [[XYPopupCarrierView alloc] init];
    [carrierView addSubview:containerView];
    [self addSubview:carrierView];
    _carrierView = carrierView;
}

#pragma mark # Action

- (void)dismissAction {
    if (!_definesDismissalTouch) return;
    [self hideAnimated:YES];
}

#pragma mark # Method

#pragma mark ## Private
- (void)calculateLayouts {
    if (![self validateProperties]) return;
    
    self.frame = _parentView.bounds;
    _maskView.frame = self.bounds;
    
    CGRect parentRect = _parentView.bounds;
    CGSize contentSize = _contentView.bounds.size;

    // source view frame
    UIView *availableView = nil;
    if (_sourceView) {
        availableView = _sourceView;
    } else {
        availableView = [_sourceBarItem valueForKey:@"view"];
    }
    
    CGRect sourceRect = _sourceRect;
    if (availableView) {
        sourceRect = [availableView convertRect:[availableView bounds] toView:_parentView];
    }
    
    // source view insets
    NSArray *sourceInsets = @[@(CGRectGetMinY(sourceRect)),
                              @(CGRectGetMinX(sourceRect)),
                              @(CGRectGetHeight(parentRect) - CGRectGetMaxY(sourceRect)),
                              @(CGRectGetWidth(parentRect) - CGRectGetMaxX(sourceRect))];
     
    // obtain actual direction of the pop view
    // note: the width and height of the arrow will be exchanged in the vertical direction
    CGSize maskMaxSize = CGSizeMake(contentSize.width + _arrowSize.height, contentSize.height + _arrowSize.height);
    _actualDirection = [self findEffectiveLayoutDirection:maskMaxSize sourceInsets:sourceInsets sourceRect:sourceRect];
    
    // layout
    CGRect containerRect, arrowRect, maskRect, contentRect;
    switch (_actualDirection) {
        case XYPopupDirectionTop: {
            BOOL leftQuadrant = CGRectGetMidX(sourceRect) < CGRectGetMidX(parentRect);
            CGFloat padding = leftQuadrant ? CGRectGetMidX(sourceRect) : CGRectGetWidth(parentRect) - CGRectGetMidX(sourceRect);
            BOOL layoutCenter = padding > contentSize.width / 2 + (leftQuadrant ? self.inset.left : self.inset.right);
            
            // mask position
            CGFloat maskX = 0;
            CGFloat maskY = CGRectGetMinY(sourceRect) - maskMaxSize.height - _popupSpacing;
            if (layoutCenter) {
                maskX = CGRectGetMidX(sourceRect) - contentSize.width / 2;
            } else {
                maskX = leftQuadrant ? self.inset.left : CGRectGetWidth(parentRect) - contentSize.width - self.inset.right;
            }
            
            // container position
            CGFloat containerX = 0, containerY = 0;
            
            // arrow position
            CGFloat arrowX = CGRectGetMidX(sourceRect) - maskX - _arrowSize.width / 2 + _arrowOffset.x;
            CGFloat arrowY = contentSize.height;
            
            maskRect = CGRectMake(maskX, maskY, contentSize.width, maskMaxSize.height);
            containerRect = CGRectMake(containerX, containerY, contentSize.width, contentSize.height);
            arrowRect = CGRectMake(arrowX, arrowY, _arrowSize.width, _arrowSize.height);
            contentRect = CGRectMake(0, 0, contentSize.width, contentSize.height);
        }
            break;
        case XYPopupDirectionLeft: {
            BOOL topQuadrant = CGRectGetMidY(sourceRect) < CGRectGetMidY(parentRect);
            CGFloat padding = topQuadrant ? CGRectGetMidY(sourceRect) : CGRectGetHeight(parentRect) - CGRectGetMidY(sourceRect);
            BOOL layoutCenter = padding > contentSize.height / 2 + (topQuadrant ? self.inset.top : self.inset.bottom);
            
            // container position
            CGFloat maskX = CGRectGetMinX(sourceRect) - maskMaxSize.width - _popupSpacing;
            CGFloat maskY = 0;
            if (layoutCenter) {
                maskY = CGRectGetMidY(sourceRect) - contentSize.height / 2;
            } else {
                maskY = topQuadrant ? self.inset.top : CGRectGetHeight(parentRect) - contentSize.height - self.inset.bottom;
            }
            
            // container position
            CGFloat containerX = 0, containerY = 0;
            
            // arrow position
            CGFloat arrowX = contentSize.width;
            CGFloat arrowY = CGRectGetMidY(sourceRect) - maskY - _arrowSize.width / 2 + _arrowOffset.y;
            
            maskRect = CGRectMake(maskX, maskY, maskMaxSize.width, contentSize.height);
            containerRect = CGRectMake(containerX, containerY, contentSize.width, contentSize.height);
            arrowRect = CGRectMake(arrowX, arrowY, _arrowSize.height, _arrowSize.width);
            contentRect = CGRectMake(0, 0, contentSize.width, contentSize.height);
        }
            break;
        case XYPopupDirectionBottom: {
            BOOL leftQuadrant = CGRectGetMidX(sourceRect) < CGRectGetMidX(parentRect);
            CGFloat padding = leftQuadrant ? CGRectGetMidX(sourceRect) : CGRectGetWidth(parentRect) - CGRectGetMidX(sourceRect);
            BOOL layoutCenter = padding > contentSize.width / 2 + (leftQuadrant ? self.inset.left : self.inset.right);
            
            // container position
            CGFloat maskX = 0;
            CGFloat maskY = CGRectGetMaxY(sourceRect) + _popupSpacing;
            if (layoutCenter) {
                maskX = CGRectGetMidX(sourceRect) - contentSize.width / 2;
            } else {
                maskX = leftQuadrant ? self.inset.left : CGRectGetWidth(parentRect) - contentSize.width - self.inset.right;
            }
            
            // container position
            CGFloat containerX = 0, containerY = _arrowSize.height;
            
            // arrow position
            CGFloat arrowX = CGRectGetMidX(sourceRect) - maskX - _arrowSize.width / 2 + _arrowOffset.x;
            CGFloat arrowY = 0;
            
            maskRect = CGRectMake(maskX, maskY, contentSize.width, maskMaxSize.height);
            containerRect = CGRectMake(containerX, containerY, contentSize.width, contentSize.height);
            arrowRect = CGRectMake(arrowX, arrowY, _arrowSize.width, _arrowSize.height);
            contentRect = CGRectMake(0, 0, contentSize.width, contentSize.height);
        }
            break;
        case XYPopupDirectionRight: {
            BOOL topQuadrant = CGRectGetMidY(sourceRect) < CGRectGetMidY(parentRect);
            CGFloat padding = topQuadrant ? CGRectGetMidY(sourceRect) : CGRectGetHeight(parentRect) - CGRectGetMidY(sourceRect);
            BOOL layoutCenter = padding > contentSize.height / 2 + (topQuadrant ? self.inset.top : self.inset.bottom);
            
            // container position
            CGFloat maskX = CGRectGetMaxX(sourceRect) + _popupSpacing;
            CGFloat maskY = 0;
            if (layoutCenter) {
                maskY = CGRectGetMidY(sourceRect) - contentSize.height / 2;
            } else {
                maskY = topQuadrant ? self.inset.top : CGRectGetHeight(parentRect) - contentSize.height - self.inset.bottom;
            }
            
            // container position
            CGFloat containerX = _arrowSize.height, containerY = 0;
            
            // arrow position
            CGFloat arrowX = 0;
            CGFloat arrowY = CGRectGetMidY(sourceRect) - maskY - _arrowSize.width / 2 + _arrowOffset.y;
            
            maskRect = CGRectMake(maskX, maskY, maskMaxSize.width, contentSize.height);
            containerRect = CGRectMake(containerX, containerY, contentSize.width, contentSize.height);
            arrowRect = CGRectMake(arrowX, arrowY, _arrowSize.height, _arrowSize.width);
            contentRect = CGRectMake(0, 0, contentSize.width, contentSize.height);
        }
            break;
    }
    
    CGSize maskOriginSize = _carrierView.frame.size;
    CGSize maskTargetSize = _carrierView.targetSize;
    if (!CGSizeEqualToSize(maskOriginSize, maskTargetSize) && !CGSizeEqualToSize(maskOriginSize, CGSizeZero)) return;
    
    _contentView.frame = contentRect;
    _containerView.frame = containerRect;
    _containerView.layer.cornerRadius = _cornerRadius;
    _carrierView.frame = maskRect;
    _carrierView.arrowRect = arrowRect;
    _carrierView.containerRect = containerRect;
    _carrierView.cornerRadius = _cornerRadius;
    [_carrierView updatePathIfNeeded];
}

// find the best direction
- (XYPopupDirection)findEffectiveLayoutDirection:(CGSize)maskSize sourceInsets:(NSArray *)sourceInsets sourceRect:(CGRect)sourceRect {
    if (_preferredDirection < 0 || _preferredDirection > 3) {
        _preferredDirection = XYPopupDirectionBottom;
    }
    
    // blocks
    CGFloat (^obtainPopupSize)(NSInteger direction) = ^CGFloat(NSInteger direction) {
        if ([self isHorizontal:direction]) return maskSize.width;
        return maskSize.height;
    };
    
    NSInteger (^obtainPopupMargin)(NSInteger direction) = ^NSInteger(NSInteger direction) {
        if (direction == XYPopupDirectionTop) return self.inset.top;
        else if (direction == XYPopupDirectionLeft) return self.inset.left;
        else if (direction == XYPopupDirectionBottom) return self.inset.bottom;
        else return self.inset.right;
    };
    
    NSInteger (^obtainNextIndex)(NSInteger index) = ^NSInteger(NSInteger index) {
        if (self.seekRule == XYPopupSeekRuleClockwise) {
            if (index == 0) return sourceInsets.count - 1;
            return --index;
        } else if (self.seekRule == XYPopupSeekRuleAnticlockwise) {
            if (index == sourceInsets.count - 1) return 0;
            return ++index;
        } else if (self.seekRule == XYPopupSeekRuleSymmetryClockwise) {
            if (self.preferredDirection == index || labs(self.preferredDirection - index) != 2) {
                return index < 2 ? index + 2 : index - 2;
            } else {
                if (index == 0) return sourceInsets.count - 1;
                return --index;
            }
        } else {
            if (self.preferredDirection == index || labs(self.preferredDirection - index) != 2) {
                return index < 2 ? index + 2 : index - 2;
            } else {
                if (index == sourceInsets.count - 1) return 0;
                return ++index;
            }
        }
    };
    
    // find effective direction
    NSInteger startIndex = _preferredDirection;
    NSInteger roop = sourceInsets.count;
    while (roop) {
        CGFloat sourceInset = [sourceInsets[startIndex] floatValue];
        CGFloat popupSize = obtainPopupSize(startIndex);
        CGFloat popupMargin = obtainPopupMargin(startIndex);
        
        if (sourceInset < popupSize + _popupSpacing + popupMargin) {
            startIndex = obtainNextIndex(startIndex);
        } else {
            if ([self isHorizontal:startIndex]) {
                CGFloat padding = 0; BOOL topQuadrant;
                if (CGRectGetMidY(sourceRect) > CGRectGetMidY(_parentView.bounds)) {
                    padding = CGRectGetHeight(_parentView.bounds) - CGRectGetMidY(sourceRect) - _arrowOffset.y;
                    topQuadrant = NO;
                } else {
                    padding = CGRectGetMidY(sourceRect) - _arrowOffset.y;
                    topQuadrant = YES;
                }
                
                CGFloat verticalMargin = topQuadrant ? self.inset.top : self.inset.bottom;
                CGFloat minHalfPopupHeight = _cornerRadius + _arrowSize.width / 2 + verticalMargin;
                
                if (minHalfPopupHeight > padding) {
                    startIndex = obtainNextIndex(startIndex);
                } else break;
            } else {
                CGFloat padding = 0; BOOL leftQuadrant;
                if (CGRectGetMidX(sourceRect) > CGRectGetMidX(_parentView.bounds)) {
                    padding = CGRectGetWidth(_parentView.bounds) - CGRectGetMidX(sourceRect) - _arrowOffset.x;
                    leftQuadrant = NO;
                } else {
                    padding = CGRectGetMidX(sourceRect) - _arrowOffset.x;
                    leftQuadrant = YES;
                }
                
                CGFloat horizontalMargin = leftQuadrant ? self.inset.left : self.inset.right;
                CGFloat minHalfPopupWidth = _cornerRadius + _arrowSize.width / 2 + horizontalMargin;
                
                if (minHalfPopupWidth > padding) {
                    startIndex = obtainNextIndex(startIndex);
                } else break;
            }
        };
        roop--;
    }
    
    if (roop) {
        return startIndex;
    } else {
        return _preferredDirection;
    }
}

- (UIWindow *)obtainWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) return window;
                }
            }
        }
        return nil;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window) window = [UIApplication sharedApplication].delegate.window;
        return window;
#pragma clang dianostic pop
    }
}

- (BOOL)isHorizontal:(XYPopupDirection)direction {
    return direction == XYPopupDirectionLeft || direction == XYPopupDirectionRight;
}

- (BOOL)validateProperties {
    if (!_sourceView && !_sourceBarItem && CGRectEqualToRect(_sourceRect, CGRectMake(-1, -1, -1, -1))) return NO;
    if (_contentView.bounds.size.width == 0 || _contentView.bounds.size.height == 0) return NO;
    return YES;
}

#pragma mark ## Public
- (void)showAnimated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![self validateProperties]) return;
        if (self.isVisible) return;
        [self.parentView addSubview:self];
        [self setIsVisible:YES];
        if (animated) {
            __weak __typeof(self) weakSelf = self;
            [self.animator showWithCompletion:^(BOOL finished) {
                __strong __typeof(weakSelf) self = weakSelf;
                if (!self) return;
                if (self.didShowBlock) self.didShowBlock(self.parentView);
            }];
        } else {
            if (self.didShowBlock) self.didShowBlock(self.parentView);
        }
    });
}

- (void)hideAnimated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.isVisible) return;
        [self setIsVisible:NO];
        if (animated) {
            __weak __typeof(self) weakSelf = self;
            [self.animator hideWithCompletion:^(BOOL finished) {
                __strong __typeof(weakSelf) self = weakSelf;
                if (!self) return;
                [self removeFromSuperview];
                if (self.didHideBlock) self.didHideBlock(self.parentView);
            }];
        } else {
            [self removeFromSuperview];
            if (self.didHideBlock) self.didHideBlock(self.parentView);
        }
    });
}

#pragma mark # Access

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
}

// Appearence
- (void)setPopupSpacing:(CGFloat)popupSpacing {
    _popupSpacing = popupSpacing;
    [self setNeedsLayout];
}

- (void)setPopupMargin:(CGFloat)popupMargin {
    _popupMargin = popupMargin;
    [self setNeedsLayout];
}

- (void)setArrowSize:(CGSize)arrowSize {
    _arrowSize = arrowSize;
    [self setNeedsLayout];
}

- (void)setArrowOffset:(CGPoint)arrowOffset {
    _arrowOffset = arrowOffset;
    [self setNeedsLayout];
}

- (void)setMaskColor:(UIColor *)carrierColor {
    _maskColor = carrierColor;
    _maskView.backgroundColor = carrierColor;
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    ((CAShapeLayer *)_carrierView.layer).fillColor = fillColor.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsLayout];
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    _carrierView.layer.shadowColor = shadowColor.CGColor;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    _shadowOffset = shadowOffset;
    _carrierView.layer.shadowOffset = shadowOffset;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    _shadowRadius = shadowRadius;
    _carrierView.layer.shadowRadius = shadowRadius;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    _shadowOpacity = shadowOpacity;
    _carrierView.layer.shadowOpacity = shadowOpacity;
}

- (void)setAnimator:(XYPopupAnimator *)animator {
    _animator = animator;
    _animator.popupView = self;
}

- (void)setSourceBarItem:(UIBarItem *)sourceBarItem {
    if (![sourceBarItem respondsToSelector:@selector(view)]) {
        NSString *reason = @"Invalid source bar item";
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
    }
    _sourceBarItem = sourceBarItem;
}

- (UIEdgeInsets)inset {
    UIEdgeInsets marginInset = UIEdgeInsetsMake(_popupMargin, _popupMargin, _popupMargin, _popupMargin);
    if (!_definesSafeAreaAdaptation) return marginInset;
    if (@available(iOS 11.0, *)) {
        return UIEdgeInsetsMake(self.safeAreaInsets.top + marginInset.top,
                                self.safeAreaInsets.left + marginInset.left,
                                self.safeAreaInsets.bottom + marginInset.bottom,
                                self.safeAreaInsets.right + marginInset.right);
    }
    return marginInset;
}

@end

#pragma mark -

@implementation UIView (XYPopupView)

- (void)setXy_popup:(XYPopupView *)xy_popup {
    objc_setAssociatedObject(self, @selector(setXy_popup:), xy_popup, OBJC_ASSOCIATION_ASSIGN);
}

- (XYPopupView *)xy_popup {
    return objc_getAssociatedObject(self, @selector(setXy_popup:));
}

@end

#pragma mark -

@interface XYPopupView (XYAppearance)
@end

@implementation XYPopupView (XYAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XYPopupView *appearance = [XYPopupView appearance];
        appearance.popupSpacing = 10;
        appearance.popupMargin = 15;
        appearance.arrowSize = CGSizeMake(12, 6);
        appearance.arrowOffset = CGPointZero;
        appearance.maskColor = [UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:0.2];
        appearance.fillColor = [UIColor whiteColor];
        appearance.cornerRadius = 5;
        appearance.shadowColor = [UIColor colorWithWhite:0 alpha:0.1];
        appearance.shadowOffset = CGSizeZero;
        appearance.shadowRadius = 4;
        appearance.shadowOpacity = 1;
    });
}

@end
