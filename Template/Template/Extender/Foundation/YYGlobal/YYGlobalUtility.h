//
//  YYGlobalUtility.h
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYGlobalUtility : NSObject
@property (class, nonatomic, readonly, nullable) YYAppDelegate *delegate;
@property (class, nonatomic, readonly, nullable) YYAppLauncher *launcher;
@end

NS_ASSUME_NONNULL_END
