//
//  XYDatabase.m
//  XYStorage
//
//  Created by nevsee on 2020/10/8.
//  Copyright © 2020 nevsee. All rights reserved.
//

#import "XYDatabase.h"

static NSMapTable *_databaseMap;
static dispatch_semaphore_t _databaseLock;

static void XYDatabaseInit() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _databaseLock = dispatch_semaphore_create(1);
        _databaseMap = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory
                                                 valueOptions:NSPointerFunctionsWeakMemory
                                                     capacity:0];
    });
}

static XYDatabase *XYDatabaseGet(NSString *path) {
    if (path.length == 0) return nil;
    XYDatabaseInit();
    dispatch_semaphore_wait(_databaseLock, DISPATCH_TIME_FOREVER);
    id db = [_databaseMap objectForKey:path];
    dispatch_semaphore_signal(_databaseLock);
    return db;
}

static void XYDatabaseSet(XYDatabase *db) {
    if (db.path.length == 0) return;
    XYDatabaseInit();
    dispatch_semaphore_wait(_databaseLock, DISPATCH_TIME_FOREVER);
    [_databaseMap setObject:db forKey:db.path];
    dispatch_semaphore_signal(_databaseLock);
}

#define dispatch_async_option(async, block)\
if (async) {\
    dispatch_async(self->_queue, block);\
} else {\
    if (block) block();\
}\


@implementation XYDatabase {
    dispatch_queue_t _queue;
    FMDatabaseQueue *_dbQueue;
}

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (!self) return nil;
    
    XYDatabase *db = XYDatabaseGet(path);
    if (db) return db;
    
    NSString *directoryPath = [path stringByDeletingLastPathComponent];
    if (![self directoryCreatesWithPath:directoryPath]) return nil;
    
    _path = path;
    _queue = dispatch_queue_create("com.nevsee.database", DISPATCH_QUEUE_CONCURRENT);
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];

    XYDatabaseSet(self);
    return self;
}

- (void)dealloc {
    [_dbQueue close];
    _queue = NULL;
    _path = nil;
    _dbQueue = nil;
}

- (void)close {
    [_dbQueue close];
}

#pragma mark # Update

- (BOOL)executeUpdateWithSQL:(NSString *)sql {
    __block BOOL result = YES;
    [self executeWithSQL:sql update:YES async:NO transformer:nil compeletion:^(BOOL succeed, NSArray *results) {
        result = succeed;
    }];
    return result;
}

- (BOOL)executeUpdateWithSQLs:(NSArray *)sqls {
    __block BOOL result = YES;
    [self executeWithSQLs:sqls update:YES async:NO transformer:nil compeletion:^(BOOL succeed, NSArray *results) {
        result = succeed;
    }];
    return result;
}

- (void)executeUpdateWithSQL:(NSString *)sql compeletion:(XYDatabaseCompletion)completion {
    [self executeWithSQL:sql update:YES async:YES transformer:nil compeletion:completion];
}

- (void)executeUpdateWithSQLs:(NSArray *)sqls compeletion:(XYDatabaseCompletion)completion {
    [self executeWithSQLs:sqls update:YES async:YES transformer:nil compeletion:completion];
}

#pragma mark # Query

- (id)executeQueryWithSQL:(NSString *)sql transformer:(id<XYDatabaseTransformer>)transformer {
    __block id result = nil;
    [self executeWithSQL:sql update:NO async:NO transformer:transformer compeletion:^(BOOL succeed, NSArray *results) {
        if (succeed) result = results.firstObject;
    }];
    return result;
}

- (NSArray *)executeQueryWithSQLs:(NSArray<NSString *> *)sqls transformer:(id<XYDatabaseTransformer>)transformer {
    __block NSArray *results = nil;
    [self executeWithSQLs:sqls update:NO async:NO transformer:transformer compeletion:^(BOOL succeed, NSArray *results) {
        if (succeed) results = results;
    }];
    return results;
}

- (void)executeQueryWithSQL:(NSString *)sql transformer:(id<XYDatabaseTransformer>)transformer compeletion:(XYDatabaseCompletion)completion {
    [self executeWithSQL:sql update:NO async:YES transformer:transformer compeletion:completion];
}

- (void)executeQueryWithSQLs:(NSArray<NSString *> *)sqls transformer:(id<XYDatabaseTransformer>)transformer compeletion:(XYDatabaseCompletion)completion {
    [self executeWithSQLs:sqls update:NO async:YES transformer:transformer compeletion:completion];
}

#pragma mark # Private

- (void)executeWithSQL:(NSString *)sql update:(BOOL)update async:(BOOL)async transformer:(id<XYDatabaseTransformer>)transformer compeletion:(XYDatabaseCompletion)completion {
    if (sql.length == 0) {
        if (completion) completion(NO, nil);
        return;
    };
    
    dispatch_async_option(async, ^{
        [self->_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            BOOL succeed = YES;
            NSMutableArray *results = nil;
            
            if (update) {
                succeed = [db executeUpdate:sql];
            } else {
                FMResultSet *set = [db executeQuery:sql];
                succeed = (set != nil);
                if (succeed) {
                    results = [NSMutableArray array];
                    while ([set next]) {
                        NSDictionary *dic = set.resultDictionary;
                        if (dic) {
                            if (transformer) {
                                id data = [transformer transformedObjectWithResult:dic];
                                if (data) [results addObject:data];
                                else [results addObject:dic];
                            } else {
                                [results addObject:dic];
                            }
                        }
                    }
                }
                [set close];
            }
            if (completion) completion(succeed, results);
        }];
    });
}

- (void)executeWithSQLs:(NSArray *)sqls update:(BOOL)update async:(BOOL)async transformer:(id<XYDatabaseTransformer>)transformer compeletion:(XYDatabaseCompletion)completion {
    if (sqls.count == 0) {
        if (completion) completion(NO, nil);
        return;
    };
    
    dispatch_async_option(async, ^{
        [self->_dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            BOOL succeed = YES;
            NSMutableArray *results = nil;
            
            for (NSString *sql in sqls) {
                if (update) {
                    succeed = [db executeUpdate:sql];
                    if (!succeed) {
                        *rollback = YES;
                        break;
                    }
                } else {
                    FMResultSet *set = [db executeQuery:sql];
                    succeed = (set != nil);
                    if (succeed) {
                        results = [NSMutableArray array];
                        while ([set next]) {
                            NSDictionary *dic = set.resultDictionary;
                            if (dic) {
                                if (transformer) {
                                    id data = [transformer transformedObjectWithResult:dic];
                                    if (data) [results addObject:data];
                                    else [results addObject:dic];
                                } else {
                                    [results addObject:dic];
                                }
                            }
                        }
                    } else {
                        *rollback = YES;
                        break;
                    }
                    [set close];
                }
            }
            if (completion) completion(succeed, results);
        }];
    });
}

- (BOOL)directoryCreatesWithPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    return (error == nil);
}

@end
