//
//  XYKeychain.m
//  XYStorage
//
//  Created by nevsee on 2020/10/8.
//  Copyright © 2020 nevsee. All rights reserved.
//

#import "XYKeychain.h"
#import <UIKit/UIKit.h>
#import <Security/Security.h>

static XYKeychainErrorCode XYKeychainErrorCodeFromOSStatus(OSStatus status) {
    switch (status) {
        case errSecUnimplemented: return XYKeychainErrorUnimplemented;
        case errSecIO: return XYKeychainErrorIO;
        case errSecOpWr: return XYKeychainErrorOpWr;
        case errSecParam: return XYKeychainErrorParam;
        case errSecAllocate: return XYKeychainErrorAllocate;
        case errSecUserCanceled: return XYKeychainErrorUserCancelled;
        case errSecBadReq: return XYKeychainErrorBadReq;
        case errSecInternalComponent: return XYKeychainErrorInternalComponent;
        case errSecNotAvailable: return XYKeychainErrorNotAvailable;
        case errSecDuplicateItem: return XYKeychainErrorDuplicateItem;
        case errSecItemNotFound: return XYKeychainErrorItemNotFound;
        case errSecInteractionNotAllowed: return XYKeychainErrorInteractionNotAllowed;
        case errSecDecode: return XYKeychainErrorDecode;
        case errSecAuthFailed: return XYKeychainErrorAuthFailed;
        default: return 0;
    }
}

static NSString *XYKeychainErrorDesc(XYKeychainErrorCode code) {
    switch (code) {
        case XYKeychainErrorUnimplemented:
            return @"Function or operation not implemented.";
        case XYKeychainErrorIO:
            return @"I/O error (bummers)";
        case XYKeychainErrorOpWr:
            return @"ile already open with with write permission.";
        case XYKeychainErrorParam:
            return @"One or more parameters passed to a function where not valid.";
        case XYKeychainErrorAllocate:
            return @"Failed to allocate memory.";
        case XYKeychainErrorUserCancelled:
            return @"User canceled the operation.";
        case XYKeychainErrorBadReq:
            return @"Bad parameter or invalid state for operation.";
        case XYKeychainErrorInternalComponent:
            return @"Inrernal Component";
        case XYKeychainErrorNotAvailable:
            return @"No keychain is available. You may need to restart your computer.";
        case XYKeychainErrorDuplicateItem:
            return @"The specified item already exists in the keychain.";
        case XYKeychainErrorItemNotFound:
            return @"The specified item could not be found in the keychain.";
        case XYKeychainErrorInteractionNotAllowed:
            return @"User interaction is not allowed.";
        case XYKeychainErrorDecode:
            return @"Unable to decode the provided data.";
        case XYKeychainErrorAuthFailed:
            return @"The user name or passphrase you entered is not";
        default:
            break;
    }
    return nil;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

static NSString *XYKeychainAccessibleStr(XYKeychainAccessible e) {
    switch (e) {
        case XYKeychainAccessibleWhenUnlocked:
            return (__bridge NSString *)(kSecAttrAccessibleWhenUnlocked);
        case XYKeychainAccessibleAfterFirstUnlock:
            return (__bridge NSString *)(kSecAttrAccessibleAfterFirstUnlock);
        case XYKeychainAccessibleAlways:
            return (__bridge NSString *)(kSecAttrAccessibleAlways);
        case XYKeychainAccessibleWhenPasscodeSetThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly);
        case XYKeychainAccessibleWhenUnlockedThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleWhenUnlockedThisDeviceOnly);
        case XYKeychainAccessibleAfterFirstUnlockThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly);
        case XYKeychainAccessibleAlwaysThisDeviceOnly:
            return (__bridge NSString *)(kSecAttrAccessibleAlwaysThisDeviceOnly);
        default:
            return nil;
    }
}

static XYKeychainAccessible XYKeychainAccessibleEnum(NSString *s) {
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleWhenUnlocked])
        return XYKeychainAccessibleWhenUnlocked;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAfterFirstUnlock])
        return XYKeychainAccessibleAfterFirstUnlock;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAlways])
        return XYKeychainAccessibleAlways;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly])
        return XYKeychainAccessibleWhenPasscodeSetThisDeviceOnly;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleWhenUnlockedThisDeviceOnly])
        return XYKeychainAccessibleWhenUnlockedThisDeviceOnly;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly])
        return XYKeychainAccessibleAfterFirstUnlockThisDeviceOnly;
    if ([s isEqualToString:(__bridge NSString *)kSecAttrAccessibleAlwaysThisDeviceOnly])
        return XYKeychainAccessibleAlwaysThisDeviceOnly;
    return XYKeychainAccessibleNone;
}

