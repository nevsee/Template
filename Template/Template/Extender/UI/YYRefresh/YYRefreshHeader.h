//
//  YYRefreshHeader.h
//  Template
//
//  Created by nevsee on 2021/11/19.
//

#import "MJRefreshHeader.h"

NS_ASSUME_NONNULL_BEGIN

/**
 1.自定义刷新动画；
 2.绑定请求类，监听请求完成状态来自动结束刷新；
 */
@interface YYRefreshHeader : MJRefreshHeader
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action bindingService:(YYRequest*)service;
@end

NS_ASSUME_NONNULL_END
