//
//  XYEasyCell.h
//  XYEasyCell
//
//  Created by nevsee on 2019/11/5.
//  Copyright © 2019 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<XYEasyCell/XYEasyCell.h>)
FOUNDATION_EXPORT double XYEasyCellVersionNumber;
FOUNDATION_EXPORT const unsigned char XYEasyCellVersionString[];
#import <XYEasyCell/XYEasyItem.h>
#import <XYEasyCell/XYEasyGroup.h>
#else
#import "XYEasyItem.h"
#import "XYEasyGroup.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface XYEasyCell : UITableViewCell
- (void)refreshCellWithItem:(XYEasyItem *)item;
@end

NS_ASSUME_NONNULL_END
