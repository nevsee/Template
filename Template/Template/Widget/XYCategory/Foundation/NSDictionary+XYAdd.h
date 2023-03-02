//
//  NSDictionary+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2017/4/15.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define XYDictionarySafeMake(dic) ([dic isKindOfClass:[NSDictionary class]] && dic ? dic : @{})

@interface NSDictionary<KeyType, ObjectType> (XYAdd)

/**
 Returns YES if the dictionary has an object for this key.
 */
- (BOOL)xy_containsObjectForKey:(KeyType)key;

/**
 Converts this dictionary to the JSON string. nil if an error occurs.
 @note
 - Top level object is an NSArray or NSDictionary
 - All objects are NSString, NSNumber, NSArray, NSDictionary, or NSNull
 - All dictionary keys are NSStrings
 - NSNumbers are not NaN or infinity
 */
- (nullable NSString *)xy_jsonStringEncoded;

@end

NS_ASSUME_NONNULL_END

