//
//  XYToastContentView.h
//  XYToastView
//
//  Created by nevsee on 2017/3/13.
//

#import <UIKit/UIKit.h>
@class XYToastView;

NS_ASSUME_NONNULL_BEGIN

@interface XYToastContentView : UIView
@property (nonatomic, weak) XYToastView *toastView;
@end

@interface XYToastDefaultContentView : XYToastContentView

@property (nonatomic, strong, nullable) UIView *customView;
@property (nonatomic, strong, nullable) NSString *text;
@property (nonatomic, strong, nullable) NSString *detailText;

@property (nonatomic, assign) UIOffset maximumSizeOffset; ///< @see `-sizeThatFits`
@property (nonatomic, assign) BOOL adjustsWidthAutomatically; ///< Sets `width = height` if `width < height`

@property (nonatomic, assign) UIEdgeInsets contentInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat customBottomMargin UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat textBottomMargin UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong, nullable) NSDictionary *textAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong, nullable) NSDictionary *detailTextAttributes UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END
