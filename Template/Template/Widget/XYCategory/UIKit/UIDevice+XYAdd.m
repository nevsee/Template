//
//  UIDevice+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2017/3/30.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "UIDevice+XYAdd.h"
#import "XYCategoryMacro.h"
#import "XYCategoryUtility.h"
#import "NSObject+XYAdd.h"
#import "UIApplication+XYAdd.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

XYSYNTH_DUMMY_CLASS(UIDevice_XYAdd)

@implementation UIDevice (XYAdd)

+ (NSString *)xy_model {
    static NSString *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([UIDevice xy_isSimulator]) {
            model = [NSString stringWithFormat:@"%s", getenv("SIMULATOR_MODEL_IDENTIFIER")];
        } else {
            size_t size;
            sysctlbyname("hw.machine", NULL, &size, NULL, 0);
            char *machine = malloc(size);
            sysctlbyname("hw.machine", machine, &size, NULL, 0);
            model = [NSString stringWithUTF8String:machine];
            free(machine);
        }
    });
    return model;
}

+ (NSString *)xy_modelName {
    static NSString *name;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *model = [UIDevice xy_model];
        NSDictionary *map = @{
            @"Watch1,1" : @"Apple Watch 1",
            @"Watch1,2" : @"Apple Watch 1",
            @"Watch2,3" : @"Apple Watch 2",
            @"Watch2,4" : @"Apple Watch 2",
            @"Watch2,6" : @"Apple Watch 1",
            @"Watch2,7" : @"Apple Watch 1",
            @"Watch3,1" : @"Apple Watch 3",
            @"Watch3,2" : @"Apple Watch 3",
            @"Watch3,3" : @"Apple Watch 3",
            @"Watch3,4" : @"Apple Watch 3",
            @"Watch4,1" : @"Apple Watch 4",
            @"Watch4,2" : @"Apple Watch 4",
            @"Watch4,3" : @"Apple Watch 4",
            @"Watch4,4" : @"Apple Watch 4",
            @"Watch5,1" : @"Apple Watch 5",
            @"Watch5,2" : @"Apple Watch 5",
            @"Watch5,3" : @"Apple Watch 5",
            @"Watch5,4" : @"Apple Watch 5",
            @"Watch5,9" : @"Apple Watch SE",
            @"Watch5,10" : @"Apple Watch SE",
            @"Watch5,11" : @"Apple Watch SE",
            @"Watch5,12" : @"Apple Watch SE",
            @"Watch6,1" : @"Apple Watch 6",
            @"Watch6,2" : @"Apple Watch 6",
            @"Watch6,3" : @"Apple Watch 6",
            @"Watch6,4" : @"Apple Watch 6",
            @"Watch6,6" : @"Apple Watch 7",
            @"Watch6,7" : @"Apple Watch 7",
            @"Watch6,8" : @"Apple Watch 7",
            @"Watch6,9" : @"Apple Watch 7",
            @"Watch6,18" : @"Apple Watch Ultra",

            @"iPad1,1" : @"iPad 1",
            @"iPad2,1" : @"iPad 2",
            @"iPad2,2" : @"iPad 2",
            @"iPad2,3" : @"iPad 2",
            @"iPad2,4" : @"iPad 2",
            @"iPad2,5" : @"iPad mini 1",
            @"iPad2,6" : @"iPad mini 1",
            @"iPad2,7" : @"iPad mini 1",
            @"iPad3,1" : @"iPad 3",
            @"iPad3,2" : @"iPad 3",
            @"iPad3,3" : @"iPad 3",
            @"iPad3,4" : @"iPad 4",
            @"iPad3,5" : @"iPad 4",
            @"iPad3,6" : @"iPad 4",
            @"iPad4,1" : @"iPad Air 1",
            @"iPad4,2" : @"iPad Air 1",
            @"iPad4,3" : @"iPad Air 1",
            @"iPad4,4" : @"iPad mini 2",
            @"iPad4,5" : @"iPad mini 2",
            @"iPad4,6" : @"iPad mini 2",
            @"iPad4,7" : @"iPad mini 3",
            @"iPad4,8" : @"iPad mini 3",
            @"iPad4,9" : @"iPad mini 3",
            @"iPad5,1" : @"iPad mini 4",
            @"iPad5,2" : @"iPad mini 4",
            @"iPad5,3" : @"iPad Air 2",
            @"iPad5,4" : @"iPad Air 2",
            @"iPad6,3" : @"iPad Pro (9.7 inch) 1",
            @"iPad6,4" : @"iPad Pro (9.7 inch) 1",
            @"iPad6,7" : @"iPad Pro (12.9 inch) 1",
            @"iPad6,8" : @"iPad Pro (12.9 inch) 1",
            @"iPad6,11": @"iPad 5",
            @"iPad6,12": @"iPad 5",
            @"iPad7,1" : @"iPad Pro (12.9 inch) 2",
            @"iPad7,2" : @"iPad Pro (12.9 inch) 2",
            @"iPad7,3" : @"iPad Pro (10.5 inch) 1",
            @"iPad7,4" : @"iPad Pro (10.5 inch) 1",
            @"iPad7,5" : @"iPad 6",
            @"iPad7,6" : @"iPad 6",
            @"iPad7,11": @"iPad 7",
            @"iPad7,12": @"iPad 7",
            @"iPad8,1" : @"iPad Pro (11 inch) 1",
            @"iPad8,2" : @"iPad Pro (11 inch) 1",
            @"iPad8,3" : @"iPad Pro (11 inch) 1",
            @"iPad8,4" : @"iPad Pro (11 inch) 1",
            @"iPad8,5" : @"iPad Pro (12.9 inch) 3",
            @"iPad8,6" : @"iPad Pro (12.9 inch) 3",
            @"iPad8,7" : @"iPad Pro (12.9 inch) 3",
            @"iPad8,8" : @"iPad Pro (12.9 inch) 3",
            @"iPad8,9" : @"iPad Pro (11 inch) 2",
            @"iPad8,10" : @"iPad Pro (11 inch) 2",
            @"iPad8,11" : @"iPad Pro (12.9 inch) 4",
            @"iPad8,12" : @"iPad Pro (12.9 inch) 4",
            @"iPad11,1" : @"iPad mini 5",
            @"iPad11,2" : @"iPad mini 5",
            @"iPad11,3" : @"iPad Air 3",
            @"iPad11,4" : @"iPad Air 3",
            @"iPad11,6" : @"iPad 8",
            @"iPad11,7" : @"iPad 8",
            @"iPad12,1" : @"iPad 9",
            @"iPad12,2" : @"iPad 9",
            @"iPad13,1" : @"iPad Air 4",
            @"iPad13,2" : @"iPad Air 4",
            @"iPad13,4" : @"iPad Pro (11 inch) 3",
            @"iPad13,5" : @"iPad Pro (11 inch) 3",
            @"iPad13,6" : @"iPad Pro (11 inch) 3",
            @"iPad13,7" : @"iPad Pro (11 inch) 3",
            @"iPad13,8" : @"iPad Pro (12.9 inch) 5",
            @"iPad13,9" : @"iPad Pro (12.9 inch) 5",
            @"iPad13,10" : @"iPad Pro (12.9 inch) 5",
            @"iPad13,11" : @"iPad Pro (12.9 inch) 5",
            @"iPad14,1" : @"iPad mini 6",
            @"iPad14,2" : @"iPad mini 6",

            @"iPhone1,1" : @"iPhone 1",
            @"iPhone1,2" : @"iPhone 3G",
            @"iPhone2,1" : @"iPhone 3GS",
            @"iPhone3,1" : @"iPhone 4",
            @"iPhone3,2" : @"iPhone 4",
            @"iPhone3,3" : @"iPhone 4",
            @"iPhone4,1" : @"iPhone 4S",
            @"iPhone5,1" : @"iPhone 5",
            @"iPhone5,2" : @"iPhone 5",
            @"iPhone5,3" : @"iPhone 5c",
            @"iPhone5,4" : @"iPhone 5c",
            @"iPhone6,1" : @"iPhone 5s",
            @"iPhone6,2" : @"iPhone 5s",
            @"iPhone7,1" : @"iPhone 6 Plus",
            @"iPhone7,2" : @"iPhone 6",
            @"iPhone8,1" : @"iPhone 6s",
            @"iPhone8,2" : @"iPhone 6s Plus",
            @"iPhone8,4" : @"iPhone SE 1",
            @"iPhone9,1" : @"iPhone 7",
            @"iPhone9,2" : @"iPhone 7 Plus",
            @"iPhone9,3" : @"iPhone 7",
            @"iPhone9,4" : @"iPhone 7 Plus",
            @"iPhone10,1" : @"iPhone 8",
            @"iPhone10,2" : @"iPhone 8 Plus",
            @"iPhone10,3" : @"iPhone X",
            @"iPhone10,4" : @"iPhone 8",
            @"iPhone10,5" : @"iPhone 8 Plus",
            @"iPhone10,6" : @"iPhone X",
            @"iPhone11,2" : @"iPhone XS",
            @"iPhone11,4" : @"iPhone XS Max",
            @"iPhone11,6" : @"iPhone XS Max",
            @"iPhone11,8" : @"iPhone XR",
            @"iPhone12,1" : @"iPhone 11",
            @"iPhone12,3" : @"iPhone 11 Pro",
            @"iPhone12,5" : @"iPhone 11 Pro Max",
            @"iPhone12,8" : @"iPhone SE 2",
            @"iPhone13,1" : @"iPhone 12 mini",
            @"iPhone13,2" : @"iPhone 12",
            @"iPhone13,3" : @"iPhone 12 Pro",
            @"iPhone13,4" : @"iPhone 12 Pro Max",
            @"iPhone14,2" : @"iPhone 13 Pro",
            @"iPhone14,3" : @"iPhone 13 Pro Max",
            @"iPhone14,4" : @"iPhone 13 mini",
            @"iPhone14,5" : @"iPhone 13",
            @"iPhone14,6" : @"iPhone SE 3",
            @"iPhone14,7" : @"iPhone 14",
            @"iPhone14,8" : @"iPhone 14 Plus",
            @"iPhone15,2" : @"iPhone 14 Pro",
            @"iPhone15,3" : @"iPhone 14 Pro Max",

            @"i386" : @"Simulator x86",
            @"x86_64" : @"Simulator x64",
        };
        name = map[model];
    });
    return name;
}

