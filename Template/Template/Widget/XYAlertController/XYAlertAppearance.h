//
//  XYAlertAction.h
//  XYAlertController
//
//  Created by nevsee on 2018/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XYAlertControllerStyle) {
    XYAlertControllerStyleSheet = 0,
    XYAlertControllerStyleAlert
};

typedef NS_ENUM(NSInteger, XYAlertActionStyle) {
    XYAlertActionStyleDefault = 0,
    XYAlertActionStyleCancel,
    XYAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, XYAlertContentStyle) {
    XYAlertContentStyleTitle = 0,
    XYAlertContentStyleMessage
};

typedef NS_OPTIONS(NSInteger, XYAlertSeparatorStyle) {
    XYAlertSeparatorStyleNone = 0,
    XYAlertSeparatorStyleTop = 1 << 0,
    XYAlertSeparatorStyleLeft = 1 << 1,
    XYAlertSeparatorStyleBottom = 1 << 2,
    XYAlertSeparatorStyleRight = 1 << 3,
};

@interface XYAlertAppearance : UIView

/// XYAlertController
@property (nonatomic, assign) CGFloat cornerRadiiForAlert UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat potraitWidthForAlert UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat landscapeWidthForAlert UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat cornerRadiiForSheet UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat potraitWidthForSheet UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat landscapeWidthForSheet UI_APPEARANCE_SELECTOR;

/// XYAlertFixedSpaceAction
@property (nonatomic, assign) CGFloat actionPlaceholderHeightFotSheet UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *actionPlaceholderColorFotSheet UI_APPEARANCE_SELECTOR;

/// XYAlertSketchAction
@property (nonatomic, assign) CGFloat actionSeparatorSize UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *actionSeparatorColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIColor *actionHighlightedColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat actionHeightForAlert UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *actionDefaultAttributesForAlert UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *actionCancelAttributesForAlert UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *actionDestructiveAttributesForAlert UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat actionHeightForSheet UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *actionDefaultAttributesForSheet UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *actionCancelAttributesForSheet UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *actionDestructiveAttributesForSheet UI_APPEARANCE_SELECTOR;

/// XYAlertTimerAction
@property (nonatomic, strong) NSDictionary *actionTitleDisabledAttributesForAlert UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *actionTitleDisabledAttributesForSheet UI_APPEARANCE_SELECTOR;

/// XYAlertFixedSpaceContent
@property (nonatomic, assign) CGFloat contentPlaceholderHeightForAlert UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat contentPlaceholderHeightForSheet UI_APPEARANCE_SELECTOR;

/// XYAlertTextContent
@property (nonatomic, assign) UIEdgeInsets contentInsetsForAlert UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *contentTitleAttributesForAlert UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *contentMessageAttributesForAlert UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) UIEdgeInsets contentInsetsForSheet UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *contentTitleAttributesForSheet UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *contentMessageAttributesForSheet UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END
