//
//  XYBrowserView.m
//  XYBrowser
//
//  Created by nevsee on 2022/9/21.
//

#import "XYBrowserView.h"

@interface XYBrowserViewCell : UICollectionViewCell
@property (nonatomic, strong, readonly) XYBrowserImageCarrier *imageCarrier;
@property (nonatomic, strong, readonly) XYBrowserVideoCarrier *videoCarrier;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, strong) Class imageCarrierClass;
@property (nonatomic, strong) Class videoCarrierClass;
- (void)reloadCellWithAsset:(id)asset index:(NSUInteger)index;
@end

@implementation XYBrowserViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageCarrier.frame = CGRectMake(0, 0, self.bounds.size.width - _itemSpacing, self.bounds.size.height);
    _videoCarrier.frame = CGRectMake(0, 0, self.bounds.size.width - _itemSpacing, self.bounds.size.height);
}

- (void)reloadCellWithAsset:(XYBrowserAsset *)asset index:(NSUInteger)index {
    [_imageCarrier loadContentWithAsset:asset index:index];
    [_videoCarrier loadContentWithAsset:asset index:index];
}

- (void)setImageCarrierClass:(Class)imageCarrierClass {
    if (_imageCarrier) return;
    _imageCarrierClass = imageCarrierClass;
    _imageCarrier = [[imageCarrierClass alloc] init];
    [self.contentView addSubview:_imageCarrier];
}

- (void)setVideoCarrierClass:(Class)videoCarrierClass {
    if (_videoCarrier) return;
    _videoCarrierClass = videoCarrierClass;
    _videoCarrier = [[videoCarrierClass alloc] init];;
    [self.contentView addSubview:_videoCarrier];
}

@end

#pragma mark -

static NSString *_xybrowserDefaultCache;

@interface XYBrowserView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) BOOL isChangingCollectionViewBounds;
@property (nonatomic, assign) BOOL firstDisplay;
@property (nonatomic, weak, nullable) XYBrowserController *browserController;
@end

@implementation XYBrowserView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _firstDisplay = YES;
        _itemSpacing = 20;
        _maximumZoomScale = 2;
        _maximumLimitedSize = 3990;
        _tooHighRatio = 3;
        _autoplayVideoWhenDisplayFirstly = YES;

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout = flowLayout;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = UIColor.clearColor;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.scrollsToTop = NO;
        collectionView.delaysContentTouches = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [collectionView registerClass:XYBrowserViewCell.class forCellWithReuseIdentifier:@"unknown"];
        [collectionView registerClass:XYBrowserViewCell.class forCellWithReuseIdentifier:@"image"];
        [collectionView registerClass:XYBrowserViewCell.class forCellWithReuseIdentifier:@"video"];
        [self addSubview:collectionView];
        _collectionView = collectionView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize collectionViewSize = CGSizeMake(_collectionView.bounds.size.width - _itemSpacing, _collectionView.bounds.size.height);
    if (CGSizeEqualToSize(self.bounds.size, collectionViewSize)) return;
    _isChangingCollectionViewBounds = YES;
    [_flowLayout invalidateLayout];
    _collectionView.frame = CGRectMake(0, 0, self.bounds.size.width + _itemSpacing, self.bounds.size.height);
    [self scrollToIndex:_currentIndex animated:NO];
    _isChangingCollectionViewBounds = NO;
}

