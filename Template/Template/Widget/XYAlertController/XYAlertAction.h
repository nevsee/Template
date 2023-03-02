//
//  XYAlertAction.h
//  XYAlertController
//
//  Created by nevsee on 2018/10/12.
//

#import <UIKit/UIKit.h>
#import "XYAlertAppearance.h"

@class XYAlertController;
@class XYAlertAction;

NS_ASSUME_NONNULL_BEGIN

typedef void(^XYAlertActionHandler) (__kindof XYAlertAction *action);

@interface XYAlertAction : UIView
@property (nonatomic, strong, readonly) UIView *contentView; ///< Subviews should be added to the content view.
@property (nonatomic, assign) CGFloat preferredHeight; ///< The height of action.
@property (nonatomic, assign) XYAlertActionStyle style;
@property (nonatomic, weak) XYAlertController *alerter;
@property (nonatomic, copy, nullable) XYAlertActionHandler beforeHandler; ///< subclass implementation
@property (nonatomic, copy, nullable) XYAlertActionHandler afterHandler; ///< subclass implementation
@property (nonatomic, assign) BOOL dismissEnabled; ///< subclass implementation
@end

/// The blank action.
@interface XYAlertFixedSpaceAction : XYAlertAction
+ (instancetype)fixedSpaceAction;
@end

/// The sketch action that contains a button inside.
@interface XYAlertSketchAction : XYAlertAction
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, strong) NSDictionary *titleAttributes;
@property (nonatomic, strong) UIColor *highlightedColor;

- (instancetype)initWithTitle:(NSString *)title
                       style:(XYAlertActionStyle)style
                      alerter:(XYAlertController *)alerter;

- (instancetype)initWithImage:(UIImage *)image
                        style:(XYAlertActionStyle)style
                      alerter:(XYAlertController *)alerter;

- (instancetype)initWithTitle:(nullable NSString *)title
                       image:(nullable UIImage *)image
                     spacing:(CGFloat)spacing
                       style:(XYAlertActionStyle)style
                      alerter:(XYAlertController *)alerter;
@end

/// Extend for XYAlertSketchAction.
@interface XYAlertTimerAction : XYAlertSketchAction
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong, nullable) NSString *format;
@property (nonatomic, strong) NSDictionary *titleDisabledAttributes;
- (void)startCounter;
- (void)stopCounter;
- (void)restartCounter;
@end

NS_ASSUME_NONNULL_END
