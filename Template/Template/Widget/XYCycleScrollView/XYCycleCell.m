//
//  XYCycleCell.m
//  XYCycleScrollView
//
//  Created by nevsee on 2017/4/1.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "XYCycleCell.h"

@implementation XYCycleCell

- (void)layoutSubviews {
    [super layoutSubviews];
    _renderView.frame = self.bounds;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    if (![_renderView respondsToSelector:@selector(prepareForReuse)]) return;
    [_renderView prepareForReuse];
}

- (void)refreshCellWithData:(id)data userInfo:(id)userInfo {
    if (![_renderView respondsToSelector:@selector(parseData:userInfo:)]) return;
    [_renderView parseData:data userInfo:userInfo];
}

- (void)setRenderView:(UIView<XYCycleDataParser> *)renderView {
    _renderView = renderView;
    [self.contentView addSubview:renderView];
}

@end