#pragma clang diagnostic pop

static id XYKeychainQuerySynchonizationID(XYKeychainQuerySynchronizationMode mode) {
    switch (mode) {
        case XYKeychainQuerySynchronizationModeAny:
            return (__bridge id)(kSecAttrSynchronizableAny);
        case XYKeychainQuerySynchronizationModeNo:
            return (__bridge id)kCFBooleanFalse;
        case XYKeychainQuerySynchronizationModeYes:
            return (__bridge id)kCFBooleanTrue;
        default:
            return (__bridge id)(kSecAttrSynchronizableAny);
    }
}

static XYKeychainQuerySynchronizationMode XYKeychainQuerySynchonizationEnum(NSNumber *num) {
    if ([num isEqualToNumber:@NO]) return XYKeychainQuerySynchronizationModeNo;
    if ([num isEqualToNumber:@YES]) return XYKeychainQuerySynchronizationModeYes;
    return XYKeychainQuerySynchronizationModeAny;
}

@interface XYKeychainItem ()
@property (nonatomic, readwrite, strong) NSDate *modificationDate;
@property (nonatomic, readwrite, strong) NSDate *creationDate;
@end

@implementation XYKeychainItem

- (void)setPassword:(NSString *)password {
    _passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)password {
    if ([_passwordData length]) {
        return [[NSString alloc] initWithData:_passwordData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSMutableDictionary *)queryDic {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    dic[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    
    if (_account) dic[(__bridge id)kSecAttrAccount] = _account;
    if (_service) dic[(__bridge id)kSecAttrService] = _service;
    
    if (![self isSimulator]) {
        // Remove the access group if running on the iPhone simulator.
        //
        // Apps that are built for the simulator aren't signed, so there's no keychain access group
        // for the simulator to check. This means that all apps can see all keychain items when run
        // on the simulator.
        //
        // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
        // simulator will return -25243 (errSecNoAccessForItem).
        //
        // The access group attribute will be included in items returned by SecItemCopyMatching,
        // which is why we need to remove it before updating the item.
        if (_accessGroup) dic[(__bridge id)kSecAttrAccessGroup] = _accessGroup;
    }
    
    if ([self isIOS7OrLater]) {
        dic[(__bridge id)kSecAttrSynchronizable] = XYKeychainQuerySynchonizationID(_synchronizable);
    }
    
    return dic;
}

- (NSMutableDictionary *)dic {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    dic[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    
    if (_account) dic[(__bridge id)kSecAttrAccount] = _account;
    if (_service) dic[(__bridge id)kSecAttrService] = _service;
    if (_label) dic[(__bridge id)kSecAttrLabel] = _label;
    
    if (![self isSimulator]) {
        // Remove the access group if running on the iPhone simulator.
        //
        // Apps that are built for the simulator aren't signed, so there's no keychain access group
        // for the simulator to check. This means that all apps can see all keychain items when run
        // on the simulator.
        //
        // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
        // simulator will return -25243 (errSecNoAccessForItem).
        //
        // The access group attribute will be included in items returned by SecItemCopyMatching,
        // which is why we need to remove it before updating the item.
        if (_accessGroup) dic[(__bridge id)kSecAttrAccessGroup] = _accessGroup;
    }
    
    if ([self isIOS7OrLater]) {
        dic[(__bridge id)kSecAttrSynchronizable] = XYKeychainQuerySynchonizationID(_synchronizable);
    }
    
    if (_accessible) dic[(__bridge id)kSecAttrAccessible] = XYKeychainAccessibleStr(_accessible);
    if (_passwordData) dic[(__bridge id)kSecValueData] = _passwordData;
    if (_type != nil) dic[(__bridge id)kSecAttrType] = _type;
    if (_creater != nil) dic[(__bridge id)kSecAttrCreator] = _creater;
    if (_comment) dic[(__bridge id)kSecAttrComment] = _comment;
    if (_descr) dic[(__bridge id)kSecAttrDescription] = _descr;
    
    return dic;
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (dic.count == 0) return nil;
    self = self.init;
    
    _service = dic[(__bridge id)kSecAttrService];
    _account = dic[(__bridge id)kSecAttrAccount];
    _passwordData = dic[(__bridge id)kSecValueData];
    _label = dic[(__bridge id)kSecAttrLabel];
    _type = dic[(__bridge id)kSecAttrType];
    _creater = dic[(__bridge id)kSecAttrCreator];
    _comment = dic[(__bridge id)kSecAttrComment];
    _descr = dic[(__bridge id)kSecAttrDescription];
    _modificationDate = dic[(__bridge id)kSecAttrModificationDate];
    _creationDate = dic[(__bridge id)kSecAttrCreationDate];
    _accessGroup = dic[(__bridge id)kSecAttrAccessGroup];
    _accessible = XYKeychainAccessibleEnum(dic[(__bridge id)kSecAttrAccessible]);
    _synchronizable = XYKeychainQuerySynchonizationEnum(dic[(__bridge id)kSecAttrSynchronizable]);
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    XYKeychainItem *item = [XYKeychainItem new];
    item.service = _service;
    item.account = _account;
    item.passwordData = _passwordData;
    item.label = _label;
    item.type = _type;
    item.creater = _creater;
    item.comment = _comment;
    item.descr = _descr;
    item.modificationDate = _modificationDate;
    item.creationDate = _creationDate;
    item.accessGroup = _accessGroup;
    item.accessible = _accessible;
    item.synchronizable = _synchronizable;
    return item;
}

- (NSString *)description {
    NSMutableString *str = @"".mutableCopy;
    [str appendString:@"XYKeychainItem:{\n"];
    if (_service) [str appendFormat:@"  service:%@,\n", _service];
    if (_account) [str appendFormat:@"  service:%@,\n", _account];
    if (self.password) [str appendFormat:@"  service:%@,\n", self.password];
    if (_label) [str appendFormat:@"  service:%@,\n", _label];
    if (_type != nil) [str appendFormat:@"  service:%@,\n", _type];
    if (_creater != nil) [str appendFormat:@"  service:%@,\n", _creater];
    if (_comment) [str appendFormat:@"  service:%@,\n", _comment];
    if (_descr) [str appendFormat:@"  service:%@,\n", _descr];
    if (_modificationDate) [str appendFormat:@"  service:%@,\n", _modificationDate];
    if (_creationDate) [str appendFormat:@"  service:%@,\n", _creationDate];
    if (_accessGroup) [str appendFormat:@"  service:%@,\n", _accessGroup];
    [str appendString:@"}"];
    return str;
}

- (BOOL)isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

- (BOOL)isIOS7OrLater {
    return [UIDevice currentDevice].systemVersion.doubleValue >= 7;
}

@end



@implementation XYKeychain

+ (NSString *)getPasswordForService:(NSString *)serviceName
                            account:(NSString *)account
                              error:(NSError **)error {
    if (!serviceName || !account) {
        if (error) *error = [XYKeychain errorWithCode:errSecParam];
        return nil;
    }
    
    XYKeychainItem *item = [XYKeychainItem new];
    item.service = serviceName;
    item.account = account;
    XYKeychainItem *result = [self selectOneItem:item error:error];
    return result.password;
}

+ (nullable NSString *)getPasswordForService:(NSString *)serviceName
                                     account:(NSString *)account {
    return [self getPasswordForService:serviceName account:account error:NULL];
}

+ (BOOL)deletePasswordForService:(NSString *)serviceName
                         account:(NSString *)account
                           error:(NSError **)error {
    if (!serviceName || !account) {
        if (error) *error = [XYKeychain errorWithCode:errSecParam];
        return NO;
    }
    
    XYKeychainItem *item = [XYKeychainItem new];
    item.service = serviceName;
    item.account = account;
    return [self deleteItem:item error:error];
}

+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account {
    return [self deletePasswordForService:serviceName account:account error:NULL];
}

+ (BOOL)setPassword:(NSString *)password
         forService:(NSString *)serviceName
            account:(NSString *)account
              error:(NSError **)error {
    if (!password || !serviceName || !account) {
        if (error) *error = [XYKeychain errorWithCode:errSecParam];
        return NO;
    }
    XYKeychainItem *item = [XYKeychainItem new];
    item.service = serviceName;
    item.account = account;
    XYKeychainItem *result = [self selectOneItem:item error:NULL];
    if (result) {
        result.password = password;
        return [self updateItem:result error:error];
    } else {
        item.password = password;
        return [self insertItem:item error:error];
    }
}

+ (BOOL)setPassword:(NSString *)password
         forService:(NSString *)serviceName
            account:(NSString *)account {
    return [self setPassword:password forService:serviceName account:account error:NULL];
}

+ (BOOL)insertItem:(XYKeychainItem *)item error:(NSError **)error {
    if (!item.service || !item.account || !item.passwordData) {
        if (error) *error = [XYKeychain errorWithCode:errSecParam];
        return NO;
    }
    
    NSMutableDictionary *query = [item dic];
    OSStatus status = status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    if (status != errSecSuccess) {
        if (error) *error = [XYKeychain errorWithCode:status];
        return NO;
    }
    
    return YES;
}

+ (BOOL)insertItem:(XYKeychainItem *)item {
    return [self insertItem:item error:NULL];
}

+ (BOOL)updateItem:(XYKeychainItem *)item error:(NSError **)error {
    if (!item.service || !item.account || !item.passwordData) {
        if (error) *error = [XYKeychain errorWithCode:errSecParam];
        return NO;
    }
    
    NSMutableDictionary *query = [item queryDic];
    NSMutableDictionary *update = [item dic];
    [update removeObjectForKey:(__bridge id)kSecClass];
    if (!query || !update) return NO;
    OSStatus status = status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)update);
    if (status != errSecSuccess) {
        if (error) *error = [XYKeychain errorWithCode:status];
        return NO;
    }
    
    return YES;
}

+ (BOOL)updateItem:(XYKeychainItem *)item {
    return [self updateItem:item error:NULL];
}

+ (BOOL)deleteItem:(XYKeychainItem *)item error:(NSError **)error {
    if (!item.service || !item.account) {
        if (error) *error = [XYKeychain errorWithCode:errSecParam];
        return NO;
    }
    
    NSMutableDictionary *query = [item dic];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    if (status != errSecSuccess) {
        if (error) *error = [XYKeychain errorWithCode:status];
        return NO;
    }
    
    return YES;
}

+ (BOOL)deleteItem:(XYKeychainItem *)item {
    return [self deleteItem:item error:NULL];
}

+ (XYKeychainItem *)selectOneItem:(XYKeychainItem *)item error:(NSError **)error {
    if (!item.service || !item.account) {
        if (error) *error = [XYKeychain errorWithCode:errSecParam];
        return nil;
    }
    
    NSMutableDictionary *query = [item dic];
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    query[(__bridge id)kSecReturnAttributes] = @YES;
    query[(__bridge id)kSecReturnData] = @YES;
    
    OSStatus status;
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status != errSecSuccess) {
        if (error) *error = [[self class] errorWithCode:status];
        return nil;
    }
    if (!result) return nil;
    
    NSDictionary *dic = nil;
    if (CFGetTypeID(result) == CFDictionaryGetTypeID()) {
        dic = (__bridge NSDictionary *)(result);
    } else if (CFGetTypeID(result) == CFArrayGetTypeID()){
        dic = [(__bridge NSArray *)(result) firstObject];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    if (!dic.count) return nil;
    return [[XYKeychainItem alloc] initWithDic:dic];
}

+ (XYKeychainItem *)selectOneItem:(XYKeychainItem *)item {
    return [self selectOneItem:item error:NULL];
}

+ (NSArray *)selectItems:(XYKeychainItem *)item error:(NSError **)error {
    NSMutableDictionary *query = [item dic];
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitAll;
    query[(__bridge id)kSecReturnAttributes] = @YES;
    query[(__bridge id)kSecReturnData] = @YES;
    
    OSStatus status;
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status != errSecSuccess && error != NULL) {
        *error = [[self class] errorWithCode:status];
        return nil;
    }
    
    NSMutableArray *res = [NSMutableArray new];
    NSDictionary *dic = nil;
    if (CFGetTypeID(result) == CFDictionaryGetTypeID()) {
        dic = (__bridge NSDictionary *)(result);
        XYKeychainItem *item = [[XYKeychainItem alloc] initWithDic:dic];
        if (item) [res addObject:item];
    } else if (CFGetTypeID(result) == CFArrayGetTypeID()){
        for (NSDictionary *dic in (__bridge NSArray *)(result)) {
            XYKeychainItem *item = [[XYKeychainItem alloc] initWithDic:dic];
            if (item) [res addObject:item];
        }
    }
    
    return res;
}

+ (NSArray *)selectItems:(XYKeychainItem *)item {
    return [self selectItems:item error:NULL];
}

+ (NSError *)errorWithCode:(OSStatus)osCode {
    XYKeychainErrorCode code = XYKeychainErrorCodeFromOSStatus(osCode);
    NSString *desc = XYKeychainErrorDesc(code);
    NSDictionary *userInfo = desc ? @{ NSLocalizedDescriptionKey : desc } : nil;
    return [NSError errorWithDomain:@"com.nevsee.keychain" code:code userInfo:userInfo];
}

@end
