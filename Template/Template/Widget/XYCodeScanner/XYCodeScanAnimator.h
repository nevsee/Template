//
//  XYCodeScanAnimator.h
//  XYCodeScanner
//
//  Created by nevsee on 2021/10/9.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYCodeScanAnimator : CALayer
@property (nonatomic, assign) CGRect animationArea; ///< Determines the rectangle of animation area. Defaults to CGRectMake(0, 0.3, 1, 0.4).
- (void)becomeActiveAction;
- (void)enterBackgroundAction;
- (void)startAnimation;
- (void)stopAnimation;
@end

@interface XYCodeScanDefaultAnimator : XYCodeScanAnimator
@property (nonatomic, strong) UIImage *lineImage;
@end

NS_ASSUME_NONNULL_END
