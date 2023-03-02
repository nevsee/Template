//
//  XYBrowser.h
//  XYBrowser
//
//  Created by nevsee on 2022/9/21.
//

#import <Foundation/Foundation.h>

#if __has_include(<XYBrowser/XYBrowser.h>)
FOUNDATION_EXPORT double XYBrowserVersionNumber;
FOUNDATION_EXPORT const unsigned char XYBrowserVersionString[];
#import <XYBrowser/XYBrowserView.h>
#import <XYBrowser/XYBrowserController.h>
#else
#import "XYBrowserView.h"
#import "XYBrowserController.h"
#endif
