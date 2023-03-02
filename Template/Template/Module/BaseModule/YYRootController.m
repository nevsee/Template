//
//  YYRootController.m
//  Template
//
//  Created by nevsee on 2021/11/23.
//

#import "YYRootController.h"
#import "YYRootCell.h"

@interface YYRootController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) UICollectionView *listView;
@end

@implementation YYRootController

- (void)parameterSetup {
    [super parameterSetup];
    
    _datas = @[
        @[@"提示弹框", @"test_fetchAlertController"],
        @[@"模态弹框", @"test_fetchBoardController"],
        @[@"二维码扫描", @"test_fetchCodeController"],
        @[@"空白占位视图", @"test_fetchEmptyController"],
        @[@"模拟进度条", @"test_fetchFakeProgressController"],
        @[@"轮播视图", @"test_fetchLoopController"],
        @[@"菜单视图", @"test_fetchMenuController"],
        @[@"操作视图", @"test_fetchOperationController"],
        @[@"选择器", @"test_fetchPickerController"],
        @[@"进度器", @"test_fetchProgressController"],
        @[@"搜索控制器", @"test_fetchSearchController"],
        @[@"网页浏览器", @"test_fetchWebController"],
        @[@"图片浏览器", @"test_fetchBrowserController"],
        @[@"角标", @"test_fetchBadgeController"],
        @[@"动画", @"test_fetchAnimationController"],
        @[@"按钮", @"test_fetchButtonController"],
        @[@"设置页", @"test_fetchCellController"],
        @[@"防抖节流", @"test_fetchLoadashController"],
        @[@"物理特效", @"test_fetchDynamicController"],
        @[@"实验室", @"test_fetchLabController"],
    ];
}

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"NEVSEE";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *listView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    listView.backgroundColor = UIColor.clearColor;
    listView.alwaysBounceVertical = YES;
    listView.delegate = self;
    listView.dataSource = self;
    listView.mj_header = [YYRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [listView registerClass:YYRootCell.class forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:listView];
    _listView = listView;

    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YYRootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = _datas[indexPath.row][0];
    cell.contentView.backgroundColor = indexPath.row % 2 ? XYColorHEXMake(@"F0EFED") : XYColorHEXMake(@"D4DADF");
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.bounds.size.width / 3;
    return CGSizeMake(width, width * 2 / 3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SEL sel = NSSelectorFromString(_datas[indexPath.row][1]);
    XYIGNORE_WARC_PERFORMSELECTOR_LEAKS_WARNING_BEGIN
    UIViewController *vc = [[XYMediator defaultMediator] performSelector:sel];
    [self xy_pushViewController:vc];
    XYIGNORE_WARC_PERFORMSELECTOR_LEAKS_WARNING_END
}

- (void)refreshAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.listView.mj_header endRefreshing];
    });
}


@end
