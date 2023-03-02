//
//  XYPopupCarrierView.h
//  XYPopupView
//
//  Created by nevsee on 2017/12/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYPopupCarrierView : UIView
@property (nonatomic, assign, readonly) CGSize targetSize;
@property (nonatomic, assign) CGRect arrowRect;
@property (nonatomic, assign) CGRect containerRect;
@property (nonatomic, assign) CGFloat cornerRadius;
- (void)updatePathIfNeeded;
@end

NS_ASSUME_NONNULL_END
