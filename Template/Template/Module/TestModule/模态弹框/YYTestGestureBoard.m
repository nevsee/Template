//
//  YYTestGestureBoard.m
//  Template
//
//  Created by nevsee on 2021/12/20.
//

#import "YYTestGestureBoard.h"
#import "YYTestUtility.h"

@implementation YYTestGestureBoard

- (void)didInitialize {
    [super didInitialize];
    self.prompter.position = XYPromptPositionBottom;
    self.prompter.animator.presentStyle = XYPromptAnimationStyleSlipBottom;
    self.prompter.animator.dismissStyle = XYPromptAnimationStyleSlipBottom;
    self.prompter.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.prompter.backgroundColor = nil;
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    self.view.backgroundColor = XYColorHEXMake(@"#FDF5E6");
    self.view.layer.cornerRadius = 12;
    self.view.layer.masksToBounds = YES;
    if (@available(iOS 13.0, *)) {
        self.view.layer.cornerCurve = kCACornerCurveContinuous;
    }
    
    XYLabel *nameLabel = [YYTestUtility labelWithText:@"人，\n\n如果没有了梦想，\n\n那和咸鱼有什么区别"];
    nameLabel.font = XYFontMake(20);
    nameLabel.textColor = XYColorHEXMake(@"#5D6D7E");
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
}

- (void)preferredBoardContentSize {
    self.xy_portraitContentSize = CGSizeMake(300, 400);
    self.xy_landscapeContentSize = CGSizeMake(300, 300);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
