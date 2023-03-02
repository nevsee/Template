//
//  XYConstructor.h
//  XYConstructor
//
//  Created by nevsee on 2018/8/7.
//  Copyright © 2018年 nevsee. All rights reserved.
//
#import <UIKit/UIKit.h>

#if __has_include(<XYConstructor/XYConstructor.h>)
FOUNDATION_EXPORT double XYConstructorVersionNumber;
FOUNDATION_EXPORT const unsigned char XYConstructorVersionString[];
#import <XYConstructor/XYNavigationController.h>
#import <XYConstructor/XYTabBarController.h>
#import <XYConstructor/XYViewController.h>
#import <XYConstructor/UIViewController+XYAutorotation.h>
#import <XYConstructor/UIViewController+XYNavigation.h>
#import <XYConstructor/UIViewController+XYWorkflow.h>
#import <XYConstructor/UITabBarItem+XYCustom.h>
#import <XYConstructor/UIBarButtonItem+XYCustom.h>
#else
#import "XYNavigationController.h"
#import "XYTabBarController.h"
#import "XYViewController.h"
#import "UIViewController+XYAutorotation.h"
#import "UIViewController+XYNavigation.h"
#import "UIViewController+XYWorkflow.h"
#import "UITabBarItem+XYCustom.h"
#import "UIBarButtonItem+XYCustom.h"
#endif

