//
//  XYEasyCell.m
//  XYEasyCell
//
//  Created by nevsee on 2019/11/5.
//  Copyright © 2019 nevsee. All rights reserved.
//

#import "XYEasyCell.h"

@interface XYEasyCell ()
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, strong) UIView *carrierView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *tailContainView;
@property (strong, nonatomic) CALayer *topSeparator;
@property (strong, nonatomic) CALayer *bottomSeparator;
@property (nonatomic, strong) XYEasyItem *item;
@end

@implementation XYEasyCell

#pragma mark # Life

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self userInterfaceSetup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self calculateLayouts];
}

- (void)userInterfaceSetup {
    [self setSelectedBackgroundView:self.selectedView];
    [self.contentView addSubview:self.carrierView];
    [self.carrierView addSubview:self.iconView];
    [self.carrierView addSubview:self.titleLabel];
    [self.carrierView addSubview:self.subtitleLabel];
    [self.carrierView addSubview:self.tailContainView];
    [self.contentView.layer addSublayer:self.topSeparator];
    [self.contentView.layer addSublayer:self.bottomSeparator];
}

- (void)calculateLayouts {
    CGFloat width = self.contentView.bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    
    // carriver view
    CGFloat cx = _item.contentInsets.left, cy = _item.contentInsets.top;
    CGFloat cw = width - cx - _item.contentInsets.right;
    CGFloat ch = height - cy - _item.contentInsets.bottom;
    _carrierView.frame = CGRectMake(cx, cy, cw, ch);
    
    // icon
    CGFloat ix = _item.iconInsets.left;
    CGFloat iy = _item.iconInsets.top > 0 ? _item.iconInsets.top : (height - _item.iconSize.height) / 2;
    CGFloat iw = _item.iconSize.width, ih = _item.iconSize.height;
    _iconView.frame = CGRectMake(ix, iy, iw, ih);
    
    // title
    CGFloat tx = ix + iw + _item.titleInsets.left;
    CGFloat ty = _item.titleHeight > 0 ? _item.titleInsets.top : 0;
    CGFloat th = _item.titleHeight > 0 ? _item.titleHeight : height, tw = _item.titleWidth;
    _titleLabel.frame = CGRectMake(tx, ty, tw, th);
    
    // tail view
    CGFloat rx = cw - _item.tailSize.width - _item.tailInsets.right;
    CGFloat ry = (height - _item.tailSize.height) / 2;
    CGFloat rw = _item.tailSize.width, rh = _item.tailSize.height;
    _tailContainView.frame = CGRectMake(rx, ry, rw, rh);
    
    // subtitle
    CGFloat sx = tx + tw + _item.subtitleInsets.left, sy = 0;
    CGFloat sw = rx - sx - _item.subtitleInsets.right, sh = height;
    _subtitleLabel.frame = CGRectMake(sx, sy, sw, sh);
    
    // separator
    if (!_topSeparator.hidden) {
        CGFloat lx = _item.topSeparatorInsets.left, ly = 0;
        CGFloat lw = width - lx - _item.topSeparatorInsets.right, lh = _item.separatorHeight;
        _topSeparator.frame = CGRectMake(lx, ly, lw, lh);
    }
    if (!_bottomSeparator.hidden) {
        CGFloat x = 0;
        if (_item.bottomSeparatorStyle == XYEasySeparatorStyleIcon) x = (iw == 0) ? 0 : cx + ix;
        if (_item.bottomSeparatorStyle == XYEasySeparatorStyleTitle) x = (tw == 0) ? 0 : cx + tx;
        CGFloat lx = x + _item.bottomSeparatorInsets.left, ly = height - _item.separatorHeight;
        CGFloat lw = width - lx - _item.bottomSeparatorInsets.right, lh = _item.separatorHeight;
        _bottomSeparator.frame = CGRectMake(lx, ly, lw, lh);
    }
}

#pragma mark # Method