#pragma mark # Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_dataSource respondsToSelector:@selector(numberOfAssetsInBrowserView:)]) {
        return [_dataSource numberOfAssetsInBrowserView:self];
    }
    return _datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XYBrowserAsset *asset = nil;
    if ([_dataSource respondsToSelector:@selector(browserView:assetAtIndex:)]) {
        asset = [_dataSource browserView:self assetAtIndex:indexPath.row];
    } else {
        asset = _datas[indexPath.row];
    }
    
    XYBrowserViewCell *cell = nil;
    if (asset.mediaType == XYBrowserViewMediaTypeImage) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
        cell.imageCarrierClass = self.imageCarrierClass;
        cell.imageCarrier.imagePlayer.cachePath = self.cachePath;
        cell.imageCarrier.imagePlayer.maximumZoomScale = _maximumZoomScale;
        cell.imageCarrier.imagePlayer.maximumLimitedSize = _maximumLimitedSize;
        cell.imageCarrier.imagePlayer.tooHighRatio = _tooHighRatio;
        cell.imageCarrier.imagePlayer.imageView.resetFrameIndexWhenStopped = _resetFrameIndexWhenStopped;
    } else if (asset.mediaType == XYBrowserViewMediaTypeVideo) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"video" forIndexPath:indexPath];
        cell.videoCarrierClass = self.videoCarrierClass;
        cell.videoCarrier.videoPlayer.cachePath = self.cachePath;
        cell.videoCarrier.videoPlayer.autoplay = _autoplayVideoWhenDisplayFirstly && _firstDisplay;
    }
    cell.itemSpacing = _itemSpacing;
    [cell reloadCellWithAsset:asset index:indexPath.row];
    _firstDisplay = NO;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [((XYBrowserViewCell *)cell).imageCarrier stopDisplay];
    [((XYBrowserViewCell *)cell).videoCarrier stopDisplay];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    ((XYBrowserViewCell *)cell).imageCarrier.browserController = _browserController;
    [((XYBrowserViewCell *)cell).imageCarrier startDisplay];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width + _itemSpacing, self.bounds.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isChangingCollectionViewBounds) return;
    
    CGFloat itemWidth = scrollView.bounds.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    offsetX = offsetX + (itemWidth * 0.5);
    
    NSInteger currentIndex = offsetX / itemWidth;
    NSInteger count = [self collectionView:_collectionView numberOfItemsInSection:0];
    
    if (currentIndex < count && _currentIndex != currentIndex && itemWidth > 0) {
        _currentIndex = currentIndex;
        if ([_delegate respondsToSelector:@selector(browserView:willScrollHalfToIndex:)]) {
            [_delegate browserView:self willScrollHalfToIndex:currentIndex];
        }
        if (_willScrollHalfToIndexBlock) _willScrollHalfToIndexBlock(currentIndex);
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([_delegate respondsToSelector:@selector(browserView:didScrollToIndex:)]) {
        [_delegate browserView:self didScrollToIndex:_currentIndex];
    }
    if (_didScrollToIndexBlock) _didScrollToIndexBlock(_currentIndex);
}

#pragma mark # Method

- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < 0 && index >= [_collectionView numberOfItemsInSection:0]) return;
    CGPoint targetPoint = CGPointMake(index * (self.bounds.size.width + _itemSpacing), 0);
    [_collectionView setContentOffset:targetPoint animated:animated];
}

- (UIView<XYBrowserCarrierDescriber> *)carrierViewAtIndex:(NSInteger)index {
    XYBrowserViewCell *cell = (XYBrowserViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return cell.videoCarrier ?: cell.imageCarrier;
}

- (UIView<XYBrowserCarrierDescriber> *)currentCarrierView {
    return [self carrierViewAtIndex:_currentIndex];
}

- (XYBrowserAsset *)assetAtIndex:(NSInteger)index {
    if ([_dataSource respondsToSelector:@selector(browserView:assetAtIndex:)]) {
        return [_dataSource browserView:self assetAtIndex:_currentIndex];
    }
    return nil;
}

- (XYBrowserAsset *)currentAsset {
    return [self assetAtIndex:_currentIndex];
}

- (void)updateSubviewAlphaExceptCarrier:(CGFloat)alpha {
    // Subclass override
}

- (void)updateSubviewValue {
    // Subclass override
}

#pragma mark # Access

- (NSUInteger)totalIndex {
    if ([_dataSource respondsToSelector:@selector(numberOfAssetsInBrowserView:)]) {
        return [_dataSource numberOfAssetsInBrowserView:self];
    }
    return _datas.count;
}

- (Class)imageCarrierClass {
    if (!_imageCarrierClass) {
        _imageCarrierClass = XYBrowserImageCarrier.class;
    }
    return _imageCarrierClass;
}

- (Class)videoCarrierClass {
    if (!_videoCarrierClass) {
        _videoCarrierClass = XYBrowserVideoCarrier.class;
    }
    return _videoCarrierClass;
}

- (NSString *)cachePath {
    if (!_cachePath) {
        _cachePath = XYBrowserView.defaultCachePath;
    }
    return _cachePath;
}

+ (NSString *)defaultCachePath {
    if (!_xybrowserDefaultCache) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        _xybrowserDefaultCache = [path stringByAppendingPathComponent:@"com.nevsee.XYBrowserCache"];
    }
    return _xybrowserDefaultCache;
}

+ (void)setDefaultCachePath:(NSString *)defaultCachePath {
    _xybrowserDefaultCache = defaultCachePath;
}

@end

@implementation XYBrowserAsset

@end

@implementation XYBrowserAsset (XYImageSupport)

+ (UIImage *)imageWithContentsOfFile:(NSString *)path {
    UIImage *image = [SDAnimatedImage imageWithContentsOfFile:path];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:path];
    }
    return image;
}

+ (UIImage *)imageWithContentsOfURL:(NSURL *)url {
    return [self imageWithContentsOfFile:url.path];
}

@end
