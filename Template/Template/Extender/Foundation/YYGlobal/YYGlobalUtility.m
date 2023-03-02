//
//  YYGlobalUtility.m
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "YYGlobalUtility.h"
#import "YYAppDispatcher.h"

@implementation YYGlobalUtility

+ (YYAppDelegate *)delegate {
    return (YYAppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (YYAppLauncher *)launcher {
    NSDictionary *objs = [YYAppDispatcher defaultDispatcher].objs;
    return [objs objectForKey:@"YYAppLauncher"];
}

@end
