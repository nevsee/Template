//
//  YYPickerView.h
//  Template
//
//  Created by nevsee on 2022/1/5.
//

#import <UIKit/UIKit.h>

@class YYPickerView;

NS_ASSUME_NONNULL_BEGIN

typedef UIView * _Nonnull (^YYPickerViewSetViewBlock)(YYPickerView *pickerView, NSInteger row, NSInteger component, UIView *reusingView);
typedef void (^YYPickerViewDidSelectItemBlock)(YYPickerView *pickerView, NSArray *selectedValues, NSArray *selectedNames);

@protocol YYPickerDataSourceMaker <NSObject>
@required
- (NSInteger)numberOfComponentsInPickerView:(YYPickerView *)pickerView;
- (NSInteger)pickerView:(YYPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString *)pickerView:(YYPickerView *)pickerView valueForRow:(NSInteger)row inComponent:(NSUInteger)component;
- (NSString *)pickerView:(YYPickerView *)pickerView nameForRow:(NSInteger)row inComponent:(NSUInteger)component;
@end

/// 选择器
@interface YYPickerView : UIView
@property (nonatomic, strong, readonly, nullable) NSArray *selectedValues;
@property (nonatomic, strong, readonly, nullable) NSArray *selectedNames;
@property (nonatomic, assign) BOOL hidesWhenEmptied; ///< 当数据为空时，是否隐藏，默认YES
@property (nonatomic, assign) BOOL keepsWhenScrolled; ///< 当滚动某一列时，其子列是否保持当前滚动位置不变，默认YES
@property (nonatomic, assign) CGFloat rowHeight; ///< 行高，默认35
@property (nonatomic, strong, nullable) NSArray *defaultIndexes; ///< 默认选中下标
@property (nonatomic, strong, nullable) id<YYPickerDataSourceMaker> dataSourceMaker; ///< 数据源
@property (nonatomic, strong, nullable) YYPickerViewSetViewBlock setViewBlock;
@property (nonatomic, strong, nullable) YYPickerViewDidSelectItemBlock didSelectItemBlock;
- (NSInteger)selectedRowInComponent:(NSInteger)component;
- (void)scrollToRow:(NSUInteger)row inComponent:(NSUInteger)component animated:(BOOL)animated;
- (void)scrollToRows:(NSArray<NSNumber *> *)rows animated:(BOOL)animated;
- (void)scrollToRows:(NSArray<NSNumber *> *)rows inComponents:(NSArray<NSNumber *> *)components animated:(BOOL)animated;
- (void)scrollToTopInComponent:(NSUInteger)component animated:(BOOL)animated;
- (void)scrollToBottomInComponent:(NSUInteger)component animated:(BOOL)animated;
- (void)reloadPicker;
@end

NS_ASSUME_NONNULL_END
