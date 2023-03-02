//
//  XYAlbumViewController.m
//  XYPhotoPicker
//
//  Created by nevsee on 2017/6/10.
//

#import "XYPhotoAlbumController.h"
#import "XYPhotoAssetController.h"
#import "XYPhotoPickerController.h"
#import "XYPhotoPickerAppearance.h"
#import "XYPhotoPickerHelper.h"
#import "XYPhoto.h"
#import <Photos/PHPhotoLibrary.h>
#import <PhotosUI/PHPhotoLibrary+PhotosUISupport.h>

static CGFloat const kXYLimitedViewHeight = 130;
static CGFloat const kXYLimitedHPadding = 30;
static CGFloat const kXYLimitedNoteHeight = 50;
static CGFloat const kXYLimitedButtonHeight = 30;

@interface XYPhotoLimitedView : UIView
@property (nonatomic, weak) UIViewController *parent;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UIButton *jumpButton;
@property (nonatomic, strong) UIButton *addButton;
@end

@implementation XYPhotoLimitedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        XYPhotoPickerAppearance *appearance = [XYPhotoPickerAppearance appearance];
        
        self.backgroundColor = appearance.pickerBackgroundColor;
        
        NSString *noteFormat = [XYPhotoPickerHelper localizedStringForKey:appearance.authorizedLimitedNoteName] ?: @"";
        NSString *noteName = [NSString stringWithFormat:noteFormat, [XYPhotoPickerHelper obtainAppDisplayName]];
        NSAttributedString *noteAttr = [[NSAttributedString alloc] initWithString:noteName attributes:appearance.authorizedLimitedNoteAttributes];
        UILabel *noteLabel = [[UILabel alloc] init];
        noteLabel.numberOfLines = 2;
        noteLabel.textAlignment = NSTextAlignmentCenter;
        noteLabel.attributedText = noteAttr;
        [self addSubview:noteLabel];
        _noteLabel = noteLabel;

        NSString *jumpName = [XYPhotoPickerHelper localizedStringForKey:appearance.authorizedLimitedJumpTitleName] ?: @"";
        NSAttributedString *jumpAttr = [[NSAttributedString alloc] initWithString:jumpName attributes:appearance.authorizedLimitedJumpTitleAttributes];
        UIButton *jumpButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [jumpButton setAttributedTitle:jumpAttr forState:UIControlStateNormal];
        [jumpButton addTarget:self action:@selector(jumpAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:jumpButton];
        _jumpButton = jumpButton;
        
        NSString *addName = [XYPhotoPickerHelper localizedStringForKey:appearance.authorizedLimitedAddTitleName] ?: @"";
        NSAttributedString *addAttr = [[NSAttributedString alloc] initWithString:addName attributes:appearance.authorizedLimitedAddTitleAttributes];
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [addButton setAttributedTitle:addAttr forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addButton];
        _addButton = addButton;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _noteLabel.frame = CGRectMake(kXYLimitedHPadding, 0, self.bounds.size.width - kXYLimitedHPadding * 2, kXYLimitedNoteHeight);
    _jumpButton.frame = CGRectMake(kXYLimitedHPadding, kXYLimitedNoteHeight, self.bounds.size.width - kXYLimitedHPadding * 2, kXYLimitedButtonHeight);
    _addButton.frame = CGRectMake(kXYLimitedHPadding, kXYLimitedNoteHeight + kXYLimitedButtonHeight, self.bounds.size.width - kXYLimitedHPadding * 2, kXYLimitedButtonHeight);
}

