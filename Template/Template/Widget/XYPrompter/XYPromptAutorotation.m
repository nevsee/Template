//
//  XYPromptTransition.h
//  XYPrompter
//
//  Created by nevsee on 2018/12/20.
//

#import "XYPromptAutorotation.h"
#import "XYPrompter.h"

@implementation XYPromptAutorotation

- (instancetype)initWithType:(BOOL)shouldFollowInController {
    self = [super init];
    if (self) {
        _shouldFollowInController = shouldFollowInController;
        _shouldAutorotate = YES;
        _supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
        _preferredInterfaceOrientationForPresentation = UIInterfaceOrientationPortrait;
    }
    return self;
}

- (BOOL)shouldAutorotate {
    if (_shouldFollowInController && _prompter.inController) {
        return _prompter.inController.shouldAutorotate;
    } else {
        return _shouldAutorotate;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (_shouldFollowInController && _prompter.inController) {
        return _prompter.inController.supportedInterfaceOrientations;
    } else {
        return _supportedInterfaceOrientations;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (_shouldFollowInController && _prompter.inController) {
        return _prompter.inController.preferredInterfaceOrientationForPresentation;
    } else {
        return _preferredInterfaceOrientationForPresentation;
    }
}

@end
