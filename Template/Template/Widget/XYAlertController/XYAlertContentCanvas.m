//
//  XYAlertAction.h
//  XYAlertController
//
//  Created by nevsee on 2018/10/12.
//

#import "XYAlertContentCanvas.h"

@interface XYAlertContentCanvas ()
@property (nonatomic, strong, readwrite) XYAlertFixedSpaceContent *headerPlaceholderContent;
@property (nonatomic, strong, readwrite) XYAlertFixedSpaceContent *footerPlaceholderContent;
@property (nonatomic, assign) XYAlertControllerStyle style;
@property (nonatomic, strong) NSMutableArray *totalContents;
@property (nonatomic, assign) BOOL isAlertStyle;
@end

@implementation XYAlertContentCanvas

+ (instancetype)canvasWithStyle:(XYAlertControllerStyle)style {
    XYAlertContentCanvas *canvas = [[XYAlertContentCanvas alloc] init];
    canvas.backgroundColor = [UIColor whiteColor];
    canvas.style = style;
    canvas.isAlertStyle = (style == XYAlertControllerStyleAlert);
    [canvas userInterfaceSetup];
    return canvas;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat contentY = 0;
    for (NSInteger i = 0; i < self.totalContents.count; i++) {
        XYAlertContent *content = self.totalContents[i];
        CGFloat contentHeight = [content sizeThatFits:self.bounds.size].height;
        content.frame = CGRectMake(0, contentY, self.bounds.size.width, contentHeight);
        contentY += contentHeight;
    }
}

- (void)userInterfaceSetup {
    XYAlertAppearance *appearance = [XYAlertAppearance appearance];
    
    XYAlertFixedSpaceContent *header = [XYAlertFixedSpaceContent fixedSpaceContent];
    header.preferredHeight = self.isAlertStyle ? appearance.contentPlaceholderHeightForAlert : appearance.contentPlaceholderHeightForSheet;
    self.headerPlaceholderContent = header;
    
    XYAlertFixedSpaceContent *footer = [XYAlertFixedSpaceContent fixedSpaceContent];
    footer.preferredHeight = self.isAlertStyle ? appearance.contentPlaceholderHeightForAlert : appearance.contentPlaceholderHeightForSheet;
    self.footerPlaceholderContent = footer;
}

- (void)updateContents:(NSArray *)contents {
    /// restore
    for (XYAlertContent *content in self.totalContents) {
        [content removeFromSuperview];
    }
    [self.totalContents removeAllObjects];
    
    /// update
    if (contents.count == 0) return;
    
    for (NSInteger i = 0; i < contents.count; i++) {
        XYAlertContent *content = contents[i];
        [content setTag:i];
        [self.totalContents addObject:content];
    }
    [self.totalContents insertObject:self.headerPlaceholderContent atIndex:0];
    [self.totalContents addObject:self.footerPlaceholderContent];
    
    /// add contents
    for (XYAlertContent *content in self.totalContents) {
        [self addSubview:content];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat height = 0;
    for (NSInteger i = 0; i < self.totalContents.count; i++) {
        XYAlertContent *content = self.totalContents[i];
        height += [content sizeThatFits:size].height;
    }
    return CGSizeMake(size.width, height);
}

/// Access
- (NSMutableArray *)totalContents {
    if (!_totalContents) {
        _totalContents = [NSMutableArray array];
    }
    return _totalContents;
}

@end
