//
//  YYBaseNavigationController.m
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "YYBaseNavigationController.h"

@implementation YYBaseNavigationController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self didInitializeWithRootController:rootViewController];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self parameterSetup];
    [self userInterfaceSetup];
}

- (void)didInitialize {
    
}

- (void)didInitializeWithRootController:(UIViewController *)rootController {
    
}

- (void)parameterSetup {
    
}

- (void)userInterfaceSetup {
    
}

@end
