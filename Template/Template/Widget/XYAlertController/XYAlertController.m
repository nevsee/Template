//
//  XYAlertController.m
//  XYAlertController
//
//  Created by nevsee on 2018/10/12.
//

#import "XYAlertController.h"

@interface XYAlertController ()
@property (nonatomic, strong, readwrite) XYAlertContentCanvas *contentCanvas;
@property (nonatomic, strong, readwrite) XYAlertActionCanvas *actionCanvas;
@property (nonatomic, assign, readwrite) XYAlertControllerStyle preferredStyle;
@property (nonatomic, strong) NSMutableArray *tempContents;
@property (nonatomic, strong) NSMutableArray *tempActions;
@property (nonatomic, assign) BOOL isAlertStyle;
@end

@implementation XYAlertController
@dynamic title;

#pragma mark  # Life

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel actions:(NSArray *)actions preferredStyle:(XYAlertControllerStyle)preferredStyle {
    XYAlertController *alerter = [[XYAlertController alloc] init];
    alerter.tempActions = [NSMutableArray array];
    alerter.tempContents = [NSMutableArray array];
    alerter.preferredStyle = preferredStyle;
    alerter.isAlertStyle = preferredStyle == XYAlertControllerStyleAlert;
    [alerter defaultParameterSetup];
    [alerter defaultContentWithText:title style:XYAlertContentStyleTitle];
    [alerter defaultContentWithText:message style:XYAlertContentStyleMessage];
    [alerter defaultActionWithText:cancel style:XYAlertActionStyleCancel];
    [alerter defaultActionWithText:actions style:XYAlertActionStyleDefault];
    [alerter userInterfaceSetup];
    [alerter defaultPrompter];
    return alerter;
}

- (void)defaultParameterSetup {
    XYAlertAppearance *appearance = [XYAlertAppearance appearance];
    _potraitWidth = _isAlertStyle ? appearance.potraitWidthForAlert : appearance.potraitWidthForSheet;
    _landscapeWidth = _isAlertStyle ? appearance.landscapeWidthForAlert: appearance.landscapeWidthForSheet;
    _corner = _isAlertStyle ? UIRectCornerAllCorners : (UIRectCornerTopLeft | UIRectCornerTopRight);
    _cornerRadii =  _isAlertStyle ? appearance.cornerRadiiForAlert : appearance.cornerRadiiForSheet;
    self.view.layer.maskedCorners = [self transformCorner:self.corner];
    self.view.layer.cornerRadius = self.cornerRadii;
    self.view.layer.masksToBounds = YES;
    if (@available(iOS 13.0, *)) self.view.layer.cornerCurve = kCACornerCurveContinuous;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSizeChangeAction:) name:XYPrompterContentSizeChangeNotification object:nil];
}

- (void)defaultContentWithText:(NSString *)text style:(XYAlertContentStyle)style {
    if (!text) return;
    XYAlertTextContent *content = [[XYAlertTextContent alloc] initWithText:text style:style alerter:self];
    [_tempContents addObject:content];
}

- (void)defaultActionWithText:(id)texts style:(XYAlertActionStyle)style {
    if (!texts) return;
    if (![texts isKindOfClass:NSArray.class]) texts = @[texts];
    
    for (NSString *text in texts) {
        XYAlertSketchAction *action = [[XYAlertSketchAction alloc] initWithTitle:text style:style alerter:self];
        [_tempActions addObject:action];
    }
}

- (void)defaultPrompter {
    XYPromptAnimationStyle style = XYPromptAnimationStyleNone;
    XYPromptPosition position = XYPromptPositionCenter;
    BOOL definesDismissalTouch = NO;
    
    if (_isAlertStyle) {
        style = XYPromptAnimationStyleBounce;
        position = XYPromptPositionCenter;
        definesDismissalTouch = NO;
    } else {
        style = XYPromptAnimationStyleSlipBottom;
        position = XYPromptPositionBottom;
        definesDismissalTouch = YES;
    }
    
    XYPrompter *prompter = [[XYPrompter alloc] init];
    prompter.animator.presentStyle = style;
    prompter.animator.dismissStyle = style;
    prompter.definesDismissalTouch = definesDismissalTouch;
    prompter.definesSafeAreaAdaptation = NO;
    prompter.position = position;
    self.xy_prompter = prompter;
}

- (void)userInterfaceSetup {
    // content canvas
    XYAlertContentCanvas *contentCanvas = [XYAlertContentCanvas canvasWithStyle:_preferredStyle];
    [self.view addSubview:contentCanvas];
    _contentCanvas = contentCanvas;
    
    // action canvas
    XYAlertActionCanvas *actionCanvas = [XYAlertActionCanvas canvasWithStyle:_preferredStyle];
    [self.view addSubview:actionCanvas];
    _actionCanvas = actionCanvas;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGSize contentSize = [_contentCanvas sizeThatFits:self.view.bounds.size];
    CGSize actionSize = [_actionCanvas sizeThatFits:self.view.bounds.size];
    _contentCanvas.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    _actionCanvas.frame = CGRectMake(0, contentSize.height, actionSize.width, actionSize.height);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark # Action

- (void)contentSizeChangeAction:(NSNotification *)sender {
    NSTimeInterval duration = [sender.userInfo[XYPrompterAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [sender.userInfo[XYPrompterAnimationOptionUserInfoKey] integerValue];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self viewWillLayoutSubviews];
    } completion:nil];
}

