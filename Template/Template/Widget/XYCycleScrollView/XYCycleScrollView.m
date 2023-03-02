//
//  XYCycleScrollView.m
//  XYCycleScrollView
//
//  Created by nevsee on 2017/4/1.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "XYCycleScrollView.h"
#import "XYCycleCell.h"

@interface XYCycleScrollView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) Class renderClass;

@property (nonatomic, assign) NSInteger actualIndex;
@property (nonatomic, assign) NSInteger actualCount;
@property (nonatomic, assign) CGFloat previousIndexWhenScrolling;
@property (nonatomic, assign) BOOL isChangingCollectionViewBounds;
@end

@implementation XYCycleScrollView

#pragma mark # Life

- (instancetype)initWithFrame:(CGRect)frame layout:(UICollectionViewFlowLayout *)layout {
    return [self initWithFrame:frame layout:layout renderClass:NULL];
}

- (instancetype)initWithFrame:(CGRect)frame layout:(UICollectionViewFlowLayout *)layout renderClass:(Class<XYCycleDataParser>)renderClass {
    self = [super initWithFrame:frame];
    if (self) {
        _layout = layout;
        _renderClass = renderClass;
        [self parameterSetup];
        [self userInterfaceSetup];
    }
    return self;
}

- (void)dealloc {
    [self deleteTimer];
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) [self deleteTimer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_actualCount == 0) {
        [self configureInitialIndex];
        [self startTimer];
    }
    
    if (!CGSizeEqualToSize(_collectionView.bounds.size, self.bounds.size)) {
        [self setIsChangingCollectionViewBounds:YES];
        [_layout invalidateLayout];
        [_collectionView setFrame:self.bounds];
        [self scrollToActualIndex:_actualIndex animated:NO];
        [self setIsChangingCollectionViewBounds:NO];
    }
}

- (void)parameterSetup {
    _datas = @[];
    _repeat = YES;
    _autoScroll = YES;
    _autoScrollInterval = 3;
    _actualIndex = 0;
    _actualCount = 0;
    _decelerationRate = UIScrollViewDecelerationRateFast;
}

- (void)userInterfaceSetup {
    UICollectionView *view = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
    view.backgroundColor = [UIColor clearColor];
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    view.scrollsToTop = NO;
    view.delaysContentTouches = NO;
    view.dataSource = self;
    view.delegate = self;
    view.decelerationRate = _decelerationRate;
    if (@available(iOS 11, *)) {
        view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (_renderClass) {
        [view registerClass:XYCycleCell.class forCellWithReuseIdentifier:[_renderClass reuseIdentifier]];
    }
    [self setCollectionView:view];
    [self addSubview:view];
}

#pragma mark # Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _actualCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Class renderClass = _renderClass;
    NSInteger index = [self obtainBusinessIndex:indexPath.item];
    if (renderClass == NULL) {
        renderClass = [_dataSource cycleScrollView:self classForItemAtIndex:index];
    }
    XYCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[renderClass reuseIdentifier] forIndexPath:indexPath];
    if (!cell.renderView) {
        cell.renderView = [[renderClass alloc] init];
    }
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didSetContentView:atIndex:)]) {
        [_delegate cycleScrollView:self didSetContentView:cell.renderView atIndex:index];
    }
    [cell refreshCellWithData:_datas[index] userInfo:_userInfo];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [_delegate cycleScrollView:self didSelectItemAtIndex:[self obtainBusinessIndex:indexPath.item]];
    }
}

// UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isChangingCollectionViewBounds) return;
    
    CGFloat index = 0;
    if (_layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = scrollView.contentOffset.x / (_layout.itemSize.width + _layout.minimumLineSpacing);
    } else {
        index = scrollView.contentOffset.y / (_layout.itemSize.height + _layout.minimumLineSpacing);
    }
    
    // Avoids calling methods frequently
    BOOL isFirstDidScrolling = _previousIndexWhenScrolling == 0;
    
    // FastToRight example : previousIndexWhenScrolling 1.49, index = 2.0
    BOOL fastToRight = (floor(index) - floor(_previousIndexWhenScrolling) >= 1.0) && (floor(index) - _previousIndexWhenScrolling > 0.5);
    BOOL turnPageToRight = fastToRight || (floor(index) + 0.5 >= _previousIndexWhenScrolling && floor(index) + 0.5 <= index);

    // FastToLeft example : previousIndexWhenScrolling 2.51, index = 1.99
    BOOL fastToLeft = (floor(_previousIndexWhenScrolling) - floor(index) >= 1.0) && (_previousIndexWhenScrolling - ceil(index) > 0.5);
    BOOL turnPageToLeft = fastToLeft || (floor(index) + 0.5 <= _previousIndexWhenScrolling && floor(index) + 0.5 >= index);
    
    if (!isFirstDidScrolling && (turnPageToRight || turnPageToLeft)) {
        index = round(index);
        if (index >= 0 && index < _actualCount) {
            _actualIndex = index;
            
            if ([_delegate respondsToSelector:@selector(cycleScrollView:willScrollToIndex:)]) {
                [_delegate cycleScrollView:self willScrollToIndex:[self obtainBusinessIndex:index]];
            }
        }
    }
    _previousIndexWhenScrolling = index;
    
    // When scrolling with NO animation, '-scrollViewDidEndScrollingAnimation' will not be called
    if (!_isAnimating && !scrollView.isDragging) {
        [self startTimer];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isAnimating = YES;
    [self deleteTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _isAnimating = NO;
    [self startTimer];
    
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [_delegate cycleScrollView:self didScrollToIndex:[self obtainBusinessIndex:_actualIndex]];
    }
    
    if (![self needRepeat]) return;
    
    // Repeats
    if (_actualIndex == _actualCount - 1) {
        _actualIndex = _actualCount * 0.5 - 1;
        [self scrollToActualIndex:_actualIndex animated:NO];
    } else if (_actualIndex == 0) {
        _actualIndex = _actualCount * 0.5;
        [self scrollToActualIndex:_actualIndex animated:NO];
    }
}

