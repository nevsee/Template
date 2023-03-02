//
//  XYPopupMenuBaseItem.m
//  XYPopupMenuContentView
//
//  Created by nevsee on 2017/12/12.
//

#import "XYPopupMenuBaseItem.h"

@implementation XYPopupMenuBaseItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        _contentView = contentView;
        
        CALayer *separator = [CALayer layer];
        [self.layer addSublayer:separator];
        _separator = separator;
        
        _autoDismiss = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat contentWidth = self.bounds.size.width - _contentInsets.left - _contentInsets.right;
    CGFloat contentHeight = self.bounds.size.height - _contentInsets.top - _contentInsets.bottom;
    _contentView.frame = CGRectMake(_contentInsets.left, _contentInsets.top, contentWidth, contentHeight);
    
    CGFloat separatorY = self.bounds.size.height - _separatorInsets.bottom - _separatorHeight;
    CGFloat separatorWidth = self.bounds.size.width - _separatorInsets.left - _separatorInsets.right;
    _separator.frame = CGRectMake(_separatorInsets.left, separatorY, separatorWidth, _separatorHeight);
}

// XYPopupMenuItemParser
+ (NSString *)reuseIdentifier {
    return nil;
}

- (void)parseData:(id)data userInfo:(id)userInfo {
}

// Access
- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    _separator.backgroundColor = separatorColor.CGColor;
}

- (void)setSeparatorHeight:(CGFloat)separatorHeight {
    _separatorHeight = separatorHeight;
    [self setNeedsLayout];
}

- (void)setSeparatorInsets:(UIEdgeInsets)separatorInsets {
    _separatorInsets = separatorInsets;
    [self setNeedsLayout];
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    [self setNeedsLayout];
}

@end

#pragma mark -

@interface XYPopupMenuTextItem ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *accessoryImage;
@end

@implementation XYPopupMenuTextItem

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:imageView];
        _imageView = imageView;
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.numberOfLines = 0;
        [self.contentView addSubview:textLabel];
        _textLabel = textLabel;
        
        UIImageView *accessoryView = [[UIImageView alloc] init];
        accessoryView.contentMode = UIViewContentModeScaleAspectFill;
        accessoryView.layer.masksToBounds = YES;
        [self.contentView addSubview:accessoryView];
        _accessoryView = accessoryView;
        
        // Appearace
        [self updateAppearance];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize contentSize = self.contentView.bounds.size;

    CGFloat imageY = (contentSize.height - _image.size.height) / 2;
    _imageView.frame = CGRectMake(0, imageY, _image.size.width, _image.size.height);
    
    CGFloat accessoryX = _accessoryImage ? contentSize.width - _accessoryImage.size.width : contentSize.width;
    CGFloat accessoryY = (contentSize.height - _accessoryImage.size.height) / 2;
    _accessoryView.frame = CGRectMake(accessoryX, accessoryY, _accessoryImage.size.width, _accessoryImage.size.height);
    
    CGFloat textX = _image ? CGRectGetMaxX(_imageView.frame) + _textInsets.left : 0;
    CGFloat textWidth = _accessoryImage ? accessoryX - textX - _textInsets.right : accessoryX - textX;
    CGFloat textHeight = contentSize.height - _textInsets.top - _textInsets.bottom;
    _textLabel.frame = CGRectMake(textX, _textInsets.top, textWidth, textHeight);
}

// XYPopupMenuItemParser
+ (NSString *)reuseIdentifier {
    return @"XYPopupMenuTextItem";
}

- (void)parseData:(id)data userInfo:(id)userInfo {
    NSDictionary *dic = data;
    _image = dic[@"image"];
    _text = dic[@"text"];
    _accessoryImage = userInfo;
    _imageView.image = _image ?: nil;
    _textLabel.attributedText = _text ? [[NSAttributedString alloc] initWithString:_text attributes:_textAttributes] : nil;
    _accessoryView.image = self.selected ? _accessoryImage : nil;
}

// Method
- (void)updateAppearance {
    XYPopupMenuTextItem *appearance = [XYPopupMenuTextItem appearance];
    self.selectedColor = appearance.selectedColor;
    self.separatorColor = appearance.separatorColor;
    self.separatorHeight = appearance.separatorHeight;
    self.separatorInsets = appearance.separatorInsets;
    self.contentInsets = appearance.contentInsets;
    _imageCornerRadius = appearance.imageCornerRadius;
    _textAttributes = appearance.textAttributes;
    _textInsets = appearance.textInsets;
}

// Override
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat delta1 = _image ? _image.size.width + _textInsets.left : 0;
    CGFloat delta2 = _accessoryImage ? _accessoryImage.size.width + _textInsets.right : 0;
    CGFloat textWidth = size.width - delta1 - delta2 - self.contentInsets.left - self.contentInsets.right;
    CGFloat textHeight = [_textLabel sizeThatFits:CGSizeMake(textWidth, HUGE)].height;
    return CGSizeMake(size.width, textHeight + _textInsets.top + _textInsets.bottom);
}

// Access
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (!_accessoryImage) return;
    _accessoryView.image = selected ? _accessoryImage : nil;
}

- (void)setImageCornerRadius:(CGFloat)imageCornerRadius {
    _imageCornerRadius = imageCornerRadius;
    _imageView.layer.cornerRadius = imageCornerRadius;
}

- (void)setTextAttributes:(NSDictionary *)textAttributes {
    _textAttributes = textAttributes;
    if (_text) {
        _textLabel.attributedText = [[NSAttributedString alloc] initWithString:_text attributes:textAttributes];
    }
    [self setNeedsLayout];
}

- (void)setTextInsets:(UIEdgeInsets)textInsets {
    _textInsets = textInsets;
    [self setNeedsLayout];
}

@end

@implementation XYPopupMenuTextItem (XYAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XYPopupMenuTextItem *appearance = [XYPopupMenuTextItem appearance];
        appearance.selectedColor = [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1];
        appearance.separatorColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
        appearance.separatorHeight = 0.5;
        appearance.separatorInsets = UIEdgeInsetsMake(0, 12, 0, 12);
        appearance.contentInsets = UIEdgeInsetsMake(0, 12, 0, 12);
        appearance.textAttributes = @{
            NSForegroundColorAttributeName: [UIColor blackColor],
            NSFontAttributeName: [UIFont systemFontOfSize:15]
        };
        appearance.textInsets = UIEdgeInsetsMake(15, 10, 15, 10);
    });
}

@end