#pragma mark # Method

- (BOOL)prefersStatusBarHidden {
    return self.prompter.inController.prefersStatusBarHidden;
}

- (CACornerMask)transformCorner:(UIRectCorner)corner {
    CACornerMask mask = 0;
    if (corner & UIRectCornerTopLeft) mask |= kCALayerMinXMinYCorner;
    if (corner & UIRectCornerTopRight) mask |= kCALayerMaxXMinYCorner;
    if (corner & UIRectCornerBottomLeft) mask |= kCALayerMinXMaxYCorner;
    if (corner & UIRectCornerBottomRight) mask |= kCALayerMaxXMaxYCorner;
    return mask;
}

- (void)verifyCancelAction {
    XYAlertAction *cancelAction = nil;
    for (XYAlertAction *action in _tempActions) {
        if (action.style != XYAlertActionStyleCancel) continue;
        if (cancelAction) {
            NSString *reason = @"XYAlertController can only have one action with a style of XYAlertActionStyleCancel";
            NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
            @throw exception;
        } else {
            cancelAction = action;
        }
    }
}

- (void)obtainContentSize {
    [_contentCanvas updateContents:self.contents];
    [_actionCanvas updateActions:self.actions];
    
    // obtain canvas height
    CGFloat contentPotraitHeight = [_contentCanvas sizeThatFits:CGSizeMake(_potraitWidth, 0)].height;
    CGFloat contentLandscapeHeight = [_contentCanvas sizeThatFits:CGSizeMake(_landscapeWidth, 0)].height;
    CGFloat actionPotraitHeight = [_actionCanvas sizeThatFits:CGSizeMake(_potraitWidth, 0)].height;
    CGFloat actionLandscapeHeight = [_actionCanvas sizeThatFits:CGSizeMake(_landscapeWidth, 0)].height;
    
    // set content size
    self.xy_portraitContentSize = CGSizeMake(_potraitWidth, contentPotraitHeight + actionPotraitHeight);
    self.xy_landscapeContentSize = CGSizeMake(_landscapeWidth, contentLandscapeHeight + actionLandscapeHeight);
}

- (void)updateCanvasIfNeeded {
    if (self.prompter.beingDismissed) return;
    [self obtainContentSize];
    [_contentCanvas setNeedsLayout];
    [_actionCanvas setNeedsLayout];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    if (![self.view respondsToSelector:@selector(safeAreaInsets)]) return;
    if (_isAlertStyle && UIEdgeInsetsEqualToEdgeInsets(self.view.safeAreaInsets, UIEdgeInsetsZero)) return;
    [self updateCanvasIfNeeded];
}

- (void)addContents:(NSArray<XYAlertContent *> *)contents {
    if (contents.count == 0) return;
    for (XYAlertContent *content in contents) {
        if (![content isKindOfClass:[XYAlertContent class]]) continue;
        [_tempContents addObject:content];
    }
    [self updateCanvasIfNeeded];
}

- (void)addActions:(NSArray<XYAlertAction *> *)actions {
    if (actions.count == 0) return;
    for (XYAlertAction *action in actions) {
        if (![action isKindOfClass:[XYAlertAction class]]) continue;
        [_tempActions addObject:action];
    }
    [self verifyCancelAction];
    [self updateCanvasIfNeeded];
}

- (void)removeContents:(NSArray<XYAlertContent *> *)contents {
    if (contents.count == 0) return;
    for (XYAlertContent *content in contents) {
        if (![self.contents containsObject:content]) continue;
        [_tempContents removeObject:content];
    }
    [self updateCanvasIfNeeded];
}

- (void)removeActions:(NSArray<XYAlertAction *> *)actions {
    if (actions.count == 0) return;
    for (XYAlertAction *action in actions) {
        if (![self.actions containsObject:action]) continue;
        [_tempActions removeObject:action];
    }
    [self updateCanvasIfNeeded];
}

- (void)presentInController:(UIViewController *)inController {
    [self obtainContentSize];
    [self.prompter present:self inController:inController completion:nil];
}

- (void)dismiss {
    [self.prompter dismissWithCompletion:nil];
}

#pragma mark # Access

- (XYPrompter *)prompter {
    return self.xy_prompter;
}

- (NSArray *)contents {
    return _tempContents.copy;
}

- (NSArray *)actions {
    return _tempActions.copy;
}

@end
