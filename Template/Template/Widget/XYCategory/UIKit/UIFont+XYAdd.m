//
//  UIFont+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2020/10/20.
//

#import "UIFont+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(UIFont_XYAdd)

@implementation UIFont (XYAdd)

- (UIFont *)xy_fontForBold {
    UIFontDescriptor *descriptor = [self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    if (!descriptor) return self;
    return [UIFont fontWithDescriptor:descriptor size:self.pointSize];
}

- (UIFont *)xy_fontForItalic {
    UIFontDescriptor *descriptor = [self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    if (!descriptor) return self;
    return [UIFont fontWithDescriptor:descriptor size:self.pointSize];
}

- (UIFont *)xy_fontForBoldItalic {
    UIFontDescriptor *descriptor = [self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic | UIFontDescriptorTraitBold];
    if (!descriptor) return self;
    return [UIFont fontWithDescriptor:descriptor size:self.pointSize];
}

- (UIFont *)xy_fontForNormal {
    UIFontDescriptor *descriptor = [self.fontDescriptor fontDescriptorWithSymbolicTraits:0];
    if (!descriptor) return self;
    return [UIFont fontWithDescriptor:descriptor size:self.pointSize];
}

@end
