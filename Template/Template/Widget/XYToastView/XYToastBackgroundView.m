//
//  XYToastBackgroundView.m
//  XYToastView
//
//  Created by nevsee on 2017/3/13.
//

#import "XYToastBackgroundView.h"

@implementation XYToastBackgroundView
@end

#pragma mark -

@interface XYToastDefaultBackgroundView ()
@property (nonatomic, strong) UIVisualEffectView *effectView;
@end

@implementation XYToastDefaultBackgroundView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.definesVisualContext = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_effectView setFrame:self.bounds];
}

- (void)setDefinesVisualContext:(BOOL)definesVisualContext {
    _definesVisualContext = definesVisualContext;

    if (definesVisualContext) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [self addSubview:effectView];
        _effectView = effectView;
    } else {
        [_effectView removeFromSuperview];
        _effectView = nil;
    }
}

// Appearance
- (void)setCornerRadii:(CGFloat)cornerRadii {
    _cornerRadii = cornerRadii;
    self.layer.cornerRadius = cornerRadii;
    if (@available(iOS 13.0, *)) {
        self.layer.cornerCurve = kCACornerCurveContinuous;
    }
}

- (void)setStyleColor:(UIColor *)styleColor {
    _styleColor = styleColor;
    self.backgroundColor = styleColor;
}

@end


#pragma mark -

@interface XYToastDefaultBackgroundView (XYAppearance)
@end

@implementation XYToastDefaultBackgroundView (XYAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XYToastDefaultBackgroundView *appearance = [XYToastDefaultBackgroundView appearance];
        appearance.styleColor = [UIColor colorWithWhite:0 alpha:0.9];
        appearance.cornerRadii = 6;
    });
}

@end
