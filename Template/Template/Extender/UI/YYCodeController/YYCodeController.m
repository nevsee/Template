//
//  YYCodeController.m
//  Template
//
//  Created by nevsee on 2021/12/27.
//

#import "YYCodeController.h"
#import "YYCodeResultHandler.h"
#import "XYPhotoPickerController.h"

typedef NS_ENUM(NSUInteger, YYCodeBackType) {
    YYCodeBackTypeBack, // 返回
    YYCodeBackTypeSingleCode, // 单个code
    YYCodeBackTypeScanMutipleCodes, // 扫描出多个code
    YYCodeBackTypeImageMutipleCodes, // 图片检测出多个code
    YYCodeBackTypeImageNonCode, // 图片检测出无code
};

@interface YYCodeController () <XYPhotoPickerControllerDelegate>
@property (nonatomic, strong, readwrite) XYCodeScanView *scanView;
@property (nonatomic, strong, readwrite) XYCodeScanImagePreview *imagePreview;
@property (nonatomic, strong) XYButton *lightButton;
@property (nonatomic, strong) XYButton *backButton;
@property (nonatomic, strong) XYButton *photoButton;
@property (nonatomic, assign) BOOL didOpenLight; // 是否开启手电筒
@property (nonatomic, assign) BOOL didShowLight; // 是否显示手电筒
@end

@implementation YYCodeController

- (void)dealloc {
    [self.scanView stopRunning];
}

