//
//  XYPopupAnimator.h
//  XYPopupView
//
//  Created by nevsee on 2017/12/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class XYPopupView;
@class XYPopupAnimator;

NS_ASSUME_NONNULL_BEGIN

/// Animation style
typedef NSString *XYPopupAnimationStyle NS_EXTENSIBLE_STRING_ENUM;
UIKIT_EXTERN XYPopupAnimationStyle const XYPopupAnimationStyleBounce;
UIKIT_EXTERN XYPopupAnimationStyle const XYPopupAnimationStyleZoom;
UIKIT_EXTERN XYPopupAnimationStyle const XYPopupAnimationStyleFade;

/// Animation protocol
@protocol XYPopupAnimationDescriber <NSObject>
@required
- (void)animateWithAnimator:(XYPopupAnimator *)animator show:(BOOL)show completion:(void (^)(BOOL finished))completion;
- (NSTimeInterval)showDuration;
- (NSTimeInterval)hideDuration;
@end

@interface XYPopupAnimator : NSObject
@property (nonatomic, strong) XYPopupAnimationStyle showStyle;
@property (nonatomic, strong) XYPopupAnimationStyle hideStyle;
@property (nonatomic, assign) NSTimeInterval showDuration;
@property (nonatomic, assign) NSTimeInterval hideDuration;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, weak) XYPopupView *popupView;
- (void)showWithCompletion:(void (^)(BOOL finished))completion;
- (void)hideWithCompletion:(void (^)(BOOL finished))completion;
+ (void)registerAnimationDescriber:(NSString *)describer forStyle:(XYPopupAnimationStyle)style;
@end

NS_ASSUME_NONNULL_END
