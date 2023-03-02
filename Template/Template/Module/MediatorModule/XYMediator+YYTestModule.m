//
//  XYMediator+YYTestModule.m
//  Template
//
//  Created by nevsee on 2021/12/6.
//

#import "XYMediator+YYTestModule.h"

@implementation XYMediator (YYTestModule)

- (UIViewController *)test_fetchAlertController {
    return [self performAction:@"fetchAlertController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchBoardController {
    return [self performAction:@"fetchBoardController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchCodeController {
    return [self performAction:@"fetchCodeController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchEmptyController {
    return [self performAction:@"fetchEmptyController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchFakeProgressController {
    return [self performAction:@"fetchFakeProgressController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchLoopController {
    return [self performAction:@"fetchLoopController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchMenuController {
    return [self performAction:@"fetchMenuController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchOperationController {
    return [self performAction:@"fetchOperationController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchPickerController {
    return [self performAction:@"fetchPickerController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchProgressController {
    return [self performAction:@"fetchProgressController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchSearchController {
    return [self performAction:@"fetchSearchController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchWebController {
    return [self performAction:@"fetchWebController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchBrowserController {
    return [self performAction:@"fetchBrowserController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchBadgeController {
    return [self performAction:@"fetchBadgeController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchAnimationController {
    return [self performAction:@"fetchAnimationController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchButtonController {
    return [self performAction:@"fetchButtonController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchCellController {
    return [self performAction:@"fetchCellController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchLabController {
    return [self performAction:@"fetchLabController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchLoadashController {
    return [self performAction:@"fetchLoadashController" forTarget:@"YYTestConnector" withParam:nil];
}

- (UIViewController *)test_fetchDynamicController {
    return [self performAction:@"fetchDynamicController" forTarget:@"YYTestConnector" withParam:nil];
}

@end
