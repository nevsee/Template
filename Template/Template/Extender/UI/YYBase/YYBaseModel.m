//
//  YYBaseModel.m
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "YYBaseModel.h"

@implementation YYBaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([value isEqual:[NSNull null]] || [value isKindOfClass:[NSNull class]]) {
        [super setValue:@"" forKey:key];
    } else {
        [super setValue:value forKey:key];
    }
}

@end
