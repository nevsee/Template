//
//  XYPhotoPickerController.m
//  XYPhotoPicker
//
//  Created by nevsee on 2017/6/10.
//

#import "XYPhotoPickerController.h"
#import "XYPhotoAlbumController.h"
#import "XYPhotoAssetController.h"
#import "XYPhotoPickerAppearance.h"

@implementation XYPhotoPickerConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _contentType = XYAlbumContentTypeAll;
        _sortType = XYAlbumSortTypePositive;
        _maximumSelectionLimit = INT_MAX;
        _allowMultipleSelection = YES;
        _allowPickingGif = YES;
        _needsOriginPhoto = NO;
        _needsLimitedNote = YES;
    }
    return self;
}

@end

@interface XYPhotoPickerController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray<XYAsset *> *selectedAssets; // 选中资源
@property (nonatomic, strong) NSMutableSet<NSString *> *selectedAssetIdentifiers; // 选中资源唯一标识
@end

@implementation XYPhotoPickerController

- (instancetype)init {
    XYPhotoPickerConfiguration *configuration = [[XYPhotoPickerConfiguration alloc] init];
    return [self initWithConfiguration:configuration];
}

- (instancetype)initWithConfiguration:(XYPhotoPickerConfiguration *)configuration {
    XYPhotoAlbumController *vc = [[XYPhotoAlbumController alloc] init];
    self = [super initWithRootViewController:vc];
    if (self) {
        _configuration = configuration;
        _selectedAssets = [NSMutableArray array];
        _selectedAssetIdentifiers = [NSMutableSet set];
        vc.configuration = _configuration;
        vc.selectedAssets = _selectedAssets;
        vc.selectedAssetIdentifiers = _selectedAssetIdentifiers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self parameterSetup];
    [self userInterfaceSetup];
}

- (void)parameterSetup {
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)userInterfaceSetup {
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    // Appearance
    XYPhotoPickerAppearance *appearance = [XYPhotoPickerAppearance appearance];
    
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[XYPhotoPickerController.class]];
    navigationBar.titleTextAttributes = appearance.pickerNavigationBarTitleAttributes;
    navigationBar.tintColor = [UIColor whiteColor];
    navigationBar.barStyle = appearance.pickerStyle;
    navigationBar.barTintColor = appearance.pickerNavigationBarColor;
    
    UIBarButtonItem *buttomItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[XYPhotoPickerController.class]];
    [buttomItem setTitleTextAttributes:appearance.pickerNavigationBarTextAttributes forState:UIControlStateNormal];
    [buttomItem setTitleTextAttributes:appearance.pickerNavigationBarTextAttributes forState:UIControlStateHighlighted];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) return NO;
    return YES;
}

- (BOOL)shouldAutorotate {
    return [XYPhotoPickerAppearance appearance].shouldAutorotate;
}

@end
