//
//  XYCodeScanIndicator.m
//  XYCodeScanner
//
//  Created by nevsee on 2021/10/21.
//

#import "XYCodeScanIndicator.h"

@implementation XYCodeScanIndicator

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActiveAction) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundAction) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)becomeActiveAction {

}

- (void)enterBackgroundAction {

}

@end

#pragma mark -

@interface XYCodeScanDefaultIndicator ()
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIGestureRecognizer *closeGesture;
@end

@implementation XYCodeScanDefaultIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSDictionary *noteAttr = @{
            NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
            NSForegroundColorAttributeName: [UIColor whiteColor]
        };
        NSDictionary *nonCodeAttr = @{
            NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
            NSForegroundColorAttributeName: [UIColor whiteColor]
        };
        NSDictionary *nonCodeCloseAttr = @{
            NSFontAttributeName: [UIFont systemFontOfSize:14],
            NSForegroundColorAttributeName: [UIColor lightGrayColor]
        };
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"XYCodeScanner" withExtension:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithURL:url];
        
        _multipleIndicatorImage = [UIImage imageNamed:@"xy_scan_jump" inBundle:bundle compatibleWithTraitCollection:nil];
        _singleIndicatorImage = [UIImage imageNamed:@"xy_scan_dot" inBundle:bundle compatibleWithTraitCollection:nil];
        _indicatorSize = CGSizeMake(40, 40);
        _noteTextBottom = 150;
        _noteText = [[NSAttributedString alloc] initWithString:@"轻触箭头图标，打开页面" attributes:noteAttr];
        _nonCodeText = [[NSAttributedString alloc] initWithString:@"未发现二维码 / 条码" attributes:nonCodeAttr];
        _nonCodeCloseText = [[NSAttributedString alloc] initWithString:@"轻触屏幕继续扫描" attributes:nonCodeCloseAttr];
    }
    return self;
}

// Method
- (void)addColorAnimationForLayer:(CALayer *)layer {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.fromValue = (id)[[UIColor blackColor] colorWithAlphaComponent:0].CGColor;
    animation.toValue = (id)[[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;
    animation.duration = 0.6;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [layer addAnimation:animation forKey:@"color"];
}

- (void)addScaleAnimationForLayer:(CALayer *)layer {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(1), @(1), @(0.8), @(1), @(0.8), @(1)];
    animation.keyTimes = @[@(0), @(0.6), @(0.7), @(0.8), @(0.9), @(1)];
    animation.duration = 3.5;
    animation.repeatCount = HUGE;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [layer addAnimation:animation forKey:@"scale"];
}

// Action
- (void)jumpAction:(UIButton *)sender {
    XYCodeScanResult *result = self.results[sender.tag];
    if (self.jumpBlock) self.jumpBlock(self, result.stringValue);
}

- (void)closeAction {
    if (self.closeBlock) self.closeBlock(self);
}

- (void)becomeActiveAction {
    for (UIButton *button in _buttons) {
        [self addScaleAnimationForLayer:button.layer];
    }
}

- (void)enterBackgroundAction {
    for (UIButton *button in _buttons) {
        [button.layer removeAllAnimations];
    }
}

// Access
- (void)setResults:(NSArray *)results {
    [super setResults:results];

    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    [self.layer removeAllAnimations];
    [self removeGestureRecognizer:_closeGesture];
    
    if (results.count == 0) { // no code
        UILabel *nonCodeLabel = [[UILabel alloc] init];
        nonCodeLabel.numberOfLines = 0;
        nonCodeLabel.textAlignment = NSTextAlignmentCenter;
        nonCodeLabel.attributedText = _nonCodeText;
        [self addSubview:nonCodeLabel];
        CGSize nonCodeSize = [nonCodeLabel sizeThatFits:CGSizeMake(self.bounds.size.width - 60, HUGE)];
        nonCodeLabel.center = self.center;
        nonCodeLabel.bounds = CGRectMake(0, 0, nonCodeSize.width, nonCodeSize.height);
        
        UILabel *nonCodeCloseLabel = [[UILabel alloc] init];
        nonCodeCloseLabel.numberOfLines = 0;
        nonCodeCloseLabel.textAlignment = NSTextAlignmentCenter;
        nonCodeCloseLabel.attributedText = _nonCodeCloseText;
        [self addSubview:nonCodeCloseLabel];
        CGSize nonCodeCloseSize = [nonCodeCloseLabel sizeThatFits:CGSizeMake(self.bounds.size.width - 60, HUGE)];
        nonCodeCloseLabel.frame = CGRectMake(30, CGRectGetMaxY(nonCodeLabel.frame) + 10, self.bounds.size.width - 60, nonCodeCloseSize.height);
        
        UITapGestureRecognizer *closeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
        _closeGesture = closeGesture;
        [self addGestureRecognizer:closeGesture];
    }
    else if (results.count == 1) { // single code
        XYCodeScanResult *result = results.firstObject;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:_singleIndicatorImage];
        if (CGRectEqualToRect(result.bounds, CGRectZero)) {
            imageView.center = self.center;
        } else {
            imageView.center = CGPointMake(CGRectGetMidX(result.bounds), CGRectGetMidY(result.bounds));
        }
        imageView.bounds = CGRectMake(0, 0, _indicatorSize.width, _indicatorSize.height);
        [self addSubview:imageView];
        if (self.jumpBlock) self.jumpBlock(self, result.stringValue);
    }
    else { // multiple codes
        _buttons = [NSMutableArray array];
        for (NSInteger i = 0; i < results.count; i++) {
            XYCodeScanResult *result = results[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTag:i];
            [button setCenter:CGPointMake(CGRectGetMidX(result.bounds), CGRectGetMidY(result.bounds))];
            [button setBounds:CGRectMake(0, 0, _indicatorSize.width, _indicatorSize.height)];
            [button setImage:_multipleIndicatorImage forState:UIControlStateNormal];
            [button addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [_buttons addObject:button];
            [self addScaleAnimationForLayer:button.layer];
        }
        if (!_noteText) return;
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.attributedText = _noteText;
        [self addSubview:label];
        CGSize size = [label sizeThatFits:CGSizeMake(self.bounds.size.width - 60, HUGE)];
        [label setFrame:CGRectMake(30, self.bounds.size.height - _noteTextBottom - size.height, self.bounds.size.width - 60, size.height)];
    }

    [self addColorAnimationForLayer:self.layer];
}

@end
