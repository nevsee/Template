//
//  XYBadgeDescriber.h
//  XYWidget
//
//  Created by nevsee on 2020/7/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XYBadgeDescriber <NSObject>
/// Text
@property (nonatomic, strong, nullable) NSString *xy_badgeValue;
@property (nonatomic, strong, nullable) UIColor *xy_badgeBackgroundColor;
@property (nonatomic, strong, nullable) UIColor *xy_badgeTextColor;
@property (nonatomic, strong, nullable) UIFont *xy_badgeFont;
@property (nonatomic, assign) UIEdgeInsets xy_badgeContentEdgeInsets;
@property (nonatomic, assign) CGPoint xy_badgeOffset;
@property (nonatomic, assign) CGPoint xy_badgeOffsetLandscape;
@property (nonatomic, strong, readonly, nullable) UILabel *xy_badgeLabel;
/// Dot
@property (nonatomic, assign) BOOL xy_badgeShowIndicator;
@property (nonatomic, strong, nullable) UIColor *xy_badgeIndicatorColor;
@property (nonatomic, assign) CGSize xy_badgeIndicatorSize;
@property (nonatomic, assign) CGPoint xy_badgeIndicatorOffset;
@property (nonatomic, assign) CGPoint xy_badgeIndicatorOffsetLandscape;
@property (nonatomic, strong, readonly, nullable) UIView *xy_badgeIndicatorView;
@end

NS_ASSUME_NONNULL_END
