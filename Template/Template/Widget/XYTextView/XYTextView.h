//
//  XYTextView.h
//  XYWidget
//
//  Created by nevsee on 2018/2/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYTextView : UITextView

/// The placeholder of text view.
/// The position of the placeholder is determined by textContainerInset & lineFragmentPadding & placeholderOffset.
@property (nonatomic, strong, nullable) NSString *placeholder;

/// The color of the placeholder. Defaults to nil.
@property (nonatomic, strong, nullable) UIColor *placeholderColor UI_APPEARANCE_SELECTOR;

/// The font of the placeholder. Defaults to nil.
@property (nonatomic, strong, nullable) UIFont *placeholderFont;

/// The offset of the placeholder. Defaults to UIOffsetZero.
@property (nonatomic, assign) UIOffset placeholderOffset;

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
