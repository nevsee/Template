//
//  XYCycleCell.h
//  XYCycleScrollView
//
//  Created by nevsee on 2017/4/1.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XYCycleDataParser;

NS_ASSUME_NONNULL_BEGIN

@interface XYCycleCell : UICollectionViewCell
@property (nonatomic, strong) UIView<XYCycleDataParser> *renderView;
- (void)refreshCellWithData:(id)data userInfo:(nullable id)userInfo;
@end

@protocol XYCycleDataParser <NSObject>
@required
+ (NSString *)reuseIdentifier;
- (void)parseData:(id)data userInfo:(nullable id)userInfo;
@optional
- (void)prepareForReuse;
@end

NS_ASSUME_NONNULL_END
