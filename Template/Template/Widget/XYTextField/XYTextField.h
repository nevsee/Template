//
//  XYTextField.h
//  XYWidget
//
//  Created by nevsee on 2018/7/24.
//

#import <UIKit/UIKit.h>

@class XYTextField;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYTextFieldAlignment) {
    XYTextFieldAlignmentLeft,
    XYTextFieldAlignmentCenter,
    XYTextFieldAlignmentRight,
};

@protocol XYTextFieldDelegate <UITextFieldDelegate>
@optional
- (void)textFieldDidChange:(XYTextField *)textField;
@end

@interface XYTextField : UITextField

@property (nonatomic, weak, nullable) id<XYTextFieldDelegate> delegate;

/// The insets of the text. Defaults to UIEdgeInsetsZero.
@property (nonatomic, assign) UIEdgeInsets textInsets;

/// The offset of the clear button. Defaults to UIOffsetZero.
@property (nonatomic, assign) UIOffset clearButtonPositionAdjustment;

/// The color of the placeholder. Defaults to nil.
@property (nonatomic, strong, nullable) UIColor *placeholderColor UI_APPEARANCE_SELECTOR;

/// The font of the placeholder. Defaults to nil.
@property (nonatomic, strong, nullable) UIFont *placeholderFont;

/// The alignment of the placeholder when not editing. Defaults to XYTextFieldAlignmentLeft.
@property (nonatomic, assign) XYTextFieldAlignment placeholderAlignmentUnlessEditing;

/// The alignment of the placeholder when editing. Defaults to XYTextFieldAlignmentLeft.
@property (nonatomic, assign) XYTextFieldAlignment placeholderAlignmentWhileEditing;

/// Whether UIControlEventEditingChanged event and UITextFieldTextDidChangeNotification
/// notification should be triggered automatically when text is modified through `settext:` or
/// `setAttributedtext:`. Defaults to NO.
@property (nonatomic, assign) BOOL shouldTriggerEventWhenTextChange;

/// Whether allows to perform action.
/// @param sender Trigger the source of this inquiry.
/// @param action Events waiting for execution.
/// @param superReturnValue The return value of superclass.
/// @return Allows if returns YES.
@property (nonatomic, copy, nullable) BOOL (^canPerformActionBlock)(id sender, SEL action, BOOL superReturnValue);

/// Whether allows to paste or not.
/// @param sender Trigger the source of this inquiry.
/// @param superReturnValue The return value of superclass.
/// @return Allows if returns YES.
@property (nonatomic, copy, nullable) BOOL (^canPerformPasteActionBlock)(id sender, BOOL superReturnValue);

/// Whether to call the default implementation of the superclass.
/// @param sender Trigger the source of this inquiry.
/// @return Calls if returns YES.
@property (nonatomic, copy, nullable) BOOL (^pasteBlock)(id sender);

@end

NS_ASSUME_NONNULL_END
