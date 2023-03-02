//
//  NSArray+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2017/4/15.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "NSArray+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(NSArray_XYAdd)

@implementation NSArray (XYAdd)

- (CGFloat)xy_sum {
    return [[self valueForKeyPath:@"@sum.floatValue"] floatValue];
}

- (CGFloat)xy_avg {
    return [[self valueForKeyPath:@"@avg.floatValue"] floatValue];
}

- (CGFloat)xy_max {
    return [[self valueForKeyPath:@"@max.floatValue"] floatValue];
}

- (CGFloat)xy_min {
    return [[self valueForKeyPath:@"@min.floatValue"] floatValue];
}

+ (instancetype)xy_arrayWithObjects:(id)object, ... {
    void (^addObjectToArrayBlock)(NSMutableArray *array, id obj) = ^void(NSMutableArray *array, id obj) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [array addObjectsFromArray:obj];
        } else {
            [array addObject:obj];
        }
    };
    
    NSMutableArray *temps = [NSMutableArray array];
    addObjectToArrayBlock(temps, object); // Add first obj
    
    va_list args;
    va_start(args, object);
    id arg;
    while ((arg = va_arg(args, id))) {
        addObjectToArrayBlock(temps, arg);
    }
    va_end(args);
    
    if ([self isKindOfClass:[NSMutableArray class]]) {
        return temps;
    }
    return temps.copy;
}

- (NSArray *)xy_filteredArrayUsingBlock:(BOOL (NS_NOESCAPE ^)(id, NSInteger))block {
    if (!block) return self;
    
    NSMutableArray *results = [NSMutableArray array];
    for (NSInteger i = 0; i < self.count; i++) {
        id item = self[i];
        if (block(item, i)) [results addObject:item];
    }
    return results.copy;
}

- (NSArray *)xy_refinedArrayUsingBlock:(id (NS_NOESCAPE ^)(id, NSInteger))block {
    if (!block) return self;
    
    NSMutableArray *results = [NSMutableArray array];
    for (NSInteger i = 0; i < self.count; i++) {
        id item = self[i];
        id obj = block(item, i);
        if (obj) [results addObject:obj];
    }
    return results.copy;
}

- (NSString *)xy_componentsJoinedByString:(NSString *)string usingBlock:(NSString * (NS_NOESCAPE ^)(id, NSInteger))block {
    if (!string) return nil;
    
    NSMutableString *result = [NSMutableString string];
    for (NSInteger i = 0; i < self.count; i++) {
        id item = self[i];
        NSString *itemString = block ? block(item, i) : item;
        if (!itemString || ![itemString isKindOfClass:NSString.class]) continue;
        if (i > 0) [result appendString:string];
        [result appendString:itemString];
    }
    return  result.copy;
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

- (id)xy_safeObjectAtIndex:(NSUInteger)index {
    if (self.count == 0) return nil;
    if (index >= self.count || index < 0) return nil;
    return [self objectAtIndex:index];
}

- (id)xy_randomObject {
    if (self.count == 0) return nil;
    return self[arc4random_uniform((u_int32_t)self.count)];
}

@end

@implementation NSMutableArray (XYAdd)

- (void)xy_moveObjectAtIndex:(NSUInteger)sourceIndex toIndex:(NSUInteger)destinationIndex {
    if (sourceIndex == destinationIndex) return;
    if (sourceIndex >= self.count || destinationIndex >= self.count) return;
    id sourceObj = [self objectAtIndex:sourceIndex];
    [self removeObjectAtIndex:sourceIndex];
    [self insertObject:sourceObj atIndex:destinationIndex];
}

- (void)xy_reverse {
    NSUInteger mid = floor(self.count / 2.f);
    for (NSInteger i = 0; i < mid; i ++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:self.count - (i + 1)];
    }
}

@end
