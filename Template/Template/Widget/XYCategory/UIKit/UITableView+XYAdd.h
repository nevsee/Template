//
//  UITableView+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2018/8/26.
//  Copyright © 2018年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A placeholder protocol to display a placeholder view if there is no data.
 */
@protocol XYTableViewPlaceholderDelegate <NSObject>
@optional
- (BOOL)scrollEnabledWhenPlaceholderViewShowing;
@required
- (UIView *)makePlaceholderView;
@end


@interface UITableView (XYAdd)

/**
 Hides tableview redundant cell.
 */
- (void)xy_hideRedundantCell;

/**
 Displays a placeholder view if there is no data.
 */
- (void)xy_reloadData;

/**
 Returns NO if cell is not visible at the given index path.
 */
- (BOOL)xy_cellVisibleAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
