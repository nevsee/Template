//
//  YYTestLoopController.m
//  Template
//
//  Created by nevsee on 2022/1/4.
//

#import "YYTestLoopController.h"
#import "YYTestUtility.h"

@interface YYTestLoopController ()
@property (nonatomic, strong) YYLoopView *loopView;
@end

@implementation YYTestLoopController

- (void)didInitialize {
    [super didInitialize];
    self.xy_supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"YYLoopView";
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];

    YYLoopView *loopView = [[YYLoopView alloc] init];
    loopView.sectionInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    loopView.setContentClassBlock = ^Class<XYCycleDataParser> (YYLoopView * loopView, NSUInteger index) {
        if (index == 1) return YYLoopTextContentView.class;
        else if (index == 4) return YYTestLoopContentView.class;
        return YYLoopImageContentView.class;
    };
    loopView.setContentAttributeBlock = ^(YYLoopView *loopView, __kindof UIView *contentView, NSUInteger index) {
        contentView.layer.cornerRadius = 10;
        if (index == 1) {
            YYLoopTextContentView *view = contentView;
            view.textLabel.textAlignment = NSTextAlignmentCenter;
            view.backgroundColor = YYNeutral2Color;
        }
    };
    loopView.datas = @[
        @"https://t7.baidu.com/it/u=1819248061,230866778&fm=193&f=GIF",
        @"别以为你长得帅我就不打你（YYLoopTextContentView）",
        @"https://t7.baidu.com/it/u=737555197,308540855&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=1297102096,3476971300&fm=193&f=GIF",
        @""
    ];
    [loopView registerCellWithReuseIdentifier:YYTestLoopContentView.reuseIdentifier];
    [self.view addSubview:loopView];
    _loopView = loopView;
    
    XYButton *button = [YYTestUtility buttonWithTitle:@"zoom样式" target:self action:@selector(tapAction:)];
    button.tag = 1;
    [self.view addSubview:button];
    
    XYButton *button2 = [YYTestUtility buttonWithTitle:@"slip样式" target:self action:@selector(tapAction:)];
    button2.tag = 2;
    [self.view addSubview:button2];

    [loopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(150);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loopView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 34));
        make.centerX.mas_equalTo(0);
    }];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 34));
        make.centerX.mas_equalTo(0);
    }];
}

- (void)tapAction:(XYButton *)sender {
    NSInteger tag = sender.tag;
    if (tag == 1) {
        _loopView.scrollStyle = YYLoopViewScrollStyleZoom;
        _loopView.sectionInsets = UIEdgeInsetsMake(0, 30, 0, 30);
    } else {
        _loopView.scrollStyle = YYLoopViewScrollStyleSlide;
        _loopView.sectionInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    }
}

@end

@implementation YYTestLoopContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        if (@available(iOS 13.0, *)) {
            self.layer.cornerCurve = kCACornerCurveContinuous;
        }
        self.backgroundColor = YYNeutral2Color;
        
        UILabel *label = [[UILabel alloc] init];
        label.font = XYFontMake(16);
        label.textColor = YYTheme1Color;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"我一生漂泊，如大海里的一叶孤舟，早已将生死置之度外（自定义）";
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 10)).priorityHigh();
        }];
    }
    return self;
}

- (void)parseData:(id)data userInfo:(id)userInfo {
    
}

+ (NSString *)reuseIdentifier {
    return @"YYTestLoopContentView";
}

@end
