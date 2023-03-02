//
//  YYTestSearchResultController.m
//  Template
//
//  Created by nevsee on 2022/1/12.
//

#import "YYTestSearchResultController.h"
#import "YYTestUtility.h"

@interface YYTestSearchResultController ()
@property (nonatomic, strong) XYLabel *label;
@property (nonatomic, strong) XYButton *button;
@property (nonatomic, strong) NSString *action;
@end

@implementation YYTestSearchResultController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didInitialize {
    [super didInitialize];
    self.xy_prefersNavigationBarHidden = YES;
    self.xy_supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)parameterSetup {
    [super parameterSetup];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowNotice:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    XYLabel *label = [YYTestUtility labelWithText:@"输入 YYTestConnector 类中的方法名\n快速查找页面\n如：alert/board/code"];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = YYNeutral6Color;
    [self.view addSubview:label];
    _label = label;
    
    XYButton *button = [YYTestUtility buttonWithTitle:@"跳转搜索页面" target:self action:@selector(tapAction:)];
    button.hidden = YES;
    [self.view addSubview:button];
    _button = button;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(250);
        make.left.right.mas_equalTo(0);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    XYSearchController *vc = (XYSearchController *)self.view.superview.xy_viewController;
    _button.frame = CGRectMake((self.view.xy_width - 150) / 2, vc.searchBar.xy_bottom + 30, 150, 34);
}

- (void)updateSearchResultsForSearchController:(XYSearchController *)searchController keyword:(NSString *)keyword {
    if (keyword.length > 0) {
        [self showEmptyView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideEmptyView];
            self.button.hidden = NO;
            self.label.hidden = YES;
            self.action = keyword;
        });
    } else {
        self.button.hidden = YES;
        self.label.hidden = NO;
    }
}

- (void)tapAction:(XYButton *)sender {
    NSString *action = [NSString stringWithFormat:@"fetch%@Controller", _action.xy_firstLetterCapitalized];
    UIViewController *vc = [[XYMediator defaultMediator] performAction:action forTarget:@"YYTestConnector" withParam:nil];
    [self xy_pushViewController:vc];
}

- (void)keyboardDidShowNotice:(NSNotification *)sender {
    if (self.emptyView.loadingOffset.vertical != 0) return;
    CGFloat height = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.emptyView.loadingOffset = UIOffsetMake(0, -(height / 2));
}

@end
