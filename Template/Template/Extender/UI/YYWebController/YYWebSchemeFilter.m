//
//  YYWebSchemeFilter.m
//  Ferry
//
//  Created by nevsee on 2022/6/19.
//

#import "YYWebSchemeFilter.h"

@interface YYWebSchemeFilter ()
@property (nonatomic, strong) NSMutableArray *schemes;
@end

@implementation YYWebSchemeFilter

+ (instancetype)defaultFilter {
    static YYWebSchemeFilter *filter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        filter = [[super allocWithZone:NULL] init];
    });
    return filter;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [YYWebSchemeFilter defaultFilter] ;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [YYWebSchemeFilter defaultFilter];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _schemes = [NSMutableArray arrayWithArray:@[
            // 系统
            @"sms", @"tel", @"mailto", @"itms-apps", @"itms-appss", @"itms-beta", @"calshow", @"mobilenotes", @"shoebox", @"music",
            @"videos", @"map", @"facetime", @"facetime-audio",
            // 社交
            @"mqq", @"mqqiapi", @"tim", @"weixin", @"tianya", @"wxwork", @"dingtalk", @"tantanapp", @"momochat", @"com.moke.moke",
            @"line", @"fetion", @"wangwangseller", @"com.baidu.tieba",
            // 新闻
            @"snssdk141", @"zhihu", @"sinaweibo", @"weibo", @"weibointernational", @"weico", @"newsapp", @"renren", @"renrenios", @"qqnews",
            @"comIfeng3GifengNews", @"sohunews", @"trivia",
            // 外卖
            @"imeituan", @"meituanwaimai", @"dianping",
            // 地图
            @"iosamap", @"baidumap", @"bdmap", @"bdNavi", @"sosomap",
            // 邮件
            @"googlegmail", @"neteasemail", @"qqmail", @"qqbizmailDistribute2",
            // 生活
            @"alipays", @"alipayqr", @"alipay", @"diditaxi", @"mihome", @"wbmain", @"youdaonote", @"evernote", @"FDMoney", @"baiduyun",
            @"sinavdisk", @"weiyun", @"keep", @"wxbcb43ea5d2d6384c", @"cn.12306", @"trainassist", @"gtgj", @"mqqsecure", @"qzzb", @"wacai",
            @"mlink", @"rili365", @"sinaweatherpro", @"sinaweather", @"rm434209233MojiWeather", @"taobaotravel",
            // 浏览器
            @"x-web-searc", @"Alook", @"wuxiang", @"quark", @"ucbrowser", @"mttbrowser", @"googlechrome", @"bdboxiosqrcode",
            @"msearchapp", @"sogousearch",
            // 购物
            @"taobao", @"tmall", @"openApp.jdMobile", @"suning", @"pinduoduo", @"yihaodian", @"cainiao", @"pricetag",
            // 影视
            @"bilibili", @"pptv", @"qiyi-iphone", @"ppstream", @"com.baofeng.play", @"tudou", @"sohuvideo-iphone", @"sohuvideo", @"awemesso",
            @"tenvideo", @"tenvideo2", @"tenvideo3", @"com.56Video", @"yymobile", @"xk", @"huajiao", @"baiduvideoiphone", @"bdviphapp",
            // 音乐
            @"xiami", @"com.kuwo.kwmusic.kwmusicForKwsing", @"doubanradio", @"qtfmp", @"kugouURL", @"baidumusic", @"ttpod", @"orpheuswidget",
            @"orpheus", @"qqmusic", @"baidumusic",
            // 学习
            @"iReader", @"hjdict", @"yddict", @"ntesopen", @"com.kingsoft.powerword.6", @"buka", @"LatteRead", @"bdbook", @"bdwenku",
            @"com.goodreader.sendtogr",
            // 银行
            @"wx1cb534bb13ba3dbd", @"cmbmobilebank", @"wx2654d9155d70a468", @"com.icbc.iphoneclien",
            // 办公
            @"KingsoftOfficeApp", @"wcc", @"camcard", @"pdfexpert5presence", @"rdocs",
            // 金融
            @"amihexin", @"dzhiphone", @"jdmobile"
        ]];
    }
    return self;
}

// Method

- (void)addSchemes:(NSArray *)schemes {
    for (NSString *scheme in schemes) {
        [self.schemes addObject:scheme];
    }
}

- (void)removeSchemes:(NSArray *)schemes {
    for (NSString *scheme in schemes) {
        [self.schemes removeObject:scheme];
    }
}

- (void)removeAllSchemes {
    [self.schemes removeAllObjects];
}

- (YYWebSchemeFilterResult)filterScheme:(NSString *)scheme {
    return [_schemes containsObject:scheme] ? YYWebSchemeFilterResultValid : YYWebSchemeFilterResultInvalid;
}

// Access

- (NSMutableArray *)schemes {
    if (!_schemes) {
        NSMutableArray *schemes = [NSMutableArray array];
        _schemes = schemes;
    }
    return _schemes;
}

@end
