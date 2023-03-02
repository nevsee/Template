//
//  NSData+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2020/10/15.
//  Copyright © 2020 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (XYAdd)

#pragma mark Encode and decode

/**
 Returns a dictionary or an array which is decoded from receiver's contents.
 Returns nil if an error occurs.
 */
- (nullable id)xy_jsonValueDecoded;

#pragma mark Other

/**
 Returns a string using UTF-8 encoding.
 */
- (nullable NSString *)xy_stringValue;

@end

NS_ASSUME_NONNULL_END
