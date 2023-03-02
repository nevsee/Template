//
//  YYUserManager.h
//  AITDBlocks
//
//  Created by nevsee on 2022/9/21.
//

#import <Foundation/Foundation.h>
#import "YYUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSNotificationName const YYUserInfoDidChangeNofication; ///< 用户信息改变通知
FOUNDATION_EXTERN NSNotificationName const YYUserDidLoginNofication; ///< 用户登录通知
FOUNDATION_EXTERN NSNotificationName const YYUserDidLogoutNofication; ///< 用户注销通知

@interface YYUserManager : NSObject

/// 用户信息
@property (nonatomic, strong, readonly) YYUserInfo *info;

/// 用户是否登录
@property (nonatomic, assign, readonly) BOOL isLogin;


+ (instancetype)defaultManager;

/**
 更新用户信息
 当本地信息为空时，会缓存本地，发送YYUserDidLoginNofication通知；
 当本地信息不为空且信息有变动时，会更新本地缓存，发送YYUserInfoDidChangedNofication通知；
 */
- (void)updateInfoWithData:(id)data;
- (void)updateInfoValue:(id)value forKey:(NSString *)key;

/**
 清除用户信息
 删除本地缓存信息，发送YYUserDidLogoutNofication通知；
 */
- (void)cleanInfo;

@end

NS_ASSUME_NONNULL_END
