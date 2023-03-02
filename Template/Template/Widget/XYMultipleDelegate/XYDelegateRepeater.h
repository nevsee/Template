//
//  XYDelegateRepeater.h
//  XYMultipleDelegate
//
//  Created by nevsee on 2020/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XYPropertyEncodingType) {
    XYPropertyEncodingTypeWeak,
    XYPropertyEncodingTypeStrong
};

@interface XYDelegateRepeater : NSObject
+ (instancetype)repeaterWithType:(XYPropertyEncodingType)type;
- (void)addDelegate:(id)delegate;
- (BOOL)removeDelegate:(id)delegate;
- (void)removeAllDelegates;
- (BOOL)containsDelegate:(id)delegate;
@end

NS_ASSUME_NONNULL_END
