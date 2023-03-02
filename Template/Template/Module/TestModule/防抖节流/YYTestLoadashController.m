//
//  YYTestLoadashController.m
//  Template
//
//  Created by nevsee on 2023/2/22.
//

#import "YYTestLoadashController.h"
#import "YYTestUtility.h"
#import "XYLoadash.h"

@interface YYTestLoadashController ()
@property (nonatomic, strong) XYLoadash *loadash;
@property (nonatomic, strong) UILabel *label;
@end

@implementation YYTestLoadashController

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.xy_preferredNavigationBarTintColor = UIColor.whiteColor;
    self.title = @"XYLoadash";
}

- (void)parameterSetup {
    [super parameterSetup];
    _loadash = [[XYLoadash alloc] initWithMode:XYLoadashModeLeadingThrottle interval:1];
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    UISegmentedControl *styleSegment = [[UISegmentedControl alloc] initWithItems:@[@"lThrottle", @"tThrottle", @"lDebounce", @"tDebounce"]];
    styleSegment.selectedSegmentIndex = 0;
    [styleSegment addTarget:self action:@selector(styleChangeAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:styleSegment];
    
    XYButton *button = [YYTestUtility buttonWithTitle:@"点击" target:self action:@selector(tapAction)];
    [self.view addSubview:button];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = YYNeutral2Color;
    [self.view addSubview:label];
    _label = label;
    
    [styleSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(100);
        make.left.right.mas_equalTo(0);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(styleSegment.mas_bottom).offset(50);
        make.size.mas_equalTo(CGSizeMake(80, 34));
        make.centerX.mas_equalTo(0);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button.mas_bottom).offset(50);
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.centerX.mas_equalTo(0);
    }];
}

- (void)styleChangeAction:(UISegmentedControl *)sender {
    _label.text = nil;
    _loadash = [[XYLoadash alloc] initWithMode:sender.selectedSegmentIndex interval:1];
}

- (void)tapAction {
    @weakify(self)
    [_loadash invokeTask:^{
        @strongify(self)
        self.label.text = self.label.text ? [self.label.text stringByAppendingString:@" ·"] : @"·";
    }];
}

@end
