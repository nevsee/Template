//
//  YYTestSearchController.m
//  Template
//
//  Created by nevsee on 2022/1/12.
//

#import "YYTestSearchController.h"
#import "YYTestSearchResultController.h"
#import "XYSearch.h"
#import "YYTestUtility.h"

@interface YYTestSearchController ()
@property (nonatomic, strong) XYSearchBar *searchBar;
@end

@implementation YYTestSearchController

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"XYSearch";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    XYButton *button = [YYTestUtility buttonWithTitle:@"push" target:self action:@selector(tapAction:)];
    button.tag = 1;
    [self.view addSubview:button];
    
    XYButton *button1 = [YYTestUtility buttonWithTitle:@"present" target:self action:@selector(tapAction:)];
    button1.tag = 2;
    [self.view addSubview:button1];
    
    XYSearchBar *searchBar = [[XYSearchBar alloc] init];
    searchBar.cancelButtonMode = XYSearchBarModeWhileEditing;
    searchBar.textField.placeholder = @"这是一个search bar";
    searchBar.textFieldCornerRadius = 25;
    searchBar.textField.centersPlaceholder = YES;
    searchBar.textField.textInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    searchBar.textField.clearButtonPositionAdjustment = UIOffsetMake(-10, 0);
    [self.view addSubview:searchBar];
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(30);
        make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.height.mas_equalTo(62);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchBar.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(120, 34));
        make.centerX.mas_equalTo(0);
    }];
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(120, 34));
        make.centerX.mas_equalTo(0);
    }];
}

- (void)tapAction:(XYButton *)sender {
    YYTestSearchResultController *rvc = [[YYTestSearchResultController alloc] init];
    XYSearchController *vc = [[XYSearchController alloc] initWithSearchResultsController:rvc];
    vc.hidesResultControllerAutomatically = NO;
    vc.searchResultsUpdater = rvc;
    vc.searchBar.textField.placeholder = @"搜索页面";
    vc.searchBar.searchIcon = XYImageMake(@"search_1");
    if (sender.tag == 1) {
        [self xy_pushViewController:vc];
    } else {
        YYBaseNavigationController *nvc = [[YYBaseNavigationController alloc] initWithRootViewController:vc];
        nvc.supportSearchTransition = YES;
        [self xy_presentViewController:nvc];
    }
}

@end
