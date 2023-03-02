//
//  YYPickerView.m
//  Template
//
//  Created by nevsee on 2022/1/5.
//

#import "YYPickerView.h"

@interface YYPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) BOOL didLayout;
@end

@implementation YYPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _rowHeight = 35;
        _hidesWhenEmptied = YES;
        _keepsWhenScrolled = YES;

        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self addSubview:pickerView];
        _pickerView = pickerView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _pickerView.frame = self.bounds;
    if (_didLayout || !self.window) return;
    _didLayout = YES;
    if (!_defaultIndexes) return;
    [self scrollToRows:_defaultIndexes animated:NO];
}

// Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger components = [_dataSourceMaker numberOfComponentsInPickerView:self];
    pickerView.alpha = (_hidesWhenEmptied && components == 0) ? 0 : 1;
    return components;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger rows = [_dataSourceMaker pickerView:self numberOfRowsInComponent:component];
    pickerView.alpha = (_hidesWhenEmptied && component == 0 && rows == 0) ? 0 : 1;
    return rows;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = XYFontBoldMake(18);
        label.textColor = YYNeutral9Color;
    }
    if (_setViewBlock) {
        return _setViewBlock(self, row, component, view ?: label);
    } else {
        label.text = [_dataSourceMaker pickerView:self nameForRow:row inComponent:component];
        return label;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return _rowHeight;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    for (NSInteger i = component + 1; i < [_dataSourceMaker numberOfComponentsInPickerView:self]; i++) {
        if (!_keepsWhenScrolled) {
            [_pickerView selectRow:0 inComponent:i animated:YES];
        }
        [_pickerView reloadComponent:i];
    }
    if (_didSelectItemBlock) _didSelectItemBlock(self, self.selectedValues, self.selectedNames);
}

// Method

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    return [_pickerView selectedRowInComponent:component];
}

- (void)scrollToRow:(NSUInteger)row inComponent:(NSUInteger)component animated:(BOOL)animated {
    [_pickerView reloadComponent:component];
    [_pickerView selectRow:row inComponent:component animated:animated];
}

- (void)scrollToRows:(NSArray<NSNumber *> *)rows animated:(BOOL)animated {
    NSInteger components = [_dataSourceMaker numberOfComponentsInPickerView:self];
    if (rows.count != components) return;
    for (NSInteger i = 0; i < components; i++) {
        NSInteger row = [rows[i] integerValue];
        [self scrollToRow:row inComponent:i animated:animated];
    }
}

- (void)scrollToRows:(NSArray<NSNumber *> *)rows inComponents:(NSArray<NSNumber *> *)components animated:(BOOL)animated {
    if (rows.count != components.count) return;
    for (NSInteger i = 0; i < rows.count; i++) {
        NSInteger row = [rows[i] integerValue];
        NSInteger component = [components[i] integerValue];
        [self scrollToRow:row inComponent:component animated:animated];
    }
}

- (void)scrollToTopInComponent:(NSUInteger)component animated:(BOOL)animated {
    [self scrollToRow:0 inComponent:component animated:animated];
}

- (void)scrollToBottomInComponent:(NSUInteger)component animated:(BOOL)animated {
    NSInteger row = [_dataSourceMaker pickerView:self numberOfRowsInComponent:component];
    [self scrollToRow:row - 1 inComponent:component animated:animated];
}

- (void)reloadPicker {
    [_pickerView reloadAllComponents];
}

// Access

- (NSArray *)selectedValues {
    NSMutableArray *values = [NSMutableArray array];
    for (NSInteger i = 0; i < [_dataSourceMaker numberOfComponentsInPickerView:self]; i++) {
        NSInteger row = [self selectedRowInComponent:i];
        NSString *value = [_dataSourceMaker pickerView:self valueForRow:row inComponent:i];
        [values addObject:value];
    }
    return values.copy;
}

- (NSArray *)selectedNames {
    NSMutableArray *names = [NSMutableArray array];
    for (NSInteger i = 0; i < [_dataSourceMaker numberOfComponentsInPickerView:self]; i++) {
        NSInteger row = [self selectedRowInComponent:i];
        NSString *name = [_dataSourceMaker pickerView:self nameForRow:row inComponent:i];
        [names addObject:name];
    }
    return names.copy;
}

- (void)setDefaultIndexes:(NSArray *)defaultIndexes {
    _defaultIndexes = defaultIndexes;
    if (!_didLayout) return;
    [self scrollToRows:defaultIndexes animated:NO];
}

- (void)setDataSourceMaker:(id<YYPickerDataSourceMaker>)dataSourceMaker {
    _dataSourceMaker = dataSourceMaker;
    [_pickerView reloadAllComponents];
}

@end