- (void)didInitialize {
    [super didInitialize];
    self.xy_prefersNavigationBarHidden = YES;
    self.xy_workflow = @"code.scan";
    self.resultHandler = [[YYCodeResultHandler alloc] init];
    self.checkAllCodesInScreen = YES;
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    self.view.backgroundColor = UIColor.blackColor;
    
    @weakify(self)
    self.scanView.didInitBlock = ^(XYCodeScanView *scanView, BOOL succeed, BOOL determined) {
        @strongify(self)
        if (determined) return;
        NSString *titile = @"相机权限未开启";
        NSString *message = [NSString stringWithFormat:@"请在“设置 > %@”选项中，允许%@访问你的摄像头", UIApplication.xy_appDisplayName, UIApplication.xy_appDisplayName];
        XYAlertController *vc = [XYAlertController alertWithTitle:titile
                                                          message:message
                                                           cancel:@"我知道了"
                                                          actions:nil
                                                   preferredStyle:XYAlertControllerStyleAlert];
        XYAlertSketchAction *action = [[XYAlertSketchAction alloc] initWithTitle:@"前往设置" style:XYAlertActionStyleDefault alerter:vc];
        action.titleAttributes = @{NSFontAttributeName: XYFontWeightMake(17, UIFontWeightMedium), NSForegroundColorAttributeName: YYTheme3Color};
        action.dismissEnabled = NO;
        action.afterHandler = ^(__kindof XYAlertAction * _Nonnull action) {
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        };
        [vc addActions:@[action]];
        [vc presentInController:self];
    };
    self.scanView.indicator.jumpBlock = ^(XYCodeScanIndicator *indicator, NSString *message) {
        // 扫描结果处理
        @strongify(self)
        if ([self.resultHandler respondsToSelector:@selector(codeController:didHandleMessage:)]) {
            [self.resultHandler codeController:self didHandleMessage:message];
        }
    };
    self.scanView.brightnessBlock = ^(XYCodeScanView *scanView, CGFloat brightness) {
        // 闪光灯处理
        @strongify(self)
        [self showFlashlightIfNeeded:brightness];
    };
    self.scanView.resultBlock = ^(XYCodeScanView *scanView, NSArray<XYCodeScanResult *> *results) {
        // 扫描结果页面UI处理
        @strongify(self)
        YYCodeBackType type = YYCodeBackTypeBack;
        if (results.count <= 1) {
            type = YYCodeBackTypeSingleCode;
        } else {
            type = YYCodeBackTypeScanMutipleCodes;
        }
        [self changeButtonsStateForType:type];
    };
    
    // 图片检测
    self.imagePreview.indicator.jumpBlock = ^(XYCodeScanIndicator *indicator, NSString *message) {
        // 图片检测结果处理
        @strongify(self)
        if ([self.resultHandler respondsToSelector:@selector(codeController:didHandleMessage:)]) {
            [self.resultHandler codeController:self didHandleMessage:message];
        }
    };
    self.imagePreview.indicator.closeBlock = ^(XYCodeScanIndicator *indicator) {
        // 图片检测无结果处理
        @strongify(self)
        [indicator removeFromSuperview];
        [self.imagePreview removeFromSuperview];
        [self.imagePreview clean];
        [self changeButtonsStateForType:YYCodeBackTypeBack];
        [self.scanView startRunning];
    };

    [self.view addSubview:self.scanView];
    [self.view addSubview:self.lightButton];
    [self.view addSubview:self.photoButton];
    [self.view addSubview:self.backButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.xy_triggerOnceValue || _backButton.tag != YYCodeBackTypeBack) return;
    [_scanView startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_backButton.tag != YYCodeBackTypeBack) return;
    [_scanView stopRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (!_cleanWorkflow) return;
    [self xy_cleanWorkflowAnimated:NO];
}

#pragma mark # Delegate

- (void)picker:(XYPhotoPickerController *)picker didFinishPicking:(NSArray<XYAsset *> *)results {
    if (results.count == 0) {
        [self.view showErrorWithText:@"获取相册图片失败"];
        [_scanView startRunning];
    } else {
        [self changeButtonsStateForType:YYCodeBackTypeSingleCode];
        [self.view insertSubview:_imagePreview belowSubview:_backButton];

        // 获取相册图片
        XYAsset *asset = results[0];
        [asset requestPreviewImageWithProgress:nil completion:^(UIImage *result, NSDictionary *info) {
            self.imagePreview.originImage = result;
            BOOL isDegraded = [info[PHImageResultIsDegradedKey] boolValue];
            BOOL hasError = info[PHImageErrorKey] != nil;
            if (isDegraded) return; // 低清图
            
            if (!hasError) {
                // 是否检测多个二维码
                if (self.checkAllCodesInScreen) {
                    self.imagePreview.screenImage = [self.imagePreview xy_snapshotImage];
                }
                
                @weakify(self)
                [self.imagePreview detectImageCodeFeaturesWithResultBlock:^(NSArray<XYCodeScanResult *> *results) {
                    @strongify(self)
                    YYCodeBackType type = YYCodeBackTypeBack;
                    if (results.count == 0) {
                        type = YYCodeBackTypeImageNonCode;
                    } else if (results.count == 1) {
                        type = YYCodeBackTypeSingleCode;
                    } else {
                        type = YYCodeBackTypeImageMutipleCodes;
                    }
                    [self changeButtonsStateForType:type];
                }];
            } else {
                [self.view showErrorWithText:@"获取相册图片失败"];
                [self.scanView startRunning];
                [self.imagePreview removeFromSuperview];
                [self changeButtonsStateForType:YYCodeBackTypeBack];
            }
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark # Action

- (void)backAction:(XYButton *)sender {
    YYCodeBackType type = sender.tag;
    if (type == YYCodeBackTypeBack || type == YYCodeBackTypeImageNonCode) {
        if (self.navigationController.viewControllers.count > 1) {
            [self xy_popViewController];
        } else {
            [self xy_dismissViewController];
        }
    }
    else if (type == YYCodeBackTypeScanMutipleCodes) {
        [self changeButtonsStateForType:YYCodeBackTypeBack];
        [_scanView.indicator removeFromSuperview];
        [_scanView startRunning];
    }
    else if (type == YYCodeBackTypeImageMutipleCodes) {
        [self changeButtonsStateForType:YYCodeBackTypeBack];
        [_imagePreview.indicator removeFromSuperview];
        [_imagePreview removeFromSuperview];
        [_imagePreview clean];
        [_scanView startRunning];
    }
}

- (void)openAlbumAction {
    XYPhotoPickerConfiguration *config = [[XYPhotoPickerConfiguration alloc] init];
    config.allowMultipleSelection = NO;
    config.allowPickingGif = NO;
    XYPhotoPickerController *vc = [[XYPhotoPickerController alloc] initWithConfiguration:config];
    vc.pickerDelegate = self;
    [self xy_presentViewController:vc];
}

- (void)openLightAction:(UIButton *)sender {
    _didOpenLight = !_didOpenLight;
    if (_didOpenLight) {
        [_lightButton setImage:XYImageMake(@"code_flashlight_open") forState:UIControlStateNormal];
        [_lightButton setTitle:@"轻触关闭" forState:UIControlStateNormal];
    } else {
        [_lightButton setImage:XYImageMake(@"code_flashlight_close") forState:UIControlStateNormal];
        [_lightButton setTitle:@"轻触点亮" forState:UIControlStateNormal];
    }
    [_lightButton xy_layoutForImagePosition:XYButtonImagePositionTop space:15];
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([captureDevice hasTorch]) {
        [captureDevice lockForConfiguration:nil];
        [captureDevice setTorchMode:_didOpenLight ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
        [captureDevice unlockForConfiguration];
    }
}

#pragma mark # Method

// 设备是否支持手电筒
- (BOOL)hasTorch {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return [captureDevice hasTorch];
}

// 显示手电筒按钮
- (void)showFlashlightIfNeeded:(CGFloat)brightness {
    if (_didOpenLight) return;
    BOOL shouldShow = (brightness <= -2.0);
    if (shouldShow == _didShowLight) return;
    _didShowLight = shouldShow;
    
    if (shouldShow) { // 开启手电筒
        [UIView animateWithDuration:0.5 animations:^{
            self.lightButton.alpha = 1;
        }];
    } else { // 关闭手电筒
        [UIView animateWithDuration:0.5 animations:^{
            self.lightButton.alpha = 0;
        }];
    }
}

// 改变返回按钮和相册按钮状态
- (void)changeButtonsStateForType:(YYCodeBackType)type {
    if (type == YYCodeBackTypeBack) {
        [_backButton setImage:XYImageMake(@"back_2") forState:UIControlStateNormal];
        [_backButton setTitle:nil forState:UIControlStateNormal];
        _backButton.hidden = NO;
        _photoButton.hidden = NO;
    }
    else if (type == YYCodeBackTypeSingleCode) {
        _backButton.hidden = YES;
        _photoButton.hidden = YES;
    }
    else if (type == YYCodeBackTypeScanMutipleCodes || type == YYCodeBackTypeImageMutipleCodes) {
        [_backButton setImage:nil forState:UIControlStateNormal];
        [_backButton setTitle:@"取消" forState:UIControlStateNormal];
        _backButton.hidden = NO;
        _photoButton.hidden = YES;
    }
    else {
        [_backButton setImage:XYImageMake(@"back_2") forState:UIControlStateNormal];
        [_backButton setTitle:nil forState:UIControlStateNormal];
        _backButton.hidden = NO;
        _photoButton.hidden = YES;
    }
    _backButton.tag = type;
}

- (void)restart {
    [self changeButtonsStateForType:YYCodeBackTypeBack];
    [_imagePreview removeFromSuperview];
    [_imagePreview.indicator removeFromSuperview];
    [_imagePreview clean];
    [_scanView.indicator removeFromSuperview];
    [_scanView startRunning];
}

- (void)restartIfNeeded {
    if (_backButton.tag == YYCodeBackTypeScanMutipleCodes || _backButton.tag == YYCodeBackTypeImageMutipleCodes) return;
    [self restart];
}

#pragma mark # Access

- (XYCodeScanView *)scanView {
    if (!_scanView) {
        XYCodeScanView *view = [[XYCodeScanView alloc] initWithFrame:self.view.bounds];
        view.animator = [XYCodeScanDefaultAnimator layer];
        view.indicator = [[XYCodeScanDefaultIndicator alloc] init];
        _scanView = view;
    }
    return _scanView;
}

- (XYCodeScanImagePreview *)imagePreview {
    if (!_imagePreview) {
        XYCodeScanImagePreview *view = [[XYCodeScanImagePreview alloc] initWithFrame:self.view.bounds];
        view.indicator = [[XYCodeScanDefaultIndicator alloc] init];
        _imagePreview = view;
    }
    return _imagePreview;
}

- (XYButton *)backButton {
    if (!_backButton) {
        XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20, YYSafeArea.top, 50, 44);
        button.titleLabel.font = XYFontMake(16);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImage:XYImageMake(@"back_2") forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        _backButton = button;
    }
    return _backButton;
}

- (XYButton *)photoButton {
    if (!_photoButton) {
        XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.view.xy_width - 70, YYSafeArea.top, 50, 44);
        button.titleLabel.font = XYFontMake(16);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button setTitle:@"相册" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(openAlbumAction) forControlEvents:UIControlEventTouchUpInside];
        _photoButton = button;
    }
    return _photoButton;
}

- (XYButton *)lightButton {
    if (![self hasTorch]) return nil;
    if (!_lightButton) {
        XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
        button.center = CGPointMake(self.view.center.x, self.view.xy_height * 0.7 + 40);
        button.bounds = CGRectMake(0, 0, 120, 65);
        button.titleLabel.font = XYFontMake(14);
        button.dimsButtonWhenHighlighted = NO;
        button.alpha = 0;
        [button setImage:XYImageMake(@"code_flashlight_close") forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [button setTitle:@"轻触点亮" forState:UIControlStateNormal];
        [button xy_layoutForImagePosition:XYButtonImagePositionTop space:15];
        [button addTarget:self action:@selector(openLightAction:) forControlEvents:UIControlEventTouchUpInside];
        _lightButton = button;
    }
    return _lightButton;
}

@end
