//
//  XYNetworkUtility.h
//  XYNetworking
//
//  Created by nevsee on 2018/8/9.
//  Copyright © 2018年 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT void XYLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

@interface XYNetworkUtility : NSObject
+ (NSString *)md5StringFromString:(NSString *)string;
+ (NSStringEncoding)stringEncodingWithResponse:(NSURLResponse *)response;
@end

NS_ASSUME_NONNULL_END
