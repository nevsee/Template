//
//  XYPopupMenuContentView.h
//  XYPopupMenuContentView
//
//  Created by nevsee on 2017/12/12.
//

#import "XYPopupMenuBaseItem.h"
#import "XYPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYPopupMenuContentView : UIView

@property (nonatomic, strong, readonly) UITableView *tableView;

/// All items
@property (nonatomic, strong, readonly) NSArray<XYPopupMenuBaseItem *> *items;

/// Whether to dismiss when selecting the item. Defaults to YES.
@property (nonatomic, assign) BOOL autoDismiss;

/// Defaults to NO.
@property (nonatomic, assign) BOOL definesSelectionMode;

/// The selected item index. Defaults to 0.
@property (nonatomic, assign) NSUInteger defaultSelectedIndex;

/// The maximum content height. Defaults to HUGE.
@property (nonatomic, assign) CGFloat maxContentHeight;

/// callback
@property (nonatomic, copy, nullable) void (^didSelectIndexBlock)(NSInteger index);
@property (nonatomic, copy, nullable) void (^didSelectItemBlock)(XYPopupMenuBaseItem *item);

/**
 Initialize with fixed width.
 */
- (instancetype)initWithFixedWidth:(CGFloat)fixedWidth;

/**
 Add items
 */
- (void)addItems:(NSArray<XYPopupMenuBaseItem *> *)items;

@end


@interface XYPopupMenuContentView (XYConvenient)

- (void)addTextItemsWithTexts:(nullable NSArray<NSString *> *)texts
                       images:(nullable NSArray<UIImage *> *)images;

- (void)addTextItemsWithTexts:(nullable NSArray<NSString *> *)texts
                       images:(nullable NSArray<UIImage *> *)images
                      setting:(nullable void (NS_NOESCAPE ^)(__kindof XYPopupMenuBaseItem *item))setting;

- (void)addTextItemsWithTexts:(nullable NSArray<NSString *> *)texts
                       images:(nullable NSArray<UIImage *> *)images
               accessoryImage:(nullable UIImage *)accessoryImage;

- (void)addTextItemsWithTexts:(nullable NSArray<NSString *> *)texts
                       images:(nullable NSArray<UIImage *> *)images
               accessoryImage:(nullable UIImage *)accessoryImage
                      setting:(nullable void (NS_NOESCAPE ^)(__kindof XYPopupMenuBaseItem *item))setting;

@end

NS_ASSUME_NONNULL_END
