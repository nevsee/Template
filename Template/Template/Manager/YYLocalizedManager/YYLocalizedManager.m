//
//  YYLocalizedManager.m
//  AITDBlocks
//
//  Created by nevsee on 2022/9/21.
//

#import "YYLocalizedManager.h"

NSNotificationName const YYLanguageDidChangeNotification = @"com.aitdblocks.language.change";

@interface YYLocalizedManager ()
@property (nonatomic, strong, readwrite) NSArray *supportedIdentities;
@property (nonatomic, strong, readwrite) NSArray *supportedNames;
@property (nonatomic, strong, readwrite) NSArray *supportedTypes;
@property (nonatomic, strong) NSBundle *selectedBundle; // 选中语言资源
@property (nonatomic, strong) NSString *selectedIdentity; // 选中语言标识
@property (nonatomic, assign) NSInteger selectedIndex; // 选中语言下标
@end

@implementation YYLocalizedManager

+ (instancetype)defaultManager {
    static YYLocalizedManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
        NSString *identity = [manager getSelectedIdentify];
        manager.selectedIdentity = identity;
        manager.selectedIndex = [manager.supportedIdentities indexOfObject:identity];
        manager.selectedBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:identity ofType:@"lproj"]];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [YYLocalizedManager defaultManager] ;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [YYLocalizedManager defaultManager];
}

#pragma mark # Public

- (NSString *)identity {
    return self.supportedIdentities[_selectedIndex];
}

- (NSString *)name {
    return self.supportedNames[_selectedIndex];
}

- (YYLanguageType)type {
    return [self.supportedTypes[_selectedIndex] integerValue];
}

- (NSArray *)supportedIdentities {
    if (!_supportedIdentities) {
        _supportedIdentities = @[@"zh-Hans", @"zh-Hant", @"en", @"ko", @"ja"];
    }
    return _supportedIdentities;
}

- (NSArray *)supportedNames {
    if (!_supportedNames) {
        _supportedNames = @[@"简体中文", @"繁體中文", @"English", @"한국어", @"日本語"];
    }
    return _supportedNames;
}

- (NSArray *)supportedTypes {
    if (!_supportedTypes) {
        _supportedTypes = @[@(1), @(2), @(3), @(4), @(5)];
    }
    return _supportedTypes;
}

- (NSString *)localizedStringForKey:(NSString *)key {
    return [self localizedStringForKey:key table:@"Localizable"];
}

- (NSString *)localizedStringForKey:(NSString *)key table:(NSString *)table {
    return NSLocalizedStringFromTableInBundle(key, table, _selectedBundle, nil);
}

- (void)updateLanguageForIdentity:(NSString *)identity {
    if (![self.supportedIdentities containsObject:identity]) return;
    // 更新当前选中语言
    _selectedIndex = [self.supportedIdentities indexOfObject:identity];
    _selectedIdentity = identity;
    _selectedBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:identity ofType:@"lproj"]];
    // 保存当前选中语言
    [[NSUserDefaults standardUserDefaults] setObject:identity forKey:@"selectedLanguageIdentify"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:YYLanguageDidChangeNotification object:nil userInfo:nil];
}

- (void)updateLanguageForName:(NSString *)name {
    if (![self.supportedNames containsObject:name]) return;
    NSInteger index = [self.supportedNames indexOfObject:name];
    NSString *identity = self.supportedIdentities[index];
    [self updateLanguageForIdentity:identity];
}

- (void)updateLanguageForType:(YYLanguageType)type {
    if (![self.supportedTypes containsObject:@(type)]) return;
    NSInteger index = [self.supportedTypes indexOfObject:@(type)];
    NSString *identity = self.supportedIdentities[index];
    [self updateLanguageForIdentity:identity];
}

#pragma mark # Private

// 获取选中的语言标识
- (NSString *)getSelectedIdentify {
    NSString *selectedIdentity = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedLanguageIdentify"];
    if (selectedIdentity) return selectedIdentity;
    
    // 优先使用设备当前语言版本
    NSString *preferredIdentity = [[NSLocale preferredLanguages] objectAtIndex:0];
    for (NSString *identity in self.supportedIdentities) {
        if ([preferredIdentity containsString:identity]) {
            selectedIdentity = identity;
            break;
        }
    }
    
    // 其次使用繁体中文
    if (!selectedIdentity) {
        selectedIdentity = self.supportedIdentities[1];
    }

    return selectedIdentity;
}

@end
