//
//  XYDatabase.h
//  XYStorage
//
//  Created by nevsee on 2020/10/8.
//  Copyright © 2020 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<FMDB.h>)
#import <FMDB.h>
#else
#import "FMDB.h"
#endif

NS_ASSUME_NONNULL_BEGIN

typedef void(^XYDatabaseCompletion)(BOOL succeed, NSArray * _Nullable results);

/**
 A transformer protocol to transform the query data from the database.
 */
@protocol XYDatabaseTransformer <NSObject>
@required
- (id)transformedObjectWithResult:(NSDictionary *)result;
@end

/**
 XYDatabase provides sync and async ways to operate the database.
 It is thread-safe.
 */
@interface XYDatabase : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 The path of the database.
 */
@property (nonatomic, strong, readonly) NSString *path;

/**
 Create a new instance based on the specified path.
 @note If the instance for the specified path already exists in memory,
 this method will return it directly, instead of creating a new instance.
 */
- (instancetype)initWithPath:(NSString *)path;

/**
 Closes the database.
 */
- (void)close;

/**
 This method performs database update operation on queue. (i.e. such as `UPDATE`, `INSERT`, or `DELETE`)
 It may blocks the calling thread until the operation finished.
 */
- (BOOL)executeUpdateWithSQL:(NSString *)sql;

/**
 This method performs database update operation on queue. (i.e. such as `UPDATE`, `INSERT`, or `DELETE`)
 It returns immediately and invoke the passed block in background queue when the operation finished.
 */
- (void)executeUpdateWithSQL:(NSString *)sql compeletion:(nullable XYDatabaseCompletion)completion;

/**
 This method performs database update operations on queue, using transactions.
 It may blocks the calling thread until the operation finished.
 */
- (BOOL)executeUpdateWithSQLs:(NSArray<NSString *> *)sqls;

/**
 This method performs database update operations on queue, using transactions.
 It returns immediately and invoke the passed block in background queue when the operation finished.
 */
- (void)executeUpdateWithSQLs:(NSArray<NSString *> *)sqls compeletion:(nullable XYDatabaseCompletion)completion;

/**
 This method performs database query operation on queue. (i.e. such as `SELECT`)
 It may blocks the calling thread until the operation finished.
 @param transformer A transformer invoked to do additional query data process.
 */
- (nullable id)executeQueryWithSQL:(NSString *)sql transformer:(nullable id<XYDatabaseTransformer>)transformer;

/**
 This method performs database query operation on queue. (i.e. such as `SELECT`)
 It returns immediately and invoke the passed block in background queue when the operation finished.
 @param transformer A transformer invoked to do additional query data process
 */
- (void)executeQueryWithSQL:(NSString *)sql transformer:(nullable id<XYDatabaseTransformer>)transformer compeletion:(nullable XYDatabaseCompletion)completion;

/**
 This method performs database query operations on queue, using transactions.
 It may blocks the calling thread until the operation finished.
 @param transformer A transformer invoked to do additional query data process.
 */
- (nullable NSArray *)executeQueryWithSQLs:(NSArray<NSString *> *)sqls transformer:(nullable id<XYDatabaseTransformer>)transformer;

/**
 This method performs database query operations on queue, using transactions.
 It returns immediately and invoke the passed block in background queue when the operation finished.
 @param transformer A transformer invoked to do additional query data process.
 */
- (void)executeQueryWithSQLs:(NSArray<NSString *> *)sqls transformer:(nullable id<XYDatabaseTransformer>)transformer compeletion:(nullable XYDatabaseCompletion)completion;

@end

NS_ASSUME_NONNULL_END
