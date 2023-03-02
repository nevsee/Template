//
//  YYRequestModel.h
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "YYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 请求响应码
typedef NS_ENUM(NSInteger, YYResponseCode) {
    YYResponseCodeSuccess = 200, ///< 成功
};

/// 请求响应数据
@interface YYRequestModel : YYBaseModel
@property (nonatomic, assign) YYResponseCode code;
@property (nonatomic, copy, nullable) NSString *msg;
@property (nonatomic, strong, nullable) __kindof id data;
@end

NS_ASSUME_NONNULL_END
