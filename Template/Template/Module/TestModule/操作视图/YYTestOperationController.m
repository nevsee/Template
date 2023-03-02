//
//  YYTestOperationController.m
//  Template
//
//  Created by nevsee on 2022/2/18.
//

#import "YYTestOperationController.h"
#import "YYTestOperationHeaderView.h"
#import "YYOperationBoard.h"
#import "YYTestUtility.h"
#import "YYGlobalUtility+Validation.h"

@interface YYTestOperationController ()
@property (nonatomic, strong) YYOperationView *operationView;
@property (nonatomic, strong) XYTextField *rowField;
@property (nonatomic, strong) XYTextField *cloumField;
@end

@implementation YYTestOperationController

- (void)didInitialize {
    [super didInitialize];
    self.xy_supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"YYOperationView";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem xy_itemWithTitle:@"弹框" target:self action:@selector(menuAction)];
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    NSArray *texts = @[
        @"微信", @"QQ", @"Skype", @"Line", @"爱聊", @"陌陌", @"实时"
    ];
    NSArray *images = @[
        @"web_system_share", @"web_safari", @"web_font", @"web_collect"
    ];
    
    NSMutableArray *items1 = [NSMutableArray array];
    NSMutableArray *items2 = [NSMutableArray array];
    for (NSInteger i = 0; i < 9; i++) {
        YYOperationItem *item = [[YYOperationItem alloc] init];
        item.text = texts.xy_randomObject;
        item.image = XYImageMake(images.xy_randomObject);
        if (i % 2) [items1 addObject:item];
        if (!(i % 2)) [items2 addObject:item];
    }

    @weakify(self)
    YYOperationView *operationView = [[YYOperationView alloc] init];
    operationView.backgroundColor = YYNeutral2Color;
    operationView.didSelectItemBlock = ^(YYOperationView *operationView, YYOperationItem *item) {
        @strongify(self)
        [self.view showInfoWithText:[NSString stringWithFormat:@"点击了%@", item.text]];
    };
    [operationView insertItems:items1 inSection:0];
    [self.view addSubview:operationView];
    _operationView = operationView;
    
    XYLabel *titleLabel1 = [YYTestUtility labelWithText:@"第几行："];
    [self.view addSubview:titleLabel1];
    
    XYTextField *rowField = [YYTestUtility textFieldWithPlaceholder:@"只能输入0或者1"];
    rowField.text = @"0";
    [self.view addSubview:rowField];
    _rowField = rowField;
    
    XYLabel *titleLabel2 = [YYTestUtility labelWithText:@"第几列："];
    [self.view addSubview:titleLabel2];
    
    XYTextField *cloumField = [YYTestUtility textFieldWithPlaceholder:@"不能大于每行总数"];
    cloumField.text = @"0";
    [self.view addSubview:cloumField];
    _cloumField = cloumField;
    
    XYButton *addButton = [YYTestUtility buttonWithTitle:@"添加" target:self action:@selector(tapAction:)];
    addButton.tag = 1;
    [self.view addSubview:addButton];
    
    XYButton *deleteButton = [YYTestUtility buttonWithTitle:@"删除" target:self action:@selector(tapAction:)];
    deleteButton.tag = 2;
    [self.view addSubview:deleteButton];
    
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.left.mas_equalTo(20);
    }];
    
    [rowField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel1.mas_right).offset(5);
        make.centerY.mas_equalTo(titleLabel1.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(160, 35));
    }];
    
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel1.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
    }];
    
    [cloumField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel2.mas_right).offset(5);
        make.centerY.mas_equalTo(titleLabel2.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(160, 35));
    }];
    
    NSArray *buttons = @[addButton, deleteButton];
    [buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:40 tailSpacing:40];
    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel2.mas_bottom).offset(40);
        make.height.mas_equalTo(40);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _operationView.frame = CGRectMake(20, 300, self.view.xy_width - 40, _operationView.xy_height);
}

- (void)tapAction:(XYButton *)sender {
    if (![YYGlobalUtility validateNumber:_rowField.text] || ![YYGlobalUtility validateNumber:_cloumField.text]) {
        [self.view showInfoWithText:@"请输入数字"];
        return;
    };
    
    NSArray *texts = @[
        @"微信", @"QQ", @"Skype", @"Line", @"爱聊", @"陌陌", @"实时"
    ];
    NSArray *images = @[
        @"web_system_share", @"web_safari", @"web_font", @"web_collect"
    ];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_cloumField.text.integerValue inSection:_rowField.text.integerValue];
    
    if (sender.tag == 1) {
        YYOperationItem *item = [[YYOperationItem alloc] init];
        item.text = texts.xy_randomObject;
        item.image = XYImageMake(images.xy_randomObject);
        [_operationView insertItem:item atIndexPath:indexPath];
    } else {
        [_operationView removeItemAtIndexPath:indexPath];
    }
}

- (void)menuAction {
    NSArray *texts = @[
        @"微信", @"QQ", @"Skype", @"Line", @"爱聊", @"陌陌", @"实时"
    ];
    NSArray *images = @[
        @"web_system_share", @"web_safari", @"web_font", @"web_collect"
    ];
    
    NSMutableArray *items1 = [NSMutableArray array];
    NSMutableArray *items2 = [NSMutableArray array];
    for (NSInteger i = 0; i < 9; i++) {
        YYOperationItem *item = [[YYOperationItem alloc] init];
        item.text = texts.xy_randomObject;
        item.image = XYImageMake(images.xy_randomObject);
        if (i % 2) [items1 addObject:item];
        if (!(i % 2)) [items2 addObject:item];
    }
    
    YYOperationBoard *board = [[YYOperationBoard alloc] init];
    board.operationView.headerView = [[YYTestOperationHeaderView alloc] init];
    [board.operationView insertItems:items1 inSection:0];
    [board.operationView insertItems:items2 inSection:1];
    [board presentInController:self];
}

@end