+ (CGSize)xy_screenSize {
    return [[UIScreen mainScreen] bounds].size;
}

+ (CGFloat)xy_screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)xy_screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGSize)xy_deviceSize {
    return CGSizeMake([self xy_deviceWidth], [self xy_deviceHeight]);
}

+ (CGFloat)xy_deviceWidth {
    return MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
}

+ (CGFloat)xy_deviceHeight {
    return MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
}

+ (BOOL)xy_isPhone {
    return [[UIDevice xy_modelName] containsString:@"iPhone"];
}

+ (BOOL)xy_isPad {
    return [[UIDevice xy_modelName] containsString:@"iPad"];
}

+ (BOOL)xy_isAppleWatch {
    return [[UIDevice xy_modelName] containsString:@"Apple Watch"];
}

+ (BOOL)xy_isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

static NSInteger is35Inch = -1;
+ (BOOL)xy_is35Inch {
    if (is35Inch < 0) {
        is35Inch = CGSizeEqualToSize([self xy_deviceSize], [self xy_sizeFor35Inch]) ? 1 : 0;
    }
    return is35Inch > 0;
}

static NSInteger is40Inch = -1;
+ (BOOL)xy_is40Inch {
    if (is40Inch < 0) {
        is40Inch = CGSizeEqualToSize([self xy_deviceSize], [self xy_sizeFor40Inch]) ? 1 : 0;
    }
    return is40Inch > 0;
}

