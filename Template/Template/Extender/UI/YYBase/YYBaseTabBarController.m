//
//  YYBaseTabBarController.m
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "YYBaseTabBarController.h"

@implementation YYBaseTabBarController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self parameterSetup];
    [self userInterfaceSetup];
}

- (void)didInitialize {
    
}

- (void)parameterSetup {
    
}

- (void)userInterfaceSetup {
    
}

@end
