//
//  XYBrowserIndicator.h
//  XYBrowser
//
//  Created by nevsee on 2022/9/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XYBrowserIndicatorDescriber <NSObject>
@required
- (void)startIndicator;
- (void)stopIndicator;
@optional
- (void)updateIndicatorProgress:(double)progress;
@end

@interface XYBrowserLoadingIndicator : UIView <XYBrowserIndicatorDescriber>
@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) UIActivityIndicatorViewStyle style UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong, nullable) UIColor *color UI_APPEARANCE_SELECTOR;
@end

@interface XYBrowserErrorIndicator : UIView <XYBrowserIndicatorDescriber>
@property (nonatomic, strong, readonly) UIImageView *indicatorView;
@property (nonatomic, strong, nullable) UIImage *image UI_APPEARANCE_SELECTOR;
@end

NS_ASSUME_NONNULL_END


