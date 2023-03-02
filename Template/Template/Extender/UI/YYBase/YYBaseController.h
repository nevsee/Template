//
//  YYBaseController.h
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "XYViewController.h"
#import "YYEmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYBaseController : XYViewController

///-------------------------------
/// @name 初始化
///-------------------------------

/**
 init初始化
 不要使用self.view，避免触发viewDidLoad
 */
- (void)didInitialize NS_REQUIRES_SUPER;

/**
 viewDidLoad初始化
 */
- (void)parameterSetup NS_REQUIRES_SUPER;
- (void)navigationBarSetup NS_REQUIRES_SUPER;
- (void)userInterfaceSetup NS_REQUIRES_SUPER;
- (void)navigationBarSetupLazily;
- (void)userInterfaceSetupLazily;
- (void)startLoading;

///-------------------------------
/// @name 提示视图
///-------------------------------

@property (nonatomic, strong, readonly) YYEmptyView *emptyView;
@property (nonatomic, assign, readonly) BOOL isEmptyViewShown;
- (void)showEmptyView;
- (void)hideEmptyView;
- (void)layoutEmptyView; ///< 子类重写
- (void)emptyViewRetryAction; ///< 子类重写

@end

NS_ASSUME_NONNULL_END
