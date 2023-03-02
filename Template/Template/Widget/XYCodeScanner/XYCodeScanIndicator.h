//
//  XYCodeScanIndicator.h
//  XYCodeScanner
//
//  Created by nevsee on 2021/10/21.
//

#import <UIKit/UIKit.h>
#import "XYCodeScanResult.h"

@class XYCodeScanIndicator;

NS_ASSUME_NONNULL_BEGIN

typedef void (^XYCodeScanIndicatorJumpBlock)(XYCodeScanIndicator *indicator, NSString *message);
typedef void (^XYCodeScanIndicatorCloseBlock)(XYCodeScanIndicator *indicator);

@interface XYCodeScanIndicator : UIView
@property (nonatomic, strong) NSArray<XYCodeScanResult *> *results;
@property (nonatomic, strong) XYCodeScanIndicatorJumpBlock jumpBlock;
@property (nonatomic, strong) XYCodeScanIndicatorCloseBlock closeBlock;
- (void)becomeActiveAction;
- (void)enterBackgroundAction;
@end

@interface XYCodeScanDefaultIndicator : XYCodeScanIndicator
@property (nonatomic, strong) UIImage *singleIndicatorImage;
@property (nonatomic, strong) UIImage *multipleIndicatorImage;
@property (nonatomic, assign) CGSize indicatorSize;
@property (nonatomic, strong, nullable) NSAttributedString *noteText; ///< Uses for the case of multiple indicators.
@property (nonatomic, assign) CGFloat noteTextBottom;
@property (nonatomic, strong) NSAttributedString *nonCodeText;
@property (nonatomic, strong) NSAttributedString *nonCodeCloseText;
@end

NS_ASSUME_NONNULL_END
