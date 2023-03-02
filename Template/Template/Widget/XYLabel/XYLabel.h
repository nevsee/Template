//
//  XYLabel.h
//  XYWidget
//
//  Created by nevsee on 2018/3/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYLabel : UILabel

/// The insets of the text. Defaults to UIEdgeInsetsZero.
@property (nonatomic, assign) UIEdgeInsets textInsets;

/// Whether to turn on the long press copy function. Defaults to NO.
@property (nonatomic, assign) BOOL canPerformCopyAction;

/// The title of copy item for the menu controller. Defaults to nil.
@property (nonatomic, strong, nullable) NSString *menuCopyItemTitle;

/// The background color when highlighted. Defaults to nil.
@property (nonatomic, strong, nullable) UIColor *highlightedBackgroundColor UI_APPEARANCE_SELECTOR;

/// A block invoked when copy function has finished.
@property (nonatomic, strong) void (^copyBlock)(XYLabel *label, NSString *stringCopied);

@end

NS_ASSUME_NONNULL_END
