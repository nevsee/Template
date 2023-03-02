//
//  YYLoopView.m
//  Template
//
//  Created by nevsee on 2022/1/4.
//

#import "YYLoopView.h"

@interface YYLoopView () <XYCycleScrollViewDelegate, XYCycleScrollViewDataSource>
@property (nonatomic, strong, readwrite) XYCycleScrollView *scrollView;
@property (nonatomic, strong, readwrite) UIPageControl *pageControl;
@property (nonatomic, strong) XYCycleZoomLayout *layout;
@end

@implementation YYLoopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollStyle = YYLoopViewScrollStyleSlide;
        _scrollDirection = YYLoopViewScrollDirectionHorizontal;
        _itemSpacing = 20;
        _pageControlBottom = 5;
        _layout = [[XYCycleZoomLayout alloc] init];
        _layout.minimumScale = 1;
        
        XYCycleScrollView *scrollView = [[XYCycleScrollView alloc] initWithFrame:CGRectZero layout:_layout];
        scrollView.delegate = self;
        scrollView.dataSource = self;
        [scrollView registerCellWithReuseIdentifier:YYLoopImageContentView.reuseIdentifier];
        [scrollView registerCellWithReuseIdentifier:YYLoopTextContentView.reuseIdentifier];
        [self addSubview:scrollView];
        _scrollView = scrollView;
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.userInteractionEnabled = NO;
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
    _pageControl.frame = CGRectMake(0, self.xy_height - _pageControlBottom - _pageControl.xy_height, self.xy_width, _pageControl.xy_height);
    [self updateCycleLayoutIfNeeded];
}

// Delegate
- (Class<XYCycleDataParser>)cycleScrollView:(XYCycleScrollView *)cycleScrollView classForItemAtIndex:(NSInteger)index {
    if (_setContentClassBlock) return _setContentClassBlock(self, index);
    return YYLoopImageContentView.class;
}

- (void)cycleScrollView:(XYCycleScrollView *)cycleScrollView willScrollToIndex:(NSInteger)index {
    _pageControl.currentPage = index;
    if (_willScrollBlock) _willScrollBlock(self, index);
}

- (void)cycleScrollView:(XYCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    if (_didScrollBlock) _didScrollBlock(self, index);
}

- (void)cycleScrollView:(XYCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (_didSelectItemBlock) _didSelectItemBlock(self, index);
}

- (void)cycleScrollView:(XYCycleScrollView *)cycleScrollView didSetContentView:(UIView *)contentView atIndex:(NSInteger)index {
    if (_setContentAttributeBlock) _setContentAttributeBlock(self, contentView, index);
}

// Method
- (void)updateCycleLayoutIfNeeded {
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) return;
    
    CGFloat width = self.xy_width - XYEdgeInsetsMaxX(_sectionInsets);
    CGFloat height = self.xy_height - XYEdgeInsetsMaxY(_sectionInsets);

    if (_scrollStyle == YYLoopViewScrollStyleZoom) {
        CGFloat length = _scrollDirection == YYLoopViewScrollDirectionHorizontal ? width : height;
        _layout.minimumScale = (length - _itemSpacing * 2) / length;
        _layout.minimumLineSpacing = 0;
    } else {
        _layout.minimumScale = 1;
        _layout.minimumLineSpacing = _itemSpacing;
    }
    _layout.itemSize = CGSizeMake(width, height);
    _layout.sectionInset = _sectionInsets;
    _layout.scrollDirection = _scrollDirection == YYLoopViewScrollDirectionHorizontal ? 1 : 0;
    [_scrollView updateLayout:_layout];
}

- (void)registerCellWithReuseIdentifier:(NSString *)identifier {
    [_scrollView registerCellWithReuseIdentifier:identifier];
}

- (__kindof UIView *)contentViewForIndex:(NSInteger)index {
    return [_scrollView cellForItemAtIndex:index].renderView;
}

