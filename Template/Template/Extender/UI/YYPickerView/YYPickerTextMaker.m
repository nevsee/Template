//
//  YYPickerTextMaker.m
//  Template
//
//  Created by nevsee on 2022/1/25.
//

#import "YYPickerTextMaker.h"

@implementation YYPickerTextMaker

- (NSInteger)numberOfComponentsInPickerView:(YYPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(YYPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _texts.count;
}

- (NSString *)pickerView:(YYPickerView *)pickerView valueForRow:(NSInteger)row inComponent:(NSUInteger)component {
    return _texts[row];
}

- (NSString *)pickerView:(YYPickerView *)pickerView nameForRow:(NSInteger)row inComponent:(NSUInteger)component {
    return _texts[row];
}

@end
