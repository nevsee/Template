//
//  XYSearchController.h
//  XYWidget
//
//  Created by nevsee on 2020/11/12.
//

#import <UIKit/UIKit.h>
#import "XYSearchBar.h"

@protocol XYSearchResultsUpdating;
@class XYSearchTransition;
@class XYSearchController;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYSearchTransitionType) {
    XYSearchTransitionTypePresent,
    XYSearchTransitionTypeDismiss,
};

typedef NS_ENUM(NSUInteger, XYSearchAnimationStyle) {
    XYSearchAnimationStyleSlide,
    XYSearchAnimationStyleFade,
};

typedef void (^XYSearchBarLayout) (XYSearchController *searchController);

@interface XYSearchController : UIViewController <UIViewControllerTransitioningDelegate>

/// Search bar.
@property (nonatomic, strong, readonly) XYSearchBar *searchBar;

/// Search result controller.
@property (nonatomic, strong, readonly) UIViewController *searchResultsController;

/// Defaults to nil.
@property (nonatomic, strong, nullable) UIColor *dimColor;

/// Defaults to NO.
@property (nonatomic, assign) BOOL adaptsSemicircleCornerRadius;

/// Whether to hide the result controller when the view will appear. Defaults to YES.
@property (nonatomic, assign) BOOL hidesResultControllerAutomatically;

/// Whether to be first responder when the view will appear. Defaults to YES.
@property (nonatomic, assign) BOOL becomesFirstResponderAutomatically;

/// If set to YES, searchResultsUpdater will be triggered when the input changes. Defaults to NO.
@property (nonatomic, assign) BOOL updatesWhenSearchTextChanged;

/// Transition animator.
/// You can provide a custom transition animator by yourself.
@property (nonatomic, strong, nullable) XYSearchTransition *transition;

/// The object responsible for updating the content of the searchResultsController.
/// By default, the object is triggered by clicking the search button or clearing the search text.
@property (nonatomic, weak, nullable) id<XYSearchResultsUpdating> searchResultsUpdater;

/// Sets the search bar layout by yourself.
/// By default, when the navigation bar exists, the height of the search bar is equal to the
/// navigation bar, otherwise it is equal to 44.
@property (nonatomic, strong, nullable) XYSearchBarLayout searchBarLayout;

/**
 This is the designated initializer for XYSearchController.
 @param searchResultsController A results controller.
 */
- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController;

@end

@protocol XYSearchResultsUpdating <NSObject>
@optional
- (void)updateSearchResultsForSearchController:(XYSearchController *)searchController keyword:(nullable NSString *)keyword;
@end

@interface UINavigationController (XYSearchController)
@property (nonatomic, assign) BOOL supportSearchTransition;
@end

@interface XYSearchTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) XYSearchTransitionType transitionType;
@property (nonatomic, assign) XYSearchAnimationStyle animationStyle;
@end

NS_ASSUME_NONNULL_END
