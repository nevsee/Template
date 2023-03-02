//
//  XYNavigator.h
//  XYMediator
//
//  Created by nevsee on 2021/1/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYNavigator : NSObject

@property (class, nonatomic, readonly, nullable) UIWindow *keyWindow;
@property (class, nonatomic, readonly, nullable) UIViewController *topViewController;

+ (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated;

+ (void)presentViewController:(UIViewController *)viewController
                     animated:(BOOL)animated
                   completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
