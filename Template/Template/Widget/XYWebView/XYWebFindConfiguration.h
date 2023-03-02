//
//  XYWebFindConfiguration.h
//  XYWidget
//
//  Created by nevsee on 2021/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYWebFindConfiguration : NSObject

/// The highlight background color of matchs.
@property (nonatomic, strong) NSString *normalBackgroundColor;

/// The highlight text color of matchs.
@property (nonatomic, strong) NSString *normalTextColor;

/// The selected background color of matchs.
@property (nonatomic, strong) NSString *selectedBackgroundColor;

/// The selected text color of matchs.
@property (nonatomic, strong) NSString *selectedTextColor;

/// Whether or not the search should be case sensitive. Defaults to NO.
@property (nonatomic, assign) BOOL caseSensitive;

/// Whether or not the first match should be selected. Defaults to YES.
@property (nonatomic, assign) BOOL selectsFirstMatch;

@end

NS_ASSUME_NONNULL_END
