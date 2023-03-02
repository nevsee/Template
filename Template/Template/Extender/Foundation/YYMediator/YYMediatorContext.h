//
//  YYMediatorContext.h
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "XYMediator.h"

NS_ASSUME_NONNULL_BEGIN

/// 路由URL安全验证与错误处理
@interface YYMediatorContext : NSObject <XYSafetyURLValidator, XYErrorProcessor>

@end

NS_ASSUME_NONNULL_END
