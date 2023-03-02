//
//  UIBarItem+XYBadge.m
//  XYWidget
//
//  Created by nevsee on 2019/4/12.
//

#import "UIBarItem+XYBadge.h"
#import "UIView+XYBadge.h"
#import "NSObject+XYBadge.h"
#import <objc/runtime.h>

@interface _XYBadgeDeallocMonitor : NSObject
@property (nonatomic, copy) void (^block)(__unsafe_unretained id target);
@property (nonatomic, unsafe_unretained) id target;
@end

@implementation _XYBadgeDeallocMonitor
- (void)dealloc {
    if (_block) _block(_target);
}
@end

@implementation UIBarItem (XYBadge)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XYBadgeOverrideImplementation([UIBarItem class], @selector(init), ^id(__unsafe_unretained Class originClass, SEL originSEL, IMP (^originIMPProvider)(void)) {
            return ^ UIView * (__unsafe_unretained __kindof UIBarItem *selfObject) {
                UIView * (*originIMP)(id, SEL);
                originIMP = (UIView * (*)(id, SEL))originIMPProvider();
                UIView *result = originIMP(selfObject, originSEL);
                [selfObject _xy_badgeInitialization];
                return result;
            };
        });

        XYBadgeOverrideImplementation([UIBarItem class], @selector(initWithCoder:), ^id(__unsafe_unretained Class originClass, SEL originSEL, IMP (^originIMPProvider)(void)) {
            return ^ UIView * (__unsafe_unretained __kindof UIBarItem *selfObject, NSCoder *coder) {
                UIView * (*originIMP)(id, SEL, NSCoder *);
                originIMP = (UIView * (*)(id, SEL, NSCoder *))originIMPProvider();
                UIView *result = originIMP(selfObject, originSEL, coder);
                [selfObject _xy_badgeInitialization];
                return result;
            };
        });
    });
}

#pragma mark # Associated Object

- (void)setXy_badgeValue:(NSString *)xy_badgeValue {
    objc_setAssociatedObject(self, _cmd, xy_badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _xy_badgeFindBarItemInnerView].xy_badgeValue = xy_badgeValue;
}

- (NSString *)xy_badgeValue {
    return objc_getAssociatedObject(self, @selector(setXy_badgeValue:));
}

- (void)setXy_badgeBackgroundColor:(UIColor *)xy_badgeBackgroundColor {
    objc_setAssociatedObject(self, _cmd, xy_badgeBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _xy_badgeFindBarItemInnerView].xy_badgeBackgroundColor = xy_badgeBackgroundColor;
}

- (UIColor *)xy_badgeBackgroundColor {
    return objc_getAssociatedObject(self, @selector(setXy_badgeBackgroundColor:));
}

- (void)setXy_badgeTextColor:(UIColor *)xy_badgeTextColor {
    objc_setAssociatedObject(self, _cmd, xy_badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _xy_badgeFindBarItemInnerView].xy_badgeTextColor = xy_badgeTextColor;
}

- (UIColor *)xy_badgeTextColor {
    return objc_getAssociatedObject(self, @selector(setXy_badgeTextColor:));
}

- (void)setXy_badgeFont:(UIFont *)xy_badgeFont {
    objc_setAssociatedObject(self, _cmd, xy_badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _xy_badgeFindBarItemInnerView].xy_badgeFont = xy_badgeFont;
}

- (UIFont *)xy_badgeFont {
    return objc_getAssociatedObject(self, @selector(setXy_badgeFont:));
}

- (void)setXy_badgeContentEdgeInsets:(UIEdgeInsets)xy_badgeContentEdgeInsets {
    objc_setAssociatedObject(self, _cmd, NSStringFromUIEdgeInsets(xy_badgeContentEdgeInsets), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _xy_badgeFindBarItemInnerView].xy_badgeContentEdgeInsets = xy_badgeContentEdgeInsets;
}

- (UIEdgeInsets)xy_badgeContentEdgeInsets {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeContentEdgeInsets:));
    return UIEdgeInsetsFromString(value);
}

- (void)setXy_badgeOffset:(CGPoint)xy_badgeOffset {
    objc_setAssociatedObject(self, _cmd, NSStringFromCGPoint(xy_badgeOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _xy_badgeFindBarItemInnerView].xy_badgeOffset = xy_badgeOffset;
}

- (CGPoint)xy_badgeOffset {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeOffset:));
    return CGPointFromString(value);
}

- (void)setXy_badgeOffsetLandscape:(CGPoint)xy_badgeOffsetLandscape {
    objc_setAssociatedObject(self, _cmd, NSStringFromCGPoint(xy_badgeOffsetLandscape), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _xy_badgeFindBarItemInnerView].xy_badgeOffsetLandscape = xy_badgeOffsetLandscape;
}

- (CGPoint)xy_badgeOffsetLandscape {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeOffsetLandscape:));
    return CGPointFromString(value);
}

- (UILabel *)xy_badgeLabel {
    return [self _xy_badgeFindBarItemInnerView].xy_badgeLabel;
}

// Indicator

- (void)setXy_badgeShowIndicator:(BOOL)xy_badgeShowIndicator {
    objc_setAssociatedObject(self, _cmd, @(xy_badgeShowIndicator), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _xy_badgeFindBarItemInnerView].xy_badgeShowIndicator = xy_badgeShowIndicator;
}

- (BOOL)xy_badgeShowIndicator {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeShowIndicator:));
    return value.boolValue;
}

