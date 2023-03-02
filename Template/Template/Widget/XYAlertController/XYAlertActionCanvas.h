//
//  XYAlertAction.h
//  XYAlertController
//
//  Created by nevsee on 2018/10/12.
//

#import <UIKit/UIKit.h>
#import "XYAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYAlertActionCanvas : UIView

/// The palceholder action
/// Only use for XYAlertControllerStyleSheet
@property (nonatomic, strong, readonly, nullable) XYAlertFixedSpaceAction *placeholderAction;
@property (nonatomic, strong, readonly, nullable) XYAlertFixedSpaceAction *safeAreaAction;

/// The maximum number of actions in horizontal layout
/// Only use for XYAlertControllerStyleAlert
@property (nonatomic, assign) NSInteger maximumNumberOfHorizontalLayout;

/// Initialize the canvas with the style
+ (instancetype)canvasWithStyle:(XYAlertControllerStyle)style;

/// Update actions
- (void)updateActions:(NSArray *)actions;

@end

NS_ASSUME_NONNULL_END