#pragma mark # Action

- (void)autoScrollAction {
    if (![self needRepeat]) return;
    [self scrollToActualIndex:_actualIndex + 1 animated:YES];
}

#pragma mark # Method

- (void)updateLayout:(UICollectionViewFlowLayout *)layout {
    _layout = layout;
    _collectionView.collectionViewLayout = layout;
    [self scrollToActualIndex:_actualIndex animated:NO];
}

- (void)registerCellWithReuseIdentifier:(NSString *)identifier {
    [_collectionView registerClass:XYCycleCell.class forCellWithReuseIdentifier:identifier];
}

- (void)reloadData {
    [self deleteTimer];
    [self configureInitialIndex];
    [self.collectionView reloadData];
    [self scrollToActualIndex:_actualIndex animated:NO];
    [self startTimer];
}

- (void)scrollToItemAtIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < 0 || index > _datas.count - 1) return;
    if (_collectionView.dragging) return;
    if (_isChangingCollectionViewBounds) return;
    
    NSInteger businessIndex = [self obtainBusinessIndex:_actualIndex];
    NSInteger interval = index - businessIndex;
    if (interval == 0) return;
    
    [self deleteTimer];
    [self scrollToActualIndex:_actualIndex + interval animated:animated];
}

- (void)scrollToNextItemAnimated:(BOOL)animated {
    if (_collectionView.dragging) return;
    if (_isChangingCollectionViewBounds) return;
    if (_actualIndex == _actualCount - 1) return;
    
    [self deleteTimer];
    [self scrollToActualIndex:_actualIndex + 1 animated:animated];
}

- (void)scrollToPreviousItemAnimated:(BOOL)animated {
    if (_collectionView.dragging) return;
    if (_isChangingCollectionViewBounds) return;
    if (_actualIndex == 0) return;
    
    [self deleteTimer];
    [self scrollToActualIndex:_actualIndex - 1 animated:animated];
}

- (void)scrollToActualIndex:(NSInteger)actualIndex animated:(BOOL)animated {
    _isAnimating = animated;
    
    if (_layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat offsetX = actualIndex * (_layout.itemSize.width + _layout.minimumLineSpacing);
        [_collectionView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
    } else {
        CGFloat offsetY = actualIndex * (_layout.itemSize.height + _layout.minimumLineSpacing);
        [_collectionView setContentOffset:CGPointMake(0, offsetY) animated:animated];
    }
}

- (XYCycleCell *)cellForItemAtIndex:(NSInteger)index {
    NSInteger businessIndex = [self obtainBusinessIndex:_actualIndex];
    NSInteger interval = index - businessIndex;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_actualIndex + interval inSection:0];
    return (XYCycleCell *)[_collectionView cellForItemAtIndexPath:indexPath];
}

- (void)configureInitialIndex {
    _previousIndexWhenScrolling = 0;
    
    if (_defaultIndex >= _datas.count) {
        _defaultIndex = 0;
    }

    // If it scrolls repeatedly, expands the amount of data 100 times and scrolls to center position
    if ([self needRepeat]) {
        _actualCount = _datas.count * 100;
        _actualIndex = _actualCount * 0.5 + _defaultIndex;
    } else {
        _actualCount = _datas.count;
        _actualIndex = _defaultIndex;
    }
}

- (BOOL)needRepeat {
    return _repeat && _datas.count > 1;
}

- (NSInteger)obtainBusinessIndex:(NSInteger)actualIndex {
    if (![self needRepeat]) return actualIndex;
    return actualIndex % _datas.count;
}

- (void)startTimer {
    if (!_autoScroll) return;
    if (![self needRepeat]) return;
    if (_timer) return;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollInterval
                                              target:self
                                            selector:@selector(autoScrollAction)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)deleteTimer {
    if (!_timer) return;
    [_timer invalidate];
    _timer = nil;
}

#pragma mark # Access

- (NSInteger)currentIndex {
    return [self obtainBusinessIndex:_actualIndex];
}

- (XYCycleCell *)currentCell {
    return [self cellForItemAtIndex:self.currentIndex];
}

- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    [self reloadData];
}

- (void)setUserInfo:(id)userInfo {
    _userInfo = userInfo;
    [self reloadData];
}

- (void)setDecelerationRate:(UIScrollViewDecelerationRate)decelerationRate {
    _decelerationRate = decelerationRate;
    _collectionView.decelerationRate = decelerationRate;
}

- (void)setDefaultIndex:(NSInteger)defaultIndex {
    _defaultIndex = defaultIndex;
    [self reloadData];
}

@end
