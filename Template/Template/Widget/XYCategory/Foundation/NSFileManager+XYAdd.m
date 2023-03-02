//
//  NSFileManager+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2017/4/15.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "NSFileManager+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(NSFileManager_XYAdd)

@implementation NSFileManager (XYAdd)

- (unsigned long long)xy_fileSizeAtPath:(NSString *)path {
    if (path.length == 0) return 0;
    
    unsigned long long totalSize = 0;
    if ([self fileExistsAtPath:path]) {
        totalSize += [self attributesOfItemAtPath:path error:nil].fileSize;
        NSDirectoryEnumerator *enumerator = [self enumeratorAtPath:path];
        for (NSString *sub in enumerator.allObjects) {
            NSString *subpath = [path stringByAppendingPathComponent:sub];
            totalSize += [self attributesOfItemAtPath:subpath error:nil].fileSize;
        }
    }
    return totalSize;
}

@end
