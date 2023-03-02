//
//  YYTestBrowserController.m
//  Template
//
//  Created by nevsee on 2022/11/16.
//

#import "YYTestBrowserController.h"
#import "XYBrowser.h"
#import "YYBrowserView.h"

@interface YYTestBrowserController () <XYBrowserViewDataSource>
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSArray *views;
@end

@implementation YYTestBrowserController

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"XYBrowser";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"image1" ofType:@"jpeg"];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"image2" ofType:@"jpeg"];
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"image3" ofType:@"jpeg"]; // gif封面
    NSString *path4 = [[NSBundle mainBundle] pathForResource:@"image4" ofType:@"jpeg"];
    NSString *path5 = [[NSBundle mainBundle] pathForResource:@"image5" ofType:@"png"]; // 视频封面
    NSString *gif1 = [[NSBundle mainBundle] pathForResource:@"gif1" ofType:@"gif"];
    NSString *link3 = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01584659ccc891a801218e18e4097e.gif&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1670065140&t=f18ae12050d7aa81f2ef6e732ea5a5ff";
    NSString *link5 = @"https://vd3.bdstatic.com/mda-nkf2q4uv8e5y3ist/sc/cae_h264/1668564532762210021/mda-nkf2q4uv8e5y3ist.mp4?v_from_s=hkapp-haokan-hnb&auth_key=1668680416-0-0-5fa1c20874b74053111a4a8bd76e48e4&bcevod_channel=searchbox_feed&cd=0&pd=1&pt=3&logid=3016193450&vid=1068654984604312407&abtest=104960_2-104959_1&klogid=3016193450";
    
    NSArray *paths = @[path1, path2, path3, path4, path5, gif1];
    NSMutableArray *assets = [NSMutableArray array];
    NSMutableArray *views = [NSMutableArray array];
    for (NSInteger i = 0; i < paths.count; i++) {
        NSString *path = paths[i];
        XYBrowserAsset *asset = [[XYBrowserAsset alloc] init];
        if (i == 2) {
            asset.thumbImage = [UIImage imageWithContentsOfFile:path];
            asset.originURL = [NSURL URLWithString:link3];
        } else if (i == 4) {
            asset.thumbImage = [UIImage imageWithContentsOfFile:path];
            asset.originURL = [NSURL URLWithString:link5];
            asset.mediaType = XYBrowserViewMediaTypeVideo;
        } else {
            asset.originURL = [NSURL fileURLWithPath:path];
        }
        [assets addObject:asset];
        
        CGFloat size = (self.view.bounds.size.width - 25) / 4;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + (i % 4) * (size + 5), 120 + (i / 4) * (size + 5) , size, size)];
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageWithContentsOfFile:path];
        [self.view addSubview:imageView];
        [views addObject:imageView];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:ges];
    }
    _datas = assets;
    _views = views;
}

- (NSUInteger)numberOfAssetsInBrowserView:(XYBrowserView *)browserView {
    return _datas.count;
}

- (XYBrowserAsset *)browserView:(XYBrowserView *)browserView assetAtIndex:(NSUInteger)index {
    return _datas[index];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    YYBrowserView *v = [[YYBrowserView alloc] init];
    XYBrowserController *vc = [[XYBrowserController alloc] initWithBrowserView:v];
    vc.browserView.dataSource = self;
    vc.browserView.currentIndex = sender.view.tag;
    vc.sourceView = ^UIView *(NSInteger currentIndex) {
        return self.views[currentIndex];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

@end
