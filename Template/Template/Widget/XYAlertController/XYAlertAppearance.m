//
//  XYAlertAction.h
//  XYAlertController
//
//  Created by nevsee on 2018/10/12.
//

#import "XYAlertAppearance.h"

@implementation XYAlertAppearance

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XYAlertAppearance *appearance = [XYAlertAppearance appearance];
        CGSize mainSize = [UIScreen mainScreen].bounds.size;
        
        // XYAlertController
        appearance.cornerRadiiForAlert = 10;
        appearance.cornerRadiiForSheet = 15;
        appearance.potraitWidthForAlert = 280;
        appearance.landscapeWidthForAlert = 280;
        appearance.potraitWidthForSheet =  MIN(mainSize.width, mainSize.height);
        appearance.landscapeWidthForSheet = MIN(mainSize.width, mainSize.height);
        
        // XYAlertFixedSpaceAction
        appearance.actionPlaceholderHeightFotSheet = 7;
        appearance.actionPlaceholderColorFotSheet = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
            
        // XYAlertSketchAction
        appearance.actionSeparatorSize = 1 / [UIScreen mainScreen].scale;
        appearance.actionSeparatorColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        appearance.actionHighlightedColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    
        appearance.actionHeightForAlert = 50;
        appearance.actionDefaultAttributesForAlert = @{
            NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1],
            NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightRegular]
        };
        appearance.actionCancelAttributesForAlert = @{
            NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1],
            NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]
        };
        appearance.actionDestructiveAttributesForAlert = @{
            NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:0.23 blue:0.19 alpha:1],
            NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightRegular]
        };
        
        appearance.actionHeightForSheet = 55;
        appearance.actionDefaultAttributesForSheet = @{
            NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1],
            NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightRegular]
        };
        appearance.actionCancelAttributesForSheet = @{
            NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1],
            NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]
        };
        appearance.actionDestructiveAttributesForSheet = @{
            NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:0.23 blue:0.19 alpha:1],
            NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightRegular]
        };
        
        // XYAlertTimerAction
        appearance.actionTitleDisabledAttributesForAlert = @{
            NSForegroundColorAttributeName: [UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1],
            NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightRegular]
        };
        appearance.actionTitleDisabledAttributesForSheet = @{
            NSForegroundColorAttributeName: [UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1],
            NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]
        };
        
        // XYAlertFixedSpaceContent
        appearance.contentPlaceholderHeightForAlert = 20;
        appearance.contentPlaceholderHeightForSheet = 15;
        
        // XYAlertTextContent
        appearance.contentInsetsForAlert = UIEdgeInsetsMake(3, 16, 3, 16);
        appearance.contentTitleAttributesForAlert = @{
            NSForegroundColorAttributeName: [UIColor colorWithWhite:0 alpha:1],
            NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]
        };
        appearance.contentMessageAttributesForAlert = @{
            NSForegroundColorAttributeName: [UIColor colorWithWhite:0 alpha:1],
            NSFontAttributeName: [UIFont systemFontOfSize:15 weight:UIFontWeightRegular]
        };
        
        appearance.contentInsetsForSheet = UIEdgeInsetsMake(3, 16, 3, 16);
        appearance.contentTitleAttributesForSheet = @{
            NSForegroundColorAttributeName: [UIColor colorWithWhite:0 alpha:0.7],
            NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]
        };
        appearance.contentMessageAttributesForSheet = @{
            NSForegroundColorAttributeName: [UIColor colorWithWhite:0 alpha:0.7],
            NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightRegular]
        };
    });
}

@end
