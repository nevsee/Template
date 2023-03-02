//
//  UITextView+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2017/4/13.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "UITextView+XYAdd.h"
#import "NSString+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(UITextView_XYAdd)

@implementation UITextView (XYAdd)

- (NSUInteger)xy_numberOfLines {
    __block NSUInteger number = 0;
    [self.layoutManager enumerateLineFragmentsForGlyphRange:NSMakeRange(0, self.layoutManager.numberOfGlyphs) usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer *textContainer, NSRange glyphRange, BOOL *stop) {
        number++;
    }];
    return number;
}

- (NSInteger)xy_limitMaxLength:(NSInteger)length truncation:(BOOL)truncation nonASCIIAsTwo:(BOOL)nonASCIIAsTwo {
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    
    if (selectedRange && position) { /// hightlighted
        return nonASCIIAsTwo ? self.text.xy_lengthByCountingNonASCIICharacterAsTwo : self.text.length;
    }
    
    if (truncation) {
        self.text = [self.text xy_substringToIndex:length less:YES nonASCIIAsTwo:nonASCIIAsTwo];
    }
    return nonASCIIAsTwo ? self.text.xy_lengthByCountingNonASCIICharacterAsTwo : self.text.length;
}

- (void)xy_scrollToLastLine {
    [self scrollRangeToVisible:NSMakeRange(self.text.length, 1)];
}

- (void)xy_selectAllWithoutMenuBoard {
    [self performSelector:@selector(selectAll:) withObject:nil afterDelay:0.01];
}

@end
