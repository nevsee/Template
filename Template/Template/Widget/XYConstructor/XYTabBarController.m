//
//  XYTabBarController.m
//  XYConstructor
//
//  Created by nevsee on 2017/3/26.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "XYTabBarController.h"

@interface XYTabBarController ()
@property (nonatomic, strong, readwrite) XYTabBarBackground *tabBarBackground;
@end

@implementation XYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _tabBarSetup];
    [self _userInterfaceSetup];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tabBarBackground.frame = (CGRect){0, 0, self.tabBar.frame.size};
}

- (void)_tabBarSetup {
    if (@available(iOS 13.0, *)) {
        UITabBarItem *barItem = [UITabBarItem appearance];
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        appearance.backgroundColor = nil;
        appearance.shadowColor = nil;
        appearance.backgroundEffect = nil;
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [barItem titleTextAttributesForState:UIControlStateHighlighted];
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [barItem titleTextAttributesForState:UIControlStateNormal];
        self.tabBar.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = appearance;
        }
    } else {
        [self.tabBar setBackgroundImage:[UIImage new]];
        [self.tabBar setShadowImage:[UIImage new]];
    }
}

- (void)_userInterfaceSetup {
    [self.tabBar insertSubview:self.tabBarBackground atIndex:0];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    UIViewController *vc = self.presentedViewController;
    vc = [self findEffectiveController:vc];
    return vc;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    UIViewController *vc = self.presentedViewController;
    vc = [self findEffectiveController:vc];
    return vc;
}

- (BOOL)shouldAutorotate {
    UIViewController *vc = self.presentedViewController;
    vc = [self findEffectiveController:vc];
    return vc.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *vc = self.presentedViewController;
    vc = [self findEffectiveController:vc];
    return vc.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    UIViewController *vc = self.presentedViewController;
    vc = [self findEffectiveController:vc];
    return vc.preferredInterfaceOrientationForPresentation;
}

- (UIViewController *)findEffectiveController:(UIViewController *)controller {
    if (!controller ||
        controller.isBeingDismissed ||
        controller.navigationController.isBeingDismissed ||
        [controller isKindOfClass:[UIAlertController class]]) {
        return self.selectedViewController;
    }
    return controller;
}

- (XYTabBarBackground *)tabBarBackground {
    if (!_tabBarBackground) {
        _tabBarBackground = ({
            XYTabBarBackground *view = [[XYTabBarBackground alloc] init];
            view;
        });
    }
    return _tabBarBackground;
}

@end

@interface XYTabBarBackground ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIView *separatorView;
@end

@implementation XYTabBarBackground

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self userInterfaceSetup];
    }
    return self;
}

- (void)userInterfaceSetup {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.blurView];
    [self.blurView.contentView addSubview:self.backgroundImageView];
    [self.blurView.contentView addSubview:self.separatorView];
    
    NSArray *blurViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blurView]|" options:0 metrics:nil views:@{@"blurView": self.blurView}];
    NSArray *blurViewVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blurView]|" options:0 metrics:nil views:@{@"blurView": self.blurView}];
    
    NSArray *backgroundImageViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundImageView]|" options:0 metrics:nil views:@{@"backgroundImageView": self.backgroundImageView}];
    NSArray *backgroundImageViewVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundImageView]|" options:0 metrics:nil views:@{@"backgroundImageView": self.backgroundImageView}];
    
    CGFloat onePixel = 1 / [UIScreen mainScreen].scale;
    NSArray *separatorViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separatorView]|" options:0 metrics:nil views:@{@"separatorView": self.separatorView}];
    NSArray *separatorViewVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[separatorView(==%@@700)]", @(onePixel)] options:0 metrics:nil views:@{@"separatorView": self.separatorView}];
    
    [self addConstraints:blurViewHConstraints];
    [self addConstraints:blurViewVConstraints];
    [self addConstraints:backgroundImageViewVConstraints];
    [self addConstraints:backgroundImageViewHConstraints];
    [self addConstraints:separatorViewHConstraints];
    [self addConstraints:separatorViewVConstraints];
}

- (void)transformBlurEffectStyle {
    UIBlurEffectStyle effectStyle = UIBlurEffectStyleExtraLight;
    if (self.barStyle == UIBarStyleBlack) {
        effectStyle = UIBlurEffectStyleDark;
    } else {
        if (self.barTintColor && CGColorGetAlpha(self.barTintColor.CGColor) > __FLT_EPSILON__) {
            effectStyle = UIBlurEffectStyleLight;
        }
    }
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:effectStyle];
    self.blurView.effect = blurEffect;
}

- (UIVisualEffectView *)blurView {
    if (!_blurView) {
        _blurView = ({
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            view;
        });
    }
    return _blurView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.layer.masksToBounds = YES;
            view.translatesAutoresizingMaskIntoConstraints = NO;
            view;
        });
    }
    return _backgroundImageView;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = ({
            UIView *view = [[UIView alloc] init];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            view;
        });
    }
    return _separatorView;
}

- (void)setBarStyle:(UIBarStyle)barStyle {
    _barStyle = barStyle;
    [self transformBlurEffectStyle];
}

- (void)setBarTranslucent:(BOOL)barTranslucent {
    _barTranslucent = barTranslucent;
    if (!_barTintColor) return;
    [self setBarTintColor:_barTintColor];
}

- (void)setBarBackgroundImage:(UIImage *)barImage {
    _barBackgroundImage = barImage;
    self.backgroundImageView.image = barImage;
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    _barTintColor = barTintColor;
    if (self.barTranslucent && CGColorGetAlpha(barTintColor.CGColor) > 0.83) {
        barTintColor = [barTintColor colorWithAlphaComponent:0.83];
    }
    self.blurView.contentView.backgroundColor = barTintColor;
    [self transformBlurEffectStyle];
}

- (void)setBarSeparatorColor:(UIColor *)barShadowColor {
    _barSeparatorColor = barShadowColor;
    self.separatorView.backgroundColor = barShadowColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
}

@end

@interface XYTabBarBackground (XYAppearance)
@end

@implementation XYTabBarBackground (XYAppearance)

+ (void)initialize {
    XYTabBarBackground *appearance = [XYTabBarBackground appearance];
    appearance.barStyle = UIBarStyleDefault;
    appearance.barTranslucent = YES;
    appearance.barTintColor = nil;
    appearance.barSeparatorColor = [UIColor colorWithWhite:0.85 alpha:1];
}

@end
