//
//  YYTestUtility.m
//  Template
//
//  Created by nevsee on 2021/12/17.
//

#import "YYTestUtility.h"

@implementation YYTestUtility

+ (XYButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    XYButton *button = [XYButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = YYNeutral1Color;
    button.titleLabel.font = XYFontMake(16);
    button.layer.borderColor = YYNeutral4Color.CGColor;
    button.layer.borderWidth = YYOnePixel;
    button.highlightedBorderColor = YYTheme1Color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:YYNeutral9Color forState:UIControlStateNormal];
    [button setTitleColor:YYTheme1Color forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (XYTextField *)textFieldWithPlaceholder:(NSString *)placeholder {
    XYTextField *textField = [[XYTextField alloc] init];
    textField.font = XYFontMake(16);
    textField.textColor = YYNeutral9Color;
    textField.placeholderColor = YYNeutral5Color;
    textField.textInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    textField.clearButtonPositionAdjustment = UIOffsetMake(-5, 0);
    textField.placeholder = placeholder;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.enablesReturnKeyAutomatically = YES;
    textField.layer.borderColor = YYNeutral4Color.CGColor;
    textField.layer.borderWidth = YYOnePixel;
    return textField;
}

+ (XYLabel *)labelWithText:(NSString *)text {
    XYLabel *label = [[XYLabel alloc] init];
    label.font = XYFontMake(16);
    label.textColor = YYNeutral9Color;
    label.numberOfLines = 0;
    label.text = text;
    return label;
}

@end
