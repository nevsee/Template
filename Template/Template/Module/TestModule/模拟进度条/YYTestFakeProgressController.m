//
//  YYTestFakeProgressController.m
//  Template
//
//  Created by nevsee on 2021/12/6.
//

#import "YYTestFakeProgressController.h"
#import "YYFakeProgressView.h"
#import "YYTestUtility.h"

@interface YYTestFakeProgressController ()
@property (nonatomic, strong) YYFakeProgressView *progressView;
@end

@implementation YYTestFakeProgressController

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"YYFakeProgressView";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];

    YYFakeProgressView *progressView = [[YYFakeProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    progressView.hidesWhenCommitted = YES;
    progressView.trackTintColor = UIColor.clearColor;
    progressView.progressTintColor = UIColor.redColor;
    [self.view addSubview:progressView];
    _progressView = progressView;
    
    XYButton *beginButton = [YYTestUtility buttonWithTitle:@"begin" target:self action:@selector(tapAction:)];
    beginButton.tag = 1;
    [self.view addSubview:beginButton];
    
    XYButton *endButton = [YYTestUtility buttonWithTitle:@"end" target:self action:@selector(tapAction:)];
    endButton.tag = 2;
    [self.view addSubview:endButton];
    
    XYButton *commitButton = [YYTestUtility buttonWithTitle:@"commit" target:self action:@selector(tapAction:)];
    commitButton.tag = 3;
    [self.view addSubview:commitButton];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.mas_equalTo(0);
    }];
    
    [beginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(50);
        make.size.mas_equalTo(CGSizeMake(100, 34));
        make.centerX.mas_equalTo(0);
    }];
    
    [endButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(beginButton.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 34));
        make.centerX.mas_equalTo(0);
    }];
    
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(endButton.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 34));
        make.centerX.mas_equalTo(0);
    }];
}

- (void)tapAction:(XYButton *)sender {
    NSInteger tag = sender.tag;
    
    if (tag == 1) {
        [_progressView begin];
    } else if (tag == 2) {
        [_progressView end];
    } else {
        [_progressView commit];
    }
}

@end
