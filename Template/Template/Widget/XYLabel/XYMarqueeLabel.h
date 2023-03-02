//
//  XYMarqueeLabel.h
//  XYWidget
//
//  Created by nevsee on 2018/5/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYMarqueeLabel : UILabel

/// The speed of text scrolling. (unit: pt/frame). Defaults to 1.
@property (nonatomic, assign) CGFloat speed UI_APPEARANCE_SELECTOR;

/// The pause time when the text scrolls to the head. Defaults to 2.5s.
@property (nonatomic, assign) NSTimeInterval pauseDurationWhenMoveToHead UI_APPEARANCE_SELECTOR;

/// The distance between the two texts. Defaults to 40.
@property (nonatomic, assign) CGFloat spacingBetweenHeadToTail UI_APPEARANCE_SELECTOR;

/// If YES, A shadow mask will be shown when the text scrolls to the edge. Defaults to YES.
@property (nonatomic, assign) BOOL shouldFadeAtEdge UI_APPEARANCE_SELECTOR;

/// The percentage of shadow mask. (0-1). Defaults to 0.2.
@property (nonatomic, assign) CGFloat fadeWidthPercent UI_APPEARANCE_SELECTOR;

/**
 Start animation
 */
- (BOOL)startAnimation;

/**
 Stop animation
 */
- (BOOL)stopAnimation;

@end

NS_ASSUME_NONNULL_END
