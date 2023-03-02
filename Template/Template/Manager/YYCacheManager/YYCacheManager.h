//
//  YYCacheManager.h
//  Template
//
//  Created by nevsee on 2021/11/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 缓存管理，所有缓存都基于以下三个目录存放
 */
@interface YYCacheManager : NSObject

/// Documents目录文件夹，iCloud或iTunes备份
/// 路径：.../Documents/AITDBlocks
@property (class, nonatomic, readonly) NSString *documentsPath;

/// Library目录文件夹，iCloud或iTunes不备份
/// 路径：.../Library/AITDBlocks
@property (class, nonatomic, readonly) NSString *libraryPath;

/// Library/Caches目录文件夹，iCloud或iTunes不备份，可能会被系统删除
/// 路径：.../Library/Caches/AITDBlocks
@property (class, nonatomic, readonly) NSString *cachesPath;

/// tmp目录文件夹，iCloud或iTunes不备份，可能会被系统删除
/// 路径：.../tmp/AITDBlocks
@property (class, nonatomic, readonly) NSString *tmpPath;

/**
 创建文件夹
 */
+ (BOOL)createCacheDirectoryAtPath:(NSString *)path backup:(BOOL)backup;

/**
 删除文件（NSString/NSURL）
 */
+ (BOOL)deleteCacheAtPath:(id)path;

/**
 获取文件/文件夹大小
 */
+ (unsigned long long)getFileSizeAtPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