- (void)jumpAction {
    [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}

- (void)addAction {
    if (!_parent) return;
    if (@available(iOS 14, *)) {
        if ([PHPhotoLibrary.sharedPhotoLibrary respondsToSelector:@selector(presentLimitedLibraryPickerFromViewController:)]) {
            [PHPhotoLibrary.sharedPhotoLibrary presentLimitedLibraryPickerFromViewController:_parent];
        } else {
            NSLog(@"please link <PhotosUI> library in your project");
        }
    }
}

@end

#pragma mark -

static CGFloat const kXYAuthVPadding = 100;
static CGFloat const kXYAuthHPadding = 30;
static CGFloat const kXYAuthButtonHeight = 50;

@interface XYPhotoAuthorizationView : UIView
@property (nonatomic, weak) UIViewController *parent;
@property (nonatomic, strong) UILabel *titleLabel; // 权限提示标题
@property (nonatomic, strong) UILabel *detailLabel; // 权限提示详情
@property (nonatomic, strong) UIButton *jumpButton; // 权限认证跳转按钮
@end

@implementation XYPhotoAuthorizationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        XYPhotoPickerAppearance *appearance = [XYPhotoPickerAppearance appearance];
        
        NSString *titleName = [XYPhotoPickerHelper localizedStringForKey:appearance.authorizedNoteTitleName] ?: @"";
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.attributedText = [[NSAttributedString alloc] initWithString:titleName attributes:appearance.authorizedNoteTitleAttributes];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        NSString *detailFormat = [XYPhotoPickerHelper localizedStringForKey:appearance.authorizedNoteDetailName] ?: @"";
        NSString *detailName = [NSString stringWithFormat:detailFormat, [XYPhotoPickerHelper obtainAppDisplayName]];
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.numberOfLines = 0;
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.attributedText = [[NSAttributedString alloc] initWithString:detailName attributes:appearance.authorizedNoteDetailAttributes];
        [detailLabel sizeToFit];
        [self addSubview:detailLabel];
        _detailLabel = detailLabel;
        
        NSString *jumpName = [XYPhotoPickerHelper localizedStringForKey:appearance.authorizedJumpTitleName] ?: @"";
        NSAttributedString *jumpAttr = [[NSAttributedString alloc] initWithString:jumpName attributes:appearance.authorizedJumpTitleAttributes];
        UIButton *jumpButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [jumpButton setAttributedTitle:jumpAttr forState:UIControlStateNormal];
        [jumpButton addTarget:self action:@selector(jumpAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:jumpButton];
        _jumpButton = jumpButton;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize maxSize = CGSizeMake(self.bounds.size.width - kXYAuthHPadding * 2, HUGE);
    CGSize titleSize = [_titleLabel sizeThatFits:maxSize];
    CGSize detailSize = [_detailLabel sizeThatFits:maxSize];
    
    _titleLabel.frame = CGRectMake(kXYAuthHPadding, kXYAuthVPadding, maxSize.width, titleSize.height);
    _detailLabel.frame = CGRectMake(kXYAuthHPadding, CGRectGetMaxY(_titleLabel.frame) + 20, maxSize.width, detailSize.height);
    _jumpButton.frame = CGRectMake(kXYAuthHPadding, CGRectGetMaxY(_detailLabel.frame) + 40, maxSize.width, kXYAuthButtonHeight);
}

- (void)jumpAction {
    [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}

@end

#pragma mark -

@interface XYPhotoAlbumCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong, readonly) XYAssetGroup *assetGroup;
- (void)refreshCellWithGroup:(XYAssetGroup *)assetGroup;
@end

@implementation XYPhotoAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self userInterfaceSetup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    XYPhotoPickerAppearance *appearance = [XYPhotoPickerAppearance appearance];
    CGFloat headerY = (appearance.albumCellHeight - appearance.albumImageSize) / 2;
    CGFloat headerX = appearance.albumImageLeftMargin;
    _headerView.frame = CGRectMake(headerX, headerY, appearance.albumImageSize, appearance.albumImageSize);
    
    CGSize arrowSize = _arrowView.image.size;
    CGFloat arrowX = CGRectGetWidth(self.bounds) - arrowSize.width - appearance.albumArrowRightMargin;
    _arrowView.frame = CGRectMake(arrowX, (CGRectGetHeight(self.bounds) - arrowSize.height) / 2, arrowSize.width, arrowSize.height);
    
    CGFloat nameX = CGRectGetMaxX(_headerView.frame) + appearance.albumNameInsets.left;
    CGFloat nameWidth = CGRectGetMinX(_arrowView.frame) - nameX - appearance.albumNameInsets.right;
    CGFloat nameHeight = [_nameLabel sizeThatFits:CGSizeMake(nameWidth, HUGE)].height;
    _nameLabel.frame = CGRectMake(nameX, CGRectGetMidY(self.bounds) - nameHeight - appearance.albumNameInsets.bottom, nameWidth, nameHeight);
    
    CGFloat numberX = CGRectGetMaxX(_headerView.frame) + appearance.albumNumberInsets.left;
    CGFloat numberWidth = CGRectGetMinX(_arrowView.frame) - numberX - appearance.albumNumberInsets.right;
    CGFloat numberHeight = [_numberLabel sizeThatFits:CGSizeMake(numberWidth, HUGE)].height;
    _numberLabel.frame = CGRectMake(nameX, CGRectGetMidY(self.bounds) + appearance.albumNumberInsets.top, numberWidth, numberHeight);
    
    CGFloat separatorX = appearance.albumSeparatorInsets.left;
    CGFloat separatorY = CGRectGetHeight(self.bounds) - appearance.albumSepratorHeight;
    CGFloat separatorWidth = CGRectGetWidth(self.bounds) - appearance.albumSeparatorInsets.left - appearance.albumSeparatorInsets.right;
    _separatorView.frame = CGRectMake(separatorX, separatorY, separatorWidth, appearance.albumSepratorHeight);
}

