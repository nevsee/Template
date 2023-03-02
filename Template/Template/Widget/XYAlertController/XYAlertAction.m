//
//  XYAlertAction.m
//  XYAlertController
//
//  Created by nevsee on 2018/10/12.
//

#import "XYAlertAction.h"
#import "XYAlertController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface XYAlertAction ()
@property (nonatomic, strong, readwrite) UIView *contentView;
@property (nonatomic, strong) UIView *topSeparator;
@property (nonatomic, strong) UIView *rightSeparator;
@property (nonatomic, assign) XYAlertSeparatorStyle separatorStyle;
@end

@implementation XYAlertAction

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _separatorStyle = -1;
        
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = UIColor.clearColor;
        [self addSubview:contentView];
        _contentView = contentView;
        
        UIView *topSeparator = [[UIView alloc] init];
        topSeparator.backgroundColor = [XYAlertAppearance appearance].actionSeparatorColor;
        [self addSubview:topSeparator];
        _topSeparator = topSeparator;
        
        UIView *rightSeparator = [[UIView alloc] init];
        rightSeparator.backgroundColor = [XYAlertAppearance appearance].actionSeparatorColor;
        [self addSubview:rightSeparator];
        _rightSeparator = rightSeparator;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat size = [XYAlertAppearance appearance].actionSeparatorSize;
    CGSize vsize = self.bounds.size;
    _contentView.frame = self.bounds;
    _topSeparator.frame = CGRectMake(0, 0, vsize.width, size);
    _rightSeparator.frame = CGRectMake(vsize.width - size, size, size, vsize.height - size);
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, _preferredHeight);
}

- (void)setSeparatorStyle:(XYAlertSeparatorStyle)separatorStyle {
    _separatorStyle = separatorStyle;
    _topSeparator.hidden = separatorStyle == XYAlertSeparatorStyleNone ? YES : !(separatorStyle & XYAlertSeparatorStyleTop);
    _rightSeparator.hidden = separatorStyle == XYAlertSeparatorStyleNone ? YES : !(separatorStyle & XYAlertSeparatorStyleRight);
}

@end

#pragma mark -

@implementation XYAlertFixedSpaceAction

+ (instancetype)fixedSpaceAction {
    XYAlertFixedSpaceAction *action = [[XYAlertFixedSpaceAction alloc] init];
    action.separatorStyle = XYAlertSeparatorStyleNone;
    return action;
}

@end

#pragma mark -

@interface XYAlertSketchAction ()
@property (nonatomic, strong) UIButton *button;
@end

@implementation XYAlertSketchAction

- (instancetype)initWithTitle:(NSString *)title style:(XYAlertActionStyle)style alerter:(XYAlertController *)alerter {
    return [self initWithTitle:title image:nil spacing:0 style:style alerter:alerter];
}

