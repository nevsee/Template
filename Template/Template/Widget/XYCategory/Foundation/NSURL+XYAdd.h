//
//  NSURL+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2021/8/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (XYAdd)

/// Returns the query items.
@property (nonatomic, strong, readonly, nullable) NSDictionary *xy_queryItems;

/// Returns the MIME-Type by \c UType.
@property (nonatomic, strong, readonly) NSString *xy_mimeType;

/// Returns the MIME-Type by \c NSURLRequest.
@property (nonatomic, strong, readonly) NSString *xy_mimeTypeByRequest;

/**
 Returns a file extension form a MIME-Type.
 */
+ (nullable NSString *)xy_getFileExtensionForMimeType:(NSString *)mimeType;

@end

NS_ASSUME_NONNULL_END
