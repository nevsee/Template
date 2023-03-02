//
//  YYTipView.m
//  Template
//
//  Created by nevsee on 2021/12/28.
//

#import "YYTipView.h"
#import "Template-Swift.h"

@implementation YYTipView

+ (void)hideAllTipsInView:(UIView *)view animated:(BOOL)animated {
    NSArray *views = [self allToastInView:view];
    for (YYTipView *view in views) {
        if ([view isKindOfClass:[YYTipView class]]) {
            [view hideAnimated:animated];
        }
    }
}

- (void)showLoading {
    [self showLoadingAnimated:YES];
}

- (void)showLoadingAnimated:(BOOL)animated {
    [self showLoadingWithText:nil animated:animated];
}

- (void)showLoadingWithText:(NSString *)text {
    [self showLoadingWithText:text animated:YES];
}

- (void)showLoadingWithText:(NSString *)text animated:(BOOL)animated {
    CGSize animationSize = YYLottieAnimationManager.loadingRingSize;
    if (text.length == 0) {
        animationSize = CGSizeMake(50, 50);
    }
    YYLottieAnimationView *animationView = [[YYLottieAnimationView alloc] initWithFileName:YYLottieAnimationManager.loadingRingName];
    animationView.bounds = (CGRect){CGPointZero, animationSize};
    [animationView changeAllElementColorWithColor:UIColor.whiteColor];
    [animationView play];
    [self configContentWithView:animationView text:text];
    [self showAnimated:animated];
}

- (void)showErrorWithText:(NSString *)text {
    [self showErrorWithText:text animated:YES];
}

- (void)showErrorWithText:(NSString *)text animated:(BOOL)animated {
    [self showErrorWithText:text afterDelay:0 animated:animated];
}

- (void)showErrorWithText:(NSString *)text afterDelay:(NSTimeInterval)delay {
    [self showErrorWithText:text afterDelay:delay animated:YES];
}

- (void)showErrorWithText:(NSString *)text afterDelay:(NSTimeInterval)delay animated:(BOOL)animated {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:XYImageMake(@"tip_error")];
    [self configContentWithView:imageView text:text];
    [self showAnimated:animated];
    if (delay > 0) {
        [self hideAnimated:animated afterDelay:delay];
    }
}

- (void)showSuccessWithText:(NSString *)text {
    [self showSuccessWithText:text animated:YES];
}

- (void)showSuccessWithText:(NSString *)text animated:(BOOL)animated {
    [self showSuccessWithText:text afterDelay:-1 animated:animated];
}

- (void)showSuccessWithText:(NSString *)text afterDelay:(NSTimeInterval)delay {
    [self showSuccessWithText:text afterDelay:delay animated:YES];
}

- (void)showSuccessWithText:(NSString *)text afterDelay:(NSTimeInterval)delay animated:(BOOL)animated {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:XYImageMake(@"tip_success")];
    [self configContentWithView:imageView text:text];
    [self showAnimated:animated];
    if (delay >= 0) {
        [self hideAnimated:animated afterDelay:delay];
    }
}

- (void)showInfoWithText:(NSString *)text {
    [self showInfoWithText:text animated:YES];
}

- (void)showInfoWithText:(NSString *)text animated:(BOOL)animated {
    [self showInfoWithText:text afterDelay:0 animated:animated];
}

- (void)showInfoWithText:(NSString *)text afterDelay:(NSTimeInterval)delay {
    [self showInfoWithText:text afterDelay:delay animated:YES];
}

- (void)showInfoWithText:(NSString *)text afterDelay:(NSTimeInterval)delay animated:(BOOL)animated {
    [self configContentWithView:nil text:text];
    [self showAnimated:animated];
    if (delay > 0) {
        [self hideAnimated:animated afterDelay:delay];
    }
}

- (void)configContentWithView:(UIView *)view text:(NSString *)text {
    XYToastDefaultContentView *contentView = (XYToastDefaultContentView *)self.contentView;
    contentView.maximumSizeOffset = UIOffsetMake(50, 50);
    contentView.adjustsWidthAutomatically = YES;
    contentView.text = text;
    contentView.customView = view;
}

