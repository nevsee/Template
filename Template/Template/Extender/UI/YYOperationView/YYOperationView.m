//
//  YYOperationView.m
//  Template
//
//  Created by nevsee on 2021/11/25.
//

#import "YYOperationView.h"

@implementation YYOperationItem

- (instancetype)init {
    self = [super init];
    if (self) {
        _tag = -1;
    }
    return self;
}

@end

#pragma mark -

@interface YYOperationConfiguration ()
@property (nonatomic, assign) CGFloat topHeight; // 上列表高
@property (nonatomic, assign) CGFloat bottomHeight; // 下列表高
@property (nonatomic, weak) YYOperationView *operationView;
@end

@implementation YYOperationConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _maximumHeight = CGFLOAT_MAX;
        _contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        _listMargin = 15;
        _listItemSpacing = 15;
        _imageHorizontalMargin = 0;
        _imageSize = 55;
        _imageCornerRadius = 12;
        _imageNormalColor = UIColor.whiteColor;
        _imageHighlightedColor = [UIColor.blackColor colorWithAlphaComponent:0.1];
        _textTopMargin = 5;
        _textAttributes = @{
            NSFontAttributeName: XYFontMake(10),
            NSForegroundColorAttributeName: YYNeutral7Color
        };
    }
    return self;
}

- (void)setMaximumHeight:(CGFloat)maximumHeight {
    if (_maximumHeight == maximumHeight) return;
    _maximumHeight = maximumHeight;
    [_operationView updateViewLayoutIfNeeded];
}

@end

#pragma mark -

@interface YYOperationItemCell : UICollectionViewCell
@property (nonatomic, strong) YYOperationConfiguration *configuration;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation YYOperationItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:imageView];
        _imageView = imageView;
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.numberOfLines = 0;
        textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:textLabel];
        _textLabel = textLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imageX = _configuration.imageHorizontalMargin;
    _imageView.frame = CGRectMake(imageX, 0, _configuration.imageSize, _configuration.imageSize);
    CGFloat textY = _configuration.imageSize + _configuration.textTopMargin;
    CGFloat textH = [_textLabel sizeThatFits:CGSizeMake(self.xy_width, HUGE)].height;
    _textLabel.frame = CGRectMake(0, textY, self.xy_width, textH);
}

- (void)highlightCell:(BOOL)highlighted {
    _imageView.backgroundColor = highlighted ? _configuration.imageHighlightedColor : _configuration.imageNormalColor;
}

- (void)refreshCellWithItem:(YYOperationItem *)item configuration:(YYOperationConfiguration *)configuration {
    _configuration = configuration;
    _imageView.image = item.image;
    _imageView.backgroundColor = configuration.imageNormalColor;
    _imageView.layer.cornerRadius = configuration.imageCornerRadius;
    if (@available(iOS 13.0, *)) _imageView.layer.cornerCurve = kCACornerCurveContinuous;
    _imageView.layer.masksToBounds = YES;
    _textLabel.attributedText = [[NSAttributedString alloc] initWithString:item.text ?: @"" attributes:configuration.textAttributes];
}

@end

#pragma mark -

@interface YYOperationCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) YYOperationConfiguration *configuration;
@property (nonatomic, strong) UICollectionView *topCollectionView;
@property (nonatomic, strong) UICollectionView *bottomCollectionView;
@property (nonatomic, strong) NSMutableArray *topItems;
@property (nonatomic, strong) NSMutableArray *bottomItems;
@property (nonatomic, assign) CGFloat updateLayout; // 更新布局
@end

@implementation YYOperationCell

