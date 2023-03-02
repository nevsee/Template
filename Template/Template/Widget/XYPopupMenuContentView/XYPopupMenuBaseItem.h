//
//  XYPopupMenuBaseItem.h
//  XYPopupMenuContentView
//
//  Created by nevsee on 2017/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XYPopupMenuItemParser <NSObject>
@required
+ (NSString *)reuseIdentifier;
- (void)parseData:(id)data userInfo:(nullable id)userInfo;
@end

@interface XYPopupMenuBaseItem : UIView <XYPopupMenuItemParser>
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) CALayer *separator;
@property (nonatomic, assign) BOOL autoDismiss;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) UIColor *selectedColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *separatorColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat separatorHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets separatorInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets contentInsets UI_APPEARANCE_SELECTOR;
@end

/// data format  => @{@"image": UIImage, @"text": NSString},  userInfo format  => UIImage
@interface XYPopupMenuTextItem : XYPopupMenuBaseItem
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UIImageView *accessoryView;
@property (nonatomic, assign) CGFloat imageCornerRadius UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *textAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets textInsets UI_APPEARANCE_SELECTOR;
@end

NS_ASSUME_NONNULL_END
