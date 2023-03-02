//
//  XYProgressView.h
//  XYWidget
//
//  Created by nevsee on 2018/9/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYProgressShape) {
    XYProgressShapeSector,
    XYProgressShapeRing,
    XYProgressShapeLine
};

@interface XYProgressLayer : CALayer
@property (nonatomic, assign) XYProgressShape shape;
@property (nonatomic, assign) CGFloat borderInsets;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *previewColor;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CFTimeInterval animationDuration;
@property (nonatomic, assign) BOOL shouldChangeProgressWithAnimation;
@end

@interface XYProgressView : UIControl

/// Drawing graphic shapes
@property (nonatomic, assign) XYProgressShape shape;

/// The width of the view's border. Defaults to 0.
@property (nonatomic, assign) CGFloat borderWidth;

/// The distance from the view's border. Defaults to UIEdgeInsetsZero.
@property (nonatomic, assign) CGFloat borderInsets;

/// The preview color of the shape. Defaults to nil.
@property (nonatomic, strong) UIColor *previewColor;

/// The basic duration of the animation. Defaults to 0.5.
@property (nonatomic, assign) CFTimeInterval animationDuration;

/// Drawing progress. (0~1)
@property (nonatomic, assign) CGFloat progress;

/**
 Sets progress with animation.
 */
- (void)setProgress:(float)progress animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
