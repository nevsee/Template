//
//  NSFileManager+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2017/4/15.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (XYAdd)

/**
 Returns the total size of the file in the given path.
 @note This method will count all file sizes, including folders.
 */
- (unsigned long long)xy_fileSizeAtPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