static NSInteger is47Inch = -1;
+ (BOOL)xy_is47Inch {
    if (is47Inch < 0) {
        is47Inch = CGSizeEqualToSize([self xy_deviceSize], [self xy_sizeFor47Inch]) ? 1 : 0;
    }
    return is47Inch > 0;
}

static NSInteger is54Inch = -1;
+ (BOOL)xy_is54Inch {
    if (is54Inch < 0) {
        NSString *model = [UIDevice xy_model];
        BOOL a = CGSizeEqualToSize([self xy_deviceSize], [self xy_sizeFor54Inch]) ? 1 : 0;
        BOOL b = [model isEqualToString:@"iPhone13,1"] || [model isEqualToString:@"iPhone14,4"];
        is54Inch = (a && b) ? 1 : 0;
    }
    return is54Inch > 0;
}

static NSInteger is55Inch = -1;
+ (BOOL)xy_is55Inch {
    if (is55Inch < 0) {
        is55Inch = CGSizeEqualToSize([self xy_deviceSize], [self xy_sizeFor55Inch]) ? 1 : 0;
    }
    return is55Inch > 0;
}

static NSInteger is58Inch = -1;
+ (BOOL)xy_is58Inch {
    if (is58Inch < 0) {
        NSString *model = [UIDevice xy_model];
        BOOL a = CGSizeEqualToSize([self xy_deviceSize], [self xy_sizeFor58Inch]) ? 1 : 0;
        BOOL b = [model isEqualToString:@"iPhone10,3"] || [model isEqualToString:@"iPhone10,6"]
        || [model isEqualToString:@"iPhone11,2"] || [model isEqualToString:@"iPhone12,3"];
        is58Inch = (a && b) ? 1 : 0;
    }
    return is58Inch > 0;
}

