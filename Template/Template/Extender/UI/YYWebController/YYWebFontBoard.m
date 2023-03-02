//
//  YYWebFontBoard.m
//  Template
//
//  Created by nevsee on 2021/11/24.
//

#import "YYWebFontBoard.h"

@interface YYWebFontBoard ()
@property (nonatomic, strong, readwrite) YYWebFontContentView *contentView;
@property (nonatomic, assign, readonly) CGFloat contentViewWidth;
@end

@implementation YYWebFontBoard

- (void)didInitialize {
    [super didInitialize];
    self.xy_prompter.position = XYPromptPositionBottom;
    self.xy_prompter.animator.presentStyle = XYPromptAnimationStyleSlipBottom;
    self.xy_prompter.animator.dismissStyle = XYPromptAnimationStyleSlipBottom;
    self.xy_prompter.definesSafeAreaAdaptation = NO;
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.contentView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _contentView.frame = CGRectMake((self.view.xy_width - self.contentViewWidth) / 2, 0, self.contentViewWidth, 120);
}

// Method

- (void)preferredBoardContentSize {
    self.xy_portraitContentSize = CGSizeMake(YYDeviceWidth, 120 + YYSafeArea.bottom);
    self.xy_landscapeContentSize = CGSizeMake(YYDeviceHeight, 120 + YYSafeArea.bottom);
}

// Access

- (YYWebFontContentView *)contentView {
    if (!_contentView) {
        YYWebFontContentView *view = [[YYWebFontContentView alloc] init];
        _contentView = view;
    }
    return _contentView;
}

- (CGFloat)contentViewWidth {
    return [UIApplication sharedApplication].xy_isInterfaceLandscape ? YYDeviceWidth + 80 : YYDeviceWidth;
}

@end

#pragma mark -

@interface YYWebFontContentView ()
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, strong) NSMutableArray *separators;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation YYWebFontContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _optionCount = 7;
        _optionInterval = 0.1;
        _optionIndex = 1;
        _currentIndex = 1;
        _separators = [NSMutableArray array];
        
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.font = XYFontMake(14);
        leftLabel.textColor = YYNeutral9Color;
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.text = @"A";
        [leftLabel sizeToFit];
        [self addSubview:leftLabel];
        _leftLabel = leftLabel;
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.font = XYFontMake(18);
        rightLabel.textColor = YYNeutral9Color;
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.text = @"A";
        [rightLabel sizeToFit];
        [self addSubview:rightLabel];
        _rightLabel = rightLabel;
        
        UILabel *noteLabel = [[UILabel alloc] init];
        noteLabel.font = XYFontMake(16);
        noteLabel.textColor = YYNeutral7Color;
        noteLabel.textAlignment = NSTextAlignmentCenter;
        noteLabel.text = @"标准";
        [noteLabel sizeToFit];
        [self addSubview:noteLabel];
        _noteLabel = noteLabel;
        
        CALayer *lineLayer = [CALayer layer];
        lineLayer.backgroundColor = YYNeutral4Color.CGColor;
        [self.layer addSublayer:lineLayer];
        _lineLayer = lineLayer;
        
        UISlider *slider = [[UISlider alloc] init];
        slider.thumbTintColor = UIColor.whiteColor;
        slider.minimumTrackTintColor = UIColor.clearColor;
        slider.maximumTrackTintColor = UIColor.clearColor;
        slider.maximumValue = (_optionCount - 1) * _optionInterval;
        slider.value = _currentIndex * _optionInterval;
        [slider addTarget:self action:@selector(slidAction:event:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:slider];
        _slider = slider;
        
        [self updateSeparators];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 中线
    CGFloat lineX = 30; // 中线左右边距
    CGFloat lineHeight = 1;
    CGFloat lineWidth = self.xy_width - lineX * 2;
    CGFloat lineY = (self.xy_height - lineHeight) / 2;
    _lineLayer.frame = CGRectMake(lineX, lineY, lineWidth, lineHeight);
    
    // 分隔线
    CGFloat separatorWidth = 1;
    CGFloat separatorHeight = 5;
    CGFloat separatorPadding = lineWidth / (_optionCount - 1); // 分隔线间距
    for (NSInteger i = 0; i < _optionCount; i++) {
        CALayer *separator = _separators[i];
        CGFloat separatorX = i * separatorPadding;
        CGFloat separatorY = (lineHeight - separatorHeight) / 2;
        separator.frame = CGRectMake(separatorX, separatorY, separatorWidth, separatorHeight);
    }
    
    // 滑杆
    _slider.xy_left = _lineLayer.xy_left - _slider.xy_height / 2;
    _slider.xy_width = _lineLayer.xy_width + _slider.xy_height;
    _slider.xy_centerY = _lineLayer.xy_centerY;
    
    // 变小提示
    _leftLabel.xy_left = _lineLayer.xy_left;
    _leftLabel.xy_bottom = _lineLayer.xy_top - 20;
    
    // 变大提示
    _rightLabel.xy_right = _lineLayer.xy_right;
    _rightLabel.xy_bottom = _lineLayer.xy_top - 20;
    
    // 标准字体提示
    _noteLabel.xy_centerX = lineX + _optionIndex * separatorPadding;
    _noteLabel.xy_bottom = _lineLayer.xy_top - 20;
}

