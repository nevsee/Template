//
//  YYAppAppearance.m
//  Template
//
//  Created by nevsee on 2021/12/24.
//

#import "YYAppAppearance.h"
#import "XYPopupMenuContentView.h"

@implementation YYAppAppearance

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    // 主框架外观设置
    [self mainFrameAppearanceSetup];
    // 提示外观设置
    [self alertAppearanceSetup];
    // 吐司外观设置
    [self toastAppearanceSetup];
    // 弹框外观设置
    [self popupAppearanceSetup];
    // 第三方UI框架外观设置
    [self thirdLibraryAppearanceSetup];
    return YES;
}

- (void)mainFrameAppearanceSetup {
    // navigationBar
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.titleTextAttributes = @{
        NSForegroundColorAttributeName: YYNeutral9Color,
        NSFontAttributeName: XYFontBoldMake(18)
    };
    navigationBar.tintColor = YYNeutral9Color;

    // navigationBarBackground
    XYNavigationBarBackground *navigationBarBackground = [XYNavigationBarBackground appearance];
    navigationBarBackground.barTintColor = YYNeutral2Color;
    navigationBarBackground.barSeparatorColor = nil;

    // tabBarBackground
    XYTabBarBackground *tabBackground = [XYTabBarBackground appearance];
    tabBackground.barSeparatorColor = nil;
    
    // barButtonItem
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    NSDictionary *barButtonItemNormalAttributes = @{
        NSForegroundColorAttributeName: YYNeutral9Color,
        NSFontAttributeName: XYFontMake(15)
    };
    NSDictionary *barButtonItemHighlightedlAttributes = @{
        NSForegroundColorAttributeName: YYNeutral9Color,
        NSFontAttributeName: XYFontMake(15)
    };
    [barButtonItem setTitleTextAttributes:barButtonItemNormalAttributes forState:UIControlStateNormal];
    [barButtonItem setTitleTextAttributes:barButtonItemHighlightedlAttributes forState:UIControlStateHighlighted];

    // tabBarItem
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    NSDictionary *tabBarItemNormalAttributes = @{
        NSForegroundColorAttributeName: YYNeutral9Color,
        NSFontAttributeName: XYFontBoldMake(11)
    };
    NSDictionary *tabBarItemHighlightedAttributes = @{
        NSForegroundColorAttributeName: YYTheme3Color,
        NSFontAttributeName: XYFontBoldMake(11)
    };
    [tabBarItem setTitleTextAttributes:tabBarItemNormalAttributes forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:tabBarItemHighlightedAttributes forState:UIControlStateHighlighted];
    
    // tableView
    if (@available(iOS 15.0, *)) {
        [UITableView appearance].sectionHeaderTopPadding = 0;
        [UITableView appearance].fillerRowHeight = 0;
        [UITableView appearance].prefetchingEnabled = NO;
    }
}

