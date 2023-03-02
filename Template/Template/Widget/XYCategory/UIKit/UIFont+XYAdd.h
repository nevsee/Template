//
//  UIFont+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2020/10/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define XYFontMake(s) [UIFont systemFontOfSize:s]
#define XYFontBoldMake(s) [UIFont boldSystemFontOfSize:s]
#define XYFontNameMake(s, n) [UIFont fontWithName:n size:s]
#define XYFontWeightMake(s, w) [UIFont systemFontOfSize:s weight:w]

@interface UIFont (XYAdd)

/**
 Returns a bold font from receiver.
 */
- (UIFont *)xy_fontForBold;

/**
 Returns a italic font from receiver.
 */
- (UIFont *)xy_fontForItalic;

/**
 Returns a bold and italic font from receiver.
 */
- (UIFont *)xy_fontForBoldItalic;

/**
 Returns a normal font from receiver.
 */
- (UIFont *)xy_fontForNormal;

@end

NS_ASSUME_NONNULL_END
