//
//  UIViewController+XYWorkflow.m
//  XYConstructor
//
//  Created by nevsee on 2017/3/26.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "UIViewController+XYWorkflow.h"
#import <objc/runtime.h>

@implementation UIViewController (XYWorkflow)

- (NSString *)xy_workflow {
    return objc_getAssociatedObject(self, @selector(setXy_workflow:));
}

- (void)setXy_workflow:(NSString *)xy_workflow {
    objc_setAssociatedObject(self, _cmd, xy_workflow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark # Push And Pop

- (void)xy_pushViewController:(UIViewController *)viewController {
    [self xy_pushViewController:viewController animated:YES];
}

- (void)xy_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!viewController || ![viewController isKindOfClass:UIViewController.class]) return;
    if ([self isKindOfClass:UINavigationController.class]) {
        [(UINavigationController *)self pushViewController:viewController animated:animated];
    } else {
        [self.navigationController pushViewController:viewController animated:animated];
    }
}

- (void)xy_popViewController {
    [self xy_popViewControllerAnimated:YES];
}

- (void)xy_popViewControllerAnimated:(BOOL)animated {
    if ([self isKindOfClass:UINavigationController.class]) {
        [(UINavigationController *)self popViewControllerAnimated:animated];
    } else {
        [self.navigationController popViewControllerAnimated:animated];
    }
}

- (void)xy_popToRootViewControllerAnimated:(BOOL)animated {
    if ([self isKindOfClass:UINavigationController.class]) {
        [(UINavigationController *)self popToRootViewControllerAnimated:animated];
    } else {
        [self.navigationController popToRootViewControllerAnimated:animated];
    }
}

- (void)xy_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!viewController || ![viewController isKindOfClass:UIViewController.class]) return;
    if ([self isKindOfClass:UINavigationController.class]) {
        [(UINavigationController *)self popToViewController:viewController animated:animated];
    } else {
        [self.navigationController popToViewController:viewController animated:animated];
    }
}

#pragma mark # Present And Dismiss

- (void)xy_presentViewController:(UIViewController *)viewController {
    [self xy_presentViewController:viewController animated:YES completion:nil];
}

- (void)xy_presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    if (!viewController || ![viewController isKindOfClass:UIViewController.class]) return;
    [self presentViewController:viewController animated:animated completion:completion];
}

- (void)xy_dismissViewController {
    [self xy_dismissViewControllerAnimated:YES completion:nil];
}

- (void)xy_dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self dismissViewControllerAnimated:animated completion:completion];
}

#pragma mark # Workflow

- (void)xy_appendWorkflow:(UIViewController *)viewController {
    [self xy_appendWorkflow:viewController animated:YES];
}

- (void)xy_appendWorkflow:(UIViewController *)viewController animated:(BOOL)animated {
    if (!self.navigationController) return;
    viewController.xy_workflow = self.xy_workflow;
    [self xy_pushViewController:viewController animated:animated];
}

- (void)xy_revokeWorkflow {
    [self xy_revokeWorkflowAnimated:YES];
}

- (void)xy_revokeWorkflowAnimated:(BOOL)animated {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count <= 1) return;
    
    if (self.xy_workflow.length == 0) {
        [self xy_popViewControllerAnimated:animated];
    } else {
        NSEnumerator *enmuerator = [viewControllers reverseObjectEnumerator];
        UIViewController *currentViewController = nil, *previousViewController = nil;
        while (currentViewController = [enmuerator nextObject]) {
            if (currentViewController.xy_workflow.length == 0 || ![currentViewController.xy_workflow isEqualToString:self.xy_workflow]) break;
            previousViewController = currentViewController;
        }
        
        [self xy_popToViewController:previousViewController animated:animated];
    }
}

- (void)xy_cleanWorkflow {
    [self xy_cleanWorkflowAnimated:YES];
}

- (void)xy_cleanWorkflowAnimated:(BOOL)animated {
    if (self.xy_workflow.length == 0) return;
    [self xy_cleanWorkflow:@[self.xy_workflow] animated:animated];
}

- (void)xy_cleanWorkflowExceptePresent {
    if (self.xy_workflow.length == 0) return;
    [self xy_cleanWorkflow:@[self.xy_workflow] present:NO animated:NO];
}

- (void)xy_cleanWorkflow:(NSArray<NSString *> *)workflows animated:(BOOL)animated {
    [self xy_cleanWorkflow:workflows present:YES animated:animated];
}

- (void)xy_cleanWorkflow:(NSArray<NSString *> *)workflows present:(BOOL)present animated:(BOOL)animated {
    if (workflows.count == 0) return;
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count <= 1) return;
    
    NSMutableArray *newViewControllers = [NSMutableArray arrayWithArray:viewControllers];
    NSEnumerator *enmuerator = [viewControllers reverseObjectEnumerator];
    UIViewController *viewController = nil;
    while (viewController = [enmuerator nextObject]) {
        if (!present && [viewController isEqual:self]) {continue;};
        for (NSString *workflow in workflows) {
            if (viewController.xy_workflow.length == 0 || workflow.length == 0) break;
            if ([viewController.xy_workflow isEqualToString:workflow]) {
                [newViewControllers removeObject:viewController];
                break;
            }
        }
        if (newViewControllers.count == 1) break;
    }
    [self.navigationController setViewControllers:newViewControllers animated:animated];
}

@end
