//
//  YYRequest.h
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import <UIKit/UIKit.h>
#import "YYRequestModel.h"
#import "YYRequestDomin.h"
#import "YYRequestCache.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YYRequestCachePolicy) {
    YYRequestCachePolicyIgnoreCache, ///< 忽略本地缓存
    YYRequestCachePolicyUseCache, ///< 先使用本地缓存后发起请求
    YYRequestCachePolicyOnlyUseCache, ///< 只使用本地缓存且不发起请求，缓存不存在则发起请求
};

typedef NS_ENUM(NSUInteger, YYRequestPageMode) {
    YYRequestPageModeRefresh, ///< 刷新
    YYRequestPageModeLoadMore, ///< 加载更多
};

typedef NS_ENUM(NSUInteger, YYRequestPageDataType) {
    YYRequestPageDataTypeDefault = 0,
    YYRequestPageDataTypeCacheData, ///< 缓存数据
    YYRequestPageDataTypeEmptyData, ///< 空数据
    YYRequestPageDataTypeHasMoreData, ///< 还有更多数据
    YYRequestPageDataTypeNoMoreData, ///< 没有更多数据
};

typedef YYRequestPageDataType (^YYRequestPageDataHandlerBlock)(id data);
typedef NSUInteger (^YYRequestPageDataDescriberBlock)(id data);
typedef void (^YYRequestInterceptorBlock)(NSMutableDictionary *info);

@interface YYRequest : XYBaseRequest
@property (nonatomic, strong, nullable) NSDictionary *parameter; ///< 请求参数
@property (nonatomic, strong, nullable) YYRequestInterceptorBlock parameterInterceptor; ///< 请求参数拦截器
@property (nonatomic, strong, nullable) NSDictionary *header; ///< 请求头
@property (nonatomic, strong, nullable) YYRequestInterceptorBlock headerInterceptor; ///< 请求头拦截器
@property (nonatomic, strong) YYRequestModel *originData; ///< 原始数据
@property (nonatomic, strong, nullable) __kindof id parsedData; ///< 预处理数据
@property (nonatomic, assign) YYRequestCachePolicy cachePolicy; ///< 缓存策略
@property (nonatomic, assign, readonly) BOOL dataFromCache; ///< 数据是否来着缓存

/**
 使用业务模型来初始化请求
 网络请求成功后会自动使用业务模型classType来解析data，最后赋值给originData.data
 @param classType 业务模型类
 */
- (instancetype)initWithType:(nullable Class)classType;

/**
 使用业务模型来初始化请求
 当请求返回数据的data不是字典的时候，data无法解析为业务模型classType，通过给定的
 customKey可以将data包装成字典之后再解析
 @param classType 业务模型类
 @param customKey 自定义key
 @example
 响应数据: @{"code": 200, "msg": "请求成功", "data": "UOd545dfsfsd22336KL"}
 包装数据: @{"code": 200, "msg": "请求成功", "data": {"customKey": "UOd545dfsfsd22336KL"}}
 */
- (instancetype)initWithType:(nullable Class)classType customKey:(nullable NSString *)customKey;

/**
 缓存验证器
 1.cachePolicy = YYRequestCachePolicyIgnoreCache，不验证
 2.cachePolicy = YYRequestCachePolicyUseCache，本地缓存验证通过则使用
 3.cachePolicy = YYRequestCachePolicyOnlyUseCache，本地缓存验证不通过则不使用缓存发起请求
 */
- (nullable id<YYRequestCacheValidation>)requestCacheValidator;

@end

/// 分页请求
@interface YYPageRequest : YYRequest
@property (nonatomic, assign) NSUInteger pageNo; ///< 分页请求页码
@property (nonatomic, assign) NSUInteger pageSize; ///< 分页请求数量
@property (nonatomic, weak, nullable) UIScrollView *bindingListView; ///< 分页列表，自动管理刷新和加载动画取消操作
@property (nonatomic, assign, readonly) YYRequestPageMode pageMode; ///< 分页请求模式
@property (nonatomic, assign, readonly) YYRequestPageDataType pageDataType; ///< 分页请求数据类型

