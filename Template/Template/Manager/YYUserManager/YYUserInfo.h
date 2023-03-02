//
//  YYUserInfo.h
//  AITDBlocks
//
//  Created by nevsee on 2022/9/22.
//

#import "YYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYUserInfo : YYBaseModel <NSSecureCoding>
@property (nonatomic, strong) NSString *token; ///< 令牌
@property (nonatomic, strong) NSString *imToken; ///< im令牌
@property (nonatomic, strong) NSString *userId; ///< id
@end

NS_ASSUME_NONNULL_END
