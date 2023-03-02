//
//  XYShimmer.h
//  XYWidget
//
//  Created by nevsee on 2017/5/25.
//

#if __has_include(<XYShimmer/XYShimmer.h>)
FOUNDATION_EXPORT double XYShimmerVersionNumber;
FOUNDATION_EXPORT const unsigned char XYShimmerVersionString[];
#import <XYShimmer/XYShimmerDescriber.h>
#import <XYShimmer/XYShimmerLayer.h>
#import <XYShimmer/XYShimmerView.h>
#else
#import "XYShimmerDescriber.h"
#import "XYShimmerLayer.h"
#import "XYShimmerView.h"
#endif
