//
//  XYShimmerLayer.h
//  XYWidget
//
//  Created by nevsee on 2017/5/25.
//

#import <QuartzCore/QuartzCore.h>
#import "XYShimmerDescriber.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYShimmerLayer : CALayer <XYShimmerDescriber>
@property (nonatomic, strong) CALayer *contentLayer; ///< The content layer to be shimmered.
@end

NS_ASSUME_NONNULL_END
