//
//  YYGlobalUtility+Image.h
//  Template
//
//  Created by nevsee on 2022/1/25.
//

#import "YYGlobalUtility.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYGlobalUtility (Image)

/**
 获取图片格式
 @param image 图片数据（UIImage / NSData）
 */
+ (nullable NSString *)getImageFormat:(id)image;

@end

NS_ASSUME_NONNULL_END
