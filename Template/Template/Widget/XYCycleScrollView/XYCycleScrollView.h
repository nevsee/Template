//
//  XYCycleScrollView.h
//  XYCycleScrollView
//
//  Created by nevsee on 2017/4/1.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<XYCycleScrollview/XYCycleScrollview.h>)
FOUNDATION_EXPORT double XYCycleScrollviewVersionNumber;
FOUNDATION_EXPORT const unsigned char XYCycleScrollviewVersionString[];
#import <XYCycleScrollview/XYCycleCell.h>
#import <XYCycleScrollview/XYCycleLayout.h>
#else
#import "XYCycleCell.h"
#import "XYCycleLayout.h"
#endif

@protocol XYCycleScrollViewDataSource, XYCycleScrollViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface XYCycleScrollView : UIView
@property (nonatomic, weak, nullable) id<XYCycleScrollViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id<XYCycleScrollViewDelegate> delegate;
@property (nonatomic, strong, nullable) NSArray *datas; ///< Data source.
@property (nonatomic, strong, nullable) id userInfo; ///< Additional parameters.
@property (nonatomic, assign) BOOL repeat; ///< Repeat-scroll. Defaults to YES.
@property (nonatomic, assign) BOOL autoScroll; ///< Auto-scroll. Defaults to YES.
@property (nonatomic, assign) NSTimeInterval autoScrollInterval; ///< Auto-scroll interval. Defaults to 3s.
@property (nonatomic, assign) UIScrollViewDecelerationRate decelerationRate; ///< Defaults to UIScrollViewDecelerationRateFast.
@property (nonatomic, assign) NSInteger defaultIndex; ///< Defaults to 0.

@property (nonatomic, assign, readonly) BOOL isAnimating;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, strong, readonly) XYCycleCell *currentCell;

- (instancetype)initWithFrame:(CGRect)frame
                       layout:(UICollectionViewFlowLayout *)layout;

- (instancetype)initWithFrame:(CGRect)frame
                       layout:(UICollectionViewFlowLayout *)layout
                  renderClass:(nullable Class<XYCycleDataParser>)renderClass;

- (void)updateLayout:(UICollectionViewFlowLayout *)layout;
- (void)registerCellWithReuseIdentifier:(NSString *)identifier;
- (void)reloadData;

- (void)scrollToItemAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)scrollToNextItemAnimated:(BOOL)animated;
- (void)scrollToPreviousItemAnimated:(BOOL)animated;

- (XYCycleCell *)cellForItemAtIndex:(NSInteger)index;
@end

@protocol XYCycleScrollViewDataSource <NSObject>
@required
- (Class<XYCycleDataParser>)cycleScrollView:(XYCycleScrollView *)cycleScrollView classForItemAtIndex:(NSInteger)index;
@end

@protocol XYCycleScrollViewDelegate <NSObject>
@optional
- (void)cycleScrollView:(XYCycleScrollView *)cycleScrollView willScrollToIndex:(NSInteger)index;
- (void)cycleScrollView:(XYCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;
- (void)cycleScrollView:(XYCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
- (void)cycleScrollView:(XYCycleScrollView *)cycleScrollView didSetContentView:(__kindof UIView *)contentView atIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
