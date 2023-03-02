//
//  YYLineFeedFlowLayout.m
//  Ferry
//
//  Created by nevsee on 2022/7/14.
//

#import "YYLineFeedFlowLayout.h"

@implementation YYLineFeedFlowLayout {
    NSMutableArray *_layoutAttributesInfos;
    NSString *_decorationElementKind;
}

// Private Method

- (CGFloat)minimumInteritemSpacingInSection:(NSInteger)section {
    if ([_delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [_delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    return self.minimumInteritemSpacing;
}

- (CGFloat)minimumLineSpacingInSection:(NSInteger)section {
    if ([_delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [_delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    return self.minimumLineSpacing;
}

- (UIEdgeInsets)sectionInsetInSection:(NSInteger)section {
    if ([_delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [_delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    return self.sectionInset;
}

- (CGSize)sizeForHeaderInSection:(NSInteger)section {
    if ([_delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        return [_delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
    }
    return self.headerReferenceSize;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        return [_delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    return self.itemSize;
}

// Public Method

- (void)prepareLayout {
    [super prepareLayout];
    
    _layoutAttributesInfos = [NSMutableArray array];
    
    NSInteger sectionCount = self.collectionView.numberOfSections;
    CGFloat headerY = 0;
    CGFloat decorationY = 0;

    for (NSInteger i = 0; i < sectionCount; i++) {
        CGFloat itemSpacing = [self minimumInteritemSpacingInSection:i];
        CGFloat lineSpacing = [self minimumLineSpacingInSection:i];
        UIEdgeInsets sectionInset = [self sectionInsetInSection:i];
        CGSize headerSize = [self sizeForHeaderInSection:i];
        
        // header
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:i];
        UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:headerIndexPath];
        headerAttributes.frame = CGRectMake(0, headerY, headerSize.width, headerSize.height);
        [_layoutAttributesInfos addObject:headerAttributes];
        headerY += headerSize.height;
        
        // item
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        CGFloat itemX = sectionInset.left;
        CGFloat itemY = sectionInset.top + headerY;
        CGFloat itemMaxHeight = 0;
        
        for (NSInteger j = 0; j < itemCount; j++) {
            NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:j inSection:i];
            CGSize itemSize = [self sizeForItemAtIndexPath:itemIndexPath];
            itemMaxHeight = MAX(itemSize.height, itemMaxHeight);

            // item换行
            if (itemX + itemSize.width > self.collectionView.xy_width - sectionInset.right) {
                itemX = sectionInset.left;
                itemY += (itemMaxHeight + lineSpacing);
                itemMaxHeight = 0;
            }
            
            if (j == itemCount - 1) {
                headerY = itemY + MAX(itemMaxHeight, itemSize.height) + sectionInset.bottom;
            }
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
            itemAttributes.frame = CGRectMake(itemX, itemY, itemSize.width, itemSize.height);
            [_layoutAttributesInfos addObject:itemAttributes];
            itemX += (itemSize.width + itemSpacing);
        }
        
        // decoration
        if (_decorationElementKind) {
            UICollectionViewLayoutAttributes *decorationAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:_decorationElementKind withIndexPath:headerIndexPath];
            decorationAttributes.frame = CGRectMake(_decorationInset.left + _decorationOffset.horizontal,
                                                    decorationY + _decorationInset.top + _decorationOffset.vertical,
                                                    self.collectionView.xy_width - XYEdgeInsetsMaxX(_decorationInset),
                                                    headerY - decorationY - XYEdgeInsetsMaxY(_decorationInset));
            decorationAttributes.zIndex = -1;
            [_layoutAttributesInfos addObject:decorationAttributes];
            decorationY = headerY;
        }
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _layoutAttributesInfos;
}

- (void)registerNib:(UINib *)nib forDecorationViewOfKind:(NSString *)elementKind {
    _decorationElementKind = elementKind;
    [super registerNib:nib forDecorationViewOfKind:elementKind];
}

- (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSString *)elementKind {
    _decorationElementKind = elementKind;
    [super registerClass:viewClass forDecorationViewOfKind:elementKind];
}

@end
