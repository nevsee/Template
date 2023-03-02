//
//  XYPromptTransition.h
//  XYPrompter
//
//  Created by nevsee on 2018/12/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class XYPrompter;

NS_ASSUME_NONNULL_BEGIN

/**
 Represents the autorotation mode of the presented view controller.
 */
@interface XYPromptAutorotation : NSObject
@property (nonatomic, weak) XYPrompter *prompter;
@property (nonatomic, assign) BOOL shouldFollowInController;
@property (nonatomic, assign) BOOL shouldAutorotate;
@property (nonatomic, assign) UIInterfaceOrientationMask supportedInterfaceOrientations;
@property (nonatomic, assign) UIInterfaceOrientation preferredInterfaceOrientationForPresentation;
- (instancetype)initWithType:(BOOL)shouldFollowInController;
@end

NS_ASSUME_NONNULL_END
