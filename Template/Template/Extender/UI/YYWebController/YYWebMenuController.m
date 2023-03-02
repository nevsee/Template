//
//  YYWebMenuController.m
//  Template
//
//  Created by nevsee on 2021/12/9.
//

#import "YYWebMenuController.h"

@interface YYWebMenuController () <UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong, readwrite) YYWebMenuBoard *menuBoard;
@property (nonatomic, strong, readwrite) YYWebFontBoard *fontBoard;
@property (nonatomic, strong, readwrite) YYWebSearchBoard *searchBoard;
@property (nonatomic, assign) CGFloat fontValue; // 记录当前字体调整系数
@end

@implementation YYWebMenuController

- (void)navigationBarSetup {
    [super navigationBarSetup];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem xy_itemWithImage:XYImageMake(@"more_1") target:self action:@selector(menuAction)];
}

#pragma mark # Delegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [super webView:webView didCommitNavigation:navigation];
    if (_fontValue == 0) return;
    [self.webView xy_updateTextSize:_fontValue];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [super webView:webView didFinishNavigation:navigation];
    if (_fontValue == 0) return;
    [self.webView xy_updateTextSize:_fontValue];
}

#pragma mark # Action

- (void)menuAction {
    if ([self isHttpURL:self.originURL]) {
        [self.menuBoard.headerView updateViewWithData:self.originURL.host userInfo:self.userInfo];
    }
    [self.menuBoard presentInController:self];
}

#pragma mark # Method

- (void)selectOperationItem:(YYOperationItem *)item {
    NSURL *url = self.webView.URL ?: self.originURL;
    
    if (item.type == YYOperationTypeWebCopyLink) {
        if (!url) return;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = url.absoluteString;
        [self.view showSuccessWithText:@"已复制"];
    }
    else if (item.type == YYOperationTypeWebRefresh) {
        [self.webView reloadFromOrigin];
    }
    else if (item.type == YYOperationTypeWebSearch) {
        [self.searchBoard presentInController:self];
    }
    else if (item.type == YYOperationTypeWebFont) {
        [self.fontBoard presentInController:self];
    }
    else if (item.type == YYOperationTypeWebSafari) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
    else if (item.type == YYOperationTypeWebSystemShare) {
        if (!url) return;
        UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
        [self xy_presentViewController:vc];
    }
    [self.menuBoard dismiss];
}

#pragma mark # Access

- (YYWebMenuBoard *)menuBoard {
    if (!_menuBoard) {
        @weakify(self)
        NSArray *shareTypes = @[YYOperationTypeWebSafari, YYOperationTypeWebSystemShare];
        NSArray *toolTypes = @[YYOperationTypeWebCopyLink, YYOperationTypeWebRefresh, YYOperationTypeWebSearch, YYOperationTypeWebFont];
        NSArray *shareItems = [YYWebMenuItemProvider obtainItemsForTypes:shareTypes];
        NSArray *toolItems = [YYWebMenuItemProvider obtainItemsForTypes:toolTypes];
        
        YYWebMenuBoard *board = [[YYWebMenuBoard alloc] init];
        board.menuController = self;
        board.headerView = [[YYWebMenuLinkHeaderView alloc] init];
        board.operationView.didSelectItemBlock = ^(YYOperationView *operationView, YYOperationItem *item) {
            @strongify(self)
            [self selectOperationItem:item];
        };
        [board.operationView insertItems:shareItems inSection:0];
        [board.operationView insertItems:toolItems inSection:1];
        _menuBoard = board;
    }
    return _menuBoard;
}

- (YYWebFontBoard *)fontBoard {
    if (!_fontBoard) {
        @weakify(self)
        YYWebFontBoard *board = [[YYWebFontBoard alloc] init];
        board.menuController = self;
        board.contentView.valueChangedBlock = ^(CGFloat value) {
            @strongify(self)
            self.fontValue = value;
            [self.webView xy_updateTextSize:value];
        };
        _fontBoard = board;
    }
    return _fontBoard;
}

- (YYWebSearchBoard *)searchBoard {
    if (!_searchBoard) {
        @weakify(self)
        YYWebSearchBoard *board = [[YYWebSearchBoard alloc] init];
        board.findBlock = ^(NSString *keyword, YYWebSearchBoard *aBoard) {
            @strongify(self)
            [self.webView xy_findAll:keyword configuration:nil completion:^(NSInteger count, NSError *error) {
                [aBoard updateSearchNumber:count index:1];
            }];
        };
        board.findNextBlock = ^(BOOL next, YYWebSearchBoard *aBoard) {
            @strongify(self)
            [self.webView xy_findNext:next completion:^(NSInteger index, NSError *error) {
                [aBoard updateSearchNumber:-1 index:index + 1];
            }];
        };
        board.clearBlock = ^(YYWebSearchBoard *aBoard) {
            @strongify(self)
            [self.webView xy_clearMatchs:^(NSError *error) {
                [aBoard updateSearchNumber:0 index:0];
            }];
        };
        _searchBoard = board;
    }
    return _searchBoard;
}

@end
