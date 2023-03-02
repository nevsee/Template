//
//  UIViewController+XYWorkflow.h
//  XYConstructor
//
//  Created by nevsee on 2017/3/26.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (XYWorkflow)

@property (nonatomic, nullable) NSString *xy_workflow; ///< 工作流名称

///-------------------------------
/// @name Push And Pop
///-------------------------------

- (void)xy_pushViewController:(UIViewController *)viewController;
- (void)xy_pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)xy_popViewController;
- (void)xy_popViewControllerAnimated:(BOOL)animated;
- (void)xy_popToRootViewControllerAnimated:(BOOL)animated;
- (void)xy_popToViewController:(UIViewController *)viewController animated:(BOOL)animated;

///-------------------------------
/// @name Present And Dismiss
///-------------------------------

- (void)xy_presentViewController:(UIViewController *)viewController;
- (void)xy_presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
- (void)xy_dismissViewController;
- (void)xy_dismissViewControllerAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

///-------------------------------
/// @name Workflow
///-------------------------------

/**
 添加viewController到当前控制器所属的工作流.
 @discussion
 1. (), [], {} 代表3种不同工作流
 2. 当前控制器c跳转到d; 工作流: (a), (b), (c); append后工作流为: (a), (b), (c), (d)
 @example
 ViewController *dvc = [[ViewController alloc] init]
 [cvc xy_appendWorkflow:dvc]
 */
- (void)xy_appendWorkflow:(UIViewController *)viewController;
- (void)xy_appendWorkflow:(UIViewController *)viewController animated:(BOOL)animated;

/**
 返回当前控制器所属的工作流的第一个控制器.
 @discussion
 1. (), [], {} 代表3种不同工作流
 2. 当前控制器: c; 工作流: (a), (b), (c); revoke后工作流为: (a)
 3. 当前控制器: d; 工作流: a, b, (c), (d); revoke后工作流为: a, b, (c)
 */
- (void)xy_revokeWorkflow;
- (void)xy_revokeWorkflowAnimated:(BOOL)animated;

/**
 清除当前控制器所属的工作流.
 @discussion
 1. (), [], {} 代表3种不同工作流
 2. 当前控制器为: a; 工作流: (a); clean后工作流为: (a)
 3. 当前控制器为: b; 工作流: (a), (b); clean后工作流为: (a)
 4. 当前控制器为: c; 工作流: (a), (b), c; clean后工作流为: (a), (b), c
 5. 当前控制器为: d; 工作流: a, b, (c), (d); clean后工作流为: a, b
 6. 当前控制器为: e; 工作流: (a), [b], (c), (d), (e); clean后工作流为: [b]
 */
- (void)xy_cleanWorkflow;
- (void)xy_cleanWorkflowAnimated:(BOOL)animated;
- (void)xy_cleanWorkflowExceptePresent;

/**
 清除指定的工作流.
 @discussion
 1. (), [], {} 代表3种不同工作流
 2. 指定工作流: (), {}; 当前工作流: (a), [b], (c), [d], {e}, f, (g); clean后工作流为: [b], [d], f
 @note
 present: 是否清除当前页面
 */
- (void)xy_cleanWorkflow:(NSArray <NSString *>*)workflows animated:(BOOL)animated;
- (void)xy_cleanWorkflow:(NSArray <NSString *>*)workflows present:(BOOL)present animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

