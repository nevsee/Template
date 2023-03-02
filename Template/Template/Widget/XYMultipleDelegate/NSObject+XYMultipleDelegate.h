//
//  NSObject+XYMultipleDelegate.h
//  XYMultipleDelegate
//
//  Created by nevsee on 2020/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XYMultipleDelegate)
@property(nonatomic, assign) BOOL xy_multipleDelegateEnabled;
- (void)xy_registerDelegate:(SEL)getter;
- (void)xy_removeDelegate:(id)delegate;
@end

NS_ASSUME_NONNULL_END
