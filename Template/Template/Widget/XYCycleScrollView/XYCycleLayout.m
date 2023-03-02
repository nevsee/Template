//
//  XYCycleFlowLayout.m
//  XYCycleScrollView
//
//  Created by nevsee on 2020/12/29.
//  Copyright © 2020 nevsee. All rights reserved.
//

#import "XYCycleLayout.h"

@implementation XYCycleLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _velocityForTriggerPageDown = 0.4;
        _pagingThreshold = 0.6;
        _velocityForMultipleItemScroll = 2.5;
        _allowsMultipleItemScroll = NO;
        
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.sectionInset = UIEdgeInsetsZero;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (![self isKindOfClass:XYCycleNormalLayout.class]) {
        return YES;
    }
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat itemWith = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? self.itemSize.width : self.itemSize.height;
    CGFloat itemSpacing = itemWith + self.minimumLineSpacing;
    
    CGSize contentSize = self.collectionViewContentSize;
    CGSize frameSize = self.collectionView.bounds.size;
    CGPoint contentOffset = self.collectionView.contentOffset;
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    
    if (@available(iOS 11, *)) {
        contentInset = self.collectionView.adjustedContentInset;
    } else {
        contentInset = self.collectionView.contentInset;
    }
    
    BOOL scrollingToRight = proposedContentOffset.x < contentOffset.x;
    BOOL scrollingToBottom = proposedContentOffset.y < contentOffset.y;
    BOOL forcePaging = NO;
    
    CGPoint translation = [self.collectionView.panGestureRecognizer translationInView:self.collectionView];
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        if (!_allowsMultipleItemScroll || ABS(velocity.y) <= ABS(_velocityForMultipleItemScroll)) {
            proposedContentOffset = contentOffset;
            
            if (ABS(velocity.y) > _velocityForTriggerPageDown) {
                forcePaging = YES;
            }
        }
       
        if (proposedContentOffset.y < -contentInset.top || proposedContentOffset.y >= contentSize.height + contentInset.bottom - frameSize.height) {
            return proposedContentOffset;
        }
        
        CGFloat progress = ((contentInset.top + proposedContentOffset.y) + self.itemSize.height / 2) / itemSpacing;
        NSInteger currentIndex = (NSInteger)progress;
        NSInteger targetIndex = currentIndex;

        if (translation.y < 0 && (ABS(translation.y) > self.itemSize.height / 2 + self.minimumLineSpacing)) {
        } else if (translation.y > 0 && ABS(translation.y > self.itemSize.height / 2)) {
        } else {
            CGFloat remainder = progress - currentIndex;
            CGFloat offset = remainder * itemSpacing;
            BOOL shouldNext = (forcePaging || (offset / self.itemSize.height >= _pagingThreshold)) && !scrollingToBottom && velocity.y > 0;
            BOOL shouldPrev = (forcePaging || (offset / self.itemSize.height <= 1 - _pagingThreshold)) && scrollingToBottom && velocity.y < 0;
            targetIndex = currentIndex + (shouldNext ? 1 : (shouldPrev ? -1 : 0));
        }
        proposedContentOffset.y = -contentInset.top + targetIndex * itemSpacing;
    } else if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        if (!_allowsMultipleItemScroll || ABS(velocity.x) <= ABS(_velocityForMultipleItemScroll)) {
            proposedContentOffset = contentOffset;
    
            if (ABS(velocity.x) > _velocityForTriggerPageDown) {
                forcePaging = YES;
            }
        }
        
        if (proposedContentOffset.x < -contentInset.left || proposedContentOffset.x >= contentSize.width + contentInset.right - frameSize.width) {
            return proposedContentOffset;
        }
        
        CGFloat progress = ((contentInset.left + proposedContentOffset.x) + self.itemSize.width / 2) / itemSpacing;
        NSInteger currentIndex = (NSInteger)progress;
        NSInteger targetIndex = currentIndex;
        
        if (translation.x < 0 && (ABS(translation.x) > self.itemSize.width / 2 + self.minimumLineSpacing)) {
        } else if (translation.x > 0 && ABS(translation.x > self.itemSize.width / 2)) {
        } else {
            CGFloat remainder = progress - currentIndex;
            CGFloat offset = remainder * itemSpacing;
            BOOL shouldNext = (forcePaging || (offset / self.itemSize.width >= _pagingThreshold)) && !scrollingToRight && velocity.x > 0;
            BOOL shouldPrev = (forcePaging || (offset / self.itemSize.width <= 1 - _pagingThreshold)) && scrollingToRight && velocity.x < 0;
            targetIndex = currentIndex + (shouldNext ? 1 : (shouldPrev ? -1 : 0));
        }
        proposedContentOffset.x = -contentInset.left + targetIndex * itemSpacing;
    }
    return proposedContentOffset;
}

@end


@implementation XYCycleNormalLayout

@end


@implementation XYCycleZoomLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _minimumScale = 0.8;
        _maximumScale = 1;
    }
    return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *> *resultAttributes = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    CGFloat offset = 0;
    CGSize itemSize = self.itemSize;
    CGFloat distanceForMinimumScale = 0;
    CGFloat distanceForMaximumScale = 0;
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        offset = CGRectGetMidY(self.collectionView.bounds);
        distanceForMinimumScale = itemSize.height + self.minimumLineSpacing;
    } else {
        offset = CGRectGetMidX(self.collectionView.bounds);
        distanceForMinimumScale = itemSize.width + self.minimumLineSpacing;
    }

    for (UICollectionViewLayoutAttributes *attributes in resultAttributes) {
        CGFloat scale = 0;
        CGFloat distance = 0;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            distance = ABS(offset - attributes.center.y);
        } else {
            distance = ABS(offset - attributes.center.x);
        }
        if (distance >= distanceForMinimumScale) {
            scale = _minimumScale;
        } else if (distance == distanceForMaximumScale) {
            scale = _maximumScale;
        } else {
            scale = _minimumScale + (distanceForMinimumScale - distance) * (_maximumScale - _minimumScale) / (distanceForMinimumScale - distanceForMaximumScale);
        }
        attributes.transform3D = CATransform3DMakeScale(scale, scale, 1);
        attributes.zIndex = 0.5;
    }
    return resultAttributes;
}
    
@end
