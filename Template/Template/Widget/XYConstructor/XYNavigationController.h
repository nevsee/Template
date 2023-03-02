//
//  XYNavigationController.h
//  XYConstructor
//
//  Created by nevsee on 2017/3/26.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYNavigationBarBackground;

NS_ASSUME_NONNULL_BEGIN

@interface XYNavigationController : UINavigationController
@property (nonatomic, strong, readonly) XYNavigationBarBackground *navigationBarBackground;
@end

@interface XYNavigationBarBackground : UIView
@property (nonatomic, assign) UIBarStyle barStyle UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) BOOL barTranslucent UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong, nullable) UIImage *barBackgroundImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong, nullable) UIColor *barTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong, nullable) UIColor *barSeparatorColor UI_APPEARANCE_SELECTOR;
@end

NS_ASSUME_NONNULL_END