// Action

- (void)slidAction:(UISlider *)sender event:(UIEvent *)event {
    NSInteger index = sender.value / _optionInterval;
    NSInteger overHalfIndex = index + (sender.value - index * _optionInterval) / (_optionInterval / 2);
    
    // 是否是节点
    BOOL isNode = (sender.value - index * _optionInterval) <= 0.2 * _optionInterval;
    if (isNode) [self callbackForIndex:index];
    
    // 停止拖动时滚动到最近节点
    UITouch *touch = event.allTouches.anyObject;
    if (touch.phase != UITouchPhaseEnded) return;
    [sender setValue:overHalfIndex * _optionInterval animated:YES];
    if (overHalfIndex == _currentIndex) return;
    [self callbackForIndex:overHalfIndex];
}

// Method

// 滑到节点触发回调
- (void)callbackForIndex:(NSInteger)index {
    _currentIndex = index;
    if (_valueChangedBlock) {
        _valueChangedBlock(1 + (index - _optionIndex) * _optionInterval);
    }
}

// 更新滑杆值
- (void)updateSliderValue {
    _slider.maximumValue = (_optionCount - 1) * _optionInterval;
    _slider.value = _currentIndex * _optionInterval;
}

// 更新分隔线
- (void)updateSeparators {
    for (CALayer *layer in _separators) {
        [layer removeFromSuperlayer];
    }
    [_separators removeAllObjects];
    
    for (NSInteger i = 0; i < _optionCount; i++) {
        CALayer *separator = [CALayer layer];
        separator.backgroundColor = YYNeutral4Color.CGColor;
        [_lineLayer addSublayer:separator];
        [_separators addObject:separator];
    }
}

// 重置滑块位置
- (void)resetCurrentIndex {
    _currentIndex = _optionIndex;
    _slider.value = _currentIndex * _optionInterval;
}

// Access

- (void)setOptionCount:(NSInteger)optionCount {
    if (_optionCount == optionCount) return;
    if (optionCount < 3) return;
    _optionCount = optionCount;
    [self updateSliderValue];
    [self updateSeparators];
    [self setNeedsLayout];
}

- (void)setOptionInterval:(CGFloat)optionInterval {
    if (_optionInterval == optionInterval) return;
    _optionInterval = optionInterval;
    [self updateSliderValue];
}

- (void)setOptionIndex:(NSInteger)optionIndex {
    if (_optionIndex == optionIndex) return;
    if (optionIndex < 1 || optionIndex >= _optionCount - 1) return;
    _optionIndex = optionIndex;
    _currentIndex = optionIndex;
    [self updateSliderValue];
    [self setNeedsLayout];
}

@end
