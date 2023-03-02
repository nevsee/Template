//
//  XYStorage.h
//  XYStorage
//
//  Created by nevsee on 2020/10/8.
//  Copyright © 2020 nevsee. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double XYStorageVersionNumber;
FOUNDATION_EXPORT const unsigned char XYStorageVersionString[];

#if __has_include(<XYStorage/XYStorage.h>)
#import <XYStorage/XYDatabase.h>
#import <XYStorage/XYArchiver.h>
#import <XYStorage/XYKeychain.h>
#else
#import "XYDatabase.h"
#import "XYArchiver.h"
#import "XYKeychain.h"
#endif

