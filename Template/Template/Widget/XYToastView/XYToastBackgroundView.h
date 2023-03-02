//
//  XYToastBackgroundView.h
//  XYToastView
//
//  Created by nevsee on 2017/3/13.
//

#import <UIKit/UIKit.h>
@class XYToastView;

NS_ASSUME_NONNULL_BEGIN

@interface XYToastBackgroundView : UIView
@property (nonatomic, weak) XYToastView *toastView;
@end

@interface XYToastDefaultBackgroundView : XYToastBackgroundView
@property (nonatomic, assign) BOOL definesVisualContext;
@property (nonatomic, assign) CGFloat cornerRadii UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *styleColor UI_APPEARANCE_SELECTOR;
@end

NS_ASSUME_NONNULL_END