- (void)setXy_badgeIndicatorColor:(UIColor *)xy_badgeIndicatorColor {
    objc_setAssociatedObject(self, _cmd, xy_badgeIndicatorColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _xy_badgeFindBarItemInnerView].xy_badgeIndicatorColor = xy_badgeIndicatorColor;
}

- (UIColor *)xy_badgeIndicatorColor {
    return objc_getAssociatedObject(self, @selector(setXy_badgeIndicatorColor:));
}

- (void)setXy_badgeIndicatorSize:(CGSize)xy_badgeIndicatorSize {
    objc_setAssociatedObject(self, _cmd, NSStringFromCGSize(xy_badgeIndicatorSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _xy_badgeFindBarItemInnerView].xy_badgeIndicatorSize = xy_badgeIndicatorSize;
}

- (CGSize)xy_badgeIndicatorSize {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeIndicatorSize:));
    return CGSizeFromString(value);
}

- (void)setXy_badgeIndicatorOffset:(CGPoint)xy_badgeIndicatorOffset {
    objc_setAssociatedObject(self, _cmd, NSStringFromCGPoint(xy_badgeIndicatorOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _xy_badgeFindBarItemInnerView].xy_badgeIndicatorOffset = xy_badgeIndicatorOffset;
}

- (CGPoint)xy_badgeIndicatorOffset {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeIndicatorOffset:));
    return CGPointFromString(value);
}

- (void)setXy_badgeIndicatorOffsetLandscape:(CGPoint)xy_badgeIndicatorOffsetLandscape {
    objc_setAssociatedObject(self, _cmd, NSStringFromCGPoint(xy_badgeIndicatorOffsetLandscape), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _xy_badgeFindBarItemInnerView].xy_badgeIndicatorOffsetLandscape = xy_badgeIndicatorOffsetLandscape;
}

- (CGPoint)xy_badgeIndicatorOffsetLandscape {
    NSString *value = objc_getAssociatedObject(self, @selector(setXy_badgeIndicatorOffsetLandscape:));
    return CGPointFromString(value);
}

- (UIView *)xy_badgeIndicatorView {
    return [self _xy_badgeFindBarItemInnerView].xy_badgeIndicatorView;
}

// kvc

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    UIView *innerView = [change valueForKey:NSKeyValueChangeNewKey];
    if (innerView) {
        [self _xy_badgeUpdateBarItemInnerView:innerView];
    }
}

#pragma mark # Private

- (void)_xy_badgeInitialization {
    self.xy_badgeBackgroundColor = [UIColor redColor];
    self.xy_badgeTextColor = [UIColor whiteColor];
    self.xy_badgeFont = [UIFont systemFontOfSize:11];
    self.xy_badgeContentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);

    self.xy_badgeIndicatorColor = [UIColor redColor];
    self.xy_badgeIndicatorSize = CGSizeMake(8, 8);
    
    if (self.class == UITabBarItem.class) {
        self.xy_badgeOffset = CGPointMake(-6, 12);
        self.xy_badgeOffsetLandscape = CGPointMake(-6, 12);
        self.xy_badgeIndicatorOffset = CGPointMake(0, 2);
        self.xy_badgeIndicatorOffsetLandscape = CGPointMake(0, 2);
    } else {
        self.xy_badgeOffset = CGPointMake(-8, 12);
        self.xy_badgeOffsetLandscape = CGPointMake(-8, 12);
        self.xy_badgeIndicatorOffset = CGPointMake(0, 4);
        self.xy_badgeIndicatorOffsetLandscape = CGPointMake(0, 4);
    }
    
    // Add observer
    [self addObserver:self forKeyPath:@"view" options:NSKeyValueObservingOptionNew context:nil];
    
    // Remove observer
    static char _XYBadgeDeallocMonitorKey;
    _XYBadgeDeallocMonitor *monitor = objc_getAssociatedObject(self, &_XYBadgeDeallocMonitorKey);
    if (!monitor) {
        monitor = [[_XYBadgeDeallocMonitor alloc] init];
        monitor.target = self;
        monitor.block = ^(__unsafe_unretained id target) {
            [target removeObserver:target forKeyPath:@"view"];
        };
        objc_setAssociatedObject(self, &_XYBadgeDeallocMonitorKey, monitor, OBJC_ASSOCIATION_RETAIN);
    }
}

- (UIView *)_xy_badgeFindBarItemInnerView {
    if ([self respondsToSelector:@selector(view)]) {
        return [self xy_badgeValueForKey:@"view"];
    }
    return nil;
}

- (void)_xy_badgeUpdateBarItemInnerView:(UIView *)innerView {
    innerView.xy_badgeValue = self.xy_badgeValue;
    innerView.xy_badgeBackgroundColor = self.xy_badgeBackgroundColor;
    innerView.xy_badgeTextColor = self.xy_badgeTextColor;
    innerView.xy_badgeFont = self.xy_badgeFont;
    innerView.xy_badgeContentEdgeInsets = self.xy_badgeContentEdgeInsets;
    innerView.xy_badgeOffset = self.xy_badgeOffset;
    innerView.xy_badgeOffsetLandscape = self.xy_badgeOffsetLandscape;
    
    innerView.xy_badgeShowIndicator = self.xy_badgeShowIndicator;
    innerView.xy_badgeIndicatorColor = self.xy_badgeIndicatorColor;
    innerView.xy_badgeIndicatorSize = self.xy_badgeIndicatorSize;
    innerView.xy_badgeIndicatorOffset = self.xy_badgeIndicatorOffset;
    innerView.xy_badgeIndicatorOffsetLandscape = self.xy_badgeIndicatorOffsetLandscape;
}

@end
