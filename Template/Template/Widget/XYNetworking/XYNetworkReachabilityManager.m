//
//  XYNetworkReachabilityManager.m
//  XYNetworking
//
//  Created by nevsee on 2016/11/30.
//  Copyright © 2016年 nevsee. All rights reserved.
//

#import "XYNetworkReachabilityManager.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

NSNotificationName const XYNetworkReachabilityDidChangeNotification = @"XYNetworkReachabilityDidChangeNotification";

static NSDictionary * XYNetworkReachabilityStatusForFlags(SCNetworkReachabilityFlags flags) {
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));

    XYNetworkReachabilityStatus status = XYNetworkReachabilityStatusUnknown;
    XYNetworkWWANType type = XYNetworkWWANTypeUnknown;

    static NSDictionary *map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{
            CTRadioAccessTechnologyEdge: @(XYNetworkWWANType2G),
            CTRadioAccessTechnologyGPRS: @(XYNetworkWWANType2G),
            CTRadioAccessTechnologyCDMA1x: @(XYNetworkWWANType2G),
            CTRadioAccessTechnologyHSDPA: @(XYNetworkWWANType3G),
            CTRadioAccessTechnologyWCDMA: @(XYNetworkWWANType3G),
            CTRadioAccessTechnologyHSUPA: @(XYNetworkWWANType3G),
            CTRadioAccessTechnologyCDMAEVDORev0: @(XYNetworkWWANType3G),
            CTRadioAccessTechnologyCDMAEVDORevA: @(XYNetworkWWANType3G),
            CTRadioAccessTechnologyCDMAEVDORevB: @(XYNetworkWWANType3G),
            CTRadioAccessTechnologyeHRPD: @(XYNetworkWWANType3G),
            CTRadioAccessTechnologyLTE: @(XYNetworkWWANType4G),
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 140000)
            CTRadioAccessTechnologyNRNSA: @(XYNetworkWWANType5G),
            CTRadioAccessTechnologyNR: @(XYNetworkWWANType5G),
#endif
#pragma clang diagnostic pop
        };
    });

    if (!isNetworkReachable) { // no network
        status = XYNetworkReachabilityStatusNotReachable;
    } else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) { // wwan
        status = XYNetworkReachabilityStatusWWAN;
        CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
        NSNumber *result = nil;
        if (@available(iOS 12, *)) {
            NSDictionary *dic = teleInfo.serviceCurrentRadioAccessTechnology;
            result = map[dic.allValues.firstObject];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            result = map[teleInfo.currentRadioAccessTechnology];
#pragma clang diagnostic pop
        }
        if (result) type = result.integerValue;
    } else { // wifi
        status = XYNetworkReachabilityStatusWiFi;
    }

    return @{@"status": @(status), @"type": @(type)};
}

static void XYPostReachabilityStatusChange(SCNetworkReachabilityFlags flags, XYNetworkReachabilityStatusBlock block) {
    NSDictionary *dic = XYNetworkReachabilityStatusForFlags(flags);
    XYNetworkReachabilityStatus status = [dic[@"status"] integerValue];
    XYNetworkWWANType type = [dic[@"type"] integerValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) block(status, type);
        [[NSNotificationCenter defaultCenter] postNotificationName:XYNetworkReachabilityDidChangeNotification object:nil userInfo:nil];
    });
}

static void XYNetworkReachabilityCallback(SCNetworkReachabilityRef __unused target, SCNetworkReachabilityFlags flags, void *info) {
    XYPostReachabilityStatusChange(flags, (__bridge XYNetworkReachabilityStatusBlock)info);
}

static const void * XYNetworkReachabilityRetainCallback(const void *info) {
    return Block_copy(info);
}

static void XYNetworkReachabilityReleaseCallback(const void *info) {
    if (info) Block_release(info);
}

@interface XYNetworkReachabilityManager ()
@property (nonatomic, assign, readonly) SCNetworkReachabilityRef networkReachability;
@end

@implementation XYNetworkReachabilityManager

+ (instancetype)defaultManager {
    static XYNetworkReachabilityManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self managerForInternetConnection];
    });
    return manager;
}

+ (instancetype)managerForDomain:(NSString *)domain {
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [domain UTF8String]);
    XYNetworkReachabilityManager *manager = [[self alloc] initWithReachability:reachability];
    CFRelease(reachability);
    return manager;
}

+ (instancetype)managerForAddress:(const void *)address {
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)address);
    XYNetworkReachabilityManager *manager = [[self alloc] initWithReachability:reachability];
    CFRelease(reachability);
    return manager;
}

+ (instancetype)managerForInternetConnection {
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000)
    struct sockaddr_in6 address;
    bzero(&address, sizeof(address));
    address.sin6_len = sizeof(address);
    address.sin6_family = AF_INET6;
#else
    struct sockaddr_in address;
    bzero(&address, sizeof(address));
    address.sin_len = sizeof(address);
    address.sin_family = AF_INET;
#endif
    return [self managerForAddress:&address];
}

- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability {
    self = [super init];
    if (self) {
        _networkReachability = CFRetain(reachability);
        _networkStatus = XYNetworkReachabilityStatusUnknown;
        _networkType = XYNetworkWWANTypeUnknown;
    }
    return self;
}

- (void)startMonitoring {
    [self stopMonitoring];
    if (!_networkReachability) return;
        
    __weak __typeof(self) weak = self;
    XYNetworkReachabilityStatusBlock callback = ^(XYNetworkReachabilityStatus status, XYNetworkWWANType type) {
        __strong __typeof(weak) self = weak;
        self->_networkStatus = status;
        self->_networkType = type;
        if (self.statusBlock) self.statusBlock(status, type);
    };

    SCNetworkReachabilityContext context = {0, (__bridge void *)callback, XYNetworkReachabilityRetainCallback, XYNetworkReachabilityReleaseCallback, NULL};
    SCNetworkReachabilitySetCallback(_networkReachability, XYNetworkReachabilityCallback, &context);
    SCNetworkReachabilityScheduleWithRunLoop(_networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(self.networkReachability, &flags)) {
            XYPostReachabilityStatusChange(flags, callback);
        }
    });
}

- (void)stopMonitoring {
    if (!_networkReachability) return;
    SCNetworkReachabilityUnscheduleFromRunLoop(_networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
}

- (BOOL)isReachable {
    return [self isReachableViaWWAN] || [self isReachableViaWiFi];
}

- (BOOL)isReachableViaWWAN {
    return _networkStatus == XYNetworkReachabilityStatusWWAN;
}

- (BOOL)isReachableViaWiFi {
    return _networkStatus == XYNetworkReachabilityStatusWiFi;
}

@end
