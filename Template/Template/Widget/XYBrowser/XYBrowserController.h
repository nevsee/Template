//
//  XYBrowserController.h
//  XYBrowser
//
//  Created by nevsee on 2022/9/27.
//

#import <UIKit/UIKit.h>
#import "XYBrowserView.h"
#import "XYBrowserAnimatedTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYBrowserController : UIViewController

@property (nonatomic, strong, readonly) __kindof XYBrowserView *browserView;

/// A set of methods for implementing the animations for a custom view controller transition.
@property (nonatomic, strong) __kindof XYBrowserAnimatedTransition *transition;

/// The `-dismiss` message is triggered when the progress of the view being dragged down
/// is greater than the given value. Defaults to 0.5.
@property (nonatomic, assign) CGFloat dismissProgressThreshold;
 
/// The `-dismiss` message is triggered when finger swipe over the view with speed greater
/// than the given value. Defaults to 920.
@property (nonatomic, assign) CGFloat dismissSpeedThreshold;

/// Indicates the hidden state of the status bar. Defaults to YES.
@property (nonatomic, assign) BOOL statusBarHidden;

/// Autorotation support. Defaults to NO.
@property (nonatomic, assign) BOOL autorotateEnabled;

/// Use for XYBrowserTransitionStyleZoom.
@property (nonatomic, strong, nullable) UIView * (^sourceView)(NSInteger currentIndex);

- (instancetype)initWithBrowserView:(nullable XYBrowserView *)browserView;

@end

NS_ASSUME_NONNULL_END