- (instancetype)initWithFrame:(CGRect)frame configuration:(YYOperationConfiguration *)configuration {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.clipsToBounds = YES;
        self.backgroundColor = UIColor.clearColor;
        self.xy_selectedBackgroundColor = UIColor.clearColor;
        _configuration = configuration;
        
        NSMutableArray *topItems = [NSMutableArray array];
        _topItems = topItems;

        NSMutableArray *bottomItems = [NSMutableArray array];
        _bottomItems = bottomItems;
        
        UICollectionViewFlowLayout *topLayout = [[UICollectionViewFlowLayout alloc] init];
        topLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *topCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:topLayout];
        topCollectionView.backgroundColor = UIColor.clearColor;
        topCollectionView.showsHorizontalScrollIndicator = NO;
        topCollectionView.alwaysBounceHorizontal = YES;
        topCollectionView.delegate = self;
        topCollectionView.dataSource = self;
        [topCollectionView registerClass:YYOperationItemCell.class forCellWithReuseIdentifier:@"cell"];
        [self.contentView addSubview:topCollectionView];
        _topCollectionView = topCollectionView;
        
        UICollectionViewFlowLayout *bottomLayout = [[UICollectionViewFlowLayout alloc] init];
        bottomLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:bottomLayout];
        bottomCollectionView.backgroundColor = UIColor.clearColor;
        bottomCollectionView.showsHorizontalScrollIndicator = NO;
        bottomCollectionView.alwaysBounceHorizontal = YES;
        bottomCollectionView.delegate = self;
        bottomCollectionView.dataSource = self;
        [bottomCollectionView registerClass:YYOperationItemCell.class forCellWithReuseIdentifier:@"cell"];
        [self.contentView addSubview:bottomCollectionView];
        _bottomCollectionView = bottomCollectionView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_topCollectionView.collectionViewLayout invalidateLayout];
    [_bottomCollectionView.collectionViewLayout invalidateLayout];
    
    _topCollectionView.frame = (CGRect){
        0,
        _configuration.contentInsets.top,
        self.xy_width,
        _configuration.topHeight
    };
    _bottomCollectionView.frame = (CGRect){
        0,
        self.xy_height - _configuration.bottomHeight - _configuration.contentInsets.bottom,
        self.xy_width,
        _configuration.bottomHeight
    };
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:_topCollectionView]) {
        return _topItems.count;
    }
    return _bottomItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YYOperationItem *item = [collectionView isEqual:_topCollectionView] ? _topItems[indexPath.row] : _bottomItems[indexPath.row];
    YYOperationItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell refreshCellWithItem:item configuration:_configuration];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [collectionView isEqual:_topCollectionView] ? _configuration.topHeight : _configuration.bottomHeight;
    return CGSizeMake(_configuration.imageSize + _configuration.imageHorizontalMargin * 2, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, _configuration.contentInsets.left, 0, _configuration.contentInsets.right);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return _configuration.listItemSpacing;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    YYOperationItemCell *cell = (YYOperationItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell highlightCell:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    YYOperationItemCell *cell = (YYOperationItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell highlightCell:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YYOperationItem *item = [collectionView isEqual:_topCollectionView] ? _topItems[indexPath.row] : _bottomItems[indexPath.row];
    if (item.handler) item.handler();
    if (_configuration.operationView.didSelectItemBlock) _configuration.operationView.didSelectItemBlock(_configuration.operationView, item);
}

// position: 0 top 1 bottom
- (void)insertItems:(NSArray<YYOperationItem *> *)items atIndex:(NSInteger)index position:(NSInteger)position {
    UICollectionView *collectionView = position ? _bottomCollectionView : _topCollectionView;
    NSMutableArray *results = position ? _bottomItems : _topItems;
    
    if (!self.window) {
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (NSInteger i = items.count - 1; i >= 0; i--) {
            [results insertObject:items[i] atIndex:index];
            [indexPaths addObject:[NSIndexPath indexPathForRow:index + i inSection:0]];
        }
        [collectionView reloadData];
    } else {
        [collectionView performBatchUpdates:^{
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (NSInteger i = items.count - 1; i >= 0; i--) {
                [results insertObject:items[i] atIndex:index];
                [indexPaths addObject:[NSIndexPath indexPathForRow:index + i inSection:0]];
            }
            [collectionView insertItemsAtIndexPaths:indexPaths];
        } completion:nil];
    }
}

// position: 0 top 1 bottom
- (void)deleteItemsAtIndexes:(NSArray<NSNumber *> *)indexes position:(NSInteger)position {
    UICollectionView *collectionView = position ? _bottomCollectionView : _topCollectionView;
    NSMutableArray *results = position ? _bottomItems : _topItems;
  
    [collectionView performBatchUpdates:^{
        NSMutableIndexSet *indexSets = [NSMutableIndexSet indexSet];
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (NSNumber *index in indexes) {
            [indexSets addIndex:index.integerValue];
            [indexPaths addObject:[NSIndexPath indexPathForRow:index.integerValue inSection:0]];
        }
        [results removeObjectsAtIndexes:indexSets];
        [collectionView deleteItemsAtIndexPaths:indexPaths];
    } completion:nil];
}

// 更新布局
- (void)setUpdateLayout:(CGFloat)updateLayout {
    _updateLayout = updateLayout;
    if (self.xy_height == updateLayout) return;
    [self setNeedsLayout];
}

@end

#pragma mark -

@interface YYOperationView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YYOperationCell *tableCell;
@property (nonatomic, strong) NSMutableArray *mutableItems;
@end

@implementation YYOperationView

- (instancetype)init {
    return [self initWithFrame:CGRectZero configuration:[[YYOperationConfiguration alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame configuration:[[YYOperationConfiguration alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame configuration:(YYOperationConfiguration *)configuration {
    frame = XYRectSetHeight(frame, 0);
    self = [super initWithFrame:frame];
    if (self) {
        _configuration = configuration;
        _configuration.operationView = self;
        
        NSMutableArray *array = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], nil];
        _mutableItems = array;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = UIColor.clearColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        _tableView = tableView;
        
        YYOperationCell *tableCell = [[YYOperationCell alloc] initWithFrame:CGRectZero configuration:configuration];
        _tableCell = tableCell;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _tableView.frame = self.bounds;
}

// Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _tableCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self obtainCellHeight];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_didScrollBlock) _didScrollBlock(self, scrollView.contentOffset);
}

// Method

// 获取cell高度
- (CGFloat)obtainCellHeight {
    BOOL topExist = [_mutableItems.firstObject count] > 0;
    BOOL bottomExist = [_mutableItems.lastObject count] > 0;
    CGFloat textTop = _configuration.imageSize + _configuration.textTopMargin;
    // 内容列表高度
    for (NSInteger i = 0; i < _mutableItems.count; i++) {
        NSArray *items = _mutableItems[i];
        CGFloat maximumTextHeight = 0;
        for (YYOperationItem *item in items) {
            CGFloat itemWidth = _configuration.imageSize + _configuration.imageHorizontalMargin;
            CGFloat textHeight = ceilf([item.text xy_heightForAttributes:_configuration.textAttributes width:itemWidth]);
            maximumTextHeight = fmax(maximumTextHeight, textHeight);
        }
        if (i == 0) {
            _configuration.topHeight = items.count > 0 ? maximumTextHeight + textTop : 0;
        } else {
            _configuration.bottomHeight = items.count > 0 ? maximumTextHeight + textTop : 0;
        }
    }
    // 总高度
    if (!topExist && !bottomExist) return 0;
    CGFloat contentHeight = _configuration.topHeight + _configuration.bottomHeight + XYEdgeInsetsMaxY(_configuration.contentInsets);
    return (topExist && bottomExist) ? contentHeight + _configuration.listMargin : contentHeight;
}

// 获取头尾视图高度
- (CGFloat)obtainHeaderFooterHeight {
    CGFloat totalHeight = 0;
    BOOL reload = NO;
    
    if (_headerView) {
        CGFloat headerHeight = [_headerView sizeThatFits:CGSizeMake(self.xy_width, HUGE)].height;
        totalHeight += headerHeight;
        reload = _headerView.xy_height != headerHeight;
        if (reload) _headerView.bounds = CGRectMake(0, 0, self.xy_width, headerHeight);
    }
    if (_footerView) {
        CGFloat footerHeight = [_footerView sizeThatFits:CGSizeMake(self.xy_width, HUGE)].height;
        totalHeight += footerHeight;
        reload = _footerView.xy_height != footerHeight;
        if (reload) _footerView.bounds = CGRectMake(0, 0, self.xy_width, footerHeight);
    }
    if (reload) [_tableView reloadData];
    
    return totalHeight;
}

// 更新布局
- (void)updateViewLayoutIfNeeded {
    CGFloat cellHeight = [self obtainCellHeight];
    CGFloat viewHeight = [self obtainHeaderFooterHeight];
    CGFloat totalHeight = cellHeight + viewHeight;
    
    // 高度无变化
    if (self.xy_height == totalHeight && totalHeight <= _configuration.maximumHeight) return;
    // 内容布局更新
    [_tableView beginUpdates];
    _tableCell.updateLayout = cellHeight;
    [_tableView endUpdates];
    // 滑动限制
    _tableView.scrollEnabled = totalHeight > _configuration.maximumHeight;
    // 最大高度限制
    if (self.xy_height == _configuration.maximumHeight && totalHeight >= _configuration.maximumHeight) return;
    self.xy_height = totalHeight >= _configuration.maximumHeight ? _configuration.maximumHeight : totalHeight;
    // 高度变化通知
    if (_didChangeBlock) _didChangeBlock(self, self.xy_height);
}

- (void)insertItem:(YYOperationItem *)item inSection:(NSInteger)section {
    if (!item || section > 1 || section < 0) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_mutableItems[section] count] inSection:section];
    [self insertItem:item atIndexPath:indexPath];
}

- (void)insertItems:(NSArray *)items inSection:(NSInteger)section {
    if (items.count == 0 || section > 1 || section < 0) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_mutableItems[section] count] inSection:section];
    [self insertItems:items atIndexPath:indexPath];
}

- (void)insertItem:(YYOperationItem *)item atIndexPath:(NSIndexPath *)indexPath {
    if (!item || indexPath.section > 1 || indexPath.section < 0) return;
    NSMutableArray *array = _mutableItems[indexPath.section];
    if (indexPath.row > array.count) return;
    // 插入数据
    [array insertObject:item atIndex:indexPath.row];
    // 更新布局
    [self updateViewLayoutIfNeeded];
    // 刷新cell
    [_tableCell insertItems:@[item] atIndex:indexPath.row position:indexPath.section];
}

- (void)insertItems:(NSArray *)items atIndexPath:(NSIndexPath *)indexPath {
    if (items.count == 0 || indexPath.section > 1 || indexPath.section < 0) return;
    NSMutableArray *array = _mutableItems[indexPath.section];
    if (indexPath.row > array.count) return;
    // 插入数据
    for (NSInteger i = items.count - 1; i >= 0; i--) {
        [array insertObject:items[i] atIndex:indexPath.row];
    }
    // 更新布局
    [self updateViewLayoutIfNeeded];
    // 刷新cell
    [_tableCell insertItems:items atIndex:indexPath.row position:indexPath.section];
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 1 || indexPath.section < 0) return;
    NSMutableArray *array = _mutableItems[indexPath.section];
    if (indexPath.row >= array.count) return;
    // 删除数据
    [array removeObjectAtIndex:indexPath.row];
    // 更新布局
    [self updateViewLayoutIfNeeded];
    // 刷新cell
    [_tableCell deleteItemsAtIndexes:@[@(indexPath.row)] position:indexPath.section];
}

// Access

- (NSArray<NSArray<YYOperationItem *> *> *)items {
    return _mutableItems.copy;
}

- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    _tableView.tableHeaderView = headerView;
    [self updateViewLayoutIfNeeded];
}

- (void)setFooterView:(UIView *)footerView {
    _footerView = footerView;
    _tableView.tableFooterView = footerView;
    [self updateViewLayoutIfNeeded];
}

- (void)setBounds:(CGRect)bounds {
    // 宽度变化，更新布局
    BOOL changed = self.xy_width != bounds.size.width;
    [super setBounds:bounds];
    if (changed) [self updateViewLayoutIfNeeded];
}

- (void)setFrame:(CGRect)frame {
    // 宽度变化，更新布局
    BOOL changed = self.xy_width != frame.size.width;
    [super setFrame:frame];
    if (changed) [self updateViewLayoutIfNeeded];
}

@end