static NSInteger is61Inch = -1;
+ (BOOL)xy_is61Inch {
    if (is61Inch < 0) {
        NSString *model = [UIDevice xy_model];
        BOOL a = CGSizeEqualToSize([self xy_deviceSize], [self xy_sizeFor61Inch]);
        BOOL b = [model isEqualToString:@"iPhone11,8"] || [model isEqualToString:@"iPhone12,1"];
        is61Inch = (a && b) ? 1 : 0;
    }
    return is61Inch > 0;
}

static NSInteger is61InchExtra = -1;
+ (BOOL)xy_is61InchExtra {
    if (is61InchExtra < 0) {
        is61InchExtra = CGSizeEqualToSize([self xy_deviceSize], [self xy_sizeFor61InchExtra]);
    }
    return is61InchExtra > 0;
}

static NSInteger is61InchExtra2 = -1;
+ (BOOL)xy_is61InchExtra2 {
    if (is61InchExtra2 < 0) {
        is61InchExtra2 = CGSizeEqualToSize([self xy_deviceSize], [self xy_sizeFor61InchExtra2]);
    }
    return is61InchExtra2 > 0;
}

static NSInteger is65Inch = -1;
+ (BOOL)xy_is65Inch {
    if (is65Inch < 0) {
        NSString *model = [UIDevice xy_model];
        BOOL a = CGSizeEqualToSize([self xy_deviceSize], [self xy_sizeFor65Inch]);
        BOOL b = [model isEqualToString:@"iPhone11,4"] || [model isEqualToString:@"iPhone11,6"]
        || [model isEqualToString:@"iPhone12,5"];
        is65Inch = (a && b) ? 1 : 0;
    }
    return is65Inch > 0;
}

static NSInteger is67Inch = -1;
+ (BOOL)xy_is67Inch {
    if (is67Inch < 0) {
        is67Inch = CGSizeEqualToSize([self xy_deviceSize], [self xy_sizeFor67Inch]) ? 1 : 0;
    }
    return is67Inch > 0;
}

static NSInteger is67InchExtra = -1;
+ (BOOL)xy_is67InchExtra {
    if (is67InchExtra < 0) {
        is67InchExtra = CGSizeEqualToSize([self xy_deviceSize], [self xy_sizeFor67InchExtra]) ? 1 : 0;
    }
    return is67InchExtra > 0;
}

+ (CGSize)xy_sizeFor35Inch {
    return CGSizeMake(320, 480);
}

+ (CGSize)xy_sizeFor40Inch {
    return CGSizeMake(320, 568);
}

+ (CGSize)xy_sizeFor47Inch {
    return CGSizeMake(375, 667);
}

+ (CGSize)xy_sizeFor54Inch {
    return CGSizeMake(375, 812);
}

+ (CGSize)xy_sizeFor55Inch {
    return CGSizeMake(414, 736);
}

+ (CGSize)xy_sizeFor58Inch {
    return CGSizeMake(375, 812);
}

+ (CGSize)xy_sizeFor61Inch {
    return CGSizeMake(414, 896);
}

+ (CGSize)xy_sizeFor61InchExtra {
    return CGSizeMake(390, 844);
}

+ (CGSize)xy_sizeFor61InchExtra2 {
    return CGSizeMake(393, 852);
}

+ (CGSize)xy_sizeFor65Inch {
    return CGSizeMake(414, 896);
}

+ (CGSize)xy_sizeFor67Inch {
    return CGSizeMake(428, 926);
}

+ (CGSize)xy_sizeFor67InchExtra {
    return CGSizeMake(430, 932);
}

+ (double)xy_systemVersion {
    return [UIDevice currentDevice].systemVersion.doubleValue;
}

