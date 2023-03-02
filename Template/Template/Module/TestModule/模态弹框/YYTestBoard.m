//
//  YYTestBoard.m
//  Template
//
//  Created by nevsee on 2021/12/20.
//

#import "YYTestBoard.h"
#import "YYTestBoardResultController.h"
#import "YYTestUtility.h"
#import "XYShimmerView.h"

@implementation YYTestBoard

- (void)didInitialize {
    [super didInitialize];
    [self fitContentViewStyle];
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    self.view.backgroundColor = XYColorHEXMake(@"#FDF5E6");
    self.view.layer.cornerRadius = 12;
    self.view.layer.masksToBounds = YES;
    if (@available(iOS 13.0, *)) {
        self.view.layer.cornerCurve = kCACornerCurveContinuous;
    }
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = XYColorHEXMake(@"#D2B4DE");
    headerView.layer.cornerRadius = 40;
    [self.view addSubview:headerView];

    XYLabel *nameLabel = [YYTestUtility labelWithText:@"准确的说，我是一个演员。"];
    nameLabel.textColor = XYColorHEXMake(@"#5D6D7E");
    [self.view addSubview:nameLabel];
    
    XYLabel *noteLabel = [YYTestUtility labelWithText:@"原来那个女孩子在我心里留下了一滴眼泪，我完全可以感受到当时她是多么的伤心。"];
    noteLabel.textColor = XYColorHEXMake(@"#5D6D7E");
    [self.view addSubview:noteLabel];
    
    XYButton *moreButton = [YYTestUtility buttonWithTitle:@"查看更多 >" target:self action:@selector(tapAction:)];
    moreButton.backgroundColor = UIColor.clearColor;
    moreButton.layer.borderWidth = 0;
    [moreButton setTitleColor:XYColorHEXMake(@"#5D6D7E") forState:UIControlStateNormal];
    [moreButton sizeToFit];
    [self.view addSubview:moreButton];
    
    XYLabel *tipLabel = [YYTestUtility labelWithText:@"旋转一下试试"];
    tipLabel.font = XYFontMake(12);
    tipLabel.textColor = YYNeutral7Color;
    tipLabel.backgroundColor = UIColor.clearColor;
    [tipLabel sizeToFit];
    XYShimmerView *tipView = [[XYShimmerView alloc] initWithFrame:CGRectMake(0, 0, tipLabel.xy_width, tipLabel.xy_height)];
    tipView.shimmeringPauseDuration = 1;
    tipView.shimmeringSpeed = tipLabel.xy_width * 0.7;
    tipView.contentView = tipLabel;
    tipView.shimmering = YES;
    [self.view addSubview:tipView];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_right).offset(10);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(headerView.mas_centerY);
    }];
    
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_bottom).offset(20);
        make.left.mas_equalTo(headerView.mas_left);
        make.right.mas_equalTo(-15);
    }];
    
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-15);
    }];
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(moreButton.mas_centerY);
        make.size.mas_equalTo(tipView.xy_size);
    }];
}

- (void)tapAction:(XYButton *)sender {
    YYTestBoardResultController *vc = [[YYTestBoardResultController alloc] init];
    vc.text = @"生亦何欢，死亦何苦";
    UINavigationController *nvc = (UINavigationController *)self.prompter.presentedViewController;
    [nvc xy_pushViewController:vc animated:YES];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self fitContentViewStyle];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)preferredBoardContentSize {
    self.xy_portraitContentSize = CGSizeMake(300, 300);
    self.xy_landscapeContentSize = CGSizeMake(300, 250);
}

- (void)fitContentViewStyle {
    BOOL flag = [UIApplication sharedApplication].xy_isInterfaceLandscape;
    self.prompter.position = flag ? XYPromptPositionRight : XYPromptPositionBottom;
    self.prompter.animator.presentStyle = flag ? XYPromptAnimationStyleSlipRight : XYPromptAnimationStyleSlipBottom;
    self.prompter.animator.dismissStyle = flag ? XYPromptAnimationStyleSlipRight : XYPromptAnimationStyleSlipBottom;
}

@end
