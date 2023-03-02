//
//  XYPromptContainerController.m
//  XYPrompter
//
//  Created by nevsee on 2018/9/20.
//

#import "XYPromptContainerController.h"
#import "XYPrompter.h"
#import <objc/runtime.h>

@interface XYPromptContainerController ()
@property (nonatomic, strong, readwrite) UIView *contentView;
@property (nonatomic, strong, readwrite) UIView<XYPromptContainerBackgroundDescriber> *backgroundView;
@property (nonatomic, assign, readonly) UIEdgeInsets safeInsets;
@property (nonatomic, assign, readonly) BOOL willDismiss;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, assign) CGRect keyboardFrame;
@property (nonatomic, assign) BOOL isKeyboardVisible;
@end

@implementation XYPromptContainerController

#pragma mark # Life

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self addNotification];
    [self userInterfaceSetup];
}

- (void)userInterfaceSetup {
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.contentView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.xy_prompter.willPresentBlock) self.xy_prompter.willPresentBlock();
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.xy_prompter.didPresentBlock) self.xy_prompter.didPresentBlock();
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.xy_prompter.willDismissBlock) self.xy_prompter.willDismissBlock();
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.xy_prompter.didDismissBlock) self.xy_prompter.didDismissBlock();
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self calculateLayouts];
}

- (void)dealloc {
    [self removeObserver];
    [self removeNotification];
    if (!_child) return;
    // break retain cycle for window mode
    [_child.xy_prompter setValue:nil forKey:@"containerWindow"];
}

#pragma mark # Action

- (void)keyboardChangeNotice:(NSNotification *)sender {
    if (!self.xy_prompter.definesKeyboardAdaptation) return;
    if (self.willDismiss) return;
    
    // keyboard properties
    CGRect keyboardFrame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval keyboardDuration = [sender.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve keyboardCurve = [sender.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    UIViewAnimationOptions keyboardOptions = keyboardCurve | (keyboardCurve << 16);
    _keyboardFrame = keyboardFrame;
    
    // keyboard visible
    _isKeyboardVisible = [sender.name isEqualToString:UIKeyboardWillShowNotification];
    
    // transform
    CGFloat interval = [self distanceFromKeyboard:_originFrame];
    if (_isKeyboardVisible && interval < 0) return;
    CGRect rect = (CGRect){_originFrame.origin.x, _originFrame.origin.y - interval, _originFrame.size};
    
    // begin the animation
    [UIView animateWithDuration:keyboardDuration delay:0 options:keyboardOptions animations:^{
        self.contentView.frame = self.isKeyboardVisible ? rect : self.originFrame;
    } completion:nil];
}

- (void)dismissAction {
    if (self.xy_prompter.definesDismissalTouch) [self.xy_prompter dismiss];
    if (!_child) return;
    if (self.xy_prompter.definesKeyboardHiddenTouch) [_child.view endEditing:YES];
}

#pragma mark # Method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.willDismiss) return;
    if (![object isEqual:_child]) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL animated = self.xy_prompter.definesSizeChangingAnimation;
        NSTimeInterval duration = animated ? 0.25 : 0;
        UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:duration delay:0 options:option animations:^{
            [self calculateLayouts];
        } completion:nil];

        // send notification
        NSDictionary *userInfo = @{
            XYPrompterAnimationDurationUserInfoKey: @(duration),
            XYPrompterAnimationOptionUserInfoKey: @(option)
        };
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:XYPrompterContentSizeChangeNotification object:self.child userInfo:userInfo];
    });
}

- (BOOL)shouldAutorotate {
    return self.xy_prompter.autorotation.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.xy_prompter.autorotation.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.xy_prompter.autorotation.preferredInterfaceOrientationForPresentation;
}

- (BOOL)prefersStatusBarHidden {
    return self.child.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.child.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.child.preferredStatusBarUpdateAnimation;
}

