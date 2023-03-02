//
//  YYTestUtility.h
//  Template
//
//  Created by nevsee on 2021/12/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYTestUtility : NSObject
+ (XYButton *)buttonWithTitle:(NSString *)title target:(nullable id)target action:(nullable SEL)action;
+ (XYTextField *)textFieldWithPlaceholder:(NSString *)placeholder;
+ (XYLabel *)labelWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
