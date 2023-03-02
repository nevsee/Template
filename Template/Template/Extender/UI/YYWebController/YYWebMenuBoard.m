//
//  YYWebMenuBoard.m
//  Template
//
//  Created by nevsee on 2021/11/24.
//

#import "YYWebMenuBoard.h"

@implementation YYWebMenuBoard

- (void)setHeaderView:(UIView<YYWebMenuSupplementaryViewDescriber> *)headerView {
    _headerView = headerView;
    headerView.menuBoard = self;
    self.operationView.headerView = headerView;
}

- (void)setFooterView:(UIView<YYWebMenuSupplementaryViewDescriber> *)footerView {
    _footerView = footerView;
    footerView.menuBoard = self;
    self.operationView.footerView = footerView;
}

@end

#pragma mark -

@implementation YYWebMenuLinkHeaderView {
    __weak YYWebMenuBoard *_board;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textInsets = UIEdgeInsetsMake(15, 15, 0, 15);
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = XYFontMake(10);
        textLabel.textColor = YYNeutral7Color;
        textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:textLabel];
        _textLabel = textLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.xy_height == 0) {
        _textLabel.frame = self.bounds;
    } else {
        _textLabel.frame = CGRectMake(_textInsets.left, _textInsets.top, self.xy_width - XYEdgeInsetsMaxX(_textInsets), self.xy_height - _textInsets.top);
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize textSize = [_textLabel sizeThatFits:CGSizeMake(size.width - XYEdgeInsetsMaxX(_textInsets), HUGE)];
    return CGSizeMake(size.width, textSize.height > 0 ? textSize.height + XYEdgeInsetsMaxY(_textInsets) : 0);
}

// YYWebMenuSupplementaryViewDescriber
- (void)updateViewWithData:(id)data userInfo:(id)userInfo {
    if (![data isKindOfClass:NSString.class]) return;
    _textLabel.text = [[NSString alloc] initWithFormat:@"此网页由 %@ 提供", data];
}

- (void)setMenuBoard:(YYWebMenuBoard *)menuBoard {
    _board = menuBoard;
}

- (YYWebMenuBoard *)menuBoard {
    return _board;
}

@end

#pragma mark -

@implementation YYWebMenuItemProvider

+ (YYOperationItem *)obainItemForType:(YYOperationType)type {
    NSArray *info = [self transformType:type];
    YYOperationItem *item = [[YYOperationItem alloc] init];
    item.text = info.firstObject;
    item.image = XYImageMake(info.lastObject);
    item.type = type;
    return item;
}

+ (NSArray<YYOperationItem *> *)obtainItemsForTypes:(NSArray<YYOperationType> *)types {
    NSMutableArray *items = [NSMutableArray array];
    for (YYOperationType type in types) {
        [items addObject:[self obainItemForType:type]];
    }
    return items.copy;
}

+ (NSArray *)transformType:(YYOperationType)type {
    static NSDictionary *infos;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        infos = @{
            YYOperationTypeWebCopyLink: @[@"复制链接", @"web_link"],
            YYOperationTypeWebRefresh: @[@"刷新", @"web_refresh"],
            YYOperationTypeWebFont: @[@"调整字体", @"web_font"],
            YYOperationTypeWebSearch: @[@"搜索页面内容", @"web_search"],
            YYOperationTypeWebCollect: @[@"收藏", @"web_collect"],
            YYOperationTypeWebSafari: @[@"在默认浏览器中打开", @"web_safari"],
            YYOperationTypeWebSystemShare: @[@"用其他应用打开", @"web_system_share"],
        };
    });
    return infos[type];
}

@end

YYOperationType const YYOperationTypeWebCopyLink = @"web.copyLink";
YYOperationType const YYOperationTypeWebRefresh = @"web.refresh";
YYOperationType const YYOperationTypeWebFont = @"web.font";
YYOperationType const YYOperationTypeWebSearch = @"web.search";
YYOperationType const YYOperationTypeWebCollect = @"web.collect";
YYOperationType const YYOperationTypeWebSafari = @"web.safari";
YYOperationType const YYOperationTypeWebSystemShare = @"web.systemShare";
