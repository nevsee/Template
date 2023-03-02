//
//  YYRefreshAutoFooter.m
//  Template
//
//  Created by nevsee on 2021/11/19.
//

#import "YYRefreshAutoFooter.h"
#import "XYShimmerView.h"

@interface YYRefreshAutoFooter ()
@property (nonatomic, weak) XYShimmerView *noteView;
@property (nonatomic, weak) UILabel *noteLabel;
@property (nonatomic, weak) YYPageRequest *service;
@end

@implementation YYRefreshAutoFooter

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action bindingService:(YYPageRequest *)service {
    YYRefreshAutoFooter *footer = [super footerWithRefreshingTarget:target refreshingAction:action];
    footer.service = service;
    if (service) {
        [service addObserver:footer forKeyPath:@"pageDataType" options:NSKeyValueObservingOptionNew context:nil];
    }
    return footer;
}

- (void)dealloc {
    if (!_service) return;
    [_service removeObserver:self forKeyPath:@"pageDataType"];
}

- (void)prepare {
    [super prepare];

    self.triggerAutomaticallyRefreshPercent = 0.2;
    self.autoTriggerTimes = -1;
    self.hidden = YES;
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.font = XYFontMake(12);
    noteLabel.textColor = YYNeutral7Color;
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.backgroundColor = UIColor.clearColor;
    _noteLabel = noteLabel;
    
    XYShimmerView *noteView = [[XYShimmerView alloc] init];
    noteView.shimmeringPauseDuration = 0.1;
    noteView.contentView = noteLabel;
    [self addSubview:noteView];
    _noteView = noteView;
}

- (void)placeSubviews {
    [super placeSubviews];
    
    CGRect noteFrame = _noteView.frame;
    noteFrame.origin.x = (self.xy_width - _noteView.xy_width) / 2;
    noteFrame.origin.y = (self.xy_height - _noteView.xy_height) / 2;
    _noteView.frame = noteFrame;
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateRefreshing) {
        _noteView.shimmering = YES;
        _noteLabel.text = @"正在努力加载";
    } else if (state == MJRefreshStateIdle) {
        _noteView.shimmering = NO;
        _noteLabel.text = @"上拉加载更多";
    } else if (state == MJRefreshStateNoMoreData) {
        _noteView.shimmering = NO;
        _noteLabel.text = @"没有更多内容了";
    }
    
    // 更新布局
    [_noteLabel sizeToFit];
    [_noteView setXy_size:_noteLabel.xy_size];
    [_noteView setShimmeringSpeed:_noteLabel.xy_width * 0.8];
    [self placeSubviews];
}

- (void)endRefreshing {
    dispatch_main_sync_safely(^{
        if (!self.isRefreshing) return;
        self.state = MJRefreshStateIdle;
    });
}

- (void)endRefreshingWithCompletionBlock:(void (^)(void))completionBlock {
    dispatch_main_sync_safely(^{
        if (!self.isRefreshing) return;
        self.endRefreshingCompletionBlock = completionBlock;
        self.state = MJRefreshStateIdle;
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_main_sync_safely(^{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        if (![keyPath isEqualToString:@"pageDataType"]) return;
        // 更新刷新状态
        if (self.service.pageDataType == YYRequestPageDataTypeNoMoreData ||
            self.service.pageDataType == YYRequestPageDataTypeCacheData) {
            self.state = MJRefreshStateNoMoreData;
        } else {
            self.state = MJRefreshStateIdle;
        }
        // 验证刷新请求数据数量
        if (self.service.pageMode == YYRequestPageModeRefresh) {
            self.hidden = (self.service.pageDataType == YYRequestPageDataTypeEmptyData || self.service.pageDataType == YYRequestPageDataTypeDefault);
        }
    });
}

@end
