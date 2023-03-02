//
//  YYFakeProgressView.h
//  Template
//
//  Created by nevsee on 2021/12/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 模拟进度条
@interface YYFakeProgressView : UIProgressView
@property (nonatomic, assign) BOOL hidesWhenCommitted; ///< 进度条完成时是否隐藏
- (void)begin;
- (void)end;
- (void)commit;
@end

NS_ASSUME_NONNULL_END
