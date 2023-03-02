//
//  YYTestMenuController.m
//  Template
//
//  Created by nevsee on 2022/1/27.
//

#import "YYTestMenuController.h"
#import "XYPopupMenuContentView.h"
#import "YYTestContentView.h"
#import "YYTestUtility.h"
#import "YYGlobalUtility+String.h"
#import "YYGlobalUtility+Date.h"
#import "YYGlobalUtility+Other.h"
#import "YYGlobalUtility+Validation.h"

@interface YYTestMenuController ()
@property (nonatomic, strong) UISegmentedControl *styleSegment;
@end

@implementation YYTestMenuController

- (void)didInitialize {
    [super didInitialize];
    self.xy_supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"XYPopupView";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem xy_itemWithTitle:@"菜单" target:self action:@selector(menuAction:)];
    
    UISegmentedControl *styleSegment = [[UISegmentedControl alloc] initWithItems:@[@"Top", @"Left", @"Bottom", @"Right"]];
    styleSegment.selectedSegmentIndex = 0;
    [self.view addSubview:styleSegment];
    _styleSegment = styleSegment;
    
    XYButton *button = [YYTestUtility buttonWithTitle:@"自定义" target:self action:@selector(moreAction:)];
    [self.view addSubview:button];
    
    [styleSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(100);
        make.centerX.mas_equalTo(0);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(styleSegment.mas_bottom).offset(50);
        make.size.mas_equalTo(CGSizeMake(80, 34));
        make.centerX.mas_equalTo(0);
    }];
}

- (void)menuAction:(UIButton *)sender {
    NSArray *titles = @[@"发起群聊", @"添加朋友", @"扫一扫", @"收付款"];
    NSArray *images = @[XYImageMake(@"popup_chat"), XYImageMake(@"popup_friend"), XYImageMake(@"popup_code"), XYImageMake(@"popup_trade")];
    
    XYPopupMenuContentView *contentView = [[XYPopupMenuContentView alloc] initWithFixedWidth:120];
    contentView.didSelectIndexBlock = ^(NSInteger index) {
        [self.view showInfoWithText:[NSString stringWithFormat:@"选择「%@」", titles[index]]];
    };
    [contentView addTextItemsWithTexts:titles images:images];
    
    XYPopupView *view = [[XYPopupView alloc] initWithContentView:contentView];
    view.sourceView = sender;
    [view showAnimated:YES];
}

- (void)moreAction:(XYButton *)sender {
    YYTestContentView *contentView = [[YYTestContentView alloc] initWithFrame:CGRectMake(0, 0, 120, 160)];
    contentView.text = @"刘先生，你好你好，有什么事情我们能帮到你。\n我要说的事，你们千万别害怕。\n我们是警察，我们不会怕。你请说。\n刚才我被美人鱼绑架了！";
    
    XYPopupView *view = [[XYPopupView alloc] initWithContentView:contentView];
    view.preferredDirection = _styleSegment.selectedSegmentIndex;
    view.sourceView = sender;
    [view showAnimated:YES];
}

@end
