//
//  YYUserInfo.m
//  AITDBlocks
//
//  Created by nevsee on 2022/9/22.
//

#import "YYUserInfo.h"

@implementation YYUserInfo

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self yy_modelInitWithCoder:coder];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [self yy_modelEncodeWithCoder:coder];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
