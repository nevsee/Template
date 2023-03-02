//
//  YYWebAdvertFilter.h
//  Ferry
//
//  Created by nevsee on 2022/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSNotificationName const YYWebAdvertDidChangeNotification;

/**
 使用正则表达式匹配url
 https://developer.apple.com/documentation/safariservices/creating_a_content_blocker?language=objc
 https://easylist.to/easylist/easylist.txt
 */
@interface YYWebAdvertFilter : NSObject
+ (instancetype)defaultFilter;
- (void)addAdvertsFromFileURL:(NSURL *)fileURL;
- (void)addAdverts:(NSArray *)adverts;
- (void)removeAdverts:(NSArray *)adverts;
- (void)removeAllAdverts;
- (NSString *)getEncodedContentRuleString;
@end

NS_ASSUME_NONNULL_END
