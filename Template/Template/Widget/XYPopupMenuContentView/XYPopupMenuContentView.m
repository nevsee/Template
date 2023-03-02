//
//  XYPopupMenuContentView.m
//  XYPopupMenuContentView
//
//  Created by nevsee on 2017/12/12.
//

#import "XYPopupMenuContentView.h"

@interface XYMenuContentCell : UITableViewCell
@property (nonatomic, strong) XYPopupMenuBaseItem *renderItem;
@end

@implementation XYMenuContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _renderItem.frame = self.bounds;
}

- (void)removeAllSubviews {
    while (self.contentView.subviews.count) {
        [self.contentView.subviews.lastObject removeFromSuperview];
    }
}

- (void)setRenderItem:(XYPopupMenuBaseItem *)renderItem {
    if (!_renderItem) {
        UIView *selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView = selectedBackgroundView;
    }
    self.selectedBackgroundView.backgroundColor = renderItem.selectedColor;

    _renderItem = renderItem;
    [self removeAllSubviews];
    [self.contentView addSubview:renderItem];
}

@end

#pragma mark -

@interface XYPopupMenuContentView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tempItems;
@property (nonatomic, strong) NSMutableArray *tempItemHeights;
@property (nonatomic, assign) NSUInteger selectedIndex;
@end

@implementation XYPopupMenuContentView

- (instancetype)initWithFixedWidth:(CGFloat)fixedWidth {
    self = [super initWithFrame:CGRectMake(0, 0, fixedWidth, 0)];
    if (self) {
        [self parameterSetup];
        [self userInterfaceSetup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_tableView setFrame:self.bounds];
}

- (void)parameterSetup {
    _autoDismiss = YES;
    _definesSelectionMode = NO;
    _defaultSelectedIndex = 0;
    _maxContentHeight = HUGE;
    _tempItems = [NSMutableArray array];
    _tempItemHeights = [NSMutableArray array];
}

- (void)userInterfaceSetup {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = UIColor.clearColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [self addSubview:tableView];
    _tableView = tableView;
}

// Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tempItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYPopupMenuBaseItem *item = _tempItems[indexPath.row];
    NSString *reuseIdentifier = [item.class reuseIdentifier];
    XYMenuContentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[XYMenuContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.renderItem = item;
    cell.renderItem.selected = (_definesSelectionMode && _defaultSelectedIndex == indexPath.row);
    cell.renderItem.separator.hidden = (indexPath.row == _tempItems.count - 1);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_tempItemHeights[indexPath.row] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XYPopupMenuBaseItem *nextItem = _tempItems[indexPath.row];
    
    if (_definesSelectionMode) {
        if (_selectedIndex == indexPath.row) return;
        XYPopupMenuBaseItem *preItem = _tempItems[_selectedIndex];
        preItem.selected = NO;
        nextItem.selected = YES;
        _selectedIndex = indexPath.row;
    }
    
    if (_didSelectItemBlock) _didSelectItemBlock(nextItem);
    if (_didSelectIndexBlock) _didSelectIndexBlock(indexPath.row);
    if (!_autoDismiss) return;
    if (!nextItem.autoDismiss) return;
    [self.xy_popup hideAnimated:YES];
}

// Method
- (void)addItems:(NSArray<XYPopupMenuBaseItem *> *)items {
    CGFloat contentHeight = self.frame.size.height;
    
    for (NSInteger i = 0; i < items.count; i++) {
        XYPopupMenuBaseItem *item = items[i];
        CGSize size = [item sizeThatFits:self.bounds.size];
        contentHeight += size.height;
        [_tempItems addObject:item];
        [_tempItemHeights addObject:@(size.height)];
    }
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, MIN(contentHeight, _maxContentHeight));
    _tableView.scrollEnabled = contentHeight > _maxContentHeight;
    [_tableView reloadData];
}

// Access
- (void)setDefaultSelectedIndex:(NSUInteger)defaultSelectedIndex {
    _defaultSelectedIndex = defaultSelectedIndex;
    _selectedIndex = defaultSelectedIndex;
}

- (NSArray<XYPopupMenuBaseItem *> *)items {
    return _tempItems.copy;
}

@end

@implementation XYPopupMenuContentView (XYConvenient)

- (void)addTextItemsWithTexts:(NSArray<NSString *> *)texts images:(NSArray<UIImage *> *)images {
    [self addTextItemsWithTexts:texts images:images setting:nil];
}

- (void)addTextItemsWithTexts:(NSArray<NSString *> *)texts images:(NSArray<UIImage *> *)images setting:(void (NS_NOESCAPE ^)(__kindof XYPopupMenuBaseItem *))setting {
    [self addTextItemsWithTexts:texts images:images accessoryImage:nil setting:setting];
}

- (void)addTextItemsWithTexts:(NSArray<NSString *> *)texts images:(NSArray<UIImage *> *)images accessoryImage:(UIImage *)accessoryImage {
    [self addTextItemsWithTexts:texts images:images accessoryImage:accessoryImage setting:nil];
}

- (void)addTextItemsWithTexts:(NSArray<NSString *> *)texts images:(NSArray<UIImage *> *)images accessoryImage:(UIImage *)accessoryImage setting:(void (NS_NOESCAPE ^)(__kindof XYPopupMenuBaseItem *))setting {
    if (!texts && !images) return;
    
    NSMutableArray *items = [NSMutableArray array];
    NSUInteger count = MAX(texts.count, images.count);
    
    for (NSInteger i = 0; i < count; i++) {
        XYPopupMenuTextItem *item = [[XYPopupMenuTextItem alloc] init];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        if (i < texts.count && texts[i]) [data setValue:texts[i] forKey:@"text"];
        if (i < images.count && images[i]) [data setValue:images[i] forKey:@"image"];
        [item parseData:data userInfo:accessoryImage];
        if (setting) setting(item);
        [items addObject:item];
    }
    [self addItems:items];
}

@end
