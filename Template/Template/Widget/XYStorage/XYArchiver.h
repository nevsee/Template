//
//  XYArchiver.h
//  XYStorage
//
//  Created by nevsee on 2020/10/8.
//  Copyright © 2020 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XYArchiverCompletion)(BOOL succeed, NSArray * _Nullable results);

/**
 XYArchiver provides async and sync access to data using by NSKeyedArchiver and NSKeyedUnarchiver.
 It is thread-safe.
 */
@interface XYArchiver : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 The path of the archived file.
 */
@property (nonatomic, strong, readonly) NSString *path;

/**
 Create a new instance based on the specified path.
 */
- (nullable instancetype)initWithPath:(NSString *)path;

/**
 Get the value according to the given key.
 */
- (nullable id)objectForKey:(NSString *)key classes:(NSArray<Class> *)classes;
- (void)objectForKey:(NSString *)key classes:(NSArray<Class> *)classes completion:(nullable XYArchiverCompletion)completion;

/**
 Get the values according to the given keys.
 @note If an error occurs in the queries, it will be ignored.
 */
- (nullable NSArray *)objectForKeys:(NSArray<NSString *> *)keys classes:(NSArray<Class> *)classes;
- (void)objectForKeys:(NSArray *)keys classes:(NSArray<Class> *)classes completion:(nullable XYArchiverCompletion)completion;

/**
 Set the value according to the given key.
 */
- (BOOL)saveObject:(id)object forKey:(NSString *)key;
- (void)saveObject:(id)object forKey:(NSString *)key completion:(nullable XYArchiverCompletion)completion;

/**
 Set the values according to the given keys.
 @note If an error occurs in the updates, it will be ignored.
 */
- (void)saveObjects:(NSArray *)objects forKeys:(NSArray<NSString *> *)keys;
- (void)saveObjects:(NSArray *)objects forKeys:(NSArray<NSString *> *)keys completion:(nullable XYArchiverCompletion)completion;

/**
 Delete the file according to the given key.
 */
- (BOOL)deleteObjectForKey:(NSString *)key;
- (void)deleteObjectForKey:(NSString *)key completion:(nullable XYArchiverCompletion)completion;

/**
 Delete the files according to the given keys.
 @note If an error occurs in the deletions, it will be ignored.
 */
- (void)deleteObjectForKeys:(NSArray<NSString *> *)keys;
- (void)deleteObjectForKeys:(NSArray<NSString *> *)keys completion:(nullable XYArchiverCompletion)completion;

/**
 Delete all files in the directory.
 @note If an error occurs in the deletions, it will be ignored.
 */
- (void)deleteAllObjects;
- (void)deleteAllObjectsWithCompletion:(nullable XYArchiverCompletion)completion;

/**
 Check if the file exists.
 */
- (BOOL)containsValueForKey:(NSString *)key;
- (void)containsValueForKey:(NSString *)key completion:(nullable XYArchiverCompletion)completion;

@end

NS_ASSUME_NONNULL_END
