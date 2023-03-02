//
//  XYCodeScanResult.h
//  XYCodeScanner
//
//  Created by nevsee on 2021/10/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYCodeScanResult : NSObject

/// The position of the rectangle.
@property (nonatomic, assign) CGRect bounds;

/// The points defining the (X,Y) locations of the corners of the machine-readable code.
/// The points are arranged in counter-clockwise order (clockwise if the code or image is mirrored),
/// starting with the top-left of the code in its canonical orientation.
@property (nonatomic, strong) NSArray<NSString *> *corners;

/// Returns the receiver's errorCorrectedData decoded into a human-readable string.
@property (nonatomic, strong) NSString *stringValue;

/// An identifier for the metadata object.
/// @see AVMetadataObjectType
@property (nonatomic, strong, nullable) NSString *type;

/// The symbology of the detected barcode.
/// @see VNBarcodeSymbology
@property (nonatomic, strong, nullable) NSString *symbology;

@end

NS_ASSUME_NONNULL_END
