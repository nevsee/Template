//
//  YYTestBoardResultController.m
//  Template
//
//  Created by nevsee on 2021/12/20.
//

#import "YYTestBoardResultController.h"
#import "YYTestUtility.h"

@implementation YYTestBoardResultController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didInitialize {
    [super didInitialize];
    self.xy_supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
    self.xy_preferredNavigationBarAlpha = 0;
}

- (void)parameterSetup {
    [super parameterSetup];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentSizeDidChangeNotice:) name:XYPrompterContentSizeChangeNotification object:nil];
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    self.view.backgroundColor = XYColorHEXMake(@"#FDF5E6");
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = XYColorHEXMake(@"#D2B4DE");
    view.layer.cornerRadius = 50;
    [self.view addSubview:view];
    
    XYLabel *noteLabel = [YYTestUtility labelWithText:_text];
    noteLabel.textColor = XYColorHEXMake(@"#5D6D7E");
    noteLabel.font = XYFontMake(12);
    noteLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noteLabel];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-15);
        make.centerX.mas_equalTo(0);
    }];
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

// 不设置，默认跟随上个控制器大小
- (void)preferredBoardContentSize {
    self.xy_portraitContentSize = CGSizeMake(300, 300);
    self.xy_landscapeContentSize = CGSizeMake(300, 300);
}

@end
