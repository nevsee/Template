//
//  XYSearchController.m
//  XYWidget
//
//  Created by nevsee on 2020/11/12.
//

#import "XYSearchController.h"
#import <objc/runtime.h>

@interface XYSearchController () <XYSearchBarDelegate>
@property (nonatomic, strong, readwrite) XYSearchBar *searchBar;
@property (nonatomic, strong, readwrite) UIViewController *searchResultsController;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, assign) BOOL firstAppear;
@end

@implementation XYSearchController

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;

        _firstAppear = YES;
        _hidesResultControllerAutomatically = YES;
        _becomesFirstResponderAutomatically = YES;
        _searchResultsController = searchResultsController;
        _transition = [[XYSearchTransition alloc] init];
        _transition.animationStyle = XYSearchAnimationStyleFade;
        
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
        _backgroundView = backgroundView;

        XYSearchBar *searchBar = [[XYSearchBar alloc] init];
        searchBar.cancelButtonMode = XYSearchBarModeAlways;
        searchBar.textField.centersPlaceholder = NO;
        searchBar.delegate = self;
        _searchBar = searchBar;
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)];
        [backgroundView addGestureRecognizer:ges];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // background view
    [self.view addSubview:_backgroundView];

    // result controller
    _searchResultsController.view.hidden = _hidesResultControllerAutomatically;
    [self addChildViewController:_searchResultsController];
    [self.view addSubview:_searchResultsController.view];
    
    // search bar
    [self.view addSubview:_searchBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_firstAppear) return;
    _firstAppear = NO;
    if (!_becomesFirstResponderAutomatically) return;
    [_searchBar becomeFirstResponder];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _backgroundView.frame = self.view.bounds;
    
    if (_searchBarLayout) {
        _searchBarLayout(self);
    } else {
        CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
        navigationBarHeight = MAX(44, navigationBarHeight);
        if ([self.view respondsToSelector:@selector(safeAreaInsets)]) {
            navigationBarHeight += self.view.safeAreaInsets.top;
        }
        _searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, navigationBarHeight);
    }
    
    if (!_adaptsSemicircleCornerRadius) return;
    _searchBar.textFieldCornerRadius = _searchBar.textField.bounds.size.height / 2.0;
}

#pragma mark # Delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _transition.transitionType = XYSearchTransitionTypePresent;
    return _transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _transition.transitionType = XYSearchTransitionTypeDismiss;
    return _transition;
}

- (void)searchBarCancelButtonClicked:(XYSearchBar *)searchBar {
    [self dismissAction];
}

- (void)searchBarSearchButtonClicked:(XYSearchBar *)searchBar {
    if ([_searchResultsUpdater respondsToSelector:@selector(updateSearchResultsForSearchController:keyword:)]) {
        [_searchResultsUpdater updateSearchResultsForSearchController:self keyword:_searchBar.textField.text];
    }
    [_searchBar resignFirstResponder];
}

- (void)searchBar:(XYSearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (_hidesResultControllerAutomatically) {
        _searchResultsController.view.hidden = (searchText.length == 0);
    } else {
        _searchResultsController.view.hidden = NO;
    }
    
    if (!_updatesWhenSearchTextChanged && searchText.length > 0) return;
    if ([_searchResultsUpdater respondsToSelector:@selector(updateSearchResultsForSearchController:keyword:)]) {
        [_searchResultsUpdater updateSearchResultsForSearchController:self keyword:searchText.length > 0 ? searchText : nil];
    }
}

#pragma mark # Method

- (BOOL)shouldAutorotate {
    return _searchResultsController.shouldAutorotate;;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return _searchResultsController.supportedInterfaceOrientations;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return _searchResultsController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return _searchResultsController;
}

#pragma mark # Action

- (void)dismissAction {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark # Access

- (void)setDimColor:(UIColor *)dimColor {
    _dimColor = dimColor;
    _backgroundView.backgroundColor = dimColor ?: [UIColor colorWithWhite:0 alpha:0.15];
}

@end

@implementation UINavigationController (XYSearchController)

- (BOOL)supportSearchTransition {
    return objc_getAssociatedObject(self, @selector(setSupportSearchTransition:));
}

- (void)setSupportSearchTransition:(BOOL)supportSearchTransition {
    if (supportSearchTransition) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self.viewControllers.firstObject;
    } else {
        self.modalPresentationStyle = UIModalPresentationPopover;
        self.transitioningDelegate = nil;
    }
    objc_setAssociatedObject(self, _cmd, @(supportSearchTransition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation XYSearchTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (_animationStyle == XYSearchAnimationStyleSlide) {
        [self slideAnimationForTransitionContext:transitionContext];
    } else if (_animationStyle == XYSearchAnimationStyleFade) {
        [self fadeAnimationForTransitionContext:transitionContext];
    }
}

- (void)slideAnimationForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    UIView *cv = [transitionContext containerView];
    
    if (_transitionType == XYSearchTransitionTypePresent) {
        UIViewController *fvc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *tvc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        XYSearchController *svc = [tvc isKindOfClass:UINavigationController.class] ? ((UINavigationController *)tvc).viewControllers.firstObject : tvc;
        [svc.view layoutIfNeeded];
        
        tvc.view.frame = fvc.view.frame;
        [cv addSubview:tvc.view];
        
        CGFloat alpha = tvc.view.alpha;
        CGRect rect = svc.searchBar.frame;
        UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut;
        
        tvc.view.alpha = 0;
        svc.searchBar.frame = CGRectMake(rect.origin.x, -rect.size.height, rect.size.width, rect.size.height);
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:option animations:^{
            svc.searchBar.frame = rect;
            tvc.view.alpha = alpha;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        UIViewController *fvc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        XYSearchController *svc = [fvc isKindOfClass:UINavigationController.class] ? ((UINavigationController *)fvc).viewControllers.firstObject : fvc;
        
        CGRect rect = svc.searchBar.frame;
        UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:option animations:^{
            svc.searchBar.frame = CGRectMake(rect.origin.x, -rect.size.height, rect.size.width, rect.size.height);
            fvc.view.alpha = 0;
        } completion:^(BOOL finished) {
            [fvc.view removeFromSuperview];
            [fvc removeFromParentViewController];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

- (void)fadeAnimationForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    UIView *cv = [transitionContext containerView];
    
    if (_transitionType == XYSearchTransitionTypePresent) {
        UIViewController *fvc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *tvc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        tvc.view.frame = fvc.view.frame;
        [cv addSubview:tvc.view];
        
        CGFloat alpha = tvc.view.alpha;
        UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut;
        
        tvc.view.alpha = 0;
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:option animations:^{
            tvc.view.alpha = alpha;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        UIViewController *fvc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:option animations:^{
            fvc.view.alpha = 0;
        } completion:^(BOOL finished) {
            [fvc.view removeFromSuperview];
            [fvc removeFromParentViewController];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
