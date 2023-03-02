//
//  YYBaseController.m
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "YYBaseController.h"

@interface YYBaseController ()
@property (nonatomic, strong, readwrite) YYEmptyView *emptyView;
@end

@implementation YYBaseController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self didInitialize];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self parameterSetup];
    [self navigationBarSetup];
    [self userInterfaceSetup];
    [self startLoading];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutEmptyView];
}

- (void)didInitialize {
    self.xy_preferredBackItemImage = XYImageMake(@"back_1");
    self.xy_shouldAutorotate = YES;
    self.xy_supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    self.xy_preferredInterfaceOrientationForPresentation = UIInterfaceOrientationPortrait;
}

- (void)parameterSetup {
    
}

- (void)navigationBarSetup {
    
}

- (void)navigationBarSetupLazily {
    
}

- (void)userInterfaceSetup {
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)userInterfaceSetupLazily {
    
}

- (void)startLoading {
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

// YYEmptyView

- (BOOL)isEmptyViewShown {
    return _emptyView && _emptyView.superview;
}

- (void)showEmptyView {
    if (self.isViewLoaded && !_emptyView.superview) {
        [self.view addSubview:self.emptyView];
    }
    // emptyView父视图为nil时，不会触发加载动画，这里重新设置一次
    _emptyView.mode = _emptyView.mode;
}

- (void)hideEmptyView {
    [_emptyView removeFromSuperview];
}

- (void)layoutEmptyView {
    if (!_emptyView.superview) return;
    _emptyView.frame = self.view.bounds;
}

- (void)emptyViewRetryAction {
    
}

// Access
- (YYEmptyView *)emptyView {
    if (!_emptyView) {
        YYEmptyView *view = [YYEmptyView defaultViewWithTarget:self retryAction:@selector(emptyViewRetryAction)];
        view.backgroundColor = UIColor.whiteColor;
        _emptyView = view;
    }
    return _emptyView;
}

@end
