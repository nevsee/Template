//
//  XYBrowserIndicator.m
//  XYBrowser
//
//  Created by nevsee on 2022/9/27.
//

#import "XYBrowserIndicator.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation XYBrowserLoadingIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
        indicatorView.activityIndicatorViewStyle = _style;
        indicatorView.color = _color;
        [self addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _indicatorView.frame = self.bounds;
}

- (void)startIndicator {
    _indicatorView.hidden = NO;
    [_indicatorView startAnimating];
}

- (void)stopIndicator {
    _indicatorView.hidden = YES;
    [_indicatorView stopAnimating];
}

- (void)updateIndicatorProgress:(double)progress {
    
}

- (void)setStyle:(UIActivityIndicatorViewStyle)style {
    if (_style == style) return;
    _style = style;
    _indicatorView.activityIndicatorViewStyle = style;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    _indicatorView.color = color;
}

@end

@interface XYBrowserLoadingIndicator (XYAppearance)
@end

@implementation XYBrowserLoadingIndicator (XYAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XYBrowserLoadingIndicator *appearance = [XYBrowserLoadingIndicator appearance];
        if (@available(iOS 13.0, *)) {
            appearance.style = UIActivityIndicatorViewStyleMedium;
            appearance.color = UIColor.whiteColor;
        } else {
            appearance.style = UIActivityIndicatorViewStyleWhite;
        }
    });
}

@end

#pragma mark -

@implementation XYBrowserErrorIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *indicatorView = [[UIImageView alloc] init];
        indicatorView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _indicatorView.frame = self.bounds;
}

- (void)startIndicator {
    _indicatorView.hidden = NO;
}

- (void)stopIndicator {
    _indicatorView.hidden = YES;
}

- (void)updateIndicatorProgress:(double)progress {
    
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _indicatorView.image = image;
}

@end

@interface XYBrowserErrorIndicator (XYAppearance)
@end

@implementation XYBrowserErrorIndicator (XYAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"XYBrowser" withExtension:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithURL:url];
        UIImage *image = [UIImage imageNamed:@"xy_browser_error" inBundle:bundle compatibleWithTraitCollection:nil];
        XYBrowserErrorIndicator *appearance = [XYBrowserErrorIndicator appearance];
        appearance.image = image;
    });
}

@end

#pragma clang dianostic pop
