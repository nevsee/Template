
//
//  UITextField+XYAdd.m
//  XYCategory
//
//  Created by nevsee on 2017/4/13.
//  Copyright © 2017年 nevsee. All rights reserved.
//

#import "UITextField+XYAdd.h"
#import "NSString+XYAdd.h"
#import "XYCategoryMacro.h"

XYSYNTH_DUMMY_CLASS(UITextField_XYAdd)

@implementation UITextField (XYAdd)

- (NSRange)xy_selectedRange {
    NSInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
    NSInteger length = [self offsetFromPosition:self.selectedTextRange.start toPosition:self.selectedTextRange.end];
    return NSMakeRange(location, length);
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

- (void)xy_selectAllWithoutMenuBoard {
    [self performSelector:@selector(selectAll:) withObject:nil afterDelay:0.01];
}

@end
