//
//  XYPromptInteractor.h
//  XYPrompter
//
//  Created by nevsee on 2021/12/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYPromptInteractionType) {
    XYPromptInteractionTypeBegan,
    XYPromptInteractionTypeChanged,
    XYPromptInteractionTypeCancelled,
    XYPromptInteractionTypeFinished,
};

@interface XYPromptInteractor : NSObject
@property (nonatomic, assign, readonly) XYPromptInteractionType type;
@property (nonatomic, assign, readonly) CGFloat progress; ///< Specified as a percentage of the overall duration.
@property (nonatomic, assign, readonly) BOOL interactive;
- (void)updateType:(XYPromptInteractionType)type progress:(CGFloat)progress interactive:(BOOL)interactive;
@end

NS_ASSUME_NONNULL_END
