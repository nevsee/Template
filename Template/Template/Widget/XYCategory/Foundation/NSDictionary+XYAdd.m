//
//  NSDictionary+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2017/4/15.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "NSDictionary+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(NSDictionary_XYAdd)

@implementation NSDictionary (XYAdd)

- (BOOL)xy_containsObjectForKey:(id)key {
    if (!key) return NO;
    return self[key] != nil;
}

- (NSString *)xy_jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!error) return string;
    }
    return nil;
}


@end
