//
//  YYTestPickerController.m
//  Template
//
//  Created by nevsee on 2022/1/5.
//

#import "YYTestPickerController.h"
#import "YYPickerBoard.h"
#import "YYPickerDateMaker.h"
#import "YYPickerTextMaker.h"
#import "YYTestUtility.h"

@interface YYTestPickerController ()
@property (nonatomic, strong) YYPickerView *pickerView;
@property (nonatomic, strong) YYPickerDateMaker *maker;
@end

@implementation YYTestPickerController

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"YYPickerView";
}

- (void)parameterSetup {
    [super parameterSetup];
    
    YYPickerDateMaker *maker = [[YYPickerDateMaker alloc] init];
    maker.mode = YYPickerDateModeYear | YYPickerDateModeMonth | YYPickerDateModeDay;
    maker.format = @"%d年;%d月;%02d日";
    maker.minimumDate = [NSDate xy_dateWithString:@"1990-2-10" format:@"yyyy-MM-dd"];
    maker.maximumDate = [NSDate xy_dateWithString:@"2050-1-1" format:@"yyyy-MM-dd"];
    _maker = maker;
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    XYLabel *label = [YYTestUtility labelWithText:@""];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    YYPickerView *pickerView = [[YYPickerView alloc] init];
    pickerView.backgroundColor = YYNeutral2Color;
    pickerView.dataSourceMaker = _maker;
    pickerView.defaultIndexes = [_maker indexesOfDate:[NSDate date]];
    pickerView.didSelectItemBlock = ^(YYPickerView *pickerView, NSArray *selectedValues, NSArray *selectedNames) {
        label.text = [selectedNames componentsJoinedByString:@""];
    };
    [self.view addSubview:pickerView];
    _pickerView = pickerView;

    XYButton *button = [YYTestUtility buttonWithTitle:@"时间弹窗" target:self action:@selector(tapAction:)];
    button.tag = 1;
    [self.view addSubview:button];
    
    XYButton *button2 = [YYTestUtility buttonWithTitle:@"文本弹窗" target:self action:@selector(tapAction:)];
    button2.tag = 2;
    [self.view addSubview:button2];
    
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(150);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pickerView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(180, 34));
        make.centerX.mas_equalTo(0);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 34));
        make.centerX.mas_equalTo(0);
    }];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 34));
        make.centerX.mas_equalTo(0);
    }];
}

- (void)tapAction:(XYButton *)sender {
    if (sender.tag == 1) {
        YYPickerBoard *board = [[YYPickerBoard alloc] init];
        board.pickerView.dataSourceMaker = _maker;
        board.pickerView.defaultIndexes = [_maker indexesOfDate:[NSDate date]];
        board.confirmBlock = ^(NSArray *values, NSArray *names) {
            [self.view showInfoWithText:[names componentsJoinedByString:@""]];
        };
        [board presentInController:self];
    } else {
        YYPickerTextMaker *maker = [[YYPickerTextMaker alloc] init];
        maker.texts = @[@"北京", @"上海", @"武汉", @"杭州", @"你猜"];
        YYPickerBoard *board = [[YYPickerBoard alloc] init];
        board.pickerView.dataSourceMaker = maker;
        [board presentInController:self];
    }
}


@end
