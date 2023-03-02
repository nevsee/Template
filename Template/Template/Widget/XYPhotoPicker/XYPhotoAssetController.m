//
//  XYPhotoAssetController.m
//  XYPhotoPicker
//
//  Created by nevsee on 2017/6/10.
//

#import "XYPhotoAssetController.h"
#import "XYPhotoPreviewController.h"
#import "XYPhotoPickerController.h"
#import "XYPhotoPickerAppearance.h"
#import "XYPhotoPickerHelper.h"
#import "XYPhoto.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface XYAsset (XYPhotoAsset)
@property (nonatomic, assign) BOOL choosed;
@end

@implementation XYAsset (XYPhotoAsset)

- (void)setChoosed:(BOOL)choosed {
    objc_setAssociatedObject(self, _cmd, @(choosed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)choosed {
    NSNumber *value = objc_getAssociatedObject(self, @selector(setChoosed:));
    return value.boolValue;
}

@end

#pragma mark -

static CGFloat const kXYToolBarHeight = 50;
static CGFloat const kXYToolbarHorizontalPadding = 20;
static CGFloat const kXYToolbarVerticalPadding = 8;
static CGFloat const kXYToolbarSendButtonInset = 14;

@interface XYPhotoAssetToolBar : UIView
@property (nonatomic, strong) UIToolbar *backgroundView;
@property (nonatomic, strong) UIButton *previewButton; // 预览按钮
@property (nonatomic, strong) UIButton *sendButton; // 发送按钮
@property (nonatomic, assign) BOOL isFirstLayout; // 是否是第一次更新布局
@property (nonatomic, assign) BOOL isUpdating; // 是否是再次更新发送按钮布局
- (void)updateViewWhenChoosingAsset:(NSInteger)assetCount;
@end

@implementation XYPhotoAssetToolBar

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        XYPhotoPickerAppearance *appearance = [XYPhotoPickerAppearance appearance];
        
        _isFirstLayout = YES;
        _isUpdating = YES;
        self.backgroundColor = [UIColor clearColor];
        
        UIToolbar *backgroundView = [[UIToolbar alloc] init];
        backgroundView.barStyle = appearance.pickerStyle;
        [self addSubview:backgroundView];
        _backgroundView = backgroundView;
        
        NSString *previewName = [XYPhotoPickerHelper localizedStringForKey:appearance.previewName];
        NSAttributedString *previewNormalTitle = [[NSAttributedString alloc] initWithString:previewName attributes:appearance.assetToolBarItemNormalAttributes];
        NSAttributedString *previewDisabledTitle = [[NSAttributedString alloc] initWithString:previewName attributes:appearance.assetToolBarItemDisabledAttributes];
        UIButton *previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        previewButton.enabled = NO;
        [previewButton setAttributedTitle:previewNormalTitle forState:UIControlStateNormal];
        [previewButton setAttributedTitle:previewDisabledTitle forState:UIControlStateDisabled];
        [previewButton sizeToFit];
        [self addSubview:previewButton];
        _previewButton = previewButton;
        
        NSString *doneName = [XYPhotoPickerHelper localizedStringForKey:appearance.doneName];
        NSAttributedString *sendNormalTitle = [[NSAttributedString alloc] initWithString:doneName attributes:appearance.assetToolBarDoneItemNormalAttributes];
        NSAttributedString *sendDisabledTitle = [[NSAttributedString alloc] initWithString:doneName attributes:appearance.assetToolBarDoneItemDisabledAttributes];
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.enabled = NO;
        sendButton.layer.cornerRadius = 3;
        sendButton.layer.masksToBounds = YES;
        [sendButton setAttributedTitle:sendNormalTitle forState:UIControlStateNormal];
        [sendButton setAttributedTitle:sendDisabledTitle forState:UIControlStateDisabled];
        [sendButton setBackgroundColor:appearance.assetToolBarDoneItemDisabledBackgroundColor];
        [sendButton sizeToFit];
        [self addSubview:sendButton];
        _sendButton = sendButton;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat safeAreaLeft = self.safeAreaInsets.left;
    CGFloat safeAreaRight = self.safeAreaInsets.right;
    
    _backgroundView.frame = self.bounds;
    
    if (_isFirstLayout) {
        _previewButton.frame = CGRectMake(safeAreaLeft, 0, CGRectGetWidth(_previewButton.bounds) + kXYToolbarHorizontalPadding * 2, kXYToolBarHeight);
        _isFirstLayout = NO;
    } else {
        _previewButton.frame = CGRectMake(safeAreaLeft, 0, CGRectGetWidth(_previewButton.bounds), kXYToolBarHeight);
    }
    
    if (_isUpdating) {
        _sendButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(_sendButton.bounds) - kXYToolbarHorizontalPadding - kXYToolbarSendButtonInset * 2 - safeAreaRight, kXYToolbarVerticalPadding, CGRectGetWidth(_sendButton.bounds) + kXYToolbarSendButtonInset * 2, kXYToolBarHeight - kXYToolbarVerticalPadding * 2);
        _isUpdating = NO;
    } else {
        _sendButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(_sendButton.bounds) - kXYToolbarHorizontalPadding - safeAreaRight, CGRectGetMinY(_sendButton.frame), CGRectGetWidth(_sendButton.bounds), CGRectGetHeight(_sendButton.bounds));
    }
}

