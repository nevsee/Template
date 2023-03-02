//
//  YYTestBoardContentController.m
//  Template
//
//  Created by nevsee on 2021/12/20.
//

#import "YYTestBoardContentController.h"
#import "YYTestBoardResultController.h"
#import "YYTestUtility.h"

@implementation YYTestBoardContentController

- (void)didInitialize {
    [super didInitialize];
    self.xy_prefersNavigationBarHidden = YES;
}

- (void)parameterSetup {
    [super parameterSetup];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSizeDidChangeNotice:) name:XYPrompterContentSizeChangeNotification object:nil];
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    self.view.backgroundColor = XYColorHEXMake(@"#FDF5E6");
    
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
}

- (void)tapAction:(XYButton *)sender {
    YYTestBoardResultController *vc = [[YYTestBoardResultController alloc] init];
    vc.text = @"你看，那个人好像一条狗哎。";
    [self xy_pushViewController:vc];
}

// 内容大小改变通知，使用动画更新布局
- (void)contentSizeDidChangeNotice:(NSNotification *)sender {
    if (![sender.object isEqual:self.navigationController]) return;
    NSTimeInterval duration = [sender.userInfo[XYPrompterAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [sender.userInfo[XYPrompterAnimationOptionUserInfoKey] integerValue];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)preferredBoardContentSize {
    self.xy_portraitContentSize = CGSizeMake(300, 400);
    self.xy_landscapeContentSize = CGSizeMake(300, 300);
}

@end
