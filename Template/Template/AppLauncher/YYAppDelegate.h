//
//  AppDelegate.h
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UNUserNotificationCenter.h>

@interface YYAppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) BOOL shouldAutorotate; ///< 全局控制屏幕旋转，默认YES
@end

