//
//  XYAlertAction.h
//  XYAlertController
//
//  Created by nevsee on 2018/10/12.
//

#import <UIKit/UIKit.h>
#import "XYAlertContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYAlertContentCanvas : UIView

/// The palceholder content
@property (nonatomic, strong, readonly) XYAlertFixedSpaceContent *headerPlaceholderContent;
@property (nonatomic, strong, readonly) XYAlertFixedSpaceContent *footerPlaceholderContent;

/// Initialize the canvas with the style
+ (instancetype)canvasWithStyle:(XYAlertControllerStyle)style;

/// Update contents
- (void)updateContents:(NSArray *)contents;

@end

NS_ASSUME_NONNULL_END