- (void)updateViewWhenChoosingAsset:(NSInteger)assetCount {
    _previewButton.enabled = assetCount != 0;
    _sendButton.enabled = assetCount != 0;
    
    NSString *doneName = [XYPhotoPickerHelper localizedStringForKey:[XYPhotoPickerAppearance appearance].doneName];
    NSAttributedString *sendTitle = nil;
    if (assetCount > 0) {
        sendTitle = [[NSAttributedString alloc] initWithString:[doneName stringByAppendingFormat:@"·%@", @(assetCount)] attributes:[XYPhotoPickerAppearance appearance].assetToolBarDoneItemNormalAttributes];
        [_sendButton setAttributedTitle:sendTitle forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:[XYPhotoPickerAppearance appearance].assetToolBarDoneItemNormalBackgroundColor];
    } else {
        sendTitle = [[NSAttributedString alloc] initWithString:doneName attributes:[XYPhotoPickerAppearance appearance].assetToolBarDoneItemDisabledAttributes];
        [_sendButton setAttributedTitle:sendTitle forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:[XYPhotoPickerAppearance appearance].assetToolBarDoneItemDisabledBackgroundColor];
    }
    [_sendButton sizeToFit];
    _isUpdating = YES;
    [self setNeedsLayout];
}

@end

#pragma mark -

static const CGFloat kXYCheckBoxSize = 40;
static const CGFloat kXYCheckBoxTopRightMargin = 10;
static const CGFloat kXYNoteHeight = 20;
static const CGFloat kXYNoteLeftMargin = 5;
static const CGFloat kXYNoteBottomMargin = 3;

@interface XYPhotoAssetCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *thumbView; // 资源缩略图
@property (nonatomic, strong) UILabel *noteLabel; // 资源描述
@property (nonatomic, strong) CAGradientLayer *noteBarLayer; // 资源描述渐变背景
@property (nonatomic, strong) UIButton *checkBoxButton; // 选择按钮
@property (nonatomic, strong) CALayer *maskLayer; // 选中遮罩
@property (nonatomic, strong) BOOL(^choosedCallback) (XYAsset *asset); // 选中回调
@property (nonatomic, strong, readonly) XYAsset *asset;
@property (nonatomic, strong, readonly) NSString *assetIdentifier;
- (void)refreshCellWithAsset:(XYAsset *)asset thumbSize:(CGSize)thumbSize configuration:(XYPhotoPickerConfiguration *)configuration;
@end

@implementation XYPhotoAssetCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self userInterfaceSetup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _thumbView.frame = self.bounds;
    _maskLayer.frame = self.bounds;
    _noteLabel.frame = CGRectMake(kXYNoteLeftMargin, self.bounds.size.height - kXYNoteHeight - kXYNoteBottomMargin, self.bounds.size.width - kXYNoteLeftMargin * 2, kXYNoteHeight);
    _noteBarLayer.frame = CGRectMake(0, self.bounds.size.height - kXYNoteHeight - kXYNoteBottomMargin * 2, self.bounds.size.width, kXYNoteHeight + kXYNoteBottomMargin * 2);
    _checkBoxButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - kXYCheckBoxSize, 0, kXYCheckBoxSize, kXYCheckBoxSize);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self resetUserInterface];
}

