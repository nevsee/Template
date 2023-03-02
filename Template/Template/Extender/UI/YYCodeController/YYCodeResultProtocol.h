//
//  YYCodeResultProtocol.h
//  Ferry
//
//  Created by nevsee on 2022/4/19.
//

#import <Foundation/Foundation.h>

@class YYCodeController;

NS_ASSUME_NONNULL_BEGIN

@protocol YYCodeResultProtocol <NSObject>
@required
- (void)codeController:(__kindof YYCodeController *)codeController didHandleMessage:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
