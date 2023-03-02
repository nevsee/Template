//
//  YYTestBadgeController.m
//  Template
//
//  Created by nevsee on 2022/11/28.
//

#import "YYTestBadgeController.h"
#import "XYBadge.h"
#import "YYTestUtility.h"

@interface YYTestBadgeController ()
@property (nonatomic, strong) UIToolbar *toolBar;
@property(nonatomic, strong) UITabBar *tabBar;
@property (nonatomic, strong) XYButton *button1;
@end

@implementation YYTestBadgeController

- (void)didInitialize {
    [super didInitialize];
    self.xy_supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"XYBadge";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    XYButton *button1 = [YYTestUtility buttonWithTitle:@"Hello World" target:nil action:NULL];
    button1.xy_badgeShowIndicator = YES;
    [self.view addSubview:button1];
    _button1 = button1;
    
    UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:nil action:NULL];
    item1.xy_badgeShowIndicator = YES;
    
    UIBarButtonItem *spaceItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:nil action:NULL];
    item2.xy_badgeValue = @"88";
    
    UIBarButtonItem *spaceItem3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"ToolbarItem" style:UIBarButtonItemStylePlain target:nil action:NULL];
    item3.xy_badgeValue = @"99+";
    
    UIBarButtonItem *spaceItem4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.items = @[spaceItem1, item1, spaceItem2, item2, spaceItem3, item3, spaceItem4];
    [toolBar sizeToFit];
    [self.view addSubview:toolBar];
    _toolBar =  toolBar;
    
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"聊天" image:XYImageMake(@"popup_chat") selectedImage:nil];
    tabBarItem1.xy_badgeValue = @"99+";
    
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"二维码" image:XYImageMake(@"popup_code") selectedImage:nil];
    tabBarItem2.xy_badgeShowIndicator = YES;
    
    UITabBar *tabBar = [[UITabBar alloc] init];
    tabBar.items = @[tabBarItem1, tabBarItem2];
    [tabBar sizeToFit];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat button1Width = UIApplication.sharedApplication.xy_isInterfaceLandscape ? 180 : 120;
    _button1.frame = CGRectMake((self.view.xy_width - button1Width) / 2, self.xy_navigationBar.xy_bottom + 20, button1Width, 45);
    _toolBar.frame = CGRectMake(0, _button1.xy_bottom + 20, self.view.xy_width, _toolBar.xy_height);
    _tabBar.frame = CGRectMake(0, _toolBar.xy_bottom + 20, self.view.xy_width, _tabBar.xy_height);
}

@end