+ (BOOL)xy_isZoom {
    if (![UIDevice xy_isPhone]) return NO;
    
    CGFloat nativeScale = UIScreen.mainScreen.nativeScale;
    CGFloat scale = UIScreen.mainScreen.scale;

    // https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
    BOOL shouldBeDownsampledDevice = CGSizeEqualToSize(UIScreen.mainScreen.nativeBounds.size, CGSizeMake(1080, 1920));
    if (shouldBeDownsampledDevice) scale /= 1.15;
    
    return nativeScale > scale;
}

static NSInteger isNotched = -1;
+ (BOOL)xy_isNotched {
    if (@available(iOS 11, *)) {
        if (isNotched < 0) {
            if (@available(iOS 12.0, *)) {
                SEL peripheryInsetsSelector = NSSelectorFromString([NSString stringWithFormat:@"_%@%@", @"periphery", @"Insets"]);
                UIEdgeInsets peripheryInsets = UIEdgeInsetsZero;
                [[UIScreen mainScreen] xy_performSelector:peripheryInsetsSelector withPrimitiveReturnValue:&peripheryInsets];
                if (peripheryInsets.bottom <= 0) {
                    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                    peripheryInsets = window.safeAreaInsets;
                    if (peripheryInsets.bottom <= 0) {
                        UIViewController *viewController = [UIViewController new];
                        window.rootViewController = viewController;
                        if (CGRectGetMinY(viewController.view.frame) > 20) {
                            peripheryInsets.bottom = 1;
                        }
                    }
                }
                isNotched = peripheryInsets.bottom > 0 ? 1 : 0;
            } else {
                isNotched = [UIDevice xy_is58Inch] ? 1 : 0;
            }
        }
    } else {
        isNotched = 0;
    }
    
    return isNotched > 0;
}

+ (BOOL)xy_isRegular {
    return [UIDevice xy_isPad] || (![UIDevice xy_isZoom] && ([UIDevice xy_is67Inch] || [UIDevice xy_is65Inch] || [UIDevice xy_is61Inch] || [UIDevice xy_is55Inch]));
}

+ (BOOL)xy_is64Bit {
#if defined(__LP64__) && __LP64__
    return YES;
#else
    return NO;
#endif
}

+ (UIEdgeInsets)xy_safeAreaInsets {
    UIWindow *keyWindow = [UIApplication.sharedApplication xy_keyWindow];
    if ([keyWindow respondsToSelector:@selector(safeAreaInsets)]) {
        return keyWindow.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

+ (int64_t)xy_diskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

+ (int64_t)xy_diskSpaceFree {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

+ (int64_t)xy_diskSpaceUsage {
    int64_t total = [self xy_diskSpace];
    int64_t free = [self xy_diskSpaceFree];
    if (total < 0 || free < 0) return -1;
    int64_t used = total - free;
    if (used < 0) used = -1;
    return used;
}

+ (float)xy_cpuUsage {
    kern_return_t kr;
    thread_array_t thread_list;
    mach_msg_type_number_t thread_count;
    thread_info_data_t thread_info_data;
    mach_msg_type_number_t thread_info_count;
    thread_basic_info_t thread_basic_info;
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) return -1;

    float cpu_usage = 0;
    for (int i = 0; i < thread_count; i++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[i], THREAD_BASIC_INFO,(thread_info_t)thread_info_data, &thread_info_count);
        if (kr != KERN_SUCCESS) return -1;
        
        thread_basic_info = (thread_basic_info_t)thread_info_data;
        if (!(thread_basic_info->flags & TH_FLAGS_IDLE)) {
            cpu_usage += thread_basic_info->cpu_usage;
        }
    }
    cpu_usage = cpu_usage / (float)TH_USAGE_SCALE * 100.0;
    vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    return cpu_usage;
}

+ (int64_t)xy_memory {
    return [NSProcessInfo processInfo].physicalMemory;
}

+ (int64_t)xy_memoryFree {
    vm_statistics_data_t statistics;
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    kern_return_t kr = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&statistics, &count);
    if (kr != KERN_SUCCESS) return -1;
    return vm_page_size * statistics.free_count + vm_page_size * statistics.inactive_count;
}

+ (int64_t)xy_memoryUsage {
    task_vm_info_data_t info;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kr = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&info, &count);
    if (kr != KERN_SUCCESS) return -1;
    return info.phys_footprint;
}

@end