- (void)userInterfaceSetup {
    self.backgroundColor = [UIColor clearColor];
    
    XYPhotoPickerAppearance *appearance = [XYPhotoPickerAppearance appearance];
    
    UIImageView *thumbiView = [[UIImageView alloc] init];
    thumbiView.contentMode = UIViewContentModeScaleAspectFill;
    thumbiView.clipsToBounds = YES;
    [self.contentView addSubview:thumbiView];
    _thumbView = thumbiView;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    maskLayer.hidden = YES;
    [self.contentView.layer addSublayer:maskLayer];
    _maskLayer = maskLayer;
    
    UIImage *checkBoxImage = [XYPhotoPickerHelper imageNamed:appearance.assetNotSelectedImage];
    CGFloat imageLeftInset = kXYCheckBoxSize - checkBoxImage.size.width - kXYCheckBoxTopRightMargin;
    CGFloat imageBottomInset = kXYCheckBoxSize - checkBoxImage.size.height - kXYCheckBoxTopRightMargin;
    UIButton *checkBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBoxButton.imageEdgeInsets = UIEdgeInsetsMake(0, imageLeftInset, imageBottomInset, 0);
    [checkBoxButton setImage:checkBoxImage forState:UIControlStateNormal];
    [checkBoxButton addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:checkBoxButton];
    _checkBoxButton = checkBoxButton;
    
    CAGradientLayer *noteBarLayer = [CAGradientLayer layer];
    noteBarLayer.startPoint = CGPointMake(0.5, 1);
    noteBarLayer.endPoint = CGPointMake(0.5, 0);
    noteBarLayer.colors = @[
        (__bridge id)[UIColor colorWithWhite:0 alpha:0.5].CGColor,
        (__bridge id)[UIColor colorWithWhite:0 alpha:0.3].CGColor,
        (__bridge id)[UIColor colorWithWhite:0 alpha:0].CGColor,
    ];
    noteBarLayer.locations = @[@(0), @(0.6), @(1)];
    [self.contentView.layer addSublayer:noteBarLayer];
    _noteBarLayer = noteBarLayer;
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.textColor = appearance.assetNoteColor;
    noteLabel.font = appearance.assetNoteFont;
    [self.contentView addSubview:noteLabel];
    _noteLabel = noteLabel;
}

- (void)chooseAction {
    if (_choosedCallback(_asset)) {
        _asset.choosed = !_asset.choosed;
        [self updateUserInterfaceWhenChoosed];
    }
}

- (void)updateUserInterfaceWhenChoosed {
    if (_asset.choosed) {
        _maskLayer.hidden = NO;
        [_checkBoxButton setImage:[XYPhotoPickerHelper imageNamed:[XYPhotoPickerAppearance appearance].assetSelectedImage] forState:UIControlStateNormal];
        [XYPhotoPickerHelper addAnimationForCheckBoxButton:_checkBoxButton];
    } else {
        _maskLayer.hidden = YES;
        [_checkBoxButton setImage:[XYPhotoPickerHelper imageNamed:[XYPhotoPickerAppearance appearance].assetNotSelectedImage] forState:UIControlStateNormal];
        [XYPhotoPickerHelper removeAnimationForCheckBoxButton:_checkBoxButton];
    }
}

- (void)resetUserInterface {
    _thumbView.image = nil;
    _noteLabel.text = nil;
    _noteBarLayer.hidden = YES;
    _maskLayer.hidden = YES;
    [_checkBoxButton setImage:[XYPhotoPickerHelper imageNamed:[XYPhotoPickerAppearance appearance].assetNotSelectedImage] forState:UIControlStateNormal];
    [XYPhotoPickerHelper removeAnimationForCheckBoxButton:_checkBoxButton];
}

- (void)refreshCellWithAsset:(XYAsset *)asset thumbSize:(CGSize)thumbSize configuration:(XYPhotoPickerConfiguration *)configuration {
    _asset = asset;
    _assetIdentifier = asset.identifier;
    
    // 资源缩略图
    __weak typeof(self) weakObj = self;
    [asset requestThumbnailImageWithsize:thumbSize progress:nil completion:^(UIImage *result, NSDictionary *info) {
        __strong typeof(weakObj) self = weakObj;
        if ([self.assetIdentifier isEqualToString:asset.identifier]) {
            self.thumbView.image = result;
        } else {
            self.thumbView.image = nil;
        }
    }];

    // 资源类型描述
    if (asset.assetType == XYAssetTypeVideo) {
        _noteLabel.text = [XYPhotoPickerHelper transformTimeIntervalWithSecond:asset.duration];
    } else {
        if (asset.assetSubType == XYAssetSubTypeGIF && configuration.allowPickingGif) {
            _noteLabel.text = @"GIF";
        }  else {
            _noteLabel.text = nil;
        }
    }
    _noteBarLayer.hidden = (_noteLabel.text == nil);
    
    // 更新选中状态
    if (configuration.allowMultipleSelection) {
        [self updateUserInterfaceWhenChoosed];
    } else {
        _checkBoxButton.hidden = YES;
    }
}

