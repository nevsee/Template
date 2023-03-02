//
//  XYCycleFlowLayout.h
//  XYCycleScrollView
//
//  Created by nevsee on 2020/12/29.
//  Copyright © 2020 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYCycleLayout : UICollectionViewFlowLayout

/// The page will be forced to turn if the scroll velocity exceeds the given value. Defaults to 0.4.
@property (nonatomic, assign) CGFloat velocityForTriggerPageDown;

/// The page will turn if the item sliding percentage exceeds the given value. Defaults to 0.6.
@property (nonatomic, assign) CGFloat pagingThreshold;

/// Whether to allow multiple items to scroll at a time. Defaults to NO.
@property (nonatomic, assign) BOOL allowsMultipleItemScroll;

/// Allowing multiple items to scroll if the scroll velocity exceeds the given value. Defaults to 2.5.
/// It do not work if `allowsMultipleItemScroll` set to NO.
@property (nonatomic, assign) CGFloat velocityForMultipleItemScroll;

@end

@interface XYCycleNormalLayout : XYCycleLayout
@end

@interface XYCycleZoomLayout : XYCycleLayout
@property(nonatomic, assign) CGFloat maximumScale;
@property(nonatomic, assign) CGFloat minimumScale;
@end


NS_ASSUME_NONNULL_END
