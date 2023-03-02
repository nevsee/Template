//
//  XYNavigationController.m
//  XYConstructor
//
//  Created by nevsee on 2017/3/26.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "XYNavigationController.h"
#import "UIViewController+XYNavigation.h"
#import "UIViewController+XYAutorotation.h"

@interface XYNavigationController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong, readwrite) XYNavigationBarBackground *navigationBarBackground;
@property (nonatomic, assign) BOOL mark;
@end

@implementation XYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _parameterSetup];
    [self _navigationBarSetup];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self _userInterfaceSetup];
}

- (void)_parameterSetup {
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)_navigationBarSetup {
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundColor = [UIColor colorWithWhite:1 alpha:0.01];
        appearance.shadowColor = nil;
        appearance.backgroundEffect = nil;
        self.navigationBar.scrollEdgeAppearance = appearance;
        self.navigationBar.standardAppearance = appearance;
    } else {
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[UIImage new]];
    }
}

- (void)_userInterfaceSetup {
    UIView *background = self.navigationBar.subviews.firstObject;
    if (!background || self.mark) return;
    self.mark = !self.mark;
    [background addSubview:self.navigationBarBackground];
    NSArray *barHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navigationBarBackground]|" options:0 metrics:nil views:@{@"navigationBarBackground": self.navigationBarBackground}];
    NSArray *barVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigationBarBackground]|" options:0 metrics:nil views:@{@"navigationBarBackground": self.navigationBarBackground}];
    [background addConstraints:barHConstraints];
    [background addConstraints:barVConstraints];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 || !self.topViewController.xy_interactivePopEnabled) return NO;
    return [self.topViewController xy_poppingByInteractiveGestureRecognizer];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.hidesBackButton = YES;
        viewController.navigationItem.leftBarButtonItem = viewController.xy_backItem;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    UIViewController *vc = self.visibleViewController;
    vc = [self findEffectiveController:vc];
    return vc;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    UIViewController *vc = self.visibleViewController;
    vc = [self findEffectiveController:vc];
    return vc;
}

- (BOOL)shouldAutorotate {
    UIViewController *vc = self.visibleViewController;
    vc = [self findEffectiveController:vc];
    return vc.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *vc = self.visibleViewController;
    vc = [self findEffectiveController:vc];
    return vc.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    UIViewController *vc = self.visibleViewController;
    vc = [self findEffectiveController:vc];
    return vc.preferredInterfaceOrientationForPresentation;
}

- (UIViewController *)findEffectiveController:(UIViewController *)controller {
    if (!controller ||
        controller.isBeingDismissed ||
        controller.navigationController.isBeingDismissed ||
        [controller isKindOfClass:[UIAlertController class]]) {
        return self.topViewController;
    }
    return controller;
}

- (XYNavigationBarBackground *)navigationBarBackground {
    if (!_navigationBarBackground) {
        _navigationBarBackground = ({
            XYNavigationBarBackground *view = [[XYNavigationBarBackground alloc] init];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            view;
        });
    }
    return _navigationBarBackground;
}

@end

@interface XYNavigationBarBackground ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIView *separatorView;
@end

@implementation XYNavigationBarBackground

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
    NSArray *separatorViewVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[separatorView(==%@@700)]|", @(onePixel)] options:0 metrics:nil views:@{@"separatorView": self.separatorView}];
    
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
            UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            blurView.translatesAutoresizingMaskIntoConstraints = NO;
            blurView;
        });
    }
    return _blurView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.clipsToBounds = YES;
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

- (void)setAlpha:(CGFloat)alpha {
    [super setAlpha:1];
    self.blurView.alpha = alpha;
}

@end

@interface XYNavigationBarBackground (XYAppearance)
@end

@implementation XYNavigationBarBackground (XYAppearance)

+ (void)initialize {
    XYNavigationBarBackground *appearance = [XYNavigationBarBackground appearance];
    appearance.barStyle = UIBarStyleDefault;
    appearance.barTranslucent = YES;
    appearance.barTintColor = nil;
    appearance.barSeparatorColor = [UIColor colorWithWhite:0.85 alpha:1];
}

@end