@end

#pragma mark -

@implementation UIView (YYTipSupport)

- (void)hide {
    [YYTipView hideAllTipsInView:self animated:YES];
}

- (void)hideAnimated:(BOOL)animated {
    [YYTipView hideAllTipsInView:self animated:animated];
}

- (void)showLoading {
    [self showLoadingWithInteractionEnabled:NO];
}

- (void)showLoadingWithInteractionEnabled:(BOOL)interactionEnabled {
    [self showLoadingWithInteractionEnabled:interactionEnabled hideOtherTips:YES];
}

- (void)showLoadingWithInteractionEnabled:(BOOL)interactionEnabled hideOtherTips:(BOOL)hideOtherTips {
    [self showLoadingWithText:nil interactionEnabled:interactionEnabled hideOtherTips:hideOtherTips];
}

- (void)showLoadingWithText:(NSString *)text {
    [self showLoadingWithText:text interactionEnabled:NO];
}

- (void)showLoadingWithText:(NSString *)text interactionEnabled:(BOOL)interactionEnabled {
    [self showLoadingWithText:text interactionEnabled:interactionEnabled hideOtherTips:YES];
}

- (void)showLoadingWithText:(NSString *)text interactionEnabled:(BOOL)interactionEnabled hideOtherTips:(BOOL)hideOtherTips {
    if (hideOtherTips) [self hideAnimated:NO];
    YYTipView *tipView = [[YYTipView alloc] initWithView:self];
    tipView.userInteractionEnabled = !interactionEnabled;
    [tipView showLoadingWithText:text animated:YES];
}

- (void)showErrorWithText:(NSString *)text {
    [self showErrorWithText:text interactionEnabled:YES];
}

- (void)showErrorWithText:(NSString *)text interactionEnabled:(BOOL)interactionEnabled {
    [self showErrorWithText:text interactionEnabled:interactionEnabled hideOtherTips:YES];
}

- (void)showErrorWithText:(NSString *)text interactionEnabled:(BOOL)interactionEnabled hideOtherTips:(BOOL)hideOtherTips {
    if (hideOtherTips) [self hideAnimated:NO];
    YYTipView *tipView = [[YYTipView alloc] initWithView:self];
    tipView.userInteractionEnabled = !interactionEnabled;
    [tipView showErrorWithText:text afterDelay:2.5 animated:YES];
}

- (void)showSuccessWithText:(NSString *)text {
    [self showSuccessWithText:text interactionEnabled:YES];
}

- (void)showSuccessWithText:(NSString *)text interactionEnabled:(BOOL)interactionEnabled {
    [self showSuccessWithText:text interactionEnabled:interactionEnabled hideOtherTips:YES];
}

- (void)showSuccessWithText:(NSString *)text interactionEnabled:(BOOL)interactionEnabled hideOtherTips:(BOOL)hideOtherTips {
    if (hideOtherTips) [self hideAnimated:NO];
    YYTipView *tipView = [[YYTipView alloc] initWithView:self];
    tipView.userInteractionEnabled = !interactionEnabled;
    [tipView showSuccessWithText:text afterDelay:2.5 animated:YES];
}

- (void)showInfoWithText:(NSString *)text {
    [self showInfoWithText:text interactionEnabled:YES];
}

- (void)showInfoWithText:(NSString *)text interactionEnabled:(BOOL)interactionEnabled {
    [self showInfoWithText:text interactionEnabled:interactionEnabled hideOtherTips:YES];
}

- (void)showInfoWithText:(NSString *)text interactionEnabled:(BOOL)interactionEnabled hideOtherTips:(BOOL)hideOtherTips {
    if (hideOtherTips) [self hideAnimated:NO];
    YYTipView *tipView = [[YYTipView alloc] initWithView:self];
    tipView.userInteractionEnabled = !interactionEnabled;
    [tipView showInfoWithText:text afterDelay:2.5 animated:YES];
}

@end
