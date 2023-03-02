//
//  UIApplication+XYAdd.h
//  XYCategory
//
//  Created by nevsee on 2017/4/12.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (XYAdd)

@property (nonatomic, readonly, nullable) UIWindowScene *xy_windowSence API_AVAILABLE(ios(13.0));
@property (nonatomic, readonly, nullable) UIWindow *xy_keyWindow;
@property (nonatomic, readonly) UIInterfaceOrientation xy_interfaceOrientation;
@property (nonatomic, readonly) BOOL xy_isInterfaceLandscape;
@property (nonatomic, readonly) BOOL xy_isDeviceLandscape;

@property (class, nonatomic, readonly) NSString *xy_appBundleIdentifier; ///< Application's bundle identifier.
@property (class, nonatomic, readonly, nullable) NSString *xy_appDisplayName; ///< Application's name. (e.g "Twitter")
@property (class, nonatomic, readonly, nullable) NSArray *xy_appIcons; ///< Application's icon.
@property (class, nonatomic, readonly, nullable) NSString *xy_appVersion; ///< The release-version-number string for the bundle.
@property (class, nonatomic, readonly, nullable) NSString *xy_appBuildVersion; ///< The build-version-number string for the bundle.

@property (class, nonatomic, readonly) NSString *xy_homePath; ///< Application's home directory path.
@property (class, nonatomic, readonly) NSString *xy_documentsPath; ///< Application's documents directory path.
@property (class, nonatomic, readonly) NSString *xy_cachesPath; ///< Application's caches directory path.
@property (class, nonatomic, readonly) NSString *xy_libraryPath; ///< Application's library directory path.
@property (class, nonatomic, readonly) NSString *xy_tmpPath; ///< Application's tmp directory path.
@property (class, nonatomic, readonly) NSString *xy_preferencePath; ///< Application's preference directory path.
@property (class, nonatomic, readonly) NSString *xy_applicationSupportPath; ///< Application's application support directory path.

/**
 The resource should be excluded from backups.
 @note Some operations commonly made to user documents will cause this method to be invalid
 and so this method should not be used on user documents.
 */
+ (void)xy_addDoNotBackupAttributeForPath:(NSString *)path error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END

