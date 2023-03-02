//
//  YYNavigationBoard.h
//  Template
//
//  Created by nevsee on 2021/12/20.
//

#import "YYBaseController.h"
#import "XYPrompter.h"
#import "UIViewController+YYBoard.h"

NS_ASSUME_NONNULL_BEGIN

/**
 模态导航弹框
 1.弹框大小跟随topViewController，topViewController需要实现preferredBoardContentSize，
   若所有子控制器大小都一样，只设置根控制器大小即可；
 2.如果有inController，屏幕旋转跟随inController，可设置prompter.autorotation来指定旋转方向；
 3.其他设置详见XYPrompter；
 */
@interface YYNavigationBoard : YYBaseNavigationController <UINavigationControllerDelegate>
@property (nonatomic, readonly) XYPrompter *prompter;
- (void)present;
- (void)presentWithCompletion:(nullable void (^)(void))completion;
- (void)presentInController:(nullable UIViewController *)inController;
- (void)presentInController:(nullable UIViewController *)inController completion:(nullable void (^)(void))completion;
- (void)dismiss;
- (void)dismissWithCompletion:(nullable void (^)(void))completion;
- (void)updateInteractiveProgress:(CGFloat)progress forType:(XYPromptInteractionType)type;
@end

NS_ASSUME_NONNULL_END
