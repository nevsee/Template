//
//  XYBrowserAnimatedTransition.h
//  XYBrowser
//
//  Created by nevsee on 2022/10/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class XYBrowserController;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYBrowserTransitionType) {
    XYBrowserTransitionTypePresent,
    XYBrowserTransitionTypeDismiss,
};

typedef NS_ENUM(NSUInteger, XYBrowserTransitionStyle) {
    XYBrowserTransitionStyleZoom,
    XYBrowserTransitionStyleFade,
};

@interface XYBrowserAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, weak) XYBrowserController *browserController;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) XYBrowserTransitionType type;
@property (nonatomic, assign) XYBrowserTransitionStyle style;
@end

@interface XYBrowserAnimatedTransition (XYZoomStyleSupport)
@property (nonatomic, assign) BOOL prefersSourceViewHidden;
- (void)updateSourceViewStateIfNeeded;
@end

NS_ASSUME_NONNULL_END
