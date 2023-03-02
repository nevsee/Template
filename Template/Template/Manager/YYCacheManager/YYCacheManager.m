//
//  YYCacheManager.m
//  Template
//
//  Created by nevsee on 2021/11/19.
//

#import "YYCacheManager.h"

@implementation YYCacheManager

+ (NSString *)documentsPath {
    NSString *path = [UIApplication.xy_documentsPath stringByAppendingPathComponent:@"Template"];
    [YYCacheManager createCacheDirectoryAtPath:path backup:YES];
    return path;
}

+ (NSString *)cachesPath {
    NSString *path = [UIApplication.xy_cachesPath stringByAppendingPathComponent:@"Template"];
    [YYCacheManager createCacheDirectoryAtPath:path backup:NO];
    return path;
}

+ (NSString *)libraryPath {
    NSString *path = [UIApplication.xy_libraryPath stringByAppendingPathComponent:@"Template"];
    [YYCacheManager createCacheDirectoryAtPath:path backup:NO];
    [UIApplication xy_addDoNotBackupAttributeForPath:path error:nil];
    return path;
}

+ (NSString *)tmpPath {
    NSString *path = [UIApplication.xy_tmpPath stringByAppendingPathComponent:@"Template"];
    [YYCacheManager createCacheDirectoryAtPath:path backup:NO];
    return path;
}

+ (BOOL)createCacheDirectoryAtPath:(NSString *)path backup:(BOOL)backup {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExisted = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
    if (isExisted && isDirectory) return YES;
    if (!isDirectory) [fileManager removeItemAtPath:path error:nil];
    BOOL result = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    if (result && !backup) [UIApplication xy_addDoNotBackupAttributeForPath:path error:nil];
    return result;
}

+ (BOOL)deleteCacheAtPath:(id)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([path isKindOfClass:NSString.class]) {
        return [fileManager removeItemAtPath:path error:nil];
    } else if ([path isKindOfClass:NSURL.class]) {
        return [fileManager removeItemAtURL:path error:nil];
    }
    return NO;
}

+ (unsigned long long)getFileSizeAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] xy_fileSizeAtPath:path];
}

@end