/**
 分页请求1（推荐）
 @param pageMode 分页请求模式
 @param success 分页请求成功回调
 @param failure 分页请求失败回调
 @param dataDescriber 业务数据描述，返回数据总数
 @example
 [self.service startWithPageMode:YYRequestPageModeRefresh success:nil failure:nil dataDescriber:^NSUInteger(id data) {
    YYListModel *list = data;
    return list.total;
 }];
 */
- (void)startWithPageMode:(YYRequestPageMode)pageMode
                  success:(nullable XYRequestCompletionBlock)success
                  failure:(nullable XYRequestCompletionBlock)failure
            dataDescriber:(nullable YYRequestPageDataDescriberBlock)dataDescriber;

/**
 分页请求2
 @param pageMode 分页请求模式
 @param success 分页请求成功回调
 @param failure 分页请求失败回调
 @param dataHandler 由业务方控制分页请求数据类型
 @example
 [self.service startWithPageMode:YYRequestPageModeRefresh success:nil failure:nil dataHandler:^YYRequestPageDataType(id data) {
     YYListModel *list = data;
 
     1.后台返回了数据总数
     if (list.total == 0) {
         return YYRequestPageDataTypeEmptyData;
     } else if (self.service.pageNo * self.service.pageSize < list.total) {
         return YYRequestPageDataTypeHasMoreData;
     } else {
         return YYRequestPageDataTypeNoMoreData;
     }
 
     2.后台没有返回数据总数，这种情况判断是否有更多数据不太准确，可能会额外多一次上拉操作
     if (list.rows.count == 0 && self.service.pageNo == 1) {
         return YYRequestPageDataTypeEmptyData;
     } else if (list.rows.count == self.service.pageSize) {
         return YYRequestPageDataTypeHasMoreData;
     } else {
         return YYRequestPageDataTypeNoMoreData;
     }
 }];
 */
- (void)startWithPageMode:(YYRequestPageMode)pageMode
                  success:(nullable XYRequestCompletionBlock)success
                  failure:(nullable XYRequestCompletionBlock)failure
              dataHandler:(nullable YYRequestPageDataHandlerBlock)dataHandler;

@end

/// 传输请求
@interface YYTransferRequest : YYRequest

/**
 上传文件 formData形式
 @param datas 上传数据（图片NSData，视频NSURL）
 @param names 文件名称
 @param types 文件类型（图片jpg/png等，视频mov/mp4等）
 @param progress 上传进度
 @param success 上传成功回调
 @param failure 上传失败回调
 */
- (void)uploadWithDatas:(NSArray *)datas
                  names:(nullable NSArray *)names
                  types:(nullable NSArray *)types
               progress:(nullable XYRequestProgressBlock)progress
                success:(nullable XYRequestCompletionBlock)success
                failure:(nullable XYRequestCompletionBlock)failure;

/**
 上传文件 NSURLSessionUploadTask
 @param body 上传文件的路径或数据（NSURL/NSData）
 @param progress 上传进度
 @param success 上传成功回调
 @param failure 上传失败回调
 */
- (void)uploadWithBody:(id)body
              progress:(nullable XYRequestProgressBlock)progress
               success:(nullable XYRequestCompletionBlock)success
               failure:(nullable XYRequestCompletionBlock)failure;

/**
 下载文件 NSURLSessionDownloadTask
 @param filePath 下载文件的保存路径（NSString/NSURL）
 @param progress 下载进度
 @param success 下载成功回调
 @param failure 下载失败回调
 */
- (void)downloadWithFilePath:(id)filePath
                    progress:(nullable XYRequestProgressBlock)progress
                     success:(nullable XYRequestCompletionBlock)success
                     failure:(nullable XYRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
