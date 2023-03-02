//
//  main.m
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import <UIKit/UIKit.h>
#import "YYAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        appDelegateClassName = NSStringFromClass([YYAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
