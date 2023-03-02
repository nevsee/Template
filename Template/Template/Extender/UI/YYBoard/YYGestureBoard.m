//
//  YYGestureBoard.m
//  Template
//
//  Created by nevsee on 2022/2/21.
//

#import "YYGestureBoard.h"

static inline YYBoardGestureDirection YYBoardTransformPanDirection(CGPoint velocity) {
    BOOL v = ABS(velocity.x) > ABS(velocity.y);
    if (v) {
        return velocity.x > 0 ? YYBoardGestureDirectionRight : YYBoardGestureDirectionLeft;
    } else {
        return velocity.y > 0 ? YYBoardGestureDirectionDown : YYBoardGestureDirectionUp;
    }
}

@implementation YYGestureViewBoard {
    YYBoardGestureDirection _panDirection;
}

- (void)didInitialize {
    [super didInitialize];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    _panGestureRecognizer = recognizer;
    _direction = YYBoardGestureDirectionDown;
    _progressThreshold = 0.3;
    _speedThreshold = 900;
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    [self.view addGestureRecognizer:_panGestureRecognizer];
}

- (void)panAction:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    CGSize size = self.view.bounds.size;
    NSTimeInterval duration = self.prompter.animator.dismissDuration;
    
    if (_panDirection == 0) {
        _panDirection = YYBoardTransformPanDirection(velocity);
    }
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self updateInteractiveProgress:0 forType:XYPromptInteractionTypeBegan];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if (!(_panDirection & _direction)) return;
        CGFloat progress = 0;
        switch (_panDirection) {
            case YYBoardGestureDirectionUp:
                progress = (-point.y / size.height) * duration;
                break;
            case YYBoardGestureDirectionDown:
                progress = (point.y / size.height) * duration;
                break;
            case YYBoardGestureDirectionLeft:
                progress = (-point.x / size.width) * duration;
                break;
            case YYBoardGestureDirectionRight:
                progress = (point.x / size.width) * duration;
                break;
        }
        progress = fmin(fmax(progress, 0), 1);
        [self updateInteractiveProgress:progress forType:XYPromptInteractionTypeChanged];
    } else {
        BOOL progressComplete = self.prompter.interactor.progress > duration * _progressThreshold;
        BOOL speedComplete = [sender velocityInView:self.view].y > _speedThreshold;
        BOOL finish = ((progressComplete || speedComplete) && sender.state != UIGestureRecognizerStateCancelled);
        XYPromptInteractionType type = finish ? XYPromptInteractionTypeFinished : XYPromptInteractionTypeCancelled;
        [self updateInteractiveProgress:finish ? 1 : 0 forType:type];
        _panDirection = 0;
    }
}

@end

#pragma mark -

@implementation YYGestureNavigationBoard {
    YYBoardGestureDirection _panDirection;
}

- (void)parameterSetup {
    [super parameterSetup];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    _panGestureRecognizer = recognizer;
    _direction = YYBoardGestureDirectionDown;
    _progressThreshold = 0.3;
    _speedThreshold = 900;
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    [self.view addGestureRecognizer:_panGestureRecognizer];
}

- (void)panAction:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    CGSize size = self.view.bounds.size;
    NSTimeInterval duration = self.prompter.animator.dismissDuration;
    
    if (_panDirection == 0) {
        _panDirection = YYBoardTransformPanDirection(velocity);
    }

    if (sender.state == UIGestureRecognizerStateBegan) {
        [self updateInteractiveProgress:0 forType:XYPromptInteractionTypeBegan];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if (!(_panDirection & _direction)) return;
        CGFloat progress = 0;
        switch (_panDirection) {
            case YYBoardGestureDirectionUp:
                progress = (-point.y / size.height) * duration;
                break;
            case YYBoardGestureDirectionDown:
                progress = (point.y / size.height) * duration;
                break;
            case YYBoardGestureDirectionLeft:
                progress = (-point.x / size.width) * duration;
                break;
            case YYBoardGestureDirectionRight:
                progress = (point.x / size.width) * duration;
                break;
        }
        progress = fmin(fmax(progress, 0), 1);
        [self updateInteractiveProgress:progress forType:XYPromptInteractionTypeChanged];
    } else {
        BOOL progressComplete = self.prompter.interactor.progress > duration * _progressThreshold;
        BOOL speedComplete = [sender velocityInView:self.view].y > _speedThreshold;
        BOOL finish = ((progressComplete || speedComplete) && sender.state != UIGestureRecognizerStateCancelled);
        XYPromptInteractionType type = finish ? XYPromptInteractionTypeFinished : XYPromptInteractionTypeCancelled;
        [self updateInteractiveProgress:finish ? 1 : 0 forType:type];
        _panDirection = 0;
    }
}

@end
