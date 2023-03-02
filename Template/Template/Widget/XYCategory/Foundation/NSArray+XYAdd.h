//
//  NSArray+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2017/4/15.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define XYArraySafeMake(arr) ([arr isKindOfClass:[NSArray class]] && arr ? arr : @[])

@interface NSArray<ObjectType> (XYAdd)

@property (nonatomic, readonly) CGFloat xy_sum;
@property (nonatomic, readonly) CGFloat xy_avg;
@property (nonatomic, readonly) CGFloat xy_max;
@property (nonatomic, readonly) CGFloat xy_min;

/**
 Creates and returns an array with some objects.
 @note If an object is NSArray or NSMutableArray, that its items will be added to the instance.
 */
+ (instancetype)xy_arrayWithObjects:(ObjectType)object, ...;

/**
 Returns an array with filtered objects.
 */
- (NSArray *)xy_filteredArrayUsingBlock:(BOOL (NS_NOESCAPE ^)(ObjectType item, NSInteger index))block;

/**
 Returns an array with refined objects.
 */
- (NSArray *)xy_refinedArrayUsingBlock:(ObjectType (NS_NOESCAPE ^)(ObjectType item, NSInteger index))block;

/**
 Joins this array by the given string.
 */
- (nullable NSString *)xy_componentsJoinedByString:(NSString *)string usingBlock:(nullable NSString * (NS_NOESCAPE ^)(ObjectType item, NSInteger index))block;

/**
 Converts this array to the JSON string. nil if an error occurs.
 @note
 - Top level object is an NSArray or NSDictionary
 - All objects are NSString, NSNumber, NSArray, NSDictionary, or NSNull
 - All dictionary keys are NSStrings
 - NSNumbers are not NaN or infinity
 */
- (nullable NSString *)xy_jsonStringEncoded;

/**
 Returns the object at the given index.
 */
- (nullable ObjectType)xy_safeObjectAtIndex:(NSUInteger)index;

/**
 Returns the object located at a random index.
 */
- (nullable id)xy_randomObject;

@end

@interface NSMutableArray<ObjectType> (XYAdd)

/**
 Moves the object to the destination index.
 */
- (void)xy_moveObjectAtIndex:(NSUInteger)sourceIndex toIndex:(NSUInteger)destinationIndex;

/**
 Reverses the index of object in this array.
 */
- (void)xy_reverse;

@end

NS_ASSUME_NONNULL_END
