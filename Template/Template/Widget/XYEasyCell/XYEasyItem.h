//
//  XYEasyItem.h
//  XYEasyCell
//
//  Created by nevsee on 2019/11/5.
//  Copyright © 2019 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XYEasySeparatorStyle) {
    XYEasySeparatorStyleNone = 0,
    XYEasySeparatorStyleFull,
    XYEasySeparatorStyleIcon,
    XYEasySeparatorStyleTitle,
};

typedef void(^XYEasyOperation)(void);

NS_ASSUME_NONNULL_BEGIN

@interface XYEasyItem : NSObject

@property (nonatomic, assign) UIEdgeInsets contentInsets; ///< Default is UIEdgeInsetsZero (top left bottom right)

@property (nonatomic, strong, nullable) NSString *iconName;
@property (nonatomic, assign) UIViewContentMode iconMode;
@property (nonatomic, assign) CGSize iconSize; ///< If no value is set, default is image size
@property (nonatomic, assign) UIEdgeInsets iconInsets; ///< Default is UIEdgeInsetsMake(0, 12, 0, 0) (top left)

@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong) NSDictionary *titleAttributes;
@property (nonatomic, assign) CGFloat titleWidth;
@property (nonatomic, assign) CGFloat titleHeight; ///< Default is 0
@property (nonatomic, assign) UIEdgeInsets titleInsets; ///< Default is UIEdgeInsetsMake(0, 12, 0, 0) (left top)
@property (nonatomic, assign) NSInteger titleLines; ///< Default is 1
@property (nonatomic, assign) NSTextAlignment titleAlignment; ///< Default is NSTextAlignmentLeft

@property (nonatomic, strong, nullable) NSString *subtitle;
@property (nonatomic, strong) NSDictionary *subtitleAttributes;
@property (nonatomic, assign) UIEdgeInsets subtitleInsets; ///< Default is UIEdgeInsetsMake(0, 12, 0, 12) (left right)
@property (nonatomic, assign) NSInteger subtitleLines; ///< Default is 1
@property (nonatomic, assign) NSTextAlignment subtitleAlignment; ///< Default is NSTextAlignmentRight

@property (nonatomic, strong, nullable) __kindof UIView *tailView; ///< The custom view in the tail
@property (nonatomic, assign) CGSize tailSize; ///< If no value is set, default is custom view size
@property (nonatomic, assign) UIEdgeInsets tailInsets; ///< Default is UIEdgeInsetsMake(0, 0, 0, 12) (top right)

@property (nonatomic, assign) XYEasySeparatorStyle topSeparatorStyle; ///< Top separator style, default is XYEasySeparatorStyleNone
@property (nonatomic, assign) XYEasySeparatorStyle bottomSeparatorStyle; ///< Bottom separator style, default is XYEasySeparatorStyleTitle
@property (nonatomic, strong, nullable) UIColor *separatorColor; ///< Separator color
@property (nonatomic, assign) CGFloat separatorHeight; ///< Separator height, default is 0.5
@property (nonatomic, assign) UIEdgeInsets topSeparatorInsets; ///< Default is UIEdgeInsetsZero (left right)
@property (nonatomic, assign) UIEdgeInsets bottomSeparatorInsets; ///< Default is UIEdgeInsetsZero (left right)

@property (nonatomic, strong, nullable) UIColor *backgroundColor; ///< The background color
@property (nonatomic, strong, nullable) UIColor *selectedColor; ///< The selected background view color

@property (nonatomic, assign) CGFloat height; ///< The cell height
@property (nonatomic, strong, nullable) id data; ///< The binding data
@property (nonatomic, strong, nullable) id userInfo; ///< The additional data
@property (nonatomic, copy, nullable) XYEasyOperation operation; ///< The block invoked when the cell is selected

+ (instancetype)itemWithTitle:(nullable NSString *)title;
+ (instancetype)itemWithTitle:(nullable NSString *)title iconName:(nullable NSString *)iconName;
+ (instancetype)itemWithTitle:(nullable NSString *)title subtitle:(nullable NSString *)subtitle;
+ (instancetype)itemWithTitle:(nullable NSString *)title subtitle:(nullable NSString *)subtitle iconName:(nullable NSString *)iconName;

@end

NS_ASSUME_NONNULL_END
