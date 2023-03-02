//
//  XYPhoto.h
//  XYPhoto
//
//  Created by nevsee on 2017/5/22.
//

#import <Foundation/Foundation.h>

#if __has_include(<XYPhoto/XYPhoto.h>)
FOUNDATION_EXPORT double XYPhotoVersionNumber;
FOUNDATION_EXPORT const unsigned char XYPhotoVersionString[];
#import <XYPhoto/XYAsset.h>
#import <XYPhoto/XYAssetGroup.h>
#import <XYPhoto/XYAssetManager.h>
#else
#import "XYAsset.h"
#import "XYAssetGroup.h"
#import "XYAssetManager.h"
#endif



