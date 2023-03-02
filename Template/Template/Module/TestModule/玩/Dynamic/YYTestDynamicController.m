//
//  YYTestDynamicController.m
//  Template
//
//  Created by nevsee on 2022/9/7.
//

#import "YYTestDynamicController.h"

@interface YYTestDynamicController () <UIDynamicAnimatorDelegate>
@property (nonatomic, strong) UIView *ball;
@property (nonatomic, strong) UIView *dot;
@property (nonatomic, strong) UIView *obstacle1;
@property (nonatomic, strong) UIView *obstacle2;
@property (nonatomic, strong) UISegmentedControl *styleSegment;
@property (nonatomic, strong) UIDynamicAnimator *dynamic;
@end

@implementation YYTestDynamicController

- (void)didInitialize {
    [super didInitialize];
    self.xy_preferredNavigationBarAlpha = 0;
}

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"UIDynamic";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem xy_itemWithTitle:@"重置" target:self action:@selector(resetAction)];
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    UISegmentedControl *styleSegment = [[UISegmentedControl alloc] initWithItems:@[@"重力", @"碰撞", @"捕捉", @"推动", @"动力", @"吸附"]];
    [styleSegment addTarget:self action:@selector(styleAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:styleSegment];
    _styleSegment = styleSegment;
    
    UIView *ball = [[UIView alloc] init];
    ball.backgroundColor = UIColor.blueColor;
    ball.layer.masksToBounds = YES;
    ball.layer.cornerRadius = 30;
    [self.view addSubview:ball];
    _ball = ball;
    
    UIView *obstacle1 = [[UIView alloc] init];
    obstacle1.backgroundColor = UIColor.brownColor;
    [self.view addSubview:obstacle1];
    _obstacle1 = obstacle1;
    
    UIView *obstacle2 = [[UIView alloc] init];
    obstacle2.backgroundColor = UIColor.redColor;
    [self.view addSubview:obstacle2];
    _obstacle2 = obstacle2;

    
    [styleSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.centerX.mas_equalTo(0);
    }];
    
    [ball mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(styleSegment.mas_bottom).offset(50);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [obstacle1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    [obstacle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(80);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
}

- (void)resetAction {
    _styleSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
    _styleSegment.enabled = YES;
    [_dot removeFromSuperview];
    [_dynamic removeAllBehaviors];
}

- (void)styleAction:(UISegmentedControl *)sender {
    sender.enabled = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    [self.dynamic removeAllBehaviors];
    
    if (_styleSegment.selectedSegmentIndex == 0) {
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
        gravity.magnitude = 1;
        [gravity addItem:_ball];
        
        UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
        collision.translatesReferenceBoundsIntoBoundary = YES;
        [collision addItem:_ball];
    
        [self.dynamic addBehavior:gravity];
        [self.dynamic addBehavior:collision];
    }
    else if (_styleSegment.selectedSegmentIndex == 1) {
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
        gravity.magnitude = 1;
        [gravity addItem:_ball];
        [gravity addItem:_obstacle1];
        [gravity addItem:_obstacle2];

        UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
        collision.translatesReferenceBoundsIntoBoundary = YES;
        [collision addItem:_ball];
        [collision addItem:_obstacle1];
        [collision addItem:_obstacle2];
        
        [self.dynamic addBehavior:gravity];
        [self.dynamic addBehavior:collision];
    }
    else if (_styleSegment.selectedSegmentIndex == 2) {
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:_ball snapToPoint:point];
        snap.damping = 1;
        [self.dynamic removeAllBehaviors];
        [self.dynamic addBehavior:snap];
    }
    else if (_styleSegment.selectedSegmentIndex == 3) {
        CGFloat x = point.x - _ball.center.x;
        CGFloat y = point.y - _ball.center.y;

        UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
        collision.translatesReferenceBoundsIntoBoundary = YES;
        [collision addItem:_ball];
        
        UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[_ball] mode:UIPushBehaviorModeInstantaneous];
        push.active = YES;
        push.magnitude = sqrtf(x * x + y * y) * 0.01;
        push.pushDirection = CGVectorMake(x, y);

        [self.dynamic addBehavior:collision];
        [self.dynamic addBehavior:push];
    }
    else if (_styleSegment.selectedSegmentIndex == 4) {
        CGFloat x = point.x - _ball.center.x;
        CGFloat y = point.y - _ball.center.y;
        
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
        gravity.magnitude = 1;
        [gravity addItem:_ball];
        [gravity addItem:_obstacle1];
        [gravity addItem:_obstacle2];
        
        UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
        collision.translatesReferenceBoundsIntoBoundary = YES;
        [collision addItem:_ball];
        [collision addItem:_obstacle1];
        [collision addItem:_obstacle2];
        
        UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[_ball] mode:UIPushBehaviorModeInstantaneous];
        push.active = YES;
        push.magnitude = sqrtf(x * x + y * y) * 0.01;
        push.pushDirection = CGVectorMake(x, y);
        
        UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:@[_ball]];
        item.elasticity = 0.8;
        item.friction = 0;
        item.density = 1;
        item.resistance = 0;
        item.angularResistance = 0.2;
        
        [self.dynamic addBehavior:gravity];
        [self.dynamic addBehavior:collision];
        [self.dynamic addBehavior:item];
        [self.dynamic addBehavior:push];
    }
    else if (_styleSegment.selectedSegmentIndex == 5) {
        if (!_dot) {
            UIView *dot = [[UIView alloc] init];
            dot.backgroundColor = UIColor.blackColor;
            dot.layer.masksToBounds = YES;
            dot.layer.cornerRadius = 5;
            _dot = dot;
        }
        if (!_dot.superview) {
            [self.view addSubview:_dot];
        }
        
        _dot.center = point;
        _dot.xy_size = CGSizeMake(10, 10);
        
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
        gravity.magnitude = 1;
        [gravity addItem:_ball];
        
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:_ball attachedToAnchor:point];
        attachment.length = 100;
        
        [self.dynamic addBehavior:gravity];
        [self.dynamic addBehavior:attachment];
    }
}

- (UIDynamicAnimator *)dynamic {
    if (!_dynamic) {
        UIDynamicAnimator *dynamic = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        dynamic.delegate = self;
        _dynamic = dynamic;
    }
    return _dynamic;
}

@end