- (void)userInterfaceSetup {
    self.backgroundColor = [UIColor clearColor];
    XYPhotoPickerAppearance *appearance = [XYPhotoPickerAppearance appearance];
    
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = appearance.albumSelectedColor;
    self.selectedBackgroundView = selectedView;
    
    UIImageView *headerView = [[UIImageView alloc] init];
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    headerView.layer.masksToBounds = YES;
    headerView.layer.cornerRadius = appearance.albumImageCornerRadius;
    [self.contentView addSubview:headerView];
    _headerView = headerView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    UILabel *numberLabel = [[UILabel alloc] init];
    [self.contentView addSubview:numberLabel];
    _numberLabel = numberLabel;
    
    UIImageView *arrowView = [[UIImageView alloc] init];
    arrowView.image = [XYPhotoPickerHelper imageNamed:appearance.albumArrowImage];
    [self.contentView addSubview:arrowView];
    _arrowView = arrowView;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = appearance.albumSeparatorColor;
    [self.contentView addSubview:separatorView];
    _separatorView = separatorView;
}

- (void)refreshCellWithGroup:(XYAssetGroup *)assetGroup {
    _assetGroup = assetGroup;
    
    XYPhotoPickerAppearance *appearance = [XYPhotoPickerAppearance appearance];
    _headerView.image = [assetGroup posterImageWithSize:CGSizeMake(appearance.albumImageSize, appearance.albumImageSize)];
    _nameLabel.attributedText = [[NSAttributedString alloc] initWithString:assetGroup.name attributes:appearance.albumNameAttributes];
    _numberLabel.attributedText = [[NSAttributedString alloc] initWithString:@(assetGroup.count).stringValue attributes:appearance.albumNumberAttributes];
}

@end


#pragma mark -

@interface XYPhotoAlbumController () <UITableViewDelegate, UITableViewDataSource, PHPhotoLibraryChangeObserver>
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) XYPhotoAuthorizationView *authorizationView; // 无权限提示
@property (nonatomic, strong) XYPhotoLimitedView *limitedView; // 受限制的照片选择提示
@end

@implementation XYPhotoAlbumController

#pragma mark # Life

- (void)viewDidLoad {
    [super viewDidLoad];
    [self parameterSetup];
    [self userInterfaceSetup];
    [self obtainAlbums];
    [self displaySmartAlbumDirectlyIfCan];
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat limitedHeight = kXYLimitedViewHeight + self.view.safeAreaInsets.bottom;
    CGFloat authTopMargin = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    
    _listView.frame = self.view.bounds;
    if (!_limitedView.hidden) _listView.contentInset = UIEdgeInsetsMake(0, 0, limitedHeight, 0);
    _authorizationView.frame = CGRectMake(0, authTopMargin, self.view.bounds.size.width, self.view.bounds.size.height - authTopMargin);
    _limitedView.frame = CGRectMake(0, self.view.bounds.size.height - limitedHeight, self.view.bounds.size.width, limitedHeight);
}