// Access
- (void)setScrollStyle:(YYLoopViewScrollStyle)scrollStyle {
    if (_scrollStyle == scrollStyle) return;
    _scrollStyle = scrollStyle;
    [self updateCycleLayoutIfNeeded];
}

- (void)setScrollDirection:(YYLoopViewScrollDirection)scrollDirection {
    if (_scrollDirection == scrollDirection) return;
    _scrollDirection = scrollDirection;
    [self updateCycleLayoutIfNeeded];
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    if (_itemSpacing == itemSpacing) return;
    _itemSpacing = itemSpacing;
    [self updateCycleLayoutIfNeeded];
}

- (void)setSectionInsets:(UIEdgeInsets)sectionInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(_sectionInsets, sectionInsets)) return;
    _sectionInsets = sectionInsets;
    [self updateCycleLayoutIfNeeded];
}

- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    _scrollView.datas = datas;
    _pageControl.numberOfPages = datas.count;
    _pageControl.currentPage = _defaultIndex;
    [_pageControl sizeToFit];
}

- (void)setUserInfo:(NSDictionary *)userInfo {
    _userInfo = userInfo;
    _scrollView.userInfo = userInfo;
}

- (void)setDefaultIndex:(NSUInteger)defaultIndex {
    _defaultIndex = defaultIndex;
    _scrollView.defaultIndex = defaultIndex;
    _pageControl.currentPage = defaultIndex;
}

@end

#pragma mark -

@implementation YYLoopImageContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        if (@available(iOS 13.0, *)) {
            self.layer.cornerCurve = kCACornerCurveContinuous;
        }
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.sd_imageTransition = [SDWebImageTransition fadeTransitionWithDuration:0.25];
        [self addSubview:imageView];
        _imageView = imageView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

- (void)prepareForReuse {
    _imageView.image = nil;
    _imageView.backgroundColor = nil;
}

- (void)parseData:(id)data userInfo:(id)userInfo {
    NSDictionary *dic = userInfo;
    UIImage *placeholderImage = dic[@"placeholderImage"];
    
    if ([data isKindOfClass:NSString.class]) {
        NSString *url = data;
        if ([url hasPrefix:@"http"]) {
            [_imageView sd_setImageWithURL:[NSURL URLWithString:data] placeholderImage:placeholderImage];
        } else {
            _imageView.image = XYImageFileMake(url);
        }
    } else if ([data isKindOfClass:NSURL.class]) {
        NSURL *url = data;
        if ([url.host hasPrefix:@"http"]) {
            [_imageView sd_setImageWithURL:url placeholderImage:placeholderImage];
        } else {
            _imageView.image = XYImageFileMake(url.absoluteString);
        }
    } else if ([data isKindOfClass:UIImage.class]) {
        _imageView.image = data;
    } else if ([data isKindOfClass:UIColor.class]) {
        _imageView.backgroundColor = data;
    } else if ([data isKindOfClass:NSData.class]) {
        _imageView.image = [UIImage imageWithData:data];
    }
}

+ (NSString *)reuseIdentifier {
    return @"YYLoopImageContentView";
}

@end

#pragma mark -

@implementation YYLoopTextContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        if (@available(iOS 13.0, *)) {
            self.layer.cornerCurve = kCACornerCurveContinuous;
        }
        
        XYLabel *textLabel = [[XYLabel alloc] init];
        textLabel.font = XYFontMake(16);
        textLabel.textColor = YYNeutral9Color;
        textLabel.numberOfLines = 0;
        [self addSubview:textLabel];
        _textLabel = textLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}

- (void)prepareForReuse {
    _textLabel.text = nil;
    _textLabel.attributedText = nil;
}

- (void)parseData:(id)data userInfo:(id)userInfo {
    if ([data isKindOfClass:NSString.class]) {
        _textLabel.text = data;
    } else if ([data isKindOfClass:NSAttributedString.class]) {
        _textLabel.attributedText = data;
    }
}

+ (NSString *)reuseIdentifier {
    return @"YYLoopTextContentView";
}

@end
