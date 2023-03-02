//
//  YYMediatorErrorController.m
//  Template
//
//  Created by nevsee on 2021/11/18.
//

#import "YYMediatorErrorController.h"

@interface YYMediatorErrorController ()
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation YYMediatorErrorController

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.title = @"导航错误";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem xy_itemWithImage:XYImageMake(@"close_1") alignment:UIControlContentHorizontalAlignmentLeft target:self action:@selector(closeAction)];
}

- (void)userInterfaceSetup {
    [super userInterfaceSetup];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = XYFontMake(17);
    textLabel.textColor = YYNeutral9Color;
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = _error.description;
    [self.view addSubview:textLabel];
    _textLabel = textLabel;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _textLabel.frame = CGRectMake(20, 100, self.view.xy_width - 40, self.view.xy_height - 200);
}

- (void)closeAction {
    [self xy_dismissViewController];
}

@end
