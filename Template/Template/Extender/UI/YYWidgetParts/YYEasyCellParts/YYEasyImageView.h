//
//  YYEasyImageView.h
//  Template
//
//  Created by nevsee on 2022/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYEasyImageView : UIView
@property (nonatomic, strong, readonly) UIImageView *tailView;
@property (nonatomic, strong, readonly) UIImageView *arrowView;
- (instancetype)initWithImageSize:(CGSize)imageSize interval:(CGFloat)interval;
- (instancetype)initWithImageSize:(CGSize)imageSize interval:(CGFloat)interval arrowImage:(nullable UIImage *)arrowImage;
@end

NS_ASSUME_NONNULL_END
