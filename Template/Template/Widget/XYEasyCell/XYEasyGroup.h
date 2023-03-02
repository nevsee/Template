//
//  XYEasyGroup.h
//  XYEasyCell
//
//  Created by nevsee on 2019/11/5.
//  Copyright © 2019 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XYEasyItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYEasyGroup : NSObject
@property (nonatomic, strong, nullable) NSString *groupHeaderTitle;
@property (nonatomic, strong, nullable) NSString *groupFooterTitle;
@property (nonatomic, assign) CGFloat groupHeaderHeight;
@property (nonatomic, assign) CGFloat groupFooterHeight;
@property (nonatomic, strong, nullable) NSMutableArray<XYEasyItem *> *easyItems;
+ (instancetype)group;
@end

NS_ASSUME_NONNULL_END
