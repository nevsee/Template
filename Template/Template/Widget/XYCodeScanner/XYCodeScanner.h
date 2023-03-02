//
//  XYCodeScanner.h
//  XYCodeScanner
//
//  Created by nevsee on 2021/10/8.
//

#import <Foundation/Foundation.h>

#if __has_include(<XYCodeScanner/XYCodeScanner.h>)
FOUNDATION_EXPORT double XYCodeScannerVersionNumber;
FOUNDATION_EXPORT const unsigned char XYCodeScannerVersionString[];
#import <XYCodeScanner/XYCodeScanView.h>
#import <XYCodeScanner/XYCodeScanResult.h>
#import <XYCodeScanner/XYCodeScanAnimator.h>
#import <XYCodeScanner/XYCodeScanIndicator.h>
#import <XYCodeScanner/XYCodeScanImagePreview.h>
#else
#import "XYCodeScanView.h"
#import "XYCodeScanResult.h"
#import "XYCodeScanAnimator.h"
#import "XYCodeScanIndicator.h"
#import "XYCodeScanImagePreview.h"
#endif


