//
//  XYPromptAnimator.h
//  XYPrompter
//
//  Created by nevsee on 2018/9/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class XYPromptAnimator;
@class XYPromptContainerController;

NS_ASSUME_NONNULL_BEGIN

/// Animation style
typedef NSString *XYPromptAnimationStyle NS_EXTENSIBLE_STRING_ENUM;
UIKIT_EXTERN XYPromptAnimationStyle const XYPromptAnimationStyleNone;
UIKIT_EXTERN XYPromptAnimationStyle const XYPromptAnimationStyleBounce;
UIKIT_EXTERN XYPromptAnimationStyle const XYPromptAnimationStyleZoom;
UIKIT_EXTERN XYPromptAnimationStyle const XYPromptAnimationStyleFade;
UIKIT_EXTERN XYPromptAnimationStyle const XYPromptAnimationStyleSlipTop;
UIKIT_EXTERN XYPromptAnimationStyle const XYPromptAnimationStyleSlipLeft;
UIKIT_EXTERN XYPromptAnimationStyle const XYPromptAnimationStyleSlipBottom;
UIKIT_EXTERN XYPromptAnimationStyle const XYPromptAnimationStyleSlipRight;

/// Animation protocol
@protocol XYPromptAnimationDescriber <NSObject>
@required
- (void)animateWithAnimator:(XYPromptAnimator *)animator present:(BOOL)present completion:(void (^)(BOOL finished))completion;
- (NSTimeInterval)presentDuration;
- (NSTimeInterval)dismissDuration;
@end

@interface XYPromptAnimator : NSObject
@property (nonatomic, weak, readonly) UIView *animationView;
@property (nonatomic, weak, readonly) XYPromptContainerController *animationController;
@property (nonatomic, strong) XYPromptAnimationStyle presentStyle;
@property (nonatomic, strong) XYPromptAnimationStyle dismissStyle;
@property (nonatomic, assign) NSTimeInterval presentDuration;
@property (nonatomic, assign) NSTimeInterval dismissDuration;
- (void)presentAnimation:(void (^ _Nullable)(BOOL finished))completion;
- (void)dismissAnimation:(void (^ _Nullable)(BOOL finished))completion;
+ (void)registerAnimationDescriber:(NSString *)describer forStyle:(XYPromptAnimationStyle)style; ///< conforms to XYPromptAnimationDescriber
@end

NS_ASSUME_NONNULL_END
