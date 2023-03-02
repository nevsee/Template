//
//  NSObject+XYBadge.h
//  XYWidget
//
//  Created by nevsee on 2022/11/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XYBadgeHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XYBadge)

- (nullable id)xy_badgeValueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
