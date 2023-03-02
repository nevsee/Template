//
//  YYFakeProgressView.m
//  Template
//
//  Created by nevsee on 2021/12/6.
//

#import "YYFakeProgressView.h"
#import "XYWeakProxy.h"

@interface YYFakeProgressView ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger fakeValue;
@end

@implementation YYFakeProgressView

- (void)dealloc {
    [self cancelTimer];
}

// Action

- (void)updateFakeValueAction {
    if (_fakeValue >= 0 && _fakeValue < 500) {
        _fakeValue += 50;
    } else if (_fakeValue >= 500 && _fakeValue < 700) {
        _fakeValue += 20;
    } else if (_fakeValue >= 700 && _fakeValue < 850) {
        _fakeValue += 15;
    } else if (_fakeValue >= 850 && _fakeValue < 900) {
        _fakeValue += 1;
    } else {
        [self cancelTimer];
    }
    [self updateProgress:_fakeValue / 1000.0];
}

// Method

// 更新进度值
- (void)updateProgress:(float)progress {
    self.progress = progress;
    [UIView animateWithDuration:0.35 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (!self.hidesWhenCommitted) return;
        if (progress < 1) return;
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        }];
    }];
}

// 取消动画
- (void)invalidateProgressAnimation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateProgress:) object:nil];
}

// 开启计时器
- (void)startTimer {
    if (_timer) [self cancelTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:[XYWeakProxy proxyWithTarget:self]
                                            selector:@selector(updateFakeValueAction)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

// 取消计时器
- (void)cancelTimer {
    if (!_timer) return;
    [_timer invalidate];
    _timer = nil;
    _fakeValue = 0;
}

- (void)begin {
    self.progress = 0;
    self.alpha = 1;
    [self invalidateProgressAnimation];
    [self startTimer];
}

- (void)end {
    [self cancelTimer];
    [self invalidateProgressAnimation];
    self.progress = 0;
    self.alpha = !_hidesWhenCommitted;
}

- (void)commit {
    [self cancelTimer];
    [self updateProgress:1];
}

@end
