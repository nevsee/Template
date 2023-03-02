//
//  NSUserDefaults+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2017/4/15.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "NSUserDefaults+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(NSUserDefaults_XYAdd)

@implementation NSUserDefaults (XYAdd)

+ (void)xy_removeAllObjects {
    NSString *domain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domain];
}

@end
