//
//  XYAlertContent.h
//  XYAlertController
//
//  Created by nevsee on 2018/10/12.
//

#import <UIKit/UIKit.h>
#import "XYAlertAppearance.h"

@class XYAlertController;

NS_ASSUME_NONNULL_BEGIN

@interface XYAlertContent : UIView
@property (nonatomic, strong, readonly) UIView *contentView; ///< Subviews should be added to the content view.
@property (nonatomic, assign) UIEdgeInsets contentInsets; ///< The edge inset of content view.
@property (nonatomic, assign) CGFloat preferredHeight; ///< The height of content.
@property (nonatomic, assign) XYAlertContentStyle style;
@property (nonatomic, weak) XYAlertController *alerter;
@end

/// The blank content.
@interface XYAlertFixedSpaceContent : XYAlertContent
+ (instancetype)fixedSpaceContent;
@end

/// The text content that contains a label inside.
@interface XYAlertTextContent : XYAlertContent
@property (nonatomic, strong) NSDictionary *textAttributes;
@property (nonatomic, strong) NSString *text;

- (instancetype)initWithText:(NSString *)text
                       style:(XYAlertContentStyle)style
                     alerter:(XYAlertController *)alerter;
@end

NS_ASSUME_NONNULL_END
