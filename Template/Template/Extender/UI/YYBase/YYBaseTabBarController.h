//
//  YYBaseTabBarController.h
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "XYTabBarController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYBaseTabBarController : XYTabBarController
- (void)didInitialize NS_REQUIRES_SUPER;
- (void)parameterSetup NS_REQUIRES_SUPER;
- (void)userInterfaceSetup NS_REQUIRES_SUPER;
@end

NS_ASSUME_NONNULL_END
