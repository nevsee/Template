//
//  XYBadge.h
//  XYWidget
//
//  Created by nevsee on 2019/4/12.
//

#if __has_include(<XYBadge/XYBadge.h>)
FOUNDATION_EXPORT double XYBadgeVersionNumber;
FOUNDATION_EXPORT const unsigned char XYBadgeVersionString[];
#import <XYBadge/UIView+XYBadge.h>
#import <XYBadge/UIBarItem+XYBadge.h>
#import <XYBadge/NSObject+XYBadge.h>
#else
#import "UIView+XYBadge.h"
#import "UIBarItem+XYBadge.h"
#import "NSObject+XYBadge.h"
#endif
