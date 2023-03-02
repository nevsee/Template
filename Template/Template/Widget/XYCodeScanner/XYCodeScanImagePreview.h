//
//  XYCodeScanImagePreview.h
//  XYCodeScanner
//
//  Created by nevsee on 2021/10/22.
//

#import <UIKit/UIKit.h>
#import "XYCodeScanResult.h"
#import "XYCodeScanIndicator.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^XYCodeScanImageResultBlock)(NSArray<XYCodeScanResult *> *results);

@interface XYCodeScanImagePreview : UIView

/// The audio played when the search is successful. Defaults to nil.
@property (nonatomic, strong, nullable) NSURL *audioUrl;

/// Gives user a feedback when the search is successful. Defaults to UIImpactFeedbackStyleMedium.
/// When the search is successful, the audio will be played first.
@property (nonatomic, assign) UIImpactFeedbackStyle feedbackStyle;

/// Scan result indication view.
@property (nonatomic, strong, nullable) XYCodeScanIndicator *indicator;

/// Screen shot.
/// If set, detects screen image first.
/// @seealso -detectImageCodeFeaturesWithResultBlock:
@property (nonatomic, strong, nullable) UIImage *screenImage;

/// Origin image.
@property (nonatomic, strong) UIImage *originImage;

- (void)detectImageCodeFeaturesWithResultBlock:(XYCodeScanImageResultBlock)resultBlock;
- (void)clean;

@end

NS_ASSUME_NONNULL_END
