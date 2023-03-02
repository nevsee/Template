//
//  YYBaseNavigationController.h
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "XYNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYBaseNavigationController : XYNavigationController
- (void)didInitialize NS_REQUIRES_SUPER;
- (void)didInitializeWithRootController:(UIViewController *)rootController NS_REQUIRES_SUPER;
- (void)parameterSetup NS_REQUIRES_SUPER;
- (void)userInterfaceSetup NS_REQUIRES_SUPER;
@end

NS_ASSUME_NONNULL_END
