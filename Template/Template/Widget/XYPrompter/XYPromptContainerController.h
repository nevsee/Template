//
//  XYPromptContainerController.h
//  XYPrompter
//
//  Created by nevsee on 2018/9/20.
//

#import <UIKit/UIKit.h>

@class XYPrompter;

NS_ASSUME_NONNULL_BEGIN

@protocol XYPromptContainerBackgroundDescriber <NSObject>
@required
- (void)transitWithDuration:(NSTimeInterval)duration present:(BOOL)present;
@end

@interface XYPromptContainerController : UIViewController
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UIView<XYPromptContainerBackgroundDescriber> *backgroundView;
@property (nonatomic, strong) UIViewController *child;
@end

@interface XYPromptContainerBackgroundView : UIView <XYPromptContainerBackgroundDescriber>
@property (nonatomic, weak) XYPrompter *prompter;
@end

@interface XYPromptContainerRootController : UIViewController
@property (nonatomic, weak) XYPrompter *prompter;
@end

@interface XYPromptContainerWindow : UIWindow
@end

NS_ASSUME_NONNULL_END
