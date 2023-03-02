//
//  YYTestProgressController.m
//  Template
//
//  Created by nevsee on 2022/2/21.
//

#import "YYTestProgressController.h"
#import "XYProgressView.h"
#import "YYTestUtility.h"

@interface YYTestProgressController ()
@property (nonatomic, strong) XYProgressView *sectorView;
@property (nonatomic, strong) XYProgressView *ringView;
@property (nonatomic, strong) XYProgressView *lineView;
@end

@implementation YYTestProgressController

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"XYProgressView";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    XYButton *button1 = [YYTestUtility buttonWithTitle:@"+" target:self action:@selector(tapAction:)];
    button1.tag = 1;
    [self.view addSubview:button1];
    
    XYButton *button2 = [YYTestUtility buttonWithTitle:@"-" target:self action:@selector(tapAction:)];
    button2.tag = 2;
    [self.view addSubview:button2];

    XYProgressView *sectorView = [[XYProgressView alloc] init];
    sectorView.shape = XYProgressShapeSector;
    sectorView.borderInsets = 3;
    sectorView.borderWidth = 2;
    sectorView.previewColor = YYNeutral2Color;
    sectorView.tintColor = YYTheme1Color;
    sectorView.progress = 0.1;
    [self.view addSubview:sectorView];
    _sectorView = sectorView;
    
    XYProgressView *ringView = [[XYProgressView alloc] init];
    ringView.shape = XYProgressShapeRing;
    ringView.borderInsets = 5;
    ringView.previewColor = YYNeutral2Color;
    ringView.tintColor = YYTheme1Color;
    ringView.progress = 0.1;
    [self.view addSubview:ringView];
    _ringView = ringView;
    
    XYProgressView *lineView = [[XYProgressView alloc] init];
    lineView.shape = XYProgressShapeLine;
    lineView.borderInsets = 2;
    lineView.borderWidth = 2;
    lineView.previewColor = YYNeutral2Color;
    lineView.tintColor = YYTheme1Color;
    lineView.progress = 0.1;
    [self.view addSubview:lineView];
    _lineView = lineView;

    [sectorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    
    [ringView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sectorView.mas_bottom).offset(40);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ringView.mas_bottom).offset(40);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(120, 12));
    }];
    
    NSArray *buttons = @[button1, button2];
    [buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:40 tailSpacing:40];
    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(40);
        make.height.mas_equalTo(40);
    }];
}

- (void)tapAction:(XYButton *)sender {
    CGFloat v = sender.tag == 1 ? 0.2 : -0.2;
    [_sectorView setProgress:_sectorView.progress + v animated:YES];
    [_ringView setProgress:_ringView.progress + v animated:YES];
    [_lineView setProgress:_lineView.progress + v animated:YES];
}

@end
