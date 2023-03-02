//
//  NSURL+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2021/8/18.
//

#import "NSURL+XYAdd.h"
#import "XYCategoryMacro.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

XYSYNTH_DUMMY_CLASS(NSURL_XYAdd)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation NSURL (XYAdd)

- (NSDictionary *)xy_queryItems {
    if (self.absoluteString.length == 0) return nil;
    
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:self.absoluteString];
    [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem *obj, NSUInteger idx, BOOL *stop) {
        if (obj.name) {
            [results setObject:obj.value ?: [NSNull null] forKey:obj.name];
        }
    }];
    return results.copy;
}

- (NSString *)xy_mimeType {
    if (@available(iOS 14.0, *)) {
        UTType *type = [UTType typeWithFilenameExtension:self.pathExtension];
        return type.preferredMIMEType ?: @"application/octet-stream";
    } else {
        NSString *extension = self.pathExtension;
        NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
        NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
        return contentType ?: @"application/octet-stream";
    }
}

- (NSString *)xy_mimeTypeByRequest {
    __block NSString *mimeType = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:self completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        mimeType = response.MIMEType ?: @"application/octet-stream";
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return mimeType;
}

+ (NSString *)xy_getFileExtensionForMimeType:(NSString *)mimeType {
    if (!mimeType) return nil;
    if (@available(iOS 14.0, *)) {
        UTType *type = [UTType typeWithMIMEType:mimeType];
        return type.preferredFilenameExtension;
    } else {
        NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)mimeType, NULL);
        NSString *extension = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassFilenameExtension);
        return extension;
    }
}

@end

#pragma clang diagnostic pop
