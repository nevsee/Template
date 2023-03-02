//
//  XYPromptTransition.h
//  XYPrompter
//
//  Created by nevsee on 2018/9/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class XYPromptAnimator;
@class XYPromptInteractor;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XYPromptTransitionType) {
    XYPromptTransitionTypePresent = 0,
    XYPromptTransitionTypeDismiss,
};
 
@interface XYPromptAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) XYPromptTransitionType type;
@property (nonatomic, weak) XYPromptAnimator *animator;
@end

@interface XYPromptInteractiveTransition : UIPercentDrivenInteractiveTransition
@property (nonatomic, weak) XYPromptInteractor *interactor;
@end

NS_ASSUME_NONNULL_END
