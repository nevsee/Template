//
//  YYUserManager.m
//  AITDBlocks
//
//  Created by nevsee on 2022/9/21.
//

#import "YYUserManager.h"

NSNotificationName const YYUserInfoDidChangeNofication = @"com.aitdblocks.user.info.change";
NSNotificationName const YYUserDidLoginNofication = @"com.aitdblocks.user.login";
NSNotificationName const YYUserDidLogoutNofication = @"com.aitdblocks.user.logout";

@interface YYUserManager ()
@property (nonatomic, strong, readwrite) YYUserInfo *info;
@property (nonatomic, strong) XYArchiver *archiver;
@end

@implementation YYUserManager

+ (instancetype)defaultManager {
    static YYUserManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
        manager.info = [manager getInfoCache];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [YYUserManager defaultManager];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [YYUserManager defaultManager];
}

- (void)updateInfoWithData:(id)data {
    if (!data) return;
    id json = ((NSObject *)data).yy_modelToJSONObject;
    
    if (!_info) {
        _info = [YYUserInfo yy_modelWithJSON:json];
        if (!_info) return;
        [[NSNotificationCenter defaultCenter] postNotificationName:YYUserDidLoginNofication object:nil];
        [self saveInfoAsynchrony:true];
    } else {
        NSUInteger oldHash = _info.yy_modelHash;
        [_info yy_modelSetWithJSON:json];
        NSUInteger newHash = _info.yy_modelHash;
        if (oldHash == newHash) return;
        [[NSNotificationCenter defaultCenter] postNotificationName:YYUserInfoDidChangeNofication object:nil];
        [self saveInfoAsynchrony:true];
    }
}

- (void)updateInfoValue:(id)value forKey:(NSString *)key {
    if (!key || !value) return;
    [self updateInfoWithData:@{key: value}];
}

- (void)cleanInfo {
    _info = nil;
    [self deleteInfoAsynchrony:true];
    [[NSNotificationCenter defaultCenter] postNotificationName:YYUserDidLogoutNofication object:nil];
}

- (BOOL)isLogin {
    return _info.token != nil;
}

#pragma mark # Private

- (YYUserInfo *)getInfoCache {
    // 必须写全类型，不然会出警告
    return [self.archiver objectForKey:@"info" classes:@[YYUserInfo.class, NSString.class, NSNumber.class]];
}

- (void)saveInfoAsynchrony:(BOOL)async {
    if (async) {
        [self.archiver saveObject:_info forKey:@"info" completion:nil];
    } else {
        [self.archiver saveObject:_info forKey:@"info"];
    }
}

- (void)deleteInfoAsynchrony:(BOOL)async {
    if (async) {
        [self.archiver deleteObjectForKey:@"info" completion:nil];
    } else {
        [self.archiver deleteObjectForKey:@"info"];
    }
}

- (XYArchiver *)archiver {
    if (!_archiver) {
        NSString *path = [YYCacheManager.libraryPath stringByAppendingPathComponent:@"User"];
        XYArchiver *archiver = [[XYArchiver alloc] initWithPath:path];
        _archiver = archiver;
    }
    return _archiver;
}

@end
