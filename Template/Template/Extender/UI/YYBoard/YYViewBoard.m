//
//  YYViewBoard.m
//  Template
//
//  Created by nevsee on 2021/12/20.
//

#import "YYViewBoard.h"

@implementation YYViewBoard

- (void)didInitialize {
    [super didInitialize];
    XYPrompter *prompter = [[XYPrompter alloc] init];
    prompter.position = XYPromptPositionCenter;
    prompter.animator.presentStyle = XYPromptAnimationStyleBounce;
    prompter.animator.dismissStyle = XYPromptAnimationStyleBounce;
    prompter.navigationClass = YYBaseNavigationController.class;
    self.xy_prompter = prompter;
    self.xy_prefersNavigationBarHidden = YES;
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    self.view.backgroundColor = UIColor.clearColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

// Method
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self preferredBoardContentSize];
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
    [self preferredBoardContentSize];
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
