//
//  XYAlertAction.h
//  XYAlertController
//
//  Created by nevsee on 2018/10/12.
//

#import "XYAlertActionCanvas.h"

@interface XYAlertAction ()
@property (nonatomic, assign) XYAlertSeparatorStyle separatorStyle;
@end

@interface XYAlertActionCanvas ()
@property (nonatomic, strong, readwrite) XYAlertFixedSpaceAction *placeholderAction;
@property (nonatomic, strong, readwrite) XYAlertFixedSpaceAction *safeAreaAction;
@property (nonatomic, assign) XYAlertControllerStyle style;
@property (nonatomic, strong) NSMutableArray *totalActions;
@property (nonatomic, assign) BOOL isAlertStyle;
@property (nonatomic, assign) BOOL isHorizontalLayout;
@end

@implementation XYAlertActionCanvas

+ (instancetype)canvasWithStyle:(XYAlertControllerStyle)style {
    XYAlertActionCanvas *canvas = [[XYAlertActionCanvas alloc] init];
    canvas.backgroundColor = [UIColor whiteColor];
    canvas.style = style;
    canvas.isAlertStyle = style == XYAlertControllerStyleAlert;
    canvas.maximumNumberOfHorizontalLayout = 2;
    canvas.totalActions = [NSMutableArray array];
    [canvas userInterfaceSetup];
    return canvas;
}

- (void)userInterfaceSetup {
    if (_isAlertStyle) return;
    
    // placeholderAction
    _placeholderAction = [XYAlertFixedSpaceAction fixedSpaceAction];
    _placeholderAction.preferredHeight = [XYAlertAppearance appearance].actionPlaceholderHeightFotSheet;
    _placeholderAction.backgroundColor = [XYAlertAppearance appearance].actionPlaceholderColorFotSheet;
    
    // safeAreaAction
    _safeAreaAction = [XYAlertFixedSpaceAction fixedSpaceAction];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_isHorizontalLayout) {
        CGFloat actionWidth = self.bounds.size.width / _totalActions.count;
        for (NSInteger i = 0; i < _totalActions.count; i++) {
            XYAlertAction *action = _totalActions[i];
            CGFloat actionHeight = [action sizeThatFits:self.bounds.size].height;
            action.frame = CGRectMake(actionWidth * i, 0, actionWidth, actionHeight);
        }
    } else {
        CGFloat actionY = 0;
        for (NSInteger i = 0; i < _totalActions.count; i++) {
            XYAlertAction *action = _totalActions[i];
            CGFloat actionHeight = [action sizeThatFits:self.bounds.size].height;
            action.frame = CGRectMake(0, actionY, self.bounds.size.width, actionHeight);
            actionY += actionHeight;
        }
    }
}

- (void)updateActions:(NSArray *)actions {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    [_totalActions removeAllObjects];
    
    NSMutableArray *otherActions = [NSMutableArray array];
    XYAlertAction *cancelAction = nil;
    NSInteger index = 1;
    for (XYAlertAction *action in actions) {
        if (action.style == XYAlertActionStyleCancel) {
            action.tag = 0;
            cancelAction = action;
        } else {
            action.tag = index++;
            [otherActions addObject:action];
        }
    }
    
    if (_isAlertStyle) {
        _isHorizontalLayout = actions.count <= _maximumNumberOfHorizontalLayout;
        NSInteger index = _isHorizontalLayout ? 0 : otherActions.count;
        [_totalActions addObjectsFromArray:otherActions];
        if (cancelAction) [_totalActions insertObject:cancelAction atIndex:index];
    } else {
        [_totalActions addObjectsFromArray:otherActions];

        if (cancelAction) {
            cancelAction.separatorStyle = XYAlertSeparatorStyleNone;
            if (_placeholderAction) [_totalActions addObject:_placeholderAction];
            [_totalActions addObject:cancelAction];
        }

        if (_safeAreaAction && [self respondsToSelector:@selector(safeAreaInsets)]) {
            UIWindow *window = [self obtainKeyWindow];
            if (window.safeAreaInsets.bottom > 0) {
                _safeAreaAction.preferredHeight = window.safeAreaInsets.bottom;
                [_totalActions addObject:_safeAreaAction];
            }
        }
    }
    
    for (NSInteger i = 0; i < _totalActions.count; i++) {
        XYAlertAction *action = _totalActions[i];
        [self addSubview:action];
        if (action.separatorStyle == XYAlertSeparatorStyleNone) continue;
        
        if (_isHorizontalLayout) {
            BOOL last = i == _totalActions.count - 1;
            action.separatorStyle = last ? XYAlertSeparatorStyleTop : XYAlertSeparatorStyleTop | XYAlertSeparatorStyleRight;
        } else {
            action.separatorStyle = XYAlertSeparatorStyleTop;
        }
    }
}

- (UIWindow *)obtainKeyWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) return window;
                }
            }
        }
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) window = [UIApplication sharedApplication].delegate.window;
    return window;
#pragma clang dianostic pop
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat height = 0;
    if (_isHorizontalLayout) {
        for (NSInteger i = 0; i < _totalActions.count; i++) {
            XYAlertAction *action = _totalActions[i];
            height = MAX(height, [action sizeThatFits:size].height);
        }
    } else {
        for (NSInteger i = 0; i < _totalActions.count; i++) {
            XYAlertAction *action = _totalActions[i];
            height += [action sizeThatFits:size].height;
        }
    }
    return CGSizeMake(size.width, height);
}

@end
