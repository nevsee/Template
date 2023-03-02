//
//  UIView+XYBadge.m
//  XYWidget
//
//  Created by nevsee on 2020/7/8.
//

#import "UIView+XYBadge.h"
#import "NSObject+XYBadge.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#define _XYBadgeIsLandscape UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)

@protocol _XYBadgeProtocol <NSObject>
@property (nonatomic, assign) CGPoint offset;
@property (nonatomic, assign) CGPoint offsetLandscape;
@end

@interface _XYBadgeLabel : UILabel <_XYBadgeProtocol>
@property (nonatomic, assign) UIEdgeInsets textInsets;
@end

@implementation _XYBadgeLabel

@synthesize offset = _offset, offsetLandscape = _offsetLandscape;

- (void)setOffset:(CGPoint)offset {
    _offset = offset;
    if (!_XYBadgeIsLandscape) {
        [self.superview setNeedsLayout];
    }
}

- (void)setOffsetLandscape:(CGPoint)offsetLandscape {
    _offsetLandscape = offsetLandscape;
    if (_XYBadgeIsLandscape) {
        [self.superview setNeedsLayout];
    }
}

- (void)setTextInsets:(UIEdgeInsets)textInsets {
    _textInsets = textInsets;
    [self setNeedsDisplay];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat horizontalInterval = self.textInsets.left + self.textInsets.right;
    CGFloat verticalInterval = self.textInsets.top + self.textInsets.bottom;
    size = [super sizeThatFits:CGSizeMake(size.width - horizontalInterval, size.height - verticalInterval)];
    CGSize result = CGSizeMake(size.width + horizontalInterval, size.height + verticalInterval);
    result = CGSizeMake(MAX(result.width, result.height), result.height);
    return result;
}

- (CGSize)intrinsicContentSize {
    CGFloat preferredMaxLayoutWidth = self.preferredMaxLayoutWidth;
    if (preferredMaxLayoutWidth <= 0) {
        preferredMaxLayoutWidth = CGFLOAT_MAX;
    }
    return [self sizeThatFits:CGSizeMake(preferredMaxLayoutWidth, CGFLOAT_MAX)];
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textInsets)];
}

@end

@interface _XYBadgeIndicatorView : UIView <_XYBadgeProtocol>
@end

@implementation _XYBadgeIndicatorView

@synthesize offset = _offset, offsetLandscape = _offsetLandscape;

- (void)setOffset:(CGPoint)offset {
    _offset = offset;
    if (!_XYBadgeIsLandscape) {
        [self.superview setNeedsLayout];
    }
}

- (void)setOffsetLandscape:(CGPoint)offsetLandscape {
    _offsetLandscape = offsetLandscape;
    if (_XYBadgeIsLandscape) {
        [self.superview setNeedsLayout];
    }
}

@end

@interface UIView ()
@property (nonatomic, strong, readwrite) _XYBadgeLabel *xy_badgeLabel;
@property (nonatomic, strong, readwrite) _XYBadgeIndicatorView *xy_badgeIndicatorView;
@property (nonatomic, assign) BOOL xy_badgeNeedsLayout;
@end

@implementation UIView (XYBadge)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XYBadgeOverrideImplementation([UIView class], @selector(initWithFrame:), ^id(__unsafe_unretained Class originClass, SEL originSEL, IMP (^originIMPProvider)(void)) {
            return ^ UIView * (__unsafe_unretained __kindof UIView *selfObject, CGRect rect) {
                UIView * (*originIMP)(id, SEL, CGRect);
                originIMP = (UIView * (*)(id, SEL, CGRect))originIMPProvider();
                UIView *result = originIMP(selfObject, originSEL, rect);
                [selfObject _xy_badgeInitialization];
                return result;
            };
        });

        XYBadgeOverrideImplementation([UIView class], @selector(initWithCoder:), ^id(__unsafe_unretained Class originClass, SEL originSEL, IMP (^originIMPProvider)(void)) {
            return ^ UIView * (__unsafe_unretained __kindof UIView *selfObject, NSCoder *coder) {
                UIView * (*originIMP)(id, SEL, NSCoder *);
                originIMP = (UIView * (*)(id, SEL, NSCoder *))originIMPProvider();
                UIView *result = originIMP(selfObject, originSEL, coder);
                [selfObject _xy_badgeInitialization];
                return result;
            };
        });
        
        XYBadgeOverrideImplementation([UIView class], @selector(setXy_badgeNeedsLayout:), ^id(__unsafe_unretained Class originClass, SEL originSEL, IMP (^originIMPProvider)(void)) {
            return ^ (__unsafe_unretained __kindof UIView *selfObject, BOOL needsLayout) {
                [UIView _xy_badgeInvokeOnce:^{
                    XYBadgeOverrideImplementation([selfObject class], @selector(layoutSubviews), ^id(__unsafe_unretained Class originClass, SEL originSEL, IMP (^originIMPProvider)(void)) {
                        return ^ (__unsafe_unretained __kindof UIView *selfObject) {
                            void (*originIMP)(id, SEL);
                            originIMP = (void (*)(id, SEL))originIMPProvider();
                            originIMP(selfObject, originSEL);
                            [selfObject _xy_badgeLayoutSubviews];
                        };
                    });
                } forIndentifier:NSStringFromClass(selfObject.class)];
                void (*originIMP)(id, SEL, BOOL);
                originIMP = (void (*)(id, SEL, BOOL))originIMPProvider();
                originIMP(selfObject, originSEL, needsLayout);
            };
        });
    });
}

