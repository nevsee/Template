//
//  XYToastAnimator.h
//  XYToastView
//
//  Created by nevsee on 2017/3/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class XYToastView;
@class XYToastAnimator;

NS_ASSUME_NONNULL_BEGIN

/// Animation style
typedef NSString *XYToastAnimationStyle NS_EXTENSIBLE_STRING_ENUM;
UIKIT_EXTERN XYToastAnimationStyle const XYToastAnimationStyleBounce;
UIKIT_EXTERN XYToastAnimationStyle const XYToastAnimationStyleZoom;
UIKIT_EXTERN XYToastAnimationStyle const XYToastAnimationStyleFade;
UIKIT_EXTERN XYToastAnimationStyle const XYToastAnimationStyleSlipTop;
UIKIT_EXTERN XYToastAnimationStyle const XYToastAnimationStyleSlipLeft;
UIKIT_EXTERN XYToastAnimationStyle const XYToastAnimationStyleSlipBottom;
UIKIT_EXTERN XYToastAnimationStyle const XYToastAnimationStyleSlipRight;

/// Animation protocol
@protocol XYToastAnimatorDescriber <NSObject>
@required
- (void)animateWithAnimator:(XYToastAnimator *)animator show:(BOOL)show completion:(void (^)(BOOL finished))completion;
- (NSTimeInterval)showDuration;
- (NSTimeInterval)hideDuration;
@end

@interface XYToastAnimator : NSObject
@property (nonatomic, strong) XYToastAnimationStyle showStyle;
@property (nonatomic, strong) XYToastAnimationStyle hideStyle;
@property (nonatomic, assign) NSTimeInterval showDuration;
@property (nonatomic, assign) NSTimeInterval hideDuration;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, weak) XYToastView *toastView;
- (void)showWithCompletion:(void (^)(BOOL finished))completion;
- (void)hideWithCompletion:(void (^)(BOOL finished))completion;
+ (void)registerAnimationDescriber:(NSString *)describer forStyle:(XYToastAnimationStyle)style;
@end

NS_ASSUME_NONNULL_END
