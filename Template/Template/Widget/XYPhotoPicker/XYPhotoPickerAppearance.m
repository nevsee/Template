//
//  XYPhotoPickerAppearance.m
//  XYPhotoPicker
//
//  Created by nevsee on 2017/6/10.
//

#import "XYPhotoPickerAppearance.h"

@implementation XYPhotoPickerAppearance

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XYPhotoPickerAppearance *appearance = [XYPhotoPickerAppearance appearance];
        appearance.pickerStyle = XYPhotoPickerStyleBlack;
        
        if (appearance.pickerStyle == XYPhotoPickerStyleBlack) {
            // picker
            appearance.pickerBackgroundColor = [UIColor colorWithRed:50 / 255.f green:50 / 255.f blue:50 / 255.f alpha:1];
            appearance.pickerNavigationBarTitleAttributes =  @{
                NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                NSForegroundColorAttributeName: [UIColor whiteColor]
            };
            appearance.pickerNavigationBarTextAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor whiteColor]
            };
            appearance.pickerNavigationBarBackImage = @"xy_nav_back_white";
            
            // authorize
            appearance.authorizedNoteTitleAttributes = @{
                NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                NSForegroundColorAttributeName: [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1]
            };
            appearance.authorizedNoteDetailAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:17],
                NSForegroundColorAttributeName: [UIColor colorWithRed:192 / 255.0 green:192 / 255.0 blue:192 / 255.0 alpha:1]
            };
            appearance.authorizedJumpTitleAttributes = @{
                NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
                NSForegroundColorAttributeName: [UIColor colorWithRed:18 / 255.0 green:150 / 255.0 blue:219 / 255.0 alpha:1]
            };
            appearance.authorizedLimitedNoteAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithRed:128 / 255.0 green:128 / 255.0 blue:128 / 255.0 alpha:1]
            };
            appearance.authorizedLimitedJumpTitleAttributes = @{
                NSFontAttributeName: [UIFont boldSystemFontOfSize:15],
                NSForegroundColorAttributeName: [UIColor colorWithRed:18 / 255.0 green:150 / 255.0 blue:219 / 255.0 alpha:1]
            };
            appearance.authorizedLimitedAddTitleAttributes = @{
                NSFontAttributeName: [UIFont boldSystemFontOfSize:15],
                NSForegroundColorAttributeName: [UIColor colorWithRed:18 / 255.0 green:150 / 255.0 blue:219 / 255.0 alpha:1]
            };

            // album
            appearance.albumCellHeight = 72;
            appearance.albumSelectedColor = [UIColor colorWithRed:67 / 255.0 green:67 / 255.0 blue:67 / 255.0 alpha:1];
            appearance.albumImageSize = 56;
            appearance.albumImageLeftMargin = 8;
            appearance.albumImageCornerRadius = 5;
            appearance.albumNameInsets = UIEdgeInsetsMake(0, 14, 2, 5);
            appearance.albumNameAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithRed:209 / 255.0 green:209 / 255.0 blue:209 / 255.0 alpha:1]
            };
            appearance.albumNumberInsets = UIEdgeInsetsMake(2, 14, 0, 5);
            appearance.albumNumberAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithRed:128 / 255.0 green:128 / 255.0 blue:128 / 255.0 alpha:1]
            };
            appearance.albumArrowRightMargin = 8;
            appearance.albumArrowImage = @"xy_album_arrow_black";
            appearance.albumSeparatorInsets = UIEdgeInsetsMake(0, 8, 0, 0);
            appearance.albumSepratorHeight = 0.5;
            appearance.albumSeparatorColor = [UIColor colorWithRed:67 / 255.0 green:67 / 255.0 blue:67 / 255.0 alpha:1];
            
            // asset
            appearance.assetColumnCount = 4;
            appearance.assetSectionInsets = UIEdgeInsetsMake(2, 2, 2, 2);
            appearance.assetSpacing = 2;
            appearance.assetNotSelectedImage = @"xy_asset_choose_n";
            appearance.assetSelectedImage = @"xy_asset_choose_s";
            appearance.assetNoteFont = [UIFont boldSystemFontOfSize:12];
            appearance.assetNoteColor = [UIColor whiteColor];
            appearance.assetToolBarItemNormalAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor whiteColor]
            };
            appearance.assetToolBarItemDisabledAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.5]
            };
            appearance.assetToolBarDoneItemNormalAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor whiteColor]
            };
            appearance.assetToolBarDoneItemDisabledAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.5]
            };
            appearance.assetToolBarDoneItemNormalBackgroundColor = [UIColor colorWithRed:18/ 255.0 green:150 / 255.0 blue:219 / 255.0 alpha:1];
            appearance.assetToolBarDoneItemDisabledBackgroundColor = [UIColor colorWithRed:45 / 255.0 green:45 / 255.0 blue:45 / 255.0 alpha:1];
            
            // preview
            appearance.previewTopBarBackImage = @"xy_nav_back_white";
            appearance.previewTopBarNotSelectedImage = @"xy_asset_choose_n";
            appearance.previewTopBarSelectedImage = @"xy_asset_choose_s";
            appearance.previewToolBarOriginNotSelectedImage = @"xy_bar_choose_n";
            appearance.previewToolBarOriginSelectedImage = @"xy_bar_choose_s";
            appearance.previewToolBarItemNormalAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor whiteColor]
            };
            appearance.previewToolBarItemDisabledAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.5]
            };
            appearance.previewToolBarItemNormalBackgroundColor = [UIColor colorWithRed:18/ 255.0 green:150 / 255.0 blue:219 / 255.0 alpha:1];
            appearance.previewToolBarItemDisabledBackgroundColor = [UIColor colorWithRed:45 / 255.0 green:45 / 255.0 blue:45 / 255.0 alpha:1];
        } else {
            // picker
            appearance.pickerBackgroundColor = [UIColor whiteColor];
            appearance.pickerNavigationBarTitleAttributes =  @{
                NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                NSForegroundColorAttributeName: [UIColor colorWithRed:49 / 255.0 green:49 / 255.0 blue:48 / 255.0 alpha:1]
            };
            appearance.pickerNavigationBarTextAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithRed:49 / 255.0 green:49 / 255.0 blue:48 / 255.0 alpha:1]
            };
            appearance.pickerNavigationBarBackImage = @"xy_nav_back_black";

            // authorize
            appearance.authorizedNoteTitleAttributes = @{
                NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                NSForegroundColorAttributeName: [UIColor colorWithRed:49 / 255.0 green:49 / 255.0 blue:48 / 255.0 alpha:1]
            };
            appearance.authorizedNoteDetailAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithRed:105 / 255.0 green:105 / 255.0 blue:105 / 255.0 alpha:1]
            };
            appearance.authorizedJumpTitleAttributes = @{
                NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithRed:18 / 255.0 green:150 / 255.0 blue:219 / 255.0 alpha:1]
            };
            appearance.authorizedLimitedNoteAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithRed:105 / 255.0 green:105 / 255.0 blue:105 / 255.0 alpha:1]
            };
            appearance.authorizedLimitedJumpTitleAttributes = @{
                NSFontAttributeName: [UIFont boldSystemFontOfSize:15],
                NSForegroundColorAttributeName: [UIColor colorWithRed:18 / 255.0 green:150 / 255.0 blue:219 / 255.0 alpha:1]
            };
            appearance.authorizedLimitedAddTitleAttributes = @{
                NSFontAttributeName: [UIFont boldSystemFontOfSize:15],
                NSForegroundColorAttributeName: [UIColor colorWithRed:18 / 255.0 green:150 / 255.0 blue:219 / 255.0 alpha:1]
            };
            
            // album
            appearance.albumCellHeight = 72;
            appearance.albumSelectedColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
            appearance.albumImageSize = 56;
            appearance.albumImageLeftMargin = 8;
            appearance.albumImageCornerRadius = 5;
            appearance.albumNameInsets = UIEdgeInsetsMake(0, 14, 2, 5);
            appearance.albumNameAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithRed:49 / 255.0 green:49 / 255.0 blue:48 / 255.0 alpha:1]
            };
            appearance.albumNumberInsets = UIEdgeInsetsMake(2, 14, 0, 5);
            appearance.albumNumberAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithRed:169 / 255.0 green:169 / 255.0 blue:169 / 255.0 alpha:1]
            };
            appearance.albumArrowRightMargin = 8;
            appearance.albumArrowImage = @"xy_album_arrow_white";
            appearance.albumSeparatorInsets = UIEdgeInsetsMake(0, 8, 0, 0);
            appearance.albumSepratorHeight = 0.5;
            appearance.albumSeparatorColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
            
            // asset
            appearance.assetColumnCount = 4;
            appearance.assetSectionInsets = UIEdgeInsetsMake(2, 2, 2, 2);
            appearance.assetSpacing = 2;
            appearance.assetNotSelectedImage = @"xy_asset_choose_n";
            appearance.assetSelectedImage = @"xy_asset_choose_s";
            appearance.assetNoteFont = [UIFont boldSystemFontOfSize:12];
            appearance.assetNoteColor = [UIColor whiteColor];
            appearance.assetToolBarItemNormalAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithRed:49 / 255.0 green:49 / 255.0 blue:48 / 255.0 alpha:1]
            };
            appearance.assetToolBarItemDisabledAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithRed:49 / 255.0 green:49 / 255.0 blue:48 / 255.0 alpha:0.5]
            };
            appearance.assetToolBarDoneItemNormalAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor whiteColor]
            };
            appearance.assetToolBarDoneItemDisabledAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithRed:49 / 255.0 green:49 / 255.0 blue:48 / 255.0 alpha:0.5]
            };
            appearance.assetToolBarDoneItemNormalBackgroundColor = [UIColor colorWithRed:18 / 255.0 green:150 / 255.0 blue:219 / 255.0 alpha:1];
            appearance.assetToolBarDoneItemDisabledBackgroundColor = [UIColor colorWithRed:169 / 255.0 green:169 / 255.0 blue:169 / 255.0 alpha:0.5];
            
            // preview
            appearance.previewTopBarBackImage = @"xy_nav_back_white";
            appearance.previewTopBarNotSelectedImage = @"xy_asset_choose_n";
            appearance.previewTopBarSelectedImage = @"xy_asset_choose_s";
            appearance.previewToolBarOriginNotSelectedImage = @"xy_bar_choose_n";
            appearance.previewToolBarOriginSelectedImage = @"xy_bar_choose_s";
            appearance.previewToolBarItemNormalAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor whiteColor]
            };
            appearance.previewToolBarItemDisabledAttributes = @{
                NSFontAttributeName: [UIFont systemFontOfSize:16],
                NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.5]
            };
            appearance.previewToolBarItemNormalBackgroundColor = [UIColor colorWithRed:18/ 255.0 green:150 / 255.0 blue:219 / 255.0 alpha:1];
            appearance.previewToolBarItemDisabledBackgroundColor = [UIColor colorWithRed:45 / 255.0 green:45 / 255.0 blue:45 / 255.0 alpha:1];
        }
        
        // localized
        appearance.pickerName = @"相簿";
        appearance.cancelName = @"取消";
        appearance.previewName = @"预览";
        appearance.doneName = @"完成";
        appearance.originName = @"原图";
        appearance.authorizedNoteTitleName = @"无法访问相簿中的照片";
        appearance.authorizedNoteDetailName = @"你已经关闭%@照片访问权限，建议允许访问「所有照片」";
        appearance.authorizedJumpTitleName = @"前往系统设置";
        appearance.authorizedLimitedNoteName = @"你已经设置%@只能访问相簿部分照片，建议允许访问「所有照片」";
        appearance.authorizedLimitedJumpTitleName = @"前往系统设置";
        appearance.authorizedLimitedAddTitleName = @"添加更多可访问照片";
        
        // Autorotate
        appearance.shouldAutorotate = YES;
    });
}

@end