@end

#pragma mark -

@interface XYPhotoAssetController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *listView;
@property (nonatomic, strong) XYPhotoAssetToolBar *toolBar;
@property (nonatomic, assign) CGSize thumbSize; // 记录列表item大小
@property (nonatomic, assign) BOOL loadAssetsCompleted; // 资源是否已经加装完成
@property (nonatomic, assign) CGRect previousPreheatRect; // 预加载区域
@end

@implementation XYPhotoAssetController

#pragma mark # Life

- (instancetype)init {
    self = [super init];
    if (self) {
        [self parameterSetup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetCachedAssets];
    [self parameterSetup];
    [self userInterfaceSetup];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    CGFloat toolBarHeight = kXYToolBarHeight + self.view.safeAreaInsets.bottom;
    
    _listView.frame = self.view.bounds;
    _toolBar.frame = CGRectMake(0, size.height - toolBarHeight, size.width, toolBarHeight);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self scrollToOriginalPositionIfNeeded];
}

- (void)dealloc {
    [self resetCachedAssets];
}

- (void)parameterSetup {
    _allAssets = [NSMutableArray array];
}

- (void)userInterfaceSetup {
    XYPhotoPickerAppearance *appearance = [XYPhotoPickerAppearance appearance];
    self.view.backgroundColor = appearance.pickerBackgroundColor;
    
    UIImage *backImage = [[XYPhotoPickerHelper imageNamed:appearance.pickerNavigationBarBackImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backAction)];
    
    NSString *cancelTitle = [XYPhotoPickerHelper localizedStringForKey:appearance.cancelName];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:cancelTitle
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(dismissAction)];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = appearance.assetSpacing;
    flowLayout.minimumInteritemSpacing = appearance.assetSpacing;
    flowLayout.sectionInset = appearance.assetSectionInsets;
    
    UICollectionView *listView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    listView.backgroundColor = [UIColor clearColor];
    listView.delegate = self;
    listView.dataSource = self;
    listView.showsHorizontalScrollIndicator = NO;
    listView.showsVerticalScrollIndicator = NO;
    [listView registerClass:[XYPhotoAssetCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:listView];
    _listView = listView;
    
    if (_configuration.allowMultipleSelection) {
        listView.contentInset = UIEdgeInsetsMake(0, 0, kXYToolBarHeight, 0);
        
        XYPhotoAssetToolBar *toolBar = [[XYPhotoAssetToolBar alloc] init];
        [toolBar.previewButton addTarget:self action:@selector(previewAction) forControlEvents:UIControlEventTouchUpInside];
        [toolBar.sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        [toolBar updateViewWhenChoosingAsset:_selectedAssets.count];
        [self.view addSubview:toolBar];
        _toolBar = toolBar;
    }
}

#pragma mark # Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!_loadAssetsCompleted) return 0;
    return _allAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XYAsset *asset = _allAssets[indexPath.row];
    asset.choosed = [_selectedAssetIdentifiers containsObject:asset.identifier]; // 检查asset是否被选中
    
    XYPhotoAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell refreshCellWithAsset:asset thumbSize:_thumbSize configuration:_configuration];
    // 资源被选中
    __weak __typeof(self) weak = self;
    cell.choosedCallback = ^BOOL(XYAsset *asset) {
        __strong __typeof(weak) self = weak;
        if (!asset) return NO;
        // 检查是否超过最大选中数量
        if (!asset.choosed && self.selectedAssets.count >= self.configuration.maximumSelectionLimit) {
            XYPhotoPickerController *controller = (XYPhotoPickerController *)self.navigationController;
            if ([controller.pickerDelegate respondsToSelector:@selector(pickerDidOverMaximumSelectionLimit:)]) {
                [controller.pickerDelegate pickerDidOverMaximumSelectionLimit:controller];
            }
            return NO;
        }
        if (asset.choosed) {
            // 保存的asset只能通过对比identifier来移除
            for (XYAsset *selectedAsset in self.selectedAssets) {
                if (![selectedAsset.identifier isEqualToString:asset.identifier]) continue;
                [self.selectedAssets removeObject:selectedAsset]; break;
            }
            [self.selectedAssetIdentifiers removeObject:asset.identifier];
        } else {
            [self.selectedAssets addObject:asset];
            [self.selectedAssetIdentifiers addObject:asset.identifier];
        }
        [self.toolBar updateViewWhenChoosingAsset:self.selectedAssets.count];
        
        return YES;
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = collectionView.bounds.size;
    NSInteger count = [XYPhotoPickerAppearance appearance].assetColumnCount;
    UIEdgeInsets inset = [XYPhotoPickerAppearance appearance].assetSectionInsets;
    CGFloat spacing = [XYPhotoPickerAppearance appearance].assetSpacing;
    CGFloat width = (size.width - inset.left - inset.right - (count - 1) * spacing) / count;
    return _thumbSize = CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XYPhotoPreviewController *vc = [[XYPhotoPreviewController alloc] init];
    vc.selectedAssets = _selectedAssets;
    vc.selectedAssetIdentifiers = _selectedAssetIdentifiers;
    vc.configuration = _configuration;
    vc.allAssets = _allAssets;
    vc.currentIndex = indexPath.row;
    vc.didUpdateBlock = ^(NSInteger index, NSString *identifier) {
        // cell
        XYAsset *asset = self.allAssets[index];
        asset.choosed = [self.selectedAssetIdentifiers containsObject:asset.identifier]; // 检查asset是否被选中
        [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        // toolbar
        [self.toolBar updateViewWhenChoosingAsset:self.selectedAssets.count];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCachedAssets];
}

#pragma mark # Action

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissAction {
    XYPhotoPickerController *controller = (XYPhotoPickerController *)self.navigationController;
    if ([controller.pickerDelegate respondsToSelector:@selector(pickerWillCancelPicking:)]) {
        [controller.pickerDelegate pickerWillCancelPicking:controller];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if ([controller.pickerDelegate respondsToSelector:@selector(pickerDidCancelPicking:)]) {
            [controller.pickerDelegate pickerDidCancelPicking:controller];
        }
    }];
}

