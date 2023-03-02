//
//  XYSearchBar.h
//  XYWidget
//
//  Created by nevsee on 2020/11/12.
//

#import <UIKit/UIKit.h>

@class XYSearchBackgroundView;
@class XYSearchTextField;
@class XYSearchButton;
@protocol XYSearchBarDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYSearchBarMode) {
    XYSearchBarModeNever,
    XYSearchBarModeWhileEditing,
    XYSearchBarModeAlways,
};

@interface XYSearchBar : UIView <UITextFieldDelegate>

/// The background view of the search bar.
@property (nonatomic, strong, readonly) XYSearchBackgroundView *backgroundView;

/// The text field of the search bar.
@property (nonatomic, strong, readonly) XYSearchTextField *textField;

/// The cancel button of the search bar.
@property (nonatomic, strong, readonly) XYSearchButton *cancelButton;

/// Whether the text field is editing or not.
@property (nonatomic, assign, readonly) BOOL isEditing;

/// Whether the cancel button is visible or not.
@property (nonatomic, assign, readonly) BOOL isCancelButtonVisible;

/// The background color of the text field.
@property (nonatomic, strong, nullable) UIColor *textFieldBackgroundColor UI_APPEARANCE_SELECTOR;

/// The corner radius of the text field. Defaults to 5.
@property (nonatomic, assign) CGFloat textFieldCornerRadius UI_APPEARANCE_SELECTOR;

/// The insets of the text field in the search bar. Defaults to (6, 16, 6, 16).
@property (nonatomic, assign) UIEdgeInsets textFieldInsets UI_APPEARANCE_SELECTOR;

/// The insets of the cancel button in the search bar. Defaults to (0, 16, 0, 16).
@property (nonatomic, assign) UIEdgeInsets cancelButtonInsets UI_APPEARANCE_SELECTOR;

/// The mode of the cancel button. Defaults to XYSearchBarModeAlways.
@property (nonatomic, assign) XYSearchBarMode cancelButtonMode;

/// The search icon. Defaults to nil.
@property (nonatomic, strong, nullable) UIImage *searchIcon UI_APPEARANCE_SELECTOR;

/// The search bar delegate.
@property (nonatomic, weak, nullable) id<XYSearchBarDelegate> delegate;

/// Forbids input. Defaults to NO.
@property (nonatomic, assign) BOOL forbidsInput;

/// Adjusts safe area. Defaults to YES.
@property (nonatomic, assign) BOOL adjustsSafeArea;

/// The text filed will be animated when user begin to edit. Defaults to YES.
@property (nonatomic, assign) BOOL animatesWhenEditing;

/// User controls whether animation is executed or not. Defaults to YES.
@property (nonatomic, assign) BOOL executesAnimation;

@end

@protocol XYSearchBarDelegate <NSObject>
@optional
- (BOOL)searchBarShouldBeginEditing:(XYSearchBar *)searchBar;
- (void)searchBarDidBeginEditing:(XYSearchBar *)searchBar;
- (BOOL)searchBarShouldEndEditing:(XYSearchBar *)searchBar;
- (void)searchBarDidEndEditing:(XYSearchBar *)searchBar;
- (void)searchBarSearchButtonClicked:(XYSearchBar *)searchBar;
- (void)searchBarCancelButtonClicked:(XYSearchBar *)searchBar;
- (void)searchBar:(XYSearchBar *)searchBar textDidChange:(NSString *)searchText;
- (void)searchBarDidClickedOnBackground:(XYSearchBar *)searchBar; ///< forbidsInput = YES
@end

@interface XYSearchBackgroundView : UIView

/// The blur effect of the view.
@property (nonatomic, strong, nullable) UIBlurEffect *blurEffect UI_APPEARANCE_SELECTOR;

/// The seperator color of the view.
@property (nonatomic, strong, nullable) UIColor *seperatorColor UI_APPEARANCE_SELECTOR;

/// The background color of the view.
@property (nonatomic, strong, nullable) UIColor *styleColor UI_APPEARANCE_SELECTOR;

@end

@interface XYSearchTextField : UITextField

/// The insets of the text.
@property (nonatomic, assign) UIEdgeInsets textInsets UI_APPEARANCE_SELECTOR;

/// The offset of the clear button.
@property (nonatomic, assign) UIOffset clearButtonPositionAdjustment UI_APPEARANCE_SELECTOR;

/// The offset of the left view.
@property (nonatomic, assign) UIOffset leftViewPositionAdjustment UI_APPEARANCE_SELECTOR;

/// The text font of the text field.
@property (nonatomic, strong, nullable) UIFont *searchTextFont UI_APPEARANCE_SELECTOR;

/// The text color of the text field.
@property (nonatomic, strong, nullable) UIColor *searchTextColor UI_APPEARANCE_SELECTOR;

/// The placeholder color of the text field.
@property (nonatomic, strong, nullable) UIColor *searchPlaceholderColor UI_APPEARANCE_SELECTOR;

/// The tint color of the text field.
@property (nonatomic, strong, nullable) UIColor *searchTintColor UI_APPEARANCE_SELECTOR;

/// If set to YES, the placeholder and left view will be displayed in center.
@property (nonatomic, assign) BOOL centersPlaceholder;

@end

@interface XYSearchButton : UIButton

/// The title normal color of the button.
@property (nonatomic, strong, nullable) UIColor *titleNormalColor UI_APPEARANCE_SELECTOR;

/// The title highlighted color of the button.
@property (nonatomic, strong, nullable) UIColor *titleHighlightedColor UI_APPEARANCE_SELECTOR;

/// The title font of the button.
@property (nonatomic, strong, nullable) UIFont *titleFont UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END
