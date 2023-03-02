//
//  XYArchiver.m
//  XYStorage
//
//  Created by nevsee on 2020/10/8.
//  Copyright © 2020 nevsee. All rights reserved.
//

#import "XYArchiver.h"
#import <UIKit/UIKit.h>

#define Lock() dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define Unlock() dispatch_semaphore_signal(self->_lock)

@implementation XYArchiver {
    dispatch_queue_t _queue;
    dispatch_semaphore_t _lock;
}

- (instancetype)initWithPath:(NSString *)path {
    if (path.length == 0) return nil;
    self = [super init];
    
    _path = path;
    _queue = dispatch_queue_create("com.nevsee.archiver", DISPATCH_QUEUE_CONCURRENT);
    _lock = dispatch_semaphore_create(1);
    
    if (![self directoryCreates]) return nil;
    return self;
}

#pragma mark # Public

- (id)objectForKey:(NSString *)key classes:(NSArray<Class> *)classes {
    if (key.length == 0 || classes.count == 0) return nil;
    
    Lock();
    NSData *data = [self fileReadsWithName:key];
    Unlock();
    if (!data) return nil;
    
    id obj;
    if (@available(iOS 11, *)) {
        obj = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithArray:classes] fromData:data error:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
#pragma clang diagnostic pop
    }
    return obj;
}

- (void)objectForKey:(NSString *)key classes:(NSArray<Class> *)classes completion:(XYArchiverCompletion)completion {
    dispatch_async(_queue, ^{
        id obj = [self objectForKey:key classes:classes];
        BOOL succeed = (obj != nil);
        if (completion) completion(succeed, succeed ? @[obj] : nil);
    });
}

- (NSArray *)objectForKeys:(NSArray<NSString *> *)keys classes:(NSArray<Class> *)classes {
    if (keys.count == 0 || classes.count == 0) return nil;
    
    NSMutableArray *results = [NSMutableArray array];
    for (NSString *key in keys) {
        id obj = [self objectForKey:key classes:classes];
        if (obj) [results addObject:obj];
    }
    return results;
}

- (void)objectForKeys:(NSArray *)keys classes:(NSArray<Class> *)classes completion:(XYArchiverCompletion)completion {
    dispatch_async(_queue, ^{
        NSArray *results = [self objectForKeys:keys classes:classes];
        BOOL succeed = (results.count > 0);
        if (completion) completion(succeed, results);
    });
}

- (BOOL)saveObject:(id)object forKey:(NSString *)key {
    if (!object || key.length == 0) return NO;
    
    NSData *data = nil;
    if (@available(iOS 11, *)) {
        data = [NSKeyedArchiver archivedDataWithRootObject:object requiringSecureCoding:YES error:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        data = [NSKeyedArchiver archivedDataWithRootObject:object];
#pragma clang diagnostic pop
    }
    if (!data) return NO;
    
    Lock();
    BOOL succeed = [self fileWritesWithName:key data:data];
    Unlock();
    
    return succeed;
}

- (void)saveObject:(id)object forKey:(NSString *)key completion:(XYArchiverCompletion)completion {
    dispatch_async(_queue, ^{
        BOOL succeed = [self saveObject:object forKey:key];
        if (completion) completion (succeed, nil);
    });
}

- (void)saveObjects:(NSArray *)objects forKeys:(NSArray *)keys {
    if (objects.count != keys.count || objects.count == 0 || keys.count == 0) return;
    
    for (NSInteger i = 0; i < objects.count; i++) {
        [self saveObject:objects[i] forKey:keys[i]];
    }
}

- (void)saveObjects:(NSArray *)objects forKeys:(NSArray<NSString *> *)keys completion:(XYArchiverCompletion)completion {
    dispatch_async(_queue, ^{
        [self saveObjects:objects forKeys:keys];
        if (completion) completion (YES, nil);
    });
}

- (BOOL)deleteObjectForKey:(NSString *)key {
    if (key.length == 0) return NO;
    
    Lock();
    BOOL succeed = YES;
    BOOL exists = [self fileExistsWithName:key];
    if (exists) succeed = [self fileDeletesWithName:key];
    Unlock();
    
    return succeed;
}

- (void)deleteObjectForKey:(NSString *)key completion:(XYArchiverCompletion)completion {
    dispatch_async(_queue, ^{
        BOOL succeed = [self deleteObjectForKey:key];
        if (completion) completion (succeed, nil);
    });
}

- (void)deleteObjectForKeys:(NSArray<NSString *> *)keys {
    if (keys.count == 0) return;
    
    for (NSString *key in keys) {
        [self deleteObjectForKey:key];
    }
}

- (void)deleteObjectForKeys:(NSArray<NSString *> *)keys completion:(XYArchiverCompletion)completion {
    dispatch_async(_queue, ^{
        [self deleteObjectForKeys:keys];
        if (completion) completion (YES, nil);
    });
}

- (void)deleteAllObjects {
    Lock();
    [self fileAllRemoves];
    Unlock();
}

- (void)deleteAllObjectsWithCompletion:(XYArchiverCompletion)completion {
    dispatch_async(_queue, ^{
        [self deleteAllObjects];
        if (completion) completion (YES, nil);
    });
}

- (BOOL)containsValueForKey:(NSString *)key {
    Lock();
    BOOL exists = [self fileExistsWithName:key];
    Unlock();
    
    return exists;
}

- (void)containsValueForKey:(NSString *)key completion:(XYArchiverCompletion)completion {
    dispatch_async(_queue, ^{
        BOOL exists = [self containsValueForKey:key];
        if (completion) completion (exists, nil);
    });
}

#pragma mark # Private

- (BOOL)fileExistsWithName:(NSString *)filename {
    NSString *path = [_path stringByAppendingPathComponent:filename];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (BOOL)fileWritesWithName:(NSString *)filename data:(NSData *)data {
    NSString *path = [_path stringByAppendingPathComponent:filename];
    return [data writeToFile:path atomically:NO];
}

- (NSData *)fileReadsWithName:(NSString *)filename {
    NSString *path = [_path stringByAppendingPathComponent:filename];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

- (BOOL)fileDeletesWithName:(NSString *)filename {
    NSString *path = [_path stringByAppendingPathComponent:filename];
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (void)fileAllRemoves {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *contents = [manager contentsOfDirectoryAtPath:_path error:nil];
    for (NSString *path in contents) {
        NSString *fullPath = [_path stringByAppendingPathComponent:path];
        [manager removeItemAtPath:fullPath error:nil];
    }
}

- (BOOL)directoryCreates {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    [manager createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:&error];
    return (error == nil);
}

@end

