//
//  YYLottieIndicatorView.m
//  Template
//
//  Created by nevsee on 2022/11/30.
//

#import "YYLottieIndicatorView.h"

@interface YYLottieIndicatorView ()
@property (nonatomic, strong) YYLottieAnimationView *animationView;
@end

@implementation YYLottieIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        YYLottieAnimationView *animationView = [[YYLottieAnimationView alloc] initWithFileName:YYLottieAnimationManager.loadingDotName];
        [animationView changeAllElementColorWithColor:UIColor.whiteColor];
        [self addSubview:animationView];
        _animationView = animationView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _animationView.frame = self.bounds;
}

- (void)startAnimation {
    [_animationView play];
}

- (void)stopAnimation:(XYLoadingResultState)state completion:(void (^)(void))completion {
    [_animationView stop];
    if (completion) completion();
}

@end