- (CGFloat)distanceFromKeyboard:(CGRect)rect {
    CGFloat minimumSpacing = self.xy_prompter.keyboardSpacing;
    CGFloat bottom = rect.origin.y + rect.size.height;
    return bottom + minimumSpacing - _keyboardFrame.origin.y;
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeNotice:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeNotice:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObserver {
    if (!_child) return;
    [_child addObserver:self forKeyPath:@"xy_portraitContentSize" options:NSKeyValueObservingOptionNew context:NULL];
    [_child addObserver:self forKeyPath:@"xy_landscapeContentSize" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeObserver {
    if (!_child) return;
    [_child removeObserver:self forKeyPath:@"xy_portraitContentSize"];
    [_child removeObserver:self forKeyPath:@"xy_landscapeContentSize"];
}

- (void)calculateLayouts {
    if (self.willDismiss || !_child) return;
    
    CGSize vsize = self.view.bounds.size;
    CGSize size = vsize.width > vsize.height ? _child.xy_landscapeContentSize : _child.xy_portraitContentSize;
    UIEdgeInsets inset = self.safeInsets;
    CGPoint point = self.xy_prompter.contentOffset;
    XYPromptPosition position = self.xy_prompter.position;
    CGFloat cx = point.x, cy = point.y, cw = size.width, ch = size.height;

    switch (position) {
        case XYPromptPositionCenter:
            cx += (vsize.width - size.width) / 2;
            cy += (vsize.height - size.height) / 2;
            break;
        case XYPromptPositionTop:
            cx += (vsize.width - size.width) / 2;
            cy += inset.top;
            break;
        case XYPromptPositionLeft:
            cx += inset.left;
            cy += (vsize.height - size.height) / 2;
            break;
        case XYPromptPositionBottom:
            cx += (vsize.width - size.width) / 2;
            cy += vsize.height - size.height - inset.bottom;
            break;
        case XYPromptPositionRight:
            cx += vsize.width - size.width - inset.right;
            cy += (vsize.height - size.height) / 2;
            break;
    }
    
    // background view
    _backgroundView.frame = self.view.bounds;
    
    // content view
    if (_isKeyboardVisible) {
        CGRect rect = CGRectMake(cx, cy, cw, ch);
        CGFloat distance = [self distanceFromKeyboard:rect];
        CGFloat x = 0;
        CGFloat y = distance >= 0 ? rect.origin.y - distance : rect.origin.y;

        if (position == XYPromptPositionTop || position == XYPromptPositionBottom || position == XYPromptPositionCenter) {
            x = rect.origin.x - (cw - rect.size.width) / 2;
        } else if (position == XYPromptPositionRight) {
            x = rect.origin.x - (cw - rect.size.width);
        }
        _contentView.frame = CGRectMake(x, y, cw, ch);
    } else {
        _contentView.frame = CGRectMake(cx, cy, cw, ch);
    }
    
    _child.view.frame = CGRectMake(0, 0, cw, ch);
    _originFrame = CGRectMake(cx, cy, cw, ch);
}

#pragma mark # Access

- (UIEdgeInsets)safeInsets {
    if (!self.xy_prompter.definesSafeAreaAdaptation) return UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) return self.view.safeAreaInsets;
    return UIEdgeInsetsZero;
}

- (BOOL)willDismiss {
    return self.navigationController.beingDismissed || self.beingDismissed;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        UIView<XYPromptContainerBackgroundDescriber> *view = nil;
        Class cls = self.xy_prompter.backgroundViewClass;
        if (cls == NULL || ![cls isSubclassOfClass:[UIView class]] || ![cls respondsToSelector:@selector(transitWithDuration:present:)]) {
            XYPromptContainerBackgroundView *defaultView = [[XYPromptContainerBackgroundView alloc] init];
            defaultView.prompter = self.xy_prompter;
            view = defaultView;
        } else {
            view = [[cls alloc] init];
        }
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)];
        [view addGestureRecognizer:ges];
        _backgroundView = view;
    }
    return _backgroundView;
}

- (UIView *)contentView {
    if (!_contentView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _contentView = view;
    }
    return _contentView;
}

@end

#pragma mark -

@interface XYPromptContainerBackgroundView ()
@property (nonatomic, strong) UIVisualEffectView *effectView;
@end

@implementation XYPromptContainerBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.effectView];
    }
    return self;
}

- (void)transitWithDuration:(NSTimeInterval)duration present:(BOOL)present {
    if (present) {
        self.backgroundColor = UIColor.clearColor;
        self.effectView.effect = nil;
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.backgroundColor = self.prompter.backgroundColor;
            self.effectView.effect = self.prompter.backgroundEffect;
        } completion:nil];
    } else {
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.backgroundColor = UIColor.clearColor;
            self.effectView.effect = nil;
        } completion:nil];
    }
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIVisualEffectView *view = [[UIVisualEffectView alloc] init];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _effectView = view;
    }
    return _effectView;
}

@end

#pragma mark -

@implementation XYPromptContainerWindow

@end

#pragma mark -

@implementation XYPromptContainerRootController

- (BOOL)prefersStatusBarHidden {
    if ([self.prompter.presentedViewController isKindOfClass:UINavigationController.class] || [self.prompter.presentedViewController isKindOfClass:UITabBarController.class]) {
        return self.prompter.presentedViewController.childViewControllerForStatusBarHidden.prefersStatusBarHidden;
    }
    return self.prompter.presentedViewController.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([self.prompter.presentedViewController isKindOfClass:UINavigationController.class] || [self.prompter.presentedViewController isKindOfClass:UITabBarController.class]) {
        return self.prompter.presentedViewController.childViewControllerForStatusBarStyle.preferredStatusBarStyle;
    }
    return self.prompter.presentedViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if ([self.prompter.presentedViewController isKindOfClass:UINavigationController.class] || [self.prompter.presentedViewController isKindOfClass:UITabBarController.class]) {
        return self.prompter.presentedViewController.childViewControllerForStatusBarHidden.preferredStatusBarUpdateAnimation;
    }
    return self.prompter.presentedViewController.preferredStatusBarUpdateAnimation;
}

@end
