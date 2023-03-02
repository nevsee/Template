//
//  XYBrowserController.m
//  XYBrowser
//
//  Created by nevsee on 2022/9/27.
//

#import "XYBrowserController.h"

@interface XYBrowserView ()
@property (nonatomic, weak) XYBrowserController *browserController;
@end

@interface XYBrowserController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIView<XYBrowserCarrierDescriber> *carrierView;
@property (nonatomic, assign) CGPoint touchLocation;
@property (nonatomic, assign) CGPoint touchVelocity;
@property (nonatomic, assign) CGRect originalContentRect;
@property (nonatomic, assign) BOOL currentStatusBarHiddenState;
@property (nonatomic, assign) BOOL originalStatusBarHiddenState;
@end

@implementation XYBrowserController

- (instancetype)initWithBrowserView:(XYBrowserView *)browserView {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        self.transitioningDelegate = self;
        
        if (browserView) _browserView = browserView;
        else _browserView = [[XYBrowserView alloc] init];
        _browserView.browserController = self;
        _dismissProgressThreshold = 0.5;
        _dismissSpeedThreshold = 920;
        _statusBarHidden = YES;
        _transition = [[XYBrowserAnimatedTransition alloc] init];
        _transition.browserController = self;
    }
    return self;
}

- (instancetype)init {
    return [self initWithBrowserView:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:_browserView];
    [_browserView updateSubviewValue];
    
    UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:ges];
    _panGestureRecognizer = ges;
    
    if (@available(iOS 13.0, *)) {
        _originalStatusBarHiddenState = self.presentingViewController.view.window.windowScene.statusBarManager.statusBarHidden;
    } else {
        _originalStatusBarHiddenState = UIApplication.sharedApplication.statusBarHidden;
    }
    _currentStatusBarHiddenState = _originalStatusBarHiddenState;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // delay the hidden time
    if (_originalStatusBarHiddenState != _statusBarHidden) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_transition.duration / 3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateStatusBarAppearance:self.statusBarHidden];
        });
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _browserView.frame = self.view.bounds;
}

#pragma mark # Delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _transition.type = XYBrowserTransitionTypePresent;
    return  _transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    [self updateStatusBarAppearance:_originalStatusBarHiddenState];
    _transition.type = XYBrowserTransitionTypeDismiss;
    return  _transition;
}

#pragma mark # Action

- (void)panAction:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        _touchVelocity = [sender velocityInView:self.view];
        _touchLocation = [sender locationInView:self.view];
        _carrierView = [_browserView carrierViewAtIndex:_browserView.currentIndex];
        _originalContentRect = _carrierView.contentView.frame;
        [_carrierView updateClipsToBounds:NO];
        [_carrierView updateSubviewAlphaExceptPlayer:0];
        [_browserView updateSubviewAlphaExceptCarrier:0];
        [_transition updateSourceViewStateIfNeeded];
        [self updateStatusBarAppearance:_originalStatusBarHiddenState];
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        if (_touchVelocity.y < 0) return;
        CGPoint location = [sender locationInView:self.view];
        CGFloat xDistance = location.x - _touchLocation.x;
        CGFloat yDistance = location.y - _touchLocation.y;
        CGFloat alpha = 1, ratio = 1;
        
        if (yDistance > 0) { // down
            alpha = 1 - yDistance / self.view.bounds.size.height * 3;
            ratio = 1 - yDistance / self.view.bounds.size.height / 2;
        }
        CGAffineTransform transform = CGAffineTransformMakeTranslation(xDistance, yDistance);
        transform = CGAffineTransformScale(transform, ratio, ratio);
        CGRect newRect = CGRectApplyAffineTransform(_originalContentRect, transform);
        _carrierView.contentView.frame = newRect;
        self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:alpha];
    }
    else {
        if (_touchVelocity.y < 0) return;
        CGPoint velocity = [sender velocityInView:self.view];
        
        if (velocity.y > _dismissSpeedThreshold) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            CGPoint location = [sender locationInView:self.view];
            CGFloat yDistance = location.y - _touchLocation.y;
            CGFloat progress = yDistance / (self.view.bounds.size.height / 2);
            if (progress > _dismissProgressThreshold) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                // reset carrier view
                [UIView animateWithDuration:0.2 animations:^{
                    self.carrierView.contentView.frame = self.originalContentRect;
                    self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
                } completion:^(BOOL finished) {
                    [self updateStatusBarAppearance:self.statusBarHidden];
                    [self.carrierView updateSubviewAlphaExceptPlayer:1];
                    [self.carrierView updateClipsToBounds:YES];
                    [self.browserView updateSubviewAlphaExceptCarrier:1];
                    [self reset];
                }];
            }
        }
    }
}

#pragma mark # Method

- (BOOL)prefersStatusBarHidden {
    return _currentStatusBarHiddenState;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

- (BOOL)shouldAutorotate {
    return _autorotateEnabled;
}

- (void)updateStatusBarAppearance:(BOOL)hidden {
    if (_currentStatusBarHiddenState == hidden) return;
    _currentStatusBarHiddenState = hidden;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)reset {
    _touchLocation = CGPointZero;
    _touchVelocity = CGPointZero;
    _carrierView = nil;
}

@end

