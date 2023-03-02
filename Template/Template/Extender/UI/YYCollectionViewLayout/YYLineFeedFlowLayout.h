//
//  YYLineFeedFlowLayout.h
//  Ferry
//
//  Created by nevsee on 2022/7/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 不足一行换行显示
@interface YYLineFeedFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, weak, nullable) id<UICollectionViewDelegateFlowLayout> delegate;
@property (nonatomic, assign) UIEdgeInsets decorationInset;
@property (nonatomic, assign) UIOffset decorationOffset;
@end

NS_ASSUME_NONNULL_END
