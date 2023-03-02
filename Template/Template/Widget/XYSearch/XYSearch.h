//
//  XYSearch.h
//  XYWidget
//
//  Created by nevsee on 2020/11/12.
//

#if __has_include(<XYSearch/XYSearch.h>)
FOUNDATION_EXPORT double XYSearchVersionNumber;
FOUNDATION_EXPORT const unsigned char XYSearchVersionString[];
#import <XYSearch/XYSearchBar.h>
#import <XYSearch/XYSearchController.h>
#else
#import "XYSearchBar.h"
#import "XYSearchController.h"
#endif
