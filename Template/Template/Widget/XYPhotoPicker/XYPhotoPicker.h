//
//  XYPhotoPicker.h
//  XYPhotoPicker
//
//  Created by nevsee on 2017/6/10.
//

#import <Foundation/Foundation.h>

#if __has_include(<XYPhotoPicker/XYPhotoPicker.h>)
FOUNDATION_EXPORT double XYPhotoPickerVersionNumber;
FOUNDATION_EXPORT const unsigned char XYPhotoPickerVersionString[];
#import <XYPhotoPicker/XYPhotoPickerAppearance.h>
#import <XYPhotoPicker/XYPhotoPickerController.h>
#import <XYPhotoPicker/XYPhotoAlbumController.h>
#import <XYPhotoPicker/XYPhotoAssetController.h>
#import <XYPhotoPicker/XYPhotoPreviewController.h>
#else
#import "XYPhotoPickerAppearance.h"
#import "XYPhotoPickerController.h"
#import "XYPhotoAlbumController.h"
#import "XYPhotoAssetController.h"
#import "XYPhotoPreviewController.h"
#endif