- (void)previewAction {
    XYPhotoPreviewController *vc = [[XYPhotoPreviewController alloc] init];
    vc.selectedAssets = _selectedAssets;
    vc.selectedAssetIdentifiers = _selectedAssetIdentifiers;
    vc.configuration = _configuration;
    vc.allAssets = _selectedAssets.copy;
    vc.didUpdateBlock = ^(NSInteger index, NSString *identifier) {
        // cell
        XYAsset *asset = [self obtainAssetWithIdentifier:identifier];
        if (!asset) return;
        NSInteger assetIndex = [self.allAssets indexOfObject:asset];
        asset.choosed = [self.selectedAssetIdentifiers containsObject:asset.identifier]; // 检查asset是否被选中
        [self.listView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:assetIndex inSection:0]]];
        // toolbar
        [self.toolBar updateViewWhenChoosingAsset:self.selectedAssets.count];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendAction {
    XYPhotoPickerController *controller = (XYPhotoPickerController *)self.navigationController;
    if ([controller.pickerDelegate respondsToSelector:@selector(picker:didFinishPicking:)]) {
        [controller.pickerDelegate picker:controller didFinishPicking:_selectedAssets];
    }
}

#pragma mark # Method

// 根据identifier获取asset
- (XYAsset *)obtainAssetWithIdentifier:(NSString *)identifier {
    for (XYAsset *asset in _allAssets) {
        if (![asset.identifier isEqualToString:identifier]) continue;
        return asset;
    }
    return nil;
}

#pragma mark ## Asset Caching

/**
 @see https://developer.apple.com/library/archive/samplecode/UsingPhotosFramework/Introduction/Intro.html#//apple_ref/doc/uid/TP40014575
 
 |——————————————————————————————————————————
 |               Stop caching
 |——————————————————————————————————————————
 |
 |          Visible Range (visibleRect)          <-------------     UICollectionView
 |
 |——————————————————————————————————————————
 |         Start caching (preheatRect)
 |——————————————————————————————————————————
 */

- (void)resetCachedAssets {
    [[XYAssetManager defaultManager].phCachingImageManager stopCachingImagesForAllAssets];
    _previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    // Update only if the view is visible
    if (!self.isViewLoaded || self.view.window == nil) return;
    
    // The preheat window is twice the height of the visible rect.
    CGRect visibleRect = CGRectMake(0, _listView.contentOffset.y, _listView.bounds.size.width, _listView.bounds.size.height);
    CGRect preheatRect = CGRectInset(visibleRect, 0, -0.5 * visibleRect.size.height);
    
    // Update only if the visible area is significantly different from the last preheated area.
    CGFloat delta = fabs(CGRectGetMidY(preheatRect) - CGRectGetMidY(_previousPreheatRect));
    if (delta <= _listView.bounds.size.height / 3.0) return;
        
    // Compute the assets to start caching and to stop caching.
    [self differencesBetweenRect:_previousPreheatRect andRect:preheatRect handler:^(CGRect addedRect, CGRect removedRect) {
        [self stopCachingImagesWithRect:removedRect];
        [self startCachingImagesWithRect:addedRect];
    }];
    
    // Store the preheat rect to compare against in the future.
    _previousPreheatRect = preheatRect;
}

