//
//  XYMultipleDelegate.h
//  XYMultipleDelegate
//
//  Created by nevsee on 2020/11/9.
//

#import <Foundation/Foundation.h>

#if __has_include(<XYMultipleDelegate/XYMultipleDelegate.h>)
FOUNDATION_EXPORT double XYMultipleDelegateVersionNumber;
FOUNDATION_EXPORT const unsigned char XYMultipleDelegateVersionString[];
#import <XYMultipleDelegate/XYDelegateRepeater.h>
#import <XYMultipleDelegate/NSObject+XYMultipleDelegate.h>
#else
#import "XYDelegateRepeater.h"
#import "NSObject+XYMultipleDelegate.h"
#endif


