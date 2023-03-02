//
//  UICollectionView+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A placeholder protocol to display a placeholder view if there is no data.
 */
@protocol XYCollectionViewPlaceholderDelegate <NSObject>
@optional
- (BOOL)scrollEnabledWhenPlaceholderViewShowing;
@required
- (UIView *)makePlaceholderView;
@end

@interface UICollectionView (XYAdd)

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
