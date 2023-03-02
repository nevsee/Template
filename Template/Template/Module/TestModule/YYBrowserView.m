//
//  YYBrowserView.m
//  Template
//
//  Created by nevsee on 2022/11/18.
//

#import "YYBrowserView.h"

@implementation YYBrowserView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *countLabel = [[UILabel alloc] init];
        countLabel.font = XYFontWeightMake(16, UIFontWeightMedium);
        countLabel.textColor = UIColor.whiteColor;
        countLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:countLabel];
        _countLabel = countLabel;
        
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreButton setImage:XYImageMake(@"more_2") forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreButton];
        _moreButton = moreButton;
        
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_safeAreaLayoutGuideTop).offset(5);
            make.left.mas_equalTo(self.mas_safeAreaLayoutGuideLeft).offset(25);
        }];
        
        [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(countLabel.mas_centerY);
            make.right.mas_equalTo(self.mas_safeAreaLayoutGuideRight);
            make.size.mas_equalTo(CGSizeMake(60, 40));
        }];
        
        @weakify(self)
        self.willScrollHalfToIndexBlock = ^(NSInteger index) {
            @strongify(self)
            [self updateSubviewValue];
        };
    }
    return self;
}

- (void)moreAction {
    UIView<XYBrowserCarrierDescriber> *carrier = [self currentCarrierView];
    XYAlertController *vc = [XYAlertController alertWithTitle:nil message:nil cancel:@"取消" actions:@[@"缓存地址", @"保存"] preferredStyle:XYAlertControllerStyleSheet];
    vc.afterHandler = ^(__kindof XYAlertAction *action) {
        if (action.tag == 1) {
            if ([self currentAsset].mediaType == XYBrowserViewMediaTypeImage) {
                XYBrowserImagePlayer *player = carrier.playerView;
                [self showInfoWithText:player.cachedImagePath];
            } else {
                XYBrowserVideoPlayer *player = carrier.playerView;
                [self showInfoWithText:player.cachedVideoPath];
            }
        }
    };
    [vc presentInController:self.xy_viewController];
}

- (void)updateSubviewAlphaExceptCarrier:(CGFloat)alpha {
    _countLabel.alpha = alpha;
    _moreButton.alpha = alpha;
}

- (void)updateSubviewValue {
    _countLabel.text = [NSString stringWithFormat:@"%ld / %ld", self.currentIndex + 1, self.totalIndex];
}

@end
