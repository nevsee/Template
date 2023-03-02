//
//  XYViewController.m
//  XYConstructor
//
//  Created by nevsee on 2017/3/26.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "XYViewController.h"

@interface XYViewController ()
@end

@implementation XYViewController

#pragma mark # Life

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self _didInitialize];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _userInterfaceSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 导航栏透明度, 背景色变换
    if (self.xy_navigationBarHidden || !animated || !self.transitionCoordinator) {
        [self navigationBarTransformation];
    } else {
        // 从有导航栏页面跳转到无导航栏页面, 需要跳转完成后再改变导航栏UI
        if (!self.xy_prefersNavigationBarHidden) {
            [self.transitionCoordinator animateAlongsideTransitionInView:self.view animation:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                [self navigationBarTransformation];
            } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                [self navigationBarTransformation];
            }];
        }
    }
    // 导航栏是否隐藏
    [self.xy_navigationController setNavigationBarHidden:self.xy_prefersNavigationBarHidden animated:self.xy_prefersNavigationBarAnimatedWhenHidden];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 从有导航栏页面跳转到无导航栏页面, 需要跳转完成后再改变导航栏UI
    if (self.xy_prefersNavigationBarHidden) {
        [self navigationBarTransformation];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_didInitialize {
    self.xy_shouldAutorotate = YES;
    self.xy_supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    self.xy_preferredInterfaceOrientationForPresentation = UIInterfaceOrientationPortrait;
    self.xy_preferredNavigationBarImage = [XYNavigationBarBackground appearance].barBackgroundImage;
    self.xy_preferredNavigationBarTintColor = [XYNavigationBarBackground appearance].barTintColor;
    self.xy_preferredNavigationBarSeparatorColor = [XYNavigationBarBackground appearance].barSeparatorColor;
    self.xy_preferredNavigationBarStyle = [XYNavigationBarBackground appearance].barStyle;
    self.xy_prefersNavigationBarTranslucent = [XYNavigationBarBackground appearance].barTranslucent;
    self.xy_preferredNavigationBarAlpha = 1;
    self.xy_prefersNavigationBarHidden = NO;
    self.xy_prefersNavigationBarAnimatedWhenHidden = YES;
    self.xy_interactivePopEnabled = YES;
}

- (void)_userInterfaceSetup {
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.xy_navigationController.viewControllers.count > 1) {
        UIButton *button = self.xy_backItem.customView;
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)navigationBarTransformation {
    self.xy_navigationBarBackground.barBackgroundImage = self.xy_preferredNavigationBarImage;
    self.xy_navigationBarBackground.barTintColor = self.xy_preferredNavigationBarTintColor;
    self.xy_navigationBarBackground.barSeparatorColor = self.xy_preferredNavigationBarSeparatorColor;
    self.xy_navigationBarBackground.barStyle = self.xy_preferredNavigationBarStyle;
    self.xy_navigationBarBackground.barTranslucent = self.xy_prefersNavigationBarTranslucent;
    self.xy_navigationBarBackground.alpha = self.xy_preferredNavigationBarAlpha;
}

#pragma mark # Action

- (void)backAction {
    [self xy_popViewController];
}

#pragma mark # Override

- (BOOL)shouldAutorotate {
    return self.xy_shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.xy_supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.xy_preferredInterfaceOrientationForPresentation;
}

@end
