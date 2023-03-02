//
//  NSData+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2020/10/15.
//  Copyright © 2020 nevsee. All rights reserved.
//

#import "NSData+XYAdd.h"
#import "NSString+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(NSData_XYAdd)

@implementation NSData (XYAdd)

- (id)xy_jsonValueDecoded {
    return [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:nil];
}

- (NSString *)xy_stringValue {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

@end
