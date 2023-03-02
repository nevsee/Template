//
//  XYButton.h
//  XYWidget
//
//  Created by nevsee on 2018/2/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYButton : UIButton

/// Dims the button when highlighted. Defaults to YES.
@property (nonatomic, assign) BOOL dimsButtonWhenHighlighted UI_APPEARANCE_SELECTOR;

/// Defaults to 0.7.
@property (nonatomic, assign) CGFloat highlightedAlpha UI_APPEARANCE_SELECTOR;

/// Dims the button when disabled. Defaults to YES.
@property (nonatomic, assign) BOOL dimsButtonWhenDisabled UI_APPEARANCE_SELECTOR;

/// Defaults to 0.5.
@property (nonatomic, assign) CGFloat disabledAlpha UI_APPEARANCE_SELECTOR;

/// The background color of the button when highlighted. Defaults to nil.
@property (nonatomic, strong, nullable) UIColor *highlightedBackgroundColor UI_APPEARANCE_SELECTOR;

/// The border color of the button when highlighted. Defaults to nil.
@property (nonatomic, strong, nullable) UIColor *highlightedBorderColor UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END
