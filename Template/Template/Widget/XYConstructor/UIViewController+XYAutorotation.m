//
//  UIViewController+XYAutorotation.m
//  XYConstructor
//
//  Created by nevsee on 2017/9/23.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "UIViewController+XYAutorotation.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation UIViewController (XYAutorotation)

- (BOOL)xy_shouldAutorotate {
    NSNumber *value = objc_getAssociatedObject(self, @selector(setXy_shouldAutorotate:));
    return value.boolValue;
}

- (void)setXy_shouldAutorotate:(BOOL)xy_shouldAutorotate {
    objc_setAssociatedObject(self, _cmd, @(xy_shouldAutorotate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIInterfaceOrientationMask)xy_supportedInterfaceOrientations {
    NSNumber *value = objc_getAssociatedObject(self, @selector(setXy_supportedInterfaceOrientations:));
    return value.integerValue;
}

- (void)setXy_supportedInterfaceOrientations:(UIInterfaceOrientationMask)xy_supportedInterfaceOrientations {
    objc_setAssociatedObject(self, _cmd, @(xy_supportedInterfaceOrientations), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIInterfaceOrientation)xy_preferredInterfaceOrientationForPresentation {
    NSNumber *value = objc_getAssociatedObject(self, @selector(setXy_preferredInterfaceOrientationForPresentation:));
    return value.integerValue;
}

- (void)setXy_preferredInterfaceOrientationForPresentation:(UIInterfaceOrientation)xy_preferredInterfaceOrientationForPresentation {
    objc_setAssociatedObject(self, _cmd, @(xy_preferredInterfaceOrientationForPresentation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xy_containsInterfaceOrientation {
    UIInterfaceOrientationMask mask = self.supportedInterfaceOrientations;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    return [UIViewController xy_containsInterfaceOrientation:orientation inInterfaceOrientationMask:mask];
}

- (UIDeviceOrientation)xy_optimalDeviceOrientation {
    UIInterfaceOrientationMask mask = self.supportedInterfaceOrientations;
    return [UIViewController xy_transformsInterfaceOrientationMaskToDeviceOrientation:mask];
}

- (BOOL)xy_rotateToOptimaDeviceOrientationIfNeeded {
    UIDeviceOrientation orientation = (UIDeviceOrientation)UIApplication.sharedApplication.statusBarOrientation;
    UIDeviceOrientation optimalOrientation = self.xy_optimalDeviceOrientation;
    if (optimalOrientation == orientation) return NO;
    return [UIViewController xy_rotateToDeviceOrientation:optimalOrientation];
}

+ (BOOL)xy_rotateToDeviceOrientation:(UIDeviceOrientation)orientation {
    if ([UIDevice currentDevice].orientation == orientation) {
        [UIViewController attemptRotationToDeviceOrientation];
        return NO;
    }
    [[UIDevice currentDevice] setValue:@(orientation) forKey:@"orientation"];
    return YES;
}

+ (BOOL)xy_rotateToDevicePortraitOrientationIfNeeded {
    UIInterfaceOrientation orientation = UIApplication.sharedApplication.statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) return NO;
    [self xy_rotateToDeviceOrientation:UIDeviceOrientationPortrait];
    return YES;
}

+ (UIDeviceOrientation)xy_transformsInterfaceOrientationMaskToDeviceOrientation:(UIInterfaceOrientationMask)mask {
    if ((mask & UIInterfaceOrientationMaskAll) == UIInterfaceOrientationMaskAll) {
        return [UIDevice currentDevice].orientation;
    }
    if ((mask & UIInterfaceOrientationMaskAllButUpsideDown) == UIInterfaceOrientationMaskAllButUpsideDown) {
        return [UIDevice currentDevice].orientation;
    }
    if ((mask & UIInterfaceOrientationMaskPortrait) == UIInterfaceOrientationMaskPortrait) {
        return UIDeviceOrientationPortrait;
    }
    if ((mask & UIInterfaceOrientationMaskLandscape) == UIInterfaceOrientationMaskLandscape) {
        return [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ? UIDeviceOrientationLandscapeLeft : UIDeviceOrientationLandscapeRight;
    }
    if ((mask & UIInterfaceOrientationMaskLandscapeLeft) == UIInterfaceOrientationMaskLandscapeLeft) {
        return UIDeviceOrientationLandscapeRight;
    }
    if ((mask & UIInterfaceOrientationMaskLandscapeRight) == UIInterfaceOrientationMaskLandscapeRight) {
        return UIDeviceOrientationLandscapeLeft;
    }
    if ((mask & UIInterfaceOrientationMaskPortraitUpsideDown) == UIInterfaceOrientationMaskPortraitUpsideDown) {
        return UIDeviceOrientationPortraitUpsideDown;
    }
    return [UIDevice currentDevice].orientation;
}

+ (BOOL)xy_containsDeviceOrientation:(UIDeviceOrientation)deviceOrientation inInterfaceOrientationMask:(UIInterfaceOrientationMask)mask {
    if (deviceOrientation == UIDeviceOrientationUnknown) {
        return YES;
    }
    if ((mask & UIInterfaceOrientationMaskAll) == UIInterfaceOrientationMaskAll) {
        return YES;
    }
    if ((mask & UIInterfaceOrientationMaskAllButUpsideDown) == UIInterfaceOrientationMaskAllButUpsideDown) {
        return UIInterfaceOrientationPortraitUpsideDown != deviceOrientation;
    }
    if ((mask & UIInterfaceOrientationMaskPortrait) == UIInterfaceOrientationMaskPortrait) {
        return UIInterfaceOrientationPortrait == deviceOrientation;
    }
    if ((mask & UIInterfaceOrientationMaskLandscape) == UIInterfaceOrientationMaskLandscape) {
        return UIInterfaceOrientationLandscapeLeft == deviceOrientation || UIInterfaceOrientationLandscapeRight == deviceOrientation;
    }
    if ((mask & UIInterfaceOrientationMaskLandscapeLeft) == UIInterfaceOrientationMaskLandscapeLeft) {
        return UIInterfaceOrientationLandscapeLeft == deviceOrientation;
    }
    if ((mask & UIInterfaceOrientationMaskLandscapeRight) == UIInterfaceOrientationMaskLandscapeRight) {
        return UIInterfaceOrientationLandscapeRight == deviceOrientation;
    }
    if ((mask & UIInterfaceOrientationMaskPortraitUpsideDown) == UIInterfaceOrientationMaskPortraitUpsideDown) {
        return UIInterfaceOrientationPortraitUpsideDown == deviceOrientation;
    }
    return YES;
}

+ (BOOL)xy_containsInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation inInterfaceOrientationMask:(UIInterfaceOrientationMask)mask {
    return [self xy_containsDeviceOrientation:(UIDeviceOrientation)interfaceOrientation inInterfaceOrientationMask:mask];
}

@end

#pragma clang diagnostic pop
