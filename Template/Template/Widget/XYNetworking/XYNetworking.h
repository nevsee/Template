//
//  XYNetworking.h
//  XYNetworking
//
//  Created by nevsee on 2018/8/9.
//  Copyright © 2018年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<XYNetworking/XYNetworking.h>)
FOUNDATION_EXPORT double XYNetworkingVersionNumber;
FOUNDATION_EXPORT const unsigned char XYNetworkingVersionString[];
#import <XYNetworking/XYNetworkConfig.h>
#import <XYNetworking/XYBaseRequest.h>
#import <XYNetworking/XYRequestProxy.h>
#import <XYNetworking/XYNetworkReachabilityManager.h>
#else
#import "XYNetworkConfig.h"
#import "XYBaseRequest.h"
#import "XYRequestAgent.h"
#import "XYNetworkReachabilityManager.h"
#endif




