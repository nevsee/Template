//
//  XYPromptInteractor.m
//  XYPrompter
//
//  Created by nevsee on 2021/12/16.
//

#import "XYPromptInteractor.h"

@interface XYPromptInteractor ()
@property (nonatomic, strong) void (^interactionDescriber) (XYPromptInteractor *interactor);
@end

@implementation XYPromptInteractor

- (void)updateType:(XYPromptInteractionType)type progress:(CGFloat)progress interactive:(BOOL)interactive {
    _type = type;
    _progress = progress;
    _interactive = interactive;
    _interactionDescriber(self);
}

@end
