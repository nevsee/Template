//
//  XYMediator+YYTestModule.h
//  Template
//
//  Created by nevsee on 2021/12/6.
//

#import "XYMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYMediator (YYTestModule)

- (UIViewController *)test_fetchAlertController;
- (UIViewController *)test_fetchBoardController;
- (UIViewController *)test_fetchCodeController;
- (UIViewController *)test_fetchEmptyController;
- (UIViewController *)test_fetchFakeProgressController;
- (UIViewController *)test_fetchLoopController;
- (UIViewController *)test_fetchMenuController;
- (UIViewController *)test_fetchOperationController;
- (UIViewController *)test_fetchPickerController;
- (UIViewController *)test_fetchProgressController;
- (UIViewController *)test_fetchSearchController;
- (UIViewController *)test_fetchWebController;
- (UIViewController *)test_fetchBrowserController;
- (UIViewController *)test_fetchBadgeController;
- (UIViewController *)test_fetchAnimationController;
- (UIViewController *)test_fetchButtonController;
- (UIViewController *)test_fetchCellController;
- (UIViewController *)test_fetchLoadashController;

- (UIViewController *)test_fetchLabController;
- (UIViewController *)test_fetchDynamicController;

@end

NS_ASSUME_NONNULL_END
