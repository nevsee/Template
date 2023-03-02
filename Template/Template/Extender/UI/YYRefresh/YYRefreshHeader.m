//
//  YYRefreshHeader.m
//  Template
//
//  Created by nevsee on 2021/11/19.
//

#import "YYRefreshHeader.h"
#import "Template-Swift.h"

@interface YYRefreshHeader ()
@property (nonatomic, weak) YYLottieAnimationView *animationView;
@property (nonatomic, weak) YYRequest *service;
@end

@implementation YYRefreshHeader

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action bindingService:(YYPageRequest *)service {
    YYRefreshHeader *header = [YYRefreshHeader headerWithRefreshingTarget:target refreshingAction:action];
    header.service = service;
    if (service) {
        [service addObserver:header forKeyPath:@"requestTask.state" options:NSKeyValueObservingOptionNew context:nil];
    }
    return header;
}

- (void)dealloc {
    if (!_service) return;
    [_service removeObserver:self forKeyPath:@"requestTask.state"];
}

- (void)prepare {
    [super prepare];
    
    self.clipsToBounds = YES;
    
    YYLottieAnimationView *animationView = [[YYLottieAnimationView alloc] initWithFileName:YYLottieAnimationManager.loadingDotName];
    animationView.alpha = 0;
    [self addSubview:animationView];
    _animationView = animationView;
}

- (void)placeSubviews {
    [super placeSubviews];
    _animationView.frame = self.bounds;
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStatePulling) {
        [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight] impactOccurred];
    } else if (state == MJRefreshStateRefreshing) {
        [_animationView play];
    } else if (state == MJRefreshStateIdle) {
        [_animationView pause];
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    if (_animationView.currentProgress != 0 && self.scrollView.isDragging) {
        _animationView.currentProgress = 0;
    }
    _animationView.alpha = MIN(pullingPercent, 1);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_main_sync_safely(^{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        if (![keyPath isEqualToString:@"requestTask.state"]) return;
        if (!self.service.isCompleted) return;
        [self endRefreshing];
    });
}

@end
