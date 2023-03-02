//
//  YYEasyImageView.m
//  Template
//
//  Created by nevsee on 2022/12/2.
//

#import "YYEasyImageView.h"

@implementation YYEasyImageView

- (instancetype)initWithImageSize:(CGSize)imageSize interval:(CGFloat)interval {
    return [self initWithImageSize:imageSize interval:interval arrowImage:nil];
}

- (instancetype)initWithImageSize:(CGSize)imageSize interval:(CGFloat)interval arrowImage:(UIImage *)arrowImage {
    CGFloat height = MAX(imageSize.height, arrowImage.size.height);
    CGFloat width = arrowImage ? imageSize.width + interval + arrowImage.size.width : imageSize.width;
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    if (self) {
        UIImageView *tailView = [[UIImageView alloc] init];
        tailView.contentMode = UIViewContentModeScaleAspectFill;
        tailView.layer.cornerRadius = imageSize.height / 2;
        tailView.layer.masksToBounds = YES;
        [self addSubview:tailView];
        _tailView = tailView;
        
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:arrowImage];
        arrowView.contentMode = UIViewContentModeRight;
        [self addSubview:arrowView];
        _arrowView = arrowView;
        
        [tailView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (arrowImage) {
                make.right.mas_equalTo(arrowView.mas_left).offset(-interval);
            } else {
                make.right.mas_equalTo(0);
            }
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(imageSize);
        }];
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return self;
}


@end
