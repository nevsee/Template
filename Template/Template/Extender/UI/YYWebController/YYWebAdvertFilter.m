//
//  YYWebAdvertFilter.m
//  Ferry
//
//  Created by nevsee on 2022/6/19.
//

#import "YYWebAdvertFilter.h"

NSNotificationName const YYWebAdvertDidChangeNotification = @"YYWebAdvertDidChangeNotification";

@interface YYWebAdvertFilter ()
@property (nonatomic, strong) NSString *tempEncodedContentRuleString;
@property (nonatomic, strong) NSMutableSet *adverts;
@end

@implementation YYWebAdvertFilter

+ (instancetype)defaultFilter {
    static YYWebAdvertFilter *filter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        filter = [[super allocWithZone:NULL] init];
    });
    return filter;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [YYWebAdvertFilter defaultFilter] ;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [YYWebAdvertFilter defaultFilter];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _adverts = [NSMutableSet setWithArray:@[
            @"googleads", @"googlesyndication", @"pos.baidu.com", @"bdfpb[0-9.]+snow"
        ]];
    }
    return self;
}

- (void)addAdvertsFromFileURL:(NSURL *)fileURL {
    if (!fileURL) return;
    NSArray *list = [NSArray arrayWithContentsOfURL:fileURL];
    if (list.count == 0) return;
    [self addAdverts:list];
}

- (void)addAdverts:(NSArray *)adverts {
    if (adverts.count == 0) return;
    [self.adverts addObjectsFromArray:adverts];
    [[NSNotificationCenter defaultCenter] postNotificationName:YYWebAdvertDidChangeNotification object:nil];
    _tempEncodedContentRuleString = nil;
}

- (void)removeAdverts:(NSArray *)adverts {
    if (adverts.count == 0) return;
    for (NSString *advert in adverts) {
        [self.adverts removeObject:advert];
    }
    _tempEncodedContentRuleString = nil;
}

- (void)removeAllAdverts {
    [self.adverts removeAllObjects];
    _tempEncodedContentRuleString = nil;
}

- (NSString *)getEncodedContentRuleString {
    if (!_tempEncodedContentRuleString) {
        NSMutableArray *ruleList = [NSMutableArray array];
        for (NSString *advert in self.adverts) {
            NSDictionary *rule = @{@"trigger": @{@"url-filter": advert}, @"action": @{@"type": @"block"}};
            [ruleList addObject:rule];
        }
        _tempEncodedContentRuleString = ruleList.xy_jsonStringEncoded;
    }
    return _tempEncodedContentRuleString;
}

// Access

- (NSMutableSet *)adverts {
    if (!_adverts) {
        NSMutableSet *adverts = [NSMutableSet set];
        _adverts = adverts;
    }
    return _adverts;
}

@end