- (void)differencesBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect handler:(void (^)(CGRect addedRect, CGRect removedRect))hander {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        CGRect rectToAdd = CGRectZero; // Add new preheat rect
        CGRect rectToRemove = CGRectZero; // Remove old preheat rect
        
        // Scroll to bottom
        if (newMaxY > oldMaxY) rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
        if (oldMinY < newMinY) rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
        
        // scroll to top
        if (oldMinY > newMinY) rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
        if (newMaxY < oldMaxY) rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
        
        hander(rectToAdd, rectToRemove);
    } else {
        hander(newRect, oldRect);
    }
}

- (void)startCachingImagesWithRect:(CGRect)rect {
    NSMutableArray<PHAsset *> *addedAssets = [self indexPathsForElementsWithRect:rect];
    PHCachingImageManager *manager = [XYAssetManager defaultManager].phCachingImageManager;
    [manager startCachingImagesForAssets:addedAssets targetSize:_thumbSize contentMode:PHImageContentModeAspectFill options: nil];
}

- (void)stopCachingImagesWithRect:(CGRect)rect {
    NSMutableArray<PHAsset *> *removedAssets = [self indexPathsForElementsWithRect:rect];
    PHCachingImageManager *manager = [XYAssetManager defaultManager].phCachingImageManager;
    [manager stopCachingImagesForAssets:removedAssets targetSize:_thumbSize contentMode:PHImageContentModeAspectFill options:nil];
}

- (NSMutableArray<PHAsset *> *)indexPathsForElementsWithRect:(CGRect)rect {
    UICollectionViewLayout *layout = _listView.collectionViewLayout;
    NSArray<UICollectionViewLayoutAttributes *> *layoutAttributes = [layout layoutAttributesForElementsInRect:rect];
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *layoutAttr in layoutAttributes) {
        NSIndexPath *indexPath = layoutAttr.indexPath;
        XYAsset *asset = [_allAssets objectAtIndex:indexPath.item];
        [assets addObject:asset.phAsset];
    }
    return assets;
}

#pragma mark ## Asset Refreshing

// 进入页面是否需要滚动到顶部或者底部
- (void)scrollToOriginalPositionIfNeeded {
    if (!_loadAssetsCompleted) return;
    if (_listView.bounds.size.height == 0) return;
    
    UIEdgeInsets contentInset = _listView.adjustedContentInset;
    CGPoint contentOffset = _listView.contentOffset;
    CGSize contentSize = _listView.contentSize;
    
    BOOL canVerticalScroll = contentSize.height + contentInset.top + contentInset.bottom > CGRectGetHeight(_listView.bounds);
    if (!canVerticalScroll) return;
    
    if (_configuration.sortType == XYAlbumSortTypeReverse) { // 滚动到顶部
        [_listView setContentOffset:CGPointMake(-contentInset.left, -contentInset.top)];
    } else { // 滚动到底部
        [_listView setContentOffset:CGPointMake(contentOffset.x, contentSize.height + contentInset.bottom - CGRectGetHeight(_listView.bounds))];
    }
}

- (void)refreshWithAssetGroup:(XYAssetGroup *)assetGroup {
    _assetGroup = assetGroup;
    self.title = assetGroup.name;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __weak typeof(self) weakObj = self;
        [assetGroup enumerateAllAssetsWithOptions:self.configuration.sortType usingBlock:^(XYAsset *asset) {
            __strong typeof(weakObj) self = weakObj;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (asset) {
                    [self.allAssets addObject:asset];
                } else {
                    self.loadAssetsCompleted = YES;
                    [self.listView reloadData];
                    [self.listView performBatchUpdates:^{
                    } completion:^(BOOL finished) {
                        [self scrollToOriginalPositionIfNeeded];
                    }];
                }
            });
        }];
    });
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [XYPhotoPickerAppearance appearance].pickerStyle == XYPhotoPickerStyleBlack ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

@end

#pragma clang diagnostic pop
