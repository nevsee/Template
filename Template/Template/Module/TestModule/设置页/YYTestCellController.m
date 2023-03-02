//
//  YYTestCellController.m
//  Template
//
//  Created by nevsee on 2022/12/2.
//

#import "YYTestCellController.h"
#import "YYEasyImageView.h"
#import "XYEasyCell.h"
#import "XYBrowser.h"

@interface YYTestCellController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *datas;
@end

@implementation YYTestCellController

- (void)didInitialize {
    [super didInitialize];
    self.xy_supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)parameterSetup {
    [super parameterSetup];
    
    // 1
    XYEasyItem *portraitItem = [self getItemWithTitle:@"头像" subTitle:nil type:1 tag:0];

    XYEasyGroup *group1 = [XYEasyGroup group];
    group1.groupHeaderHeight = 15;
    [group1.easyItems addObject:portraitItem];
    
    // 2
    XYEasyItem *nameItem = [self getItemWithTitle:@"名称" subTitle:@"周杰伦演唱会" type:3 tag:1];
    XYEasyItem *genderItem = [self getItemWithTitle:@"性别" subTitle:@"男" type:0 tag:2];
    XYEasyItem *codeItem = [self getItemWithTitle:@"我的二维码" subTitle:nil type:4 tag:3];

    XYEasyGroup *group2 = [XYEasyGroup group];
    group2.groupHeaderHeight = 15;
    [group2.easyItems addObjectsFromArray:@[nameItem, genderItem, codeItem]];
    
    // 3
    XYEasyItem *logoutItem = [self getItemWithTitle:nil subTitle:@"退出登录" type:2 tag:4];
    logoutItem.operation = ^{
        XYAlertController *vc = [XYAlertController alertWithTitle:@"确定要退出吗？" message:@"退出之后无法获取奖励" cancel:@"取消" actions:@[@"确定"] preferredStyle:XYAlertControllerStyleAlert];
        [vc presentInController:self];
    };
    
    XYEasyGroup *group3 = [XYEasyGroup group];
    group3.groupHeaderHeight = 12;
    [group3.easyItems addObject: logoutItem];
    
    _datas = @[group1, group2, group3];
}

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.xy_preferredNavigationBarTintColor = UIColor.whiteColor;
    self.title = @"XYEasyCell";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = YYNeutral1Color;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:XYEasyCell.class forCellReuseIdentifier:@"cell"];
    [tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"header"];
    [tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"footer"];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark # Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XYEasyGroup *group = _datas[section];
    return group.easyItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYEasyGroup *group = _datas[indexPath.section];
    XYEasyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell refreshCellWithItem:group.easyItems[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYEasyGroup *group = _datas[indexPath.section];
    XYEasyItem *item = group.easyItems[indexPath.row];
    return item.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    XYEasyGroup *group = _datas[section];
    return group.groupHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    XYEasyGroup *group = _datas[section];
    return group.groupFooterHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XYEasyGroup *group = _datas[indexPath.section];
    XYEasyItem *item = group.easyItems[indexPath.row];
    
    // 可以直接写block
    if (item.operation) item.operation();
    
    // 也可以if else
    // indexPath.section == 1 && indexPath.row == 1 最好不要这么写
    if ([item.userInfo integerValue] == 2) {
        XYAlertController *vc = [XYAlertController alertWithTitle:nil message:nil cancel:@"取消" actions:@[@"男", @"女"] preferredStyle:XYAlertControllerStyleSheet];
        vc.afterHandler = ^(__kindof XYAlertAction * _Nonnull action) {
            if (action.tag == 0) return;
            item.subtitle = ((XYAlertTimerAction *)action).title;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [vc presentInController:self];
    }
}

#pragma mark # Action

- (void)tapImageAction:(UIGestureRecognizer *)sender {
    XYEasyGroup *group = _datas[0];
    XYEasyItem *item = group.easyItems[0];
    YYEasyImageView *view = item.tailView;
    XYBrowserAsset *asset = [[XYBrowserAsset alloc] init];
    asset.thumbImage = view.tailView.image;
    
    XYBrowserController *vc = [[XYBrowserController alloc] init];
    vc.browserView.datas = @[asset];
    vc.sourceView = ^UIView * _Nonnull(NSInteger currentIndex) {
        return sender.view;
    };
    [self xy_presentViewController:vc];
}

#pragma mark # Method

- (XYEasyItem *)getItemWithTitle:(NSString *)title subTitle:(NSString *)subTitle type:(NSInteger)type tag:(NSInteger)tag {
    XYEasyItem *item = [XYEasyItem itemWithTitle:title];
    item.height = 60;
    item.backgroundColor = [UIColor whiteColor];
    item.selectedColor = [UIColor clearColor];
    item.title = title;
    item.titleInsets = UIEdgeInsetsMake(0, 17, 0, 0);
    item.titleAttributes = @{
        NSForegroundColorAttributeName: YYNeutral9Color,
        NSFontAttributeName: XYFontMake(17)
    };
    item.titleWidth = 120;
    item.subtitle = subTitle;
    item.subtitleAttributes = @{
        NSForegroundColorAttributeName: YYNeutral7Color,
        NSFontAttributeName: XYFontMake(16)
    };
    item.separatorColor = YYNeutral4Color;
    item.separatorHeight = YYOnePixel;
    item.userInfo = @(tag);
    
    // 演示，实际不应该写死
    if (type == 0) {
        item.tailView = [[UIImageView alloc] initWithImage:XYImageMake(@"arrow_right_1")];
        item.bottomSeparatorInsets = UIEdgeInsetsMake(0, 0, 0, 12);
    } else if (type == 1) {
        item.topSeparatorStyle = XYEasySeparatorStyleFull;
        item.bottomSeparatorStyle = XYEasySeparatorStyleFull;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)];
        YYEasyImageView *portraitView = [[YYEasyImageView alloc] initWithImageSize:CGSizeMake(60, 60) interval:10 arrowImage:XYImageMake(@"arrow_right_1")];
        portraitView.tailView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image1" ofType:@"jpeg"]];
        portraitView.tailView.userInteractionEnabled = YES;
        [portraitView.tailView addGestureRecognizer:ges];
        item.tailView = portraitView;
        item.height = 80;
    } else if (type == 2) {
        item.topSeparatorStyle = XYEasySeparatorStyleFull;
        item.bottomSeparatorStyle = XYEasySeparatorStyleFull;
        item.subtitleAttributes = @{
            NSForegroundColorAttributeName: YYWarning2Color,
            NSFontAttributeName: XYFontMake(16)
        };
        item.subtitleAlignment = NSTextAlignmentCenter;
    } else if (type == 3) {
        item.tailView = [[UIImageView alloc] initWithImage:XYImageMake(@"arrow_right_1")];
        item.bottomSeparatorInsets = UIEdgeInsetsMake(0, 0, 0, 12);
        item.topSeparatorStyle = XYEasySeparatorStyleFull;
    } else if (type == 4) {
        item.tailView = [[UIImageView alloc] initWithImage:XYImageMake(@"arrow_right_1")];
        item.bottomSeparatorStyle = XYEasySeparatorStyleFull;
    }
    
    return item;
}

@end