- (void)alertAppearanceSetup {
    NSMutableParagraphStyle *contentStyle = [[NSMutableParagraphStyle alloc] init];
    contentStyle.lineSpacing = 4;
    contentStyle.alignment = NSTextAlignmentCenter;
    
    XYAlertAppearance *alert = [XYAlertAppearance appearance];
    // alert
    alert.cornerRadiiForAlert = 10;
    alert.potraitWidthForAlert = UIDevice.xy_deviceWidth > 320 ? 300 : 285;
    alert.landscapeWidthForAlert = UIDevice.xy_deviceWidth > 320 ? 300 : 285;
    alert.contentInsetsForAlert = UIEdgeInsetsMake(5, 20, 10, 20);
    alert.actionHighlightedColor = YYNeutral1Color;
    alert.actionDefaultAttributesForAlert = @{
        NSForegroundColorAttributeName: YYNeutral9Color,
        NSFontAttributeName: XYFontMake(17)
    };
    alert.actionCancelAttributesForAlert = @{
        NSForegroundColorAttributeName: YYNeutral9Color,
        NSFontAttributeName: XYFontWeightMake(17, UIFontWeightMedium)
    };
    alert.actionDestructiveAttributesForAlert = @{
        NSForegroundColorAttributeName: YYWarning2Color,
        NSFontAttributeName: XYFontMake(17)
    };
    alert.actionTitleDisabledAttributesForAlert = @{
        NSForegroundColorAttributeName: YYNeutral5Color,
        NSFontAttributeName: XYFontMake(17)
    };
    alert.contentTitleAttributesForAlert = @{
        NSForegroundColorAttributeName: YYNeutral9Color,
        NSFontAttributeName: XYFontBoldMake(17),
        NSParagraphStyleAttributeName: contentStyle
    };
    alert.contentMessageAttributesForAlert = @{
        NSForegroundColorAttributeName: YYNeutral7Color,
        NSFontAttributeName: XYFontMake(17),
        NSParagraphStyleAttributeName: contentStyle
    };
    
    // sheet
    alert.cornerRadiiForSheet = 15;
    alert.potraitWidthForSheet = YYDeviceWidth;
    alert.landscapeWidthForSheet = YYDeviceWidth;
    alert.contentInsetsForSheet = UIEdgeInsetsMake(5, 20, 5, 20);
    alert.actionDefaultAttributesForSheet = @{
        NSForegroundColorAttributeName: YYNeutral9Color,
        NSFontAttributeName: XYFontMake(17)
    };
    alert.actionCancelAttributesForSheet = @{
        NSForegroundColorAttributeName: YYNeutral9Color,
        NSFontAttributeName: XYFontMake(17)
    };
    alert.actionDestructiveAttributesForSheet = @{
        NSForegroundColorAttributeName: YYWarning2Color,
        NSFontAttributeName: XYFontMake(17)
    };
    alert.actionTitleDisabledAttributesForSheet = @{
        NSForegroundColorAttributeName: YYNeutral5Color,
        NSFontAttributeName: XYFontMake(17)
    };
    alert.contentTitleAttributesForSheet = @{
        NSForegroundColorAttributeName: YYNeutral7Color,
        NSFontAttributeName: XYFontBoldMake(15),
        NSParagraphStyleAttributeName: contentStyle
    };
    alert.contentMessageAttributesForSheet = @{
        NSForegroundColorAttributeName: YYNeutral7Color,
        NSFontAttributeName: XYFontMake(13),
        NSParagraphStyleAttributeName: contentStyle
    };
}

- (void)toastAppearanceSetup {
    // background
    XYToastDefaultBackgroundView *backgroundView = [XYToastDefaultBackgroundView appearance];
    backgroundView.styleColor = [UIColor colorWithWhite:0 alpha:0.9];

    // content
    NSMutableParagraphStyle *defaultStyle = [[NSMutableParagraphStyle alloc] init];
    defaultStyle.lineSpacing = 3;
    defaultStyle.alignment = NSTextAlignmentCenter;
    XYToastDefaultContentView *defaultContentView = [XYToastDefaultContentView appearance];
    defaultContentView.contentInsets = UIEdgeInsetsMake(18, 18, 18, 18);
    defaultContentView.customBottomMargin = 12;
    defaultContentView.textBottomMargin = 6;
    defaultContentView.textAttributes = @{
        NSFontAttributeName: XYFontMake(16),
        NSForegroundColorAttributeName: UIColor.whiteColor,
        NSParagraphStyleAttributeName: defaultStyle
    };
    defaultContentView.detailTextAttributes = @{
        NSFontAttributeName: XYFontMake(14),
        NSForegroundColorAttributeName: [UIColor colorWithWhite:0.95 alpha:1],
        NSParagraphStyleAttributeName: defaultStyle
    };
}

- (void)popupAppearanceSetup {
    XYPopupView *popup = [XYPopupView appearance];
    popup.popupSpacing = 5;
    popup.popupMargin = 10;
    
    XYPopupMenuTextItem *item = [XYPopupMenuTextItem appearance];
    item.textInsets = UIEdgeInsetsMake(17, 10, 17, 10);
    item.textAttributes = @{
        NSForegroundColorAttributeName: [UIColor blackColor],
        NSFontAttributeName: XYFontMake(15)
    };
}

- (void)thirdLibraryAppearanceSetup {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.keyboardDistanceFromTextField = 20;
    manager.toolbarTintColor = YYNeutral9Color;
    manager.toolbarDoneBarButtonItemText = @"完成";
    manager.shouldShowToolbarPlaceholder = NO;
}

@end
