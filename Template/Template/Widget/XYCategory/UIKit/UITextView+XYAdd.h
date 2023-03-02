//
//  UITextView+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2017/4/13.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (XYAdd)

/// Returns the number of text lines.
@property (nonatomic, assign, readonly) NSUInteger xy_numberOfLines;

/**
 Limits maximum text length (Avoid breaking up character sequences).
 @param length The maximum length of text.
 @param truncation Whether needs to truncate text.
 @param nonASCIIAsTwo Whether needs to count the length of a non ASCII character to two.
 @return The length of text.
 */
- (NSInteger)xy_limitMaxLength:(NSInteger)length truncation:(BOOL)truncation nonASCIIAsTwo:(BOOL)nonASCIIAsTwo;

/**
 Scrolls to the last line.
 @note
 you should try this code if it scrolls to top automatically.
 self.layoutManager.allowsNonContiguousLayout = NO;
 */
- (void)xy_scrollToLastLine;

/**
 Select all text without the menu board.
 */
- (void)xy_selectAllWithoutMenuBoard;

@end

NS_ASSUME_NONNULL_END
