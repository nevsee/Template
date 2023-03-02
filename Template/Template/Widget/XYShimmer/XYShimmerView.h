//
//  XYShimmerLayer.h
//  XYWidget
//
//  Created by nevsee on 2017/5/25.
//

#import <UIKit/UIKit.h>
#import "XYShimmerDescriber.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYShimmerView : UIView <XYShimmerDescriber>
@property (nonatomic, strong) UIView *contentView; ///< The content view to be shimmered.
@end

NS_ASSUME_NONNULL_END