- (void)refreshCellWithItem:(XYEasyItem *)item {
    _item = item;
    
    self.backgroundColor = item.backgroundColor;
    
    // selected view
    _selectedView.backgroundColor = item.selectedColor;
    
    // icon
    UIImage *icon = item.iconName ? [UIImage imageNamed:item.iconName] : nil;
    if (icon) {
        if (item.iconSize.width == 0 || item.iconSize.height == 0) {
            item.iconSize = icon.size;
        }
    } else {
        item.iconInsets = UIEdgeInsetsZero;
        item.iconSize = CGSizeZero;
    }
    _iconView.image = icon;
    _iconView.contentMode = item.iconMode;
    
    // title
    if (item.title) {
        if (item.titleAttributes) {
            _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:item.title attributes:item.titleAttributes];
        } else {
            _titleLabel.text = item.title;
        }
    } else {
        item.titleInsets = UIEdgeInsetsZero;
        item.titleWidth = 0;
        item.titleHeight = 0;
        _titleLabel.text = nil;
    }
    _titleLabel.textAlignment = item.titleAlignment;
    _titleLabel.numberOfLines = item.titleLines;

    // tail view
    CGSize size = CGSizeZero;
    if (item.tailView) {
        size = item.tailView.bounds.size;
        if (item.tailSize.width == 0 || item.tailSize.height == 0) {
            item.tailSize = size;
        } else {
            item.tailView.frame = (CGRect){CGPointZero, item.tailSize};
        }
    } else {
        item.tailInsets = UIEdgeInsetsZero;
        item.tailSize = CGSizeZero;
    }
    for (UIView *view in _tailContainView.subviews) {
        [view removeFromSuperview];
    }
    
    [_tailContainView addSubview:item.tailView];
    
    // subtitle
    if (item.subtitle) {
        if (item.subtitleAttributes) {
            _subtitleLabel.attributedText = [[NSAttributedString alloc] initWithString:item.subtitle attributes:item.subtitleAttributes];
        } else {
            _subtitleLabel.text = item.subtitle;
        }
    } else {
        item.subtitleInsets = UIEdgeInsetsZero;
        _subtitleLabel.text = nil;
    }
    _subtitleLabel.textAlignment = item.subtitleAlignment;
    _subtitleLabel.numberOfLines = item.subtitleLines;
    
    // separator
    switch (item.topSeparatorStyle) {
        case XYEasySeparatorStyleNone:
        case XYEasySeparatorStyleTitle:
        case XYEasySeparatorStyleIcon:
            _topSeparator.hidden = true;
            break;
        case XYEasySeparatorStyleFull:
            _topSeparator.hidden = false;
            break;
    }
    
    switch (item.bottomSeparatorStyle) {
        case XYEasySeparatorStyleNone:
            _bottomSeparator.hidden = true;
            break;
        case XYEasySeparatorStyleFull:
        case XYEasySeparatorStyleTitle:
        case XYEasySeparatorStyleIcon:
            _bottomSeparator.hidden = false;
            break;
    }
    _topSeparator.backgroundColor = item.separatorColor.CGColor;
    _bottomSeparator.backgroundColor = item.separatorColor.CGColor;
}

#pragma mark # Access

- (UIView *)selectedView {
    if (!_selectedView) {
        _selectedView = ({
            UIView *view = [[UIView alloc] init];
            view;
        });
    }
    return _selectedView;
}


- (UIView *)carrierView {
    if (!_carrierView) {
        _carrierView = ({
            UIView *view = [[UIView alloc] init];
            view;
        });
    }
    return _carrierView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view;
        });
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *view = [[UILabel alloc] init];
            view;
        });
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = ({
            UILabel *view = [[UILabel alloc] init];
            view;
        });
    }
    return _subtitleLabel;
}

- (UIView *)tailContainView {
    if (!_tailContainView) {
        _tailContainView = ({
            UIView *view = [[UIView alloc] init];
            view;
        });
    }
    return _tailContainView;
}

- (CALayer *)topSeparator {
    if (!_topSeparator) {
        _topSeparator = ({
            CALayer *view = [CALayer layer];
            view;
        });
    }
    return _topSeparator;
}

- (CALayer *)bottomSeparator {
    if (!_bottomSeparator) {
        _bottomSeparator = ({
            CALayer *view = [CALayer layer];
            view;
        });
    }
    return _bottomSeparator;
}

@end