- (void)parameterSetup {
    _allAlbums = [NSMutableArray array];
}

- (void)userInterfaceSetup {
    XYPhotoPickerAppearance *appearance = [XYPhotoPickerAppearance appearance];
    
    self.view.backgroundColor = appearance.pickerBackgroundColor;
    self.title = [XYPhotoPickerHelper localizedStringForKey:appearance.pickerName];
    
    NSString *cancelName = [XYPhotoPickerHelper localizedStringForKey:appearance.cancelName];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:cancelName
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(dismissAction)];
    
    UITableView *listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    listView.backgroundColor = [UIColor clearColor];
    listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listView.delegate = self;
    listView.dataSource = self;
    [listView registerClass:[XYPhotoAlbumCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:listView];
    _listView = listView;
    
    XYPhotoAuthorizationView *authorizationView = [[XYPhotoAuthorizationView alloc] init];
    authorizationView.hidden = YES;
    [self.view addSubview:authorizationView];
    _authorizationView = authorizationView;
    
    XYPhotoLimitedView *limitedView = [[XYPhotoLimitedView alloc] init];
    limitedView.parent = self;
    limitedView.hidden = YES;
    [self.view addSubview:limitedView];
    _limitedView = limitedView;
}

#pragma mark # Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allAlbums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYPhotoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell refreshCellWithGroup:_allAlbums[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XYPhotoPickerAppearance appearance].albumCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushToAssetControllerWithAssetGroup:_allAlbums[indexPath.row] animated:YES];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_async (dispatch_get_main_queue (), ^{
        [self.allAlbums removeAllObjects];
        [self obtainAlbums];
    });
}

#pragma mark # Action
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

#pragma mark # Method

// 跳转相册资源列表
- (void)pushToAssetControllerWithAssetGroup:(XYAssetGroup *)assetGroup animated:(BOOL)animated {
    XYPhotoAssetController *vc = [[XYPhotoAssetController alloc] init];
    vc.selectedAssets = _selectedAssets;
    vc.selectedAssetIdentifiers = _selectedAssetIdentifiers;
    vc.configuration = _configuration;
    [vc refreshWithAssetGroup:assetGroup];
    [self.navigationController pushViewController:vc animated:animated];
}

// 直接显示最近项目
- (void)displaySmartAlbumDirectlyIfCan {
    if ([XYAssetManager authorizationStatus] == XYAuthorizationStatusNotDetermined) return;
    if ([XYAssetManager authorizationStatus] == XYAuthorizationStatusNotAuthorized) return;
    
    XYAssetGroup *group = [[XYAssetManager defaultManager] userLibrarySmartAlbumWithAlbumContentType:_configuration.contentType showEmptyAlbum:NO];
    if (!group) return;
    [self pushToAssetControllerWithAssetGroup:group animated:NO];
}

// 获取相册列表
- (void)obtainAlbums {
    [XYAssetManager requestAuthorization:^(XYAuthorizationStatus status) {
        // 未授权提示
        if (status == XYAuthorizationStatusNotAuthorized) {
            self.authorizationView.hidden = NO;
            return;
        }
        
        // 访问受限提示
        if (@available(iOS 14, *)) {
            if (status == XYAuthorizationStatusLimited && self.configuration.needsLimitedNote) {
                self.limitedView.hidden = NO;
                self.listView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.limitedView.bounds), 0);
            }
        }
        
        // 注册相册资源改变通知
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        
        // 获取相册资源
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[XYAssetManager defaultManager] enumerateAllAlbumsWithAlbumContentType:self.configuration.contentType usingBlock:^(XYAssetGroup *group) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (group) {
                        if (group.phAssetCollection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumAllHidden) { // 隐藏相册不显示
                            [self.allAlbums addObject:group];
                        }
                    } else {
                        [self.listView reloadData];
                    }
                });
            }];
        });
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [XYPhotoPickerAppearance appearance].pickerStyle == XYPhotoPickerStyleBlack ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

@end
