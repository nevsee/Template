//
//  XYCategoryUtility.h
//  XYCategory
//
//  Created by nevsee on 2017/1/10.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Gets main screen's scale.
CG_INLINE CGFloat XYScreenScale() {
    return [UIScreen mainScreen].scale;
};

/// Gets main screen's size.
CG_INLINE CGSize XYScreenSize() {
    return [UIScreen mainScreen].bounds.size;
};

#pragma mark CGFloat

/// Converts point to pixel.
/// px = pt * (ppi / dpi) = pt * scale
CG_INLINE CGFloat XYFloatToPixel(CGFloat value) {
    return value * XYScreenScale();
}

/// Converts pixel to point.
/// pt = px / (ppi / dpi) = px / scale
CG_INLINE CGFloat XYFloatFromPixel(CGFloat value) {
    return value / XYScreenScale();
}

/// @see http://error408.com/2016/08/02/one-point/
CG_INLINE CGFloat XYFloatFlatByScale(CGFloat value, CGFloat scale) {
    scale = scale ?: XYScreenScale();
    return ceil(value * scale) / scale;
}

CG_INLINE CGFloat XYFloatFlat(CGFloat value) {
    return XYFloatFlatByScale(value, 0);
}

CG_INLINE BOOL XYFloatBetween(CGFloat minimumValue, CGFloat value, CGFloat maximumValue) {
    return minimumValue < value && value < maximumValue;
}

CG_INLINE BOOL XYFloatBetweenOrEqual(CGFloat minimumValue, CGFloat value, CGFloat maximumValue) {
    return minimumValue <= value && value <= maximumValue;
}

#pragma mark CGPoint

CG_INLINE CGPoint XYPointConcat(CGPoint p1, CGPoint p2) {
    p1.x += p2.x;
    p1.y += p2.y;
    return p1;
}

CG_INLINE CGPoint XYPointSubtract(CGPoint p1, CGPoint p2) {
    p1.x -= p2.x;
    p1.y -= p2.y;
    return p1;
}
 
CG_INLINE CGPoint XYPointGetCenterInRect(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CG_INLINE CGPoint XYPointGetCenterInSize(CGSize size) {
    return CGPointMake(size.width / 2.0, size.height / 2.0);
}

CG_INLINE CGPoint XYPointFlatMake(CGFloat x, CGFloat y) {
    return CGPointMake(XYFloatFlat(x), XYFloatFlat(y));
}

CG_INLINE CGPoint XYPointFlat(CGPoint point) {
    return XYPointFlatMake(point.x, point.y);
}

#pragma mark CGRect

CG_INLINE CGRect XYRectSetX(CGRect rect, CGFloat x) {
    rect.origin.x = x;
    return rect;
}

CG_INLINE CGRect XYRectSetY(CGRect rect, CGFloat y) {
    rect.origin.y = y;
    return rect;
}

CG_INLINE CGRect XYRectSetOrigin(CGRect rect, CGPoint origin) {
    rect.origin = origin;
    return rect;
}

CG_INLINE CGRect XYRectSetWidth(CGRect rect, CGFloat width) {
    rect.size.width = width;
    return rect;
}

CG_INLINE CGRect XYRectSetHeight(CGRect rect, CGFloat height) {
    rect.size.height = height;
    return rect;
}

CG_INLINE CGRect XYRectSetSize(CGRect rect, CGSize size) {
    rect.size = size;
    return rect;
}

CG_INLINE CGRect XYRectFlatMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    return CGRectMake(XYFloatFlat(x), XYFloatFlat(y), XYFloatFlat(width), XYFloatFlat(height));
}

CG_INLINE CGRect XYRectFlat(CGRect rect) {
    return XYRectFlatMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

#pragma mark CGSize

CG_INLINE BOOL XYSizeIsEmpty(CGSize size) {
    return size.width <= 0 || size.height <= 0;
}

CG_INLINE CGSize XYSizeFlatMake(CGFloat width, CGFloat height) {
    return CGSizeMake(XYFloatFlat(width), XYFloatFlat(height));
}

CG_INLINE CGSize XYSizeFlat(CGSize size) {
    return XYSizeFlatMake(size.width, size.height);
}

#pragma mark UIEdgeInsets

CG_INLINE CGFloat XYEdgeInsetsMaxX(UIEdgeInsets e) {
    return e.left + e.right;
}

CG_INLINE CGFloat XYEdgeInsetsMaxY(UIEdgeInsets e) {
    return e.top + e.bottom;
}

CG_INLINE UIEdgeInsets XYEdgeInsetsConcat(UIEdgeInsets e1, UIEdgeInsets e2) {
    e1.top += e2.top;
    e1.left += e2.left;
    e1.bottom += e2.bottom;
    e1.right += e2.right;
    return e1;
}

CG_INLINE UIEdgeInsets XYEdgeInsetsSubtract(UIEdgeInsets e1, UIEdgeInsets e2) {
    e1.top -= e2.top;
    e1.left -= e2.left;
    e1.bottom -= e2.bottom;
    e1.right -= e2.right;
    return e1;
}

CG_INLINE UIEdgeInsets XYEdgeInsetsAllMake(CGFloat value) {
    return UIEdgeInsetsMake(value, value, value, value);
}

#pragma mark NSRange

/// r1 contains r2
CG_INLINE BOOL XYRangeContain(NSRange r1, NSRange r2) {
    if (r1.location <= r2.location && r1.location + r1.length >= r2.location + r2.length) {
        return YES;
    }
    return NO;
}

#pragma mark Other

/// Returns a rectangle to fit rect with specified content mode.
CGRect XYRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode);

/// Transform UIImageOrientation to CGImagePropertyOrientation.
CGImagePropertyOrientation XYImageOrientationTransform(UIImageOrientation imageOrientation);

NS_ASSUME_NONNULL_END
