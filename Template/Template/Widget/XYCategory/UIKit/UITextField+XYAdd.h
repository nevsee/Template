//
//  UITextField+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2017/4/13.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (XYAdd)

@property (nonatomic, readonly) NSRange xy_selectedRange;

/**
 Limits maximum text length (Avoid breaking up character sequences).
 @param length The maximum length of text.
 @param truncation Whether needs to truncate text.
 @param nonASCIIAsTwo Whether needs to count the length of a non ASCII character to two.
 @return The length of text.
 */
- (NSInteger)xy_limitMaxLength:(NSInteger)length truncation:(BOOL)truncation nonASCIIAsTwo:(BOOL)nonASCIIAsTwo;

/**
 Select all text without the menu board.
 */
- (void)xy_selectAllWithoutMenuBoard;

@end

NS_ASSUME_NONNULL_END
