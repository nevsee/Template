//
//  XYNetworkReachabilityManager.h
//  XYNetworking
//
//  Created by nevsee on 2016/11/30.
//  Copyright © 2016年 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XYNetworkReachabilityStatus) {
    XYNetworkReachabilityStatusUnknown = -1,
    XYNetworkReachabilityStatusNotReachable = 0,
    XYNetworkReachabilityStatusWiFi = 1,
    XYNetworkReachabilityStatusWWAN = 2,
};

typedef NS_ENUM(NSInteger, XYNetworkWWANType) {
    XYNetworkWWANTypeUnknown = -1,
    XYNetworkWWANType2G = 0,
    XYNetworkWWANType3G = 1,
    XYNetworkWWANType4G = 2,
    XYNetworkWWANType5G = 3,
};

FOUNDATION_EXTERN NSNotificationName const XYNetworkReachabilityDidChangeNotification;

typedef void (^XYNetworkReachabilityStatusBlock)(XYNetworkReachabilityStatus status, XYNetworkWWANType type);

@interface XYNetworkReachabilityManager : NSObject
@property (nonatomic, assign, readonly) XYNetworkReachabilityStatus networkStatus;
@property (nonatomic, assign, readonly) XYNetworkWWANType networkType;
@property (nonatomic, assign, readonly, getter = isReachable) BOOL reachable;
@property (nonatomic, assign, readonly, getter = isReachableViaWiFi) BOOL reachableViaWiFi;
@property (nonatomic, assign, readonly, getter = isReachableViaWWAN) BOOL reachableViaWWAN;
@property (nonatomic, copy) XYNetworkReachabilityStatusBlock statusBlock;
+ (instancetype)defaultManager;
+ (instancetype)managerForDomain:(NSString *)domain;
+ (instancetype)managerForAddress:(const void *)address;
+ (instancetype)managerForInternetConnection;
- (void)startMonitoring;
- (void)stopMonitoring;
@end

NS_ASSUME_NONNULL_END
