//
//  YYLocalizedManager.h
//  AITDBlocks
//
//  Created by nevsee on 2022/9/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 获取本地化映射内容
#define YYLocalizedString(key) [[YYLocalizedManager defaultManager] localizedStringForKey:key]
#define YYLocalizedStringFromTable(key, tbl) [[YYLocalizedManager defaultManager] localizedStringForKey:key table:tbl]

/// 语言切换通知
FOUNDATION_EXPORT NSNotificationName const YYLanguageDidChangeNotification;

/// 语言类型
typedef NS_ENUM(NSUInteger, YYLanguageType) {
    YYLanguageTypeHans = 1, ///< 简体中文
    YYLanguageTypeHant = 2, ///< 繁体中文
    YYLanguageTypeEN = 3, ///< 英文
    YYLanguageTypeKO = 4, ///< 韩文
    YYLanguageTypeJA = 5 ///< 日文
};

@interface YYLocalizedManager : NSObject

/// 当前用户使用的语言类型
@property (nonatomic, strong, readonly) NSString *identity;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) YYLanguageType type;

/// 支持的多语言列表
@property (nonatomic, strong, readonly) NSArray *supportedIdentities;
@property (nonatomic, strong, readonly) NSArray *supportedNames;
@property (nonatomic, strong, readonly) NSArray *supportedTypes;

+ (instancetype)defaultManager;

/**
 获取当前语言对应字段的内容
 */
- (NSString *)localizedStringForKey:(NSString *)key;
- (NSString *)localizedStringForKey:(NSString *)key table:(NSString *)table;

/**
 更改当前语言，必须是所支持的语言类型
 */
- (void)updateLanguageForIdentity:(NSString *)identity;
- (void)updateLanguageForName:(NSString *)name;
- (void)updateLanguageForType:(YYLanguageType)type;

@end

NS_ASSUME_NONNULL_END
