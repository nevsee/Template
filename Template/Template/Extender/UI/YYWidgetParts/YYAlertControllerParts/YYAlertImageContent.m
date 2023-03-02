//
//  YYAlertImageContent.m
//  Ferry
//
//  Created by nevsee on 2022/5/9.
//

#import "YYAlertImageContent.h"

@interface YYAlertImageContent ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation YYAlertImageContent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        _imageView = imageView;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    self.preferredHeight = MIN(size.width - XYEdgeInsetsMaxX(self.contentInsets), _targetImage.size.height + XYEdgeInsetsMaxY(self.contentInsets));
    return [super sizeThatFits:size];
}

- (void)setTargetImage:(UIImage *)targetImage {
    _targetImage = targetImage;
    _imageView.image = targetImage;
}

@end
