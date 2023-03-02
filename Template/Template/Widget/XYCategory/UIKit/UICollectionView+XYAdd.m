//
//  UICollectionView+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2020/12/29.
//

#import "UICollectionView+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(UICollectionView_XYAdd)

@interface UICollectionView ()
@property (nonatomic, assign) BOOL _xy_autoLayout;
@property (nonatomic, assign) BOOL _xy_scrollEnabled;
@property (nonatomic, strong) UIView *_xy_placeholderView;
@end

@implementation UICollectionView (XYAdd)

XYSYNTH_DYNAMIC_PROPERTY_CTYPE(_xy_autoLayout, set_xy_autoLayout, BOOL)
XYSYNTH_DYNAMIC_PROPERTY_CTYPE(_xy_scrollEnabled, set_xy_scrollEnabled, BOOL)
XYSYNTH_DYNAMIC_PROPERTY_OBJECT(_xy_placeholderView, set_xy_placeholderView, RETAIN_NONATOMIC, UIView *)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XYOverrideVoidImplementationWithoutArguments([UICollectionView class], @selector(layoutSubviews), ^(UICollectionView *selfObject) {
            if (!selfObject._xy_autoLayout) return;
            selfObject._xy_placeholderView.frame = CGRectMake(0, 0, selfObject.frame.size.width, selfObject.frame.size.height - selfObject.safeAreaInsets.top);
        });
    });
}

- (void)_xy_checkEmpty {
    BOOL isEmpty = YES;
    
    id<UICollectionViewDataSource> src = self.dataSource;
    NSInteger sections = 1;
    if ([src respondsToSelector: @selector(numberOfSectionsInCollectionView:)]) {
        sections = [src numberOfSectionsInCollectionView:self];
    }
    for (int i = 0; i < sections; ++i) {
        NSInteger rows = [src collectionView:self numberOfItemsInSection:i];
        if (rows) {
            isEmpty = NO;
            break;
        }
    }
    if (!isEmpty != !self._xy_placeholderView) {
        if (isEmpty) {
            self._xy_scrollEnabled = self.scrollEnabled;
            BOOL scrollEnabled = YES;
            if ([self respondsToSelector:@selector(scrollEnabledWhenPlaceholderViewShowing)]) {
                scrollEnabled = [self performSelector:@selector(scrollEnabledWhenPlaceholderViewShowing)];
            } else if ([self.delegate respondsToSelector:@selector(scrollEnabledWhenPlaceholderViewShowing)]) {
                scrollEnabled = [self.delegate performSelector:@selector(scrollEnabledWhenPlaceholderViewShowing)];
            }
            self.scrollEnabled = scrollEnabled;
            if ([self respondsToSelector:@selector(makePlaceholderView)]) {
                self._xy_placeholderView = [self performSelector:@selector(makePlaceholderView)];
            } else if ( [self.delegate respondsToSelector:@selector(makePlaceholderView)]) {
                self._xy_placeholderView = [self.delegate performSelector:@selector(makePlaceholderView)];
            }
            if (CGRectEqualToRect(self._xy_placeholderView.frame, CGRectZero)) {
                self._xy_autoLayout = YES;
                self._xy_placeholderView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.safeAreaInsets.top);
            }
            [self addSubview:self._xy_placeholderView];
        } else {
            self.scrollEnabled = self._xy_scrollEnabled;
            [self._xy_placeholderView removeFromSuperview];
            self._xy_placeholderView = nil;
        }
    } else if (isEmpty) {
        [self._xy_placeholderView removeFromSuperview];
        if ([self respondsToSelector:@selector(makePlaceholderView)]) {
            self._xy_placeholderView = [self performSelector:@selector(makePlaceholderView)];
        } else if ([self.delegate respondsToSelector:@selector(makePlaceholderView)]) {
            self._xy_placeholderView = [self.delegate performSelector:@selector(makePlaceholderView)];
        }
        if (CGRectEqualToRect(self._xy_placeholderView.frame, CGRectZero)) {
            self._xy_autoLayout = YES;
            self._xy_placeholderView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.safeAreaInsets.top);
        }
        [self addSubview:self._xy_placeholderView];
    }
}

- (void)xy_reloadData {
    [self reloadData];
    [self _xy_checkEmpty];
}

- (BOOL)xy_cellVisibleAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *visibleCellIndexPaths = self.indexPathsForVisibleItems;
    for (NSIndexPath *visibleIndexPath in visibleCellIndexPaths) {
        if ([indexPath isEqual:visibleIndexPath]) {
            return YES;
        }
    }
    return NO;
}

@end
