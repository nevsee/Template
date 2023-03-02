//
//  YYNavigationBoard.m
//  Template
//
//  Created by nevsee on 2021/12/20.
//

#import "YYNavigationBoard.h"
#import "XYPrompter.h"

@implementation YYNavigationBoard

- (void)parameterSetup {
    [super parameterSetup];
    XYPrompter *prompter = [[XYPrompter alloc] init];
    prompter.position = XYPromptPositionCenter;
    prompter.animator.presentStyle = XYPromptAnimationStyleBounce;
    prompter.animator.dismissStyle = XYPromptAnimationStyleBounce;
    prompter.navigationClass = YYBaseNavigationController.class;
    self.xy_prompter = prompter;
    self.delegate = self;
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    self.view.backgroundColor = UIColor.clearColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

// Delegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 子视图旋转属性一定要和autorotation旋转属性一样，避免导航动画错乱
    viewController.xy_shouldAutorotate = self.prompter.autorotation.shouldAutorotate;
    viewController.xy_supportedInterfaceOrientations = self.prompter.autorotation.supportedInterfaceOrientations;
    [self updateContainerViewSize];
}

// Method
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self updateContainerViewSize];
    [self.navigationBar setNeedsLayout];
}

- (void)updateContainerViewSize {
    UIViewController *topViewController = self.topViewController;
    [topViewController preferredBoardContentSize];
    CGSize portraitContentSize = topViewController.xy_portraitContentSize;
    CGSize landscapeContentSize = topViewController.xy_landscapeContentSize;
    if (portraitContentSize.width != 0 && portraitContentSize.height != 0) {
        self.xy_portraitContentSize = portraitContentSize;
    }
    if (landscapeContentSize.width != 0 && landscapeContentSize.height != 0) {
        self.xy_landscapeContentSize = landscapeContentSize;
    }
}

- (void)present {
    [self presentWithCompletion:nil];
}

- (void)presentWithCompletion:(void (^)(void))completion {
    [self presentInController:nil completion:completion];
}

- (void)presentInController:(UIViewController *)inController {
    [self presentInController:inController completion:nil];
}

- (void)presentInController:(UIViewController *)inController completion:(void (^)(void))completion {
    [self updateContainerViewSize];
    // cell选中执行present跳转时，可能会有延迟或者不执行
    dispatch_main_async_safely(^{
        [self.xy_prompter present:self inController:inController completion:completion];
    });
}

- (void)dismiss {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    [self.xy_prompter dismissWithCompletion:completion];
}

- (void)updateInteractiveProgress:(CGFloat)progress forType:(XYPromptInteractionType)type {
    if (type == XYPromptInteractionTypeBegan) {
        [self.prompter.interactor updateType:type progress:0 interactive:YES];
        [self dismiss];
    } else if (type == XYPromptInteractionTypeChanged) {
        [self.prompter.interactor updateType:type progress:progress interactive:YES];
    } else if (type == XYPromptInteractionTypeFinished) {
        [self.prompter.interactor updateType:type progress:1 interactive:NO];
    } else {
        [self.prompter.interactor updateType:type progress:0 interactive:NO];
    }
}

- (XYPrompter *)prompter {
    return self.xy_prompter;
}

@end