- (instancetype)initWithImage:(UIImage *)image style:(XYAlertActionStyle)style alerter:(XYAlertController *)alerter {
    return [self initWithTitle:nil image:image spacing:0 style:style alerter:alerter];
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image spacing:(CGFloat)spacing style:(XYAlertActionStyle)style alerter:(XYAlertController *)alerter {
    self = [super init];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        [button addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        _button = button;
        
        self.dismissEnabled = YES;
        self.style = style;
        self.alerter = alerter;
        self.title = title;
        self.image = image;
        self.spacing = spacing;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _button.frame = self.contentView.bounds;
}

// Action
- (void)tapAction {
    if (self.beforeHandler) self.beforeHandler(self);
    if (self.alerter.beforeHandler) self.alerter.beforeHandler(self);
    if (self.dismissEnabled) [self.alerter dismiss];
    if (self.afterHandler) self.afterHandler(self);
    if (self.alerter.afterHandler) self.alerter.afterHandler(self);
}

// Method
- (UIImage *)obtainImageWithColor:(UIColor *)color {
    if (!color) return nil;
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)updateButtonIfNeeded {
    NSAttributedString *attributedTitle = _title ? [[NSAttributedString alloc] initWithString:_title attributes:_titleAttributes] : nil;
    [_button setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [_button setImage:_image forState:UIControlStateNormal];
    _button.titleEdgeInsets = (_title && _image) ? UIEdgeInsetsMake(0, _spacing / 2, 0, 0) : UIEdgeInsetsZero;
    _button.imageEdgeInsets = (_title && _image) ? UIEdgeInsetsMake(0, 0, 0, _spacing / 2) : UIEdgeInsetsZero;
}

// Access
- (void)setTitle:(NSString *)title {
    _title = title;
    [self updateButtonIfNeeded];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self updateButtonIfNeeded];
}

- (void)setSpacing:(CGFloat)spacing {
    _spacing = spacing;
    [self updateButtonIfNeeded];
}

- (void)setTitleAttributes:(NSDictionary *)titleAttributes {
    _titleAttributes = titleAttributes;
    [self updateButtonIfNeeded];
}

- (void)setHighlightedColor:(UIColor *)highlightedColor {
    _highlightedColor = highlightedColor;
    UIImage *highlightedImage = [self obtainImageWithColor:highlightedColor];
    [_button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
}

- (void)setAlerter:(XYAlertController *)alerter {
    if (self.alerter) return;
    [super setAlerter:alerter];

    XYAlertAppearance *appearance = [XYAlertAppearance appearance];
    self.highlightedColor = appearance.actionHighlightedColor;
    
    if (alerter.preferredStyle == XYAlertControllerStyleAlert) {
        self.preferredHeight = appearance.actionHeightForAlert;
        if (self.style == XYAlertActionStyleDefault) self.titleAttributes = appearance.actionDefaultAttributesForAlert;
        else if (self.style == XYAlertActionStyleCancel) self.titleAttributes = appearance.actionCancelAttributesForAlert;
        else self.titleAttributes = appearance.actionDestructiveAttributesForAlert;
    } else {
        self.preferredHeight = appearance.actionHeightForSheet;
        if (self.style == XYAlertActionStyleDefault) self.titleAttributes = appearance.actionDefaultAttributesForSheet;
        else if (self.style == XYAlertActionStyleCancel) self.titleAttributes = appearance.actionCancelAttributesForSheet;
        else self.titleAttributes = appearance.actionDestructiveAttributesForSheet;
    }
}

@end


#pragma mark -

@interface XYAlertTimerAction ()
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSTimeInterval recordDuration;
@end

@implementation XYAlertTimerAction

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image spacing:(CGFloat)spacing style:(XYAlertActionStyle)style alerter:(XYAlertController *)alerter {
    self = [super initWithTitle:title image:image spacing:spacing style:style alerter:alerter];
    if (self) {
        _format = @"%@";
    }
    return self;
}

- (void)dealloc {
    [self stopCounter];
}

// Method
- (void)resetButtonTitle:(NSString *)title enabled:(BOOL)enabled forAttributes:(NSDictionary *)attributes {
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    [self.button setAttributedTitle:attributedTitle forState:enabled ? UIControlStateNormal : UIControlStateDisabled];
    [self.button setEnabled:enabled];
}

- (void)startCounter {
    if (_timer) return;

    __weak typeof(self) weak = self;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        __strong typeof(weak) self = weak;
        if (self.duration > 0) {
            NSString *title = [NSString stringWithFormat:self.format, @(self.duration)];
            [self resetButtonTitle:title enabled:NO forAttributes:self.titleDisabledAttributes];
            self.duration--;
        } else {
            [self resetButtonTitle:self.title enabled:YES forAttributes:self.titleAttributes];
            [self stopCounter];
        }
    });
    dispatch_resume(_timer);
}

- (void)stopCounter {
    if (!_timer) return;
    dispatch_source_cancel(_timer);
    _timer = nil;
}

- (void)restartCounter {
    self.duration = _recordDuration;
    [self stopCounter];
    [self startCounter];
}

// Access
- (void)setAlerter:(XYAlertController *)alerter {
    if (self.alerter) return;
    [super setAlerter:alerter];
    
    XYAlertAppearance *appearance = [XYAlertAppearance appearance];
    if (alerter.preferredStyle == XYAlertControllerStyleAlert) {
        _titleDisabledAttributes = appearance.actionTitleDisabledAttributesForAlert;
    } else {
        _titleDisabledAttributes = appearance.actionTitleDisabledAttributesForSheet;
    }
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    if (_recordDuration > 0) return;
    _recordDuration = duration;
}

@end

#pragma clang diagnostic pop