#pragma mark # Associated Object

- (void)setXy_badgeValue:(NSString *)xy_badgeValue {
    objc_setAssociatedObject(self, _cmd, xy_badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (xy_badgeValue.length > 0) {
        if (!self.xy_badgeLabel) {
            _XYBadgeLabel *badgeLabel = [[_XYBadgeLabel alloc] init];
            badgeLabel.clipsToBounds = YES;
            badgeLabel.textAlignment = NSTextAlignmentCenter;
            badgeLabel.backgroundColor = self.xy_badgeBackgroundColor;
            badgeLabel.textColor = self.xy_badgeTextColor;
            badgeLabel.font = self.xy_badgeFont;
            badgeLabel.textInsets = self.xy_badgeContentEdgeInsets;
            badgeLabel.offset = self.xy_badgeOffset;
            badgeLabel.offsetLandscape = self.xy_badgeOffsetLandscape;
            if (@available(iOS 13.0, *)) badgeLabel.layer.cornerCurve = kCACornerCurveContinuous;
            [self addSubview:badgeLabel];
            self.xy_badgeLabel = badgeLabel;
            self.xy_badgeNeedsLayout = YES;
        }
        self.xy_badgeLabel.text = xy_badgeValue;
        self.xy_badgeLabel.hidden = NO;
        [self _xy_badgeUpdateBadgeLabelLayoutIfNeeded];
    } else {
        self.xy_badgeLabel.text = nil;
        self.xy_badgeLabel.hidden = YES;
    }
}

- (NSString *)xy_badgeValue {
    return objc_getAssociatedObject(self, @selector(setXy_badgeValue:));
}

- (void)setXy_badgeBackgroundColor:(UIColor *)xy_badgeBackgroundColor {
    objc_setAssociatedObject(self, _cmd, xy_badgeBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.xy_badgeLabel.backgroundColor = xy_badgeBackgroundColor;
}

- (UIColor *)xy_badgeBackgroundColor {
    return objc_getAssociatedObject(self, @selector(setXy_badgeBackgroundColor:));
}

- (void)setXy_badgeTextColor:(UIColor *)xy_badgeTextColor {
    objc_setAssociatedObject(self, _cmd, xy_badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.xy_badgeLabel.textColor = xy_badgeTextColor;
}

- (UIColor *)xy_badgeTextColor {
    return objc_getAssociatedObject(self, @selector(setXy_badgeTextColor:));
}

- (void)setXy_badgeFont:(UIFont *)xy_badgeFont {
    objc_setAssociatedObject(self, _cmd, xy_badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.xy_badgeLabel.font = xy_badgeFont;
    [self _xy_badgeUpdateBadgeLabelLayoutIfNeeded];
}

- (UIFont *)xy_badgeFont {
    return objc_getAssociatedObject(self, @selector(setXy_badgeFont:));
}

- (void)setXy_badgeContentEdgeInsets:(UIEdgeInsets)xy_badgeContentEdgeInsets {
    objc_setAssociatedObject(self, _cmd, NSStringFromUIEdgeInsets(xy_badgeContentEdgeInsets), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.xy_badgeLabel.textInsets = xy_badgeContentEdgeInsets;
    [self _xy_badgeUpdateBadgeLabelLayoutIfNeeded];
}

- (UIEdgeInsets)xy_badgeContentEdgeInsets {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeContentEdgeInsets:));
    return UIEdgeInsetsFromString(value);
}

- (void)setXy_badgeOffset:(CGPoint)xy_badgeOffset {
    objc_setAssociatedObject(self, _cmd, NSStringFromCGPoint(xy_badgeOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.xy_badgeLabel.offset = xy_badgeOffset;
    [self _xy_badgeUpdateBadgeLabelLayoutIfNeeded];
}

- (CGPoint)xy_badgeOffset {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeOffset:));
    return CGPointFromString(value);
}

- (void)setXy_badgeOffsetLandscape:(CGPoint)xy_badgeOffsetLandscape {
    objc_setAssociatedObject(self, _cmd, NSStringFromCGPoint(xy_badgeOffsetLandscape), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.xy_badgeLabel.offsetLandscape = xy_badgeOffsetLandscape;
    [self _xy_badgeUpdateBadgeLabelLayoutIfNeeded];
}

- (CGPoint)xy_badgeOffsetLandscape {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeOffsetLandscape:));
    return CGPointFromString(value);
}

- (void)setXy_badgeLabel:(_XYBadgeLabel *)xy_badgeLabel {
    objc_setAssociatedObject(self, _cmd, xy_badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (_XYBadgeLabel *)xy_badgeLabel {
    return (_XYBadgeLabel *)objc_getAssociatedObject(self, @selector(setXy_badgeLabel:));
}

// Indicator

- (void)setXy_badgeShowIndicator:(BOOL)xy_badgeShowIndicator {
    objc_setAssociatedObject(self, _cmd, @(xy_badgeShowIndicator), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (xy_badgeShowIndicator) {
        if (!self.xy_badgeIndicatorView) {
            _XYBadgeIndicatorView *badgeIndicatorView = [[_XYBadgeIndicatorView alloc] initWithFrame:(CGRect){CGPointZero, self.xy_badgeIndicatorSize}];
            badgeIndicatorView.layer.cornerRadius = self.xy_badgeIndicatorSize.height / 2;
            badgeIndicatorView.backgroundColor = self.xy_badgeIndicatorColor;
            badgeIndicatorView.offset = self.xy_badgeIndicatorOffset;
            badgeIndicatorView.offsetLandscape = self.xy_badgeIndicatorOffsetLandscape;
            if (@available(iOS 13.0, *)) badgeIndicatorView.layer.cornerCurve = kCACornerCurveContinuous;
            [self addSubview:badgeIndicatorView];
            self.xy_badgeIndicatorView = badgeIndicatorView;
            self.xy_badgeNeedsLayout = YES;
        }
        self.xy_badgeIndicatorView.hidden = NO;
        [self _xy_badgeUpdateBadgeIndicatorLayoutIfNeeded];
    } else {
        self.xy_badgeIndicatorView.hidden = YES;
    }
}

- (BOOL)xy_badgeShowIndicator {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeShowIndicator:));
    return value.boolValue;
}

- (void)setXy_badgeIndicatorColor:(UIColor *)xy_badgeIndicatorColor {
    objc_setAssociatedObject(self, _cmd, xy_badgeIndicatorColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.xy_badgeIndicatorView.backgroundColor = xy_badgeIndicatorColor;
}

- (UIColor *)xy_badgeIndicatorColor {
    return objc_getAssociatedObject(self, @selector(setXy_badgeIndicatorColor:));
}

- (void)setXy_badgeIndicatorSize:(CGSize)xy_badgeIndicatorSize {
    objc_setAssociatedObject(self, _cmd, NSStringFromCGSize(xy_badgeIndicatorSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    CGPoint point = self.xy_badgeIndicatorView.frame.origin;
    self.xy_badgeIndicatorView.frame = (CGRect){point, xy_badgeIndicatorSize};
    self.xy_badgeIndicatorView.layer.cornerRadius = xy_badgeIndicatorSize.height / 2;
    [self _xy_badgeUpdateBadgeIndicatorLayoutIfNeeded];
}

- (CGSize)xy_badgeIndicatorSize {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeIndicatorSize:));
    return CGSizeFromString(value);
}

- (void)setXy_badgeIndicatorOffset:(CGPoint)xy_badgeIndicatorOffset {
    objc_setAssociatedObject(self, _cmd, NSStringFromCGPoint(xy_badgeIndicatorOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.xy_badgeIndicatorView.offset = xy_badgeIndicatorOffset;
    [self _xy_badgeUpdateBadgeIndicatorLayoutIfNeeded];
}

- (CGPoint)xy_badgeIndicatorOffset {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeIndicatorOffset:));
    return CGPointFromString(value);
}

- (void)setXy_badgeIndicatorOffsetLandscape:(CGPoint)xy_badgeIndicatorOffsetLandscape {
    objc_setAssociatedObject(self, _cmd, NSStringFromCGPoint(xy_badgeIndicatorOffsetLandscape), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.xy_badgeIndicatorView.offsetLandscape = xy_badgeIndicatorOffsetLandscape;
    [self _xy_badgeUpdateBadgeIndicatorLayoutIfNeeded];
}

- (CGPoint)xy_badgeIndicatorOffsetLandscape {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeIndicatorOffsetLandscape:));
    return CGPointFromString(value);
}

- (void)setXy_badgeIndicatorView:(_XYBadgeIndicatorView *)xy_badgeIndicatorView {
    objc_setAssociatedObject(self, _cmd, xy_badgeIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (_XYBadgeIndicatorView *)xy_badgeIndicatorView {
    return (_XYBadgeIndicatorView *)objc_getAssociatedObject(self, @selector(setXy_badgeIndicatorView:));
}

- (void)setXy_badgeNeedsLayout:(BOOL)xy_badgeNeedsLayout {
    objc_setAssociatedObject(self, _cmd, @(xy_badgeNeedsLayout), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xy_badgeNeedsLayout {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeNeedsLayout:));
    return value.boolValue;
}

#pragma mark # Private

- (void)_xy_badgeInitialization {
    self.xy_badgeBackgroundColor = [UIColor redColor];
    self.xy_badgeTextColor = [UIColor whiteColor];
    self.xy_badgeFont = [UIFont systemFontOfSize:11];
    self.xy_badgeContentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    self.xy_badgeOffset = CGPointMake(-8, 8);
    self.xy_badgeOffsetLandscape = CGPointMake(-8, 8);
    self.xy_badgeIndicatorColor = [UIColor redColor];
    self.xy_badgeIndicatorSize = CGSizeMake(8, 8);
    self.xy_badgeIndicatorOffset = CGPointMake(3, 3);
    self.xy_badgeIndicatorOffsetLandscape = CGPointMake(3, 3);
}

- (void)_xy_badgeUpdateBadgeLabelLayoutIfNeeded {
    if (self.xy_badgeValue.length > 0  && self.xy_badgeLabel) {
        self.clipsToBounds = NO;
        [self setNeedsLayout];
    }
}

- (void)_xy_badgeUpdateBadgeIndicatorLayoutIfNeeded {
    if (self.xy_badgeShowIndicator && self.xy_badgeIndicatorView) {
        self.clipsToBounds = NO;
        [self setNeedsLayout];
    }
}

- (UIView *)_xy_badgeFindBarButtonImageView {
    NSString *classString = NSStringFromClass(self.class);
    
    if ([classString isEqualToString:@"UITabBarButton"]) { // UITabBarItem
        if (@available(iOS 13.0, *)) {
            return [self xy_badgeValueForKey:@"_imageView"];
        }
        return [self xy_badgeValueForKey:@"_info"];
    }
       
    if ([classString isEqualToString:@"_UIButtonBarButton"]) {
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:UIButton.class]) {
                UIView *imageView = ((UIButton *)subview).imageView;
                if (imageView && !imageView.hidden) {
                    return imageView;
                }
            }
        }
    }
    
    return nil;
}

- (void)_xy_badgeLayoutSubviews {
    void (^layoutBlock)(UIView *view, UIView *badgeView) = ^void(UIView *view, UIView<_XYBadgeProtocol> *badgeView) {
        CGPoint offset = _XYBadgeIsLandscape ? badgeView.offsetLandscape : badgeView.offset;
        UIView *imageView = [view _xy_badgeFindBarButtonImageView];
        
        if (imageView) {
            CGRect imageViewFrame = [view convertRect:imageView.frame fromView:imageView.superview];
            badgeView.frame = CGRectMake(CGRectGetMaxX(imageViewFrame) + offset.x, CGRectGetMinY(imageViewFrame) - CGRectGetHeight(badgeView.frame) + offset.y, badgeView.bounds.size.width, badgeView.bounds.size.height);
        } else {
            badgeView.frame = CGRectMake(CGRectGetWidth(view.bounds) + offset.x, -CGRectGetHeight(badgeView.frame) + offset.y, badgeView.bounds.size.width, badgeView.bounds.size.height);
        }

        [view bringSubviewToFront:badgeView];
    };
    
    if (self.xy_badgeIndicatorView && !self.xy_badgeIndicatorView.hidden) {
        layoutBlock(self, self.xy_badgeIndicatorView);
    }
    
    if (self.xy_badgeLabel && !self.xy_badgeLabel.hidden) {
        [self.xy_badgeLabel sizeToFit];
        self.xy_badgeLabel.layer.cornerRadius = MIN(self.xy_badgeLabel.bounds.size.height / 2, self.xy_badgeLabel.bounds.size.width / 2);
        layoutBlock(self, self.xy_badgeLabel);
    }
}

static NSMutableSet *_badgeClassMaps;
+ (void)_xy_badgeInvokeOnce:(void (NS_NOESCAPE ^)(void))block forIndentifier:(NSString *)indentifier {
    if (!_badgeClassMaps) _badgeClassMaps = [NSMutableSet set];
    @synchronized (self) {
        if ([_badgeClassMaps containsObject:indentifier]) return;
        [_badgeClassMaps addObject:indentifier];
        if (block) block();
    }
}

@end

#pragma clang diagnostic pop
