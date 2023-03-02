//
//  XYAlertController.h
//  XYAlertController
//
//  Created by nevsee on 2018/10/12.
//

#import <UIKit/UIKit.h>

#if __has_include(<XYPrompter/XYPrompter.h>)
#import <XYPrompter/XYPrompter.h>
#else
#import "XYPrompter.h"
#endif

#if __has_include(<XYAlertController/XYAlertController.h>)
FOUNDATION_EXPORT double XYAlertControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char XYAlertControllerVersionString[];
#import <XYAlertController/XYAlertActionCanvas.h>
#import <XYAlertController/XYAlertContentCanvas.h>
#import <XYAlertController/XYAlertAppearance.h>
#else
#import "XYAlertActionCanvas.h"
#import "XYAlertContentCanvas.h"
#import "XYAlertAppearance.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface XYAlertController : UIViewController
@property (nonatomic, assign, readonly) XYAlertControllerStyle preferredStyle;
@property (nonatomic, strong, readonly, nullable) XYAlertContentCanvas *contentCanvas;
@property (nonatomic, strong, readonly, nullable) XYAlertActionCanvas *actionCanvas;
@property (nonatomic, strong, readonly) XYPrompter *prompter;

/// All contents.
@property (nonatomic, strong, readonly, nullable) NSArray *contents;

/// All actions. The tag and index of the cancel action is always 0
@property (nonatomic, strong, readonly, nullable) NSArray *actions;

/// The width of the view.
@property (nonatomic, assign) CGFloat potraitWidth;
@property (nonatomic, assign) CGFloat landscapeWidth;

/// Defines which of the corners receives the masking.
@property (nonatomic, assign) UIRectCorner corner;
@property (nonatomic, assign) CGFloat cornerRadii;

@property (nonatomic, copy, nullable) XYAlertActionHandler beforeHandler;
@property (nonatomic, copy, nullable) XYAlertActionHandler afterHandler;

+ (instancetype)alertWithTitle:(nullable NSString *)title
                       message:(nullable NSString *)message
                        cancel:(nullable NSString *)cancel
                       actions:(nullable NSArray<NSString *> *)actions /// XYAlertActionStyleDefault
                preferredStyle:(XYAlertControllerStyle)preferredStyle;

- (void)addContents:(NSArray<XYAlertContent *> *)contents;
- (void)addActions:(NSArray<XYAlertAction *> *)actions;

- (void)removeContents:(NSArray<XYAlertContent *> *)contents;
- (void)removeActions:(NSArray<XYAlertAction *> *)actions;

- (void)presentInController:(UIViewController *)inController;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
