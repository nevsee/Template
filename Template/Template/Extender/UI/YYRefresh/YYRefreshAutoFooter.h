//
//  YYRefreshAutoFooter.h
//  Template
//
//  Created by nevsee on 2021/11/19.
//

#import "MJRefreshAutoFooter.h"

NS_ASSUME_NONNULL_BEGIN

/**
 1.自定义加载动画；
 2.绑定请求类，根据请求完成状态和数据状态来自动管理加载控件内容显示及结束加载；
 */
@interface YYRefreshAutoFooter : MJRefreshAutoFooter
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action bindingService:(YYPageRequest *)service;
@end

NS_ASSUME_NONNULL_END
