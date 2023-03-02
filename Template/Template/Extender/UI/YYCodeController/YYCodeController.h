//
//  YYCodeController.h
//  Template
//
//  Created by nevsee on 2021/12/27.
//

#import "YYBaseController.h"
#import "YYCodeResultProtocol.h"
#import "XYCodeScanner.h"

NS_ASSUME_NONNULL_BEGIN

/// 扫码控制器
@interface YYCodeController : YYBaseController
@property (nonatomic, strong, readonly) XYCodeScanView *scanView;
@property (nonatomic, strong, readonly) XYCodeScanImagePreview *imagePreview;
@property (nonatomic, strong, nullable) id<YYCodeResultProtocol> resultHandler; ///< 结果处理对象，默认YYCodeResultHandler
@property (nonatomic, assign) BOOL cleanWorkflow; ///< 跳转其他页面后是否清除扫码页面
@property (nonatomic, assign) BOOL checkAllCodesInScreen; ///< 图片检测是否检测屏幕内所有二维码
- (void)restart; ///< 关闭所有指示视图，重启扫描
- (void)restartIfNeeded; ///< 当指示视图有多个结果时，不重启
@end

NS_ASSUME_NONNULL_END
