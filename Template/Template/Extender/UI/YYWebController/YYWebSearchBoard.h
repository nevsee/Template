//
//  YYWebSearchBoard.h
//  Template
//
//  Created by nevsee on 2021/12/14.
//

#import "YYViewBoard.h"

NS_ASSUME_NONNULL_BEGIN

/// 搜索板
@interface YYWebSearchBoard : YYViewBoard
@property (nonatomic, strong, nullable) void (^findBlock)(NSString *keyword, YYWebSearchBoard *board);
@property (nonatomic, strong, nullable) void (^findNextBlock)(BOOL next, YYWebSearchBoard *board);
@property (nonatomic, strong, nullable) void (^clearBlock)(YYWebSearchBoard *board);
- (void)updateSearchNumber:(NSInteger)number index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
