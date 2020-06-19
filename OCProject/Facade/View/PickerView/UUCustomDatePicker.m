//
//  UUCustomDatePicker.m
//  OCProject
//
//  Created by Pan on 2020/6/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUCustomDatePicker.h"

@interface UUCustomDatePicker () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    BOOL _lineStroked;      // 是否修改了分割线颜色
    NSInteger _yearColumn;  // 年所在列
    NSInteger _monthColumn; // 月所在列
    NSInteger _dayColumn;   // 日所在列
    NSInteger _totalColumn; // 总的列数
    
    NSDateComponents *_minimumComponents; // 最小日期部件
    NSDateComponents *_maximumComponents; // 最大日期部件
    NSDateComponents *_currentComponents; // 当前日期部件
    
    UILabel *_titleLabel;      // 标题标签
    UIPickerView *_pickerView; // 选择器视图
    UIView *_upLine;           // 第一条分割线
    UIView *_downLine;         // 第二条分割线
}
@end

@implementation UUCustomDatePicker

// 展示日期选择视图
+ (void)showDatePickerWithType:(UUCustomDatePickerType)type completion:(DatePickerBlock)block {
    [self showPickerWithType:type minDate:nil maxDate:nil includeTotal:NO completion:block];
}

// 展示日期选择视图
+ (void)showPickerWithType:(UUCustomDatePickerType)type
                   minDate:(NSDate *)minDate
                   maxDate:(NSDate *)maxDate
              includeTotal:(BOOL)includeTotal
                completion:(DatePickerBlock)block {
    CGRect frame = [UIScreen mainScreen].bounds;
    UUCustomDatePicker *picker = [[UUCustomDatePicker alloc] initWithFrame:frame];
    picker.pickerType = type;
    picker.minimumDate = minDate;
    picker.maximumDate = maxDate;
    picker.includeTotal = includeTotal;
    picker.block = block;
    picker.animationType = UUAnimationPopFromBottom;
    [[UIApplication sharedApplication].keyWindow addSubview:picker];
    [picker popViewAnimated];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [COLOR_HEX(0x030303) colorWithAlphaComponent:0.5];
        [self commonInitialize];
        [self generateSubviews];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"== %@", [self class]);
}

#pragma mark - Initialization

// 初始化变量
- (void)commonInitialize {
    _lineStroked = NO;
    _pickerType = UUCustomDatePickerYear | UUCustomDatePickerMonth | UUCustomDatePickerDay;
    _yearColumn = 0;
    _monthColumn = 1;
    _dayColumn = 2;
    _totalColumn = 3;
    _includeTotal = NO;
    [self updateComponents];
}

// 更新日期部件
- (void)updateComponents {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];
    NSInteger interval = 10;
    
    NSDate *minDate, *maxDate, *curDate = [NSDate date];
    if (_minimumDate) {
        minDate = _minimumDate;
        if ([curDate earlierDate:minDate]) curDate = minDate;
    } else {
        minDate = [calendar dateByAddingUnit:NSCalendarUnitYear value:-interval
                                      toDate:curDate options:NSCalendarWrapComponents];
    }
    
    if (_maximumDate) {
        maxDate = _maximumDate;
        if ([curDate laterDate:maxDate]) curDate = maxDate;
    } else {
        maxDate = [calendar dateByAddingUnit:NSCalendarUnitYear value:interval
                                      toDate:curDate options:NSCalendarWrapComponents];
    }
    
    if (_minimumDate && _maximumDate && [_minimumDate laterDate:_maximumDate]) {
        minDate = [calendar dateByAddingUnit:NSCalendarUnitYear value:-interval
                                      toDate:curDate options:NSCalendarWrapComponents];
        if ([minDate laterDate:_maximumDate]) {
            maxDate = [calendar dateByAddingUnit:NSCalendarUnitYear value:interval
                                          toDate:curDate options:NSCalendarWrapComponents];
        }
    }
    _currentComponents = [calendar componentsInTimeZone:timeZone fromDate:curDate];
    _minimumComponents = [calendar componentsInTimeZone:timeZone fromDate:minDate];
    _maximumComponents = [calendar componentsInTimeZone:timeZone fromDate:maxDate];
    
    [self reloadPickerViewComponents];
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    // 背景框视图
    CGFloat bezelH = FIT_HEIGHT(280);
    CGRect frame = CGRectMake(0, height - bezelH - BOTTOM_SAFE_AREA, width, bezelH + BOTTOM_SAFE_AREA);
    self.bezelView = [[UIView alloc] initWithFrame:frame];
    self.bezelView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bezelView];
    
    // 背景框蒙版
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bezelView.bounds
                                                     byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                           cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = self.bezelView.bounds;
    shapeLayer.path = bezierPath.CGPath;
    self.bezelView.layer.mask = shapeLayer;
    
    // 取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(5, 10, 53, 42);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bezelView addSubview:cancelButton];
    
    // 标题标签
    frame = CGRectMake((width - 200) / 2, 10, 200, 42);
    _titleLabel = [[UILabel alloc] initWithFrame:frame];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = UIColor.lightGrayColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"时间筛选";
    [self.bezelView addSubview:_titleLabel];
    
    // 确定按钮
    UIButton *determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    determineButton.frame = CGRectMake(width - 58, 10, 53, 42);
    determineButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [determineButton setTitle:@"确定" forState:UIControlStateNormal];
    [determineButton setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [determineButton addTarget:self action:@selector(determineButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bezelView addSubview:determineButton];
        
    // 选择器视图
    frame = CGRectMake(0, 52, width, self.bezelView.bounds.size.height - 52 - BOTTOM_SAFE_AREA);
    _pickerView = [[UIPickerView alloc] initWithFrame:frame];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [self.bezelView addSubview:_pickerView];
    
    // 第一条分割线
    _upLine = [[UIView alloc] init];
    _upLine.backgroundColor = COLOR_HEX(0xE5E9EF);
    [self.bezelView addSubview:_upLine];
    
    // 第二条分割线
    _downLine = [[UIView alloc] init];
    _downLine.backgroundColor = COLOR_HEX(0xE5E9EF);
    [self.bezelView addSubview:_downLine];
}

#pragma mark - Respond

// 点击空白区域
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.bezelView.frame, point)) return;
    [self hideViewAnimated];
}

// 点击取消按钮
- (void)cancelButtonClicked {
    [self hideViewAnimated];
}

// 点击确定按钮
- (void)determineButtonClicked {
    if (self.block) self.block(_currentComponents.year, _currentComponents.month, _currentComponents.day);
    [self hideViewAnimated];
}

#pragma mark - Setter

// 日期类型
- (void)setPickerType:(UUCustomDatePickerType)pickerType {
    _pickerType = pickerType;
    _totalColumn = 0;
    if (_pickerType & UUCustomDatePickerYear) {
        _yearColumn = _totalColumn;
        _totalColumn ++;
    }
    if (_pickerType & UUCustomDatePickerMonth) {
        _monthColumn = _totalColumn;
        _totalColumn ++;
    }
    if (_pickerType & UUCustomDatePickerDay) {
        _dayColumn = _totalColumn;
        _totalColumn ++;
    }
    [self reloadPickerViewComponents];
}

// 最小日期
- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    [self updateComponents];
}

// 最大日期
- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    [self updateComponents];
}

// 含有全部
- (void)setIncludeTotal:(BOOL)includeTotal {
    _includeTotal = includeTotal;
    [self reloadPickerViewComponents];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _totalColumn;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_pickerType & UUCustomDatePickerYear) {
        if (component == _yearColumn) return _maximumComponents.year - _minimumComponents.year + 1;
    }
    if (_pickerType & UUCustomDatePickerMonth) {
        if (component == _monthColumn) return _includeTotal ? 13 : 12;
    }
    if (_pickerType & UUCustomDatePickerDay) {
        if (component == _dayColumn) {
            NSInteger number = [self dayCountWithComponents:_currentComponents];
            return _includeTotal ? number + 1 : number;
        }
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.bounds.size.width / _totalColumn;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (!_lineStroked) {
        _lineStroked = YES;
        UIView *firstLine = [pickerView.subviews objectAtIndex:1];
        UIView *secondLine = [pickerView.subviews objectAtIndex:2];
        firstLine.backgroundColor = UIColor.whiteColor;
        secondLine.backgroundColor = UIColor.whiteColor;

        CGRect upFrame = CGRectInset(firstLine.frame, 15, 0);
        CGRect downFrame = CGRectInset(secondLine.frame, 15, 0);
        upFrame.origin.y += 52;
        downFrame.origin.y += 52;
        _upLine.frame = upFrame;
        _downLine.frame = downFrame;
    }

    CGSize size = [pickerView rowSizeForComponent:component];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.textColor = UIColor.blackColor;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (_pickerType & UUCustomDatePickerYear) {
        if (component == _yearColumn) {
            titleLabel.text = [NSString stringWithFormat:@"%zd年", _minimumComponents.year + row];
        }
    }
    if (_pickerType & UUCustomDatePickerMonth) {
        if (component == _monthColumn) {
            if (_includeTotal) {
                titleLabel.text = row == 0?  @"全部" : [NSString stringWithFormat:@"%02zd月", row];
            } else {
                titleLabel.text = [NSString stringWithFormat:@"%02zd月", (row + 1)];
            }
        }
    }
    if (_pickerType & UUCustomDatePickerDay) {
        if (component == _dayColumn) {
            if (_includeTotal) {
                titleLabel.text = row == 0?  @"全部" : [NSString stringWithFormat:@"%02zd日", row];
            } else {
                titleLabel.text = [NSString stringWithFormat:@"%02zd日", (row + 1)];
            }
        }
    }
    return titleLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_pickerType & UUCustomDatePickerYear) {
        if (component == _yearColumn) {
            _currentComponents.year = _minimumComponents.year + row;
            [self resetMonth];
            [self resetDay];
            [self limitedMonth];
            [self limitedDay];
        }
    }
    if (_pickerType & UUCustomDatePickerMonth) {
        if (component == _monthColumn) {
            _currentComponents.month = _includeTotal ? row : row + 1;
            [self resetDay];
            [self limitedMonth];
            [self limitedDay];
        }
    }
    if (_pickerType & UUCustomDatePickerDay) {
        if (component == _dayColumn) {
            _currentComponents.day = _includeTotal ? row : row + 1;
            [self limitedDay];
        }
    }
}

#pragma mark - Utility

// 重新加载picker视图
- (void)reloadPickerViewComponents {
    [_pickerView reloadAllComponents];
    if (_pickerType & UUCustomDatePickerYear) {
        NSInteger year = _currentComponents.year - _minimumComponents.year;
        [_pickerView selectRow:year inComponent:_yearColumn animated:NO];
    }
    if (_pickerType & UUCustomDatePickerMonth) {
        NSInteger row = _currentComponents.month - (_includeTotal ? 0 : 1);
        [_pickerView selectRow:row inComponent:_monthColumn animated:NO];
    }
    if (_pickerType & UUCustomDatePickerDay) {
        NSInteger row = _currentComponents.day - (_includeTotal ? 0 : 1);
        [_pickerView selectRow:row inComponent:_dayColumn animated:NO];
    }
}

// 根据选择的年月计算当月天数
- (NSInteger)dayCountWithComponents:(NSDateComponents *)components {
    switch (components.month) {
        case 2:
            return [self checkLeapYear:components.year] ? 29 : 28;
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 4: case 6: case 9: case 11:
            return 30;
        default:
            return 0;
    }
}

// 检查是否是闰年
- (BOOL)checkLeapYear:(NSInteger)year {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}

// 重置月份到一月
- (void)resetMonth {
    if (!(_pickerType & UUCustomDatePickerMonth)) return;
    _currentComponents.month = _includeTotal ? 0 : 1;
    [_pickerView reloadComponent:_monthColumn];
    [_pickerView selectRow:0 inComponent:_monthColumn animated:NO];
}

// 重置日期到一号
- (void)resetDay {
    if (!(_pickerType & UUCustomDatePickerDay)) return;
    _currentComponents.day = _includeTotal ? 0 : 1;
    [_pickerView reloadComponent:_dayColumn];
    [_pickerView selectRow:0 inComponent:_dayColumn animated:NO];
}

// 限定月份
- (void)limitedMonth {
    if (!(_pickerType & UUCustomDatePickerMonth)) return;
    if (_currentComponents.year == _minimumComponents.year
        && _currentComponents.month <= _minimumComponents.month) {
        _currentComponents.month = _minimumComponents.month;
        NSInteger row = _currentComponents.month - (_includeTotal ? 0 : 1);
        [_pickerView reloadComponent:_monthColumn];
        [_pickerView selectRow:row inComponent:_monthColumn animated:YES];
    }
    if (_currentComponents.year == _maximumComponents.year
        && _currentComponents.month >= _maximumComponents.month) {
        _currentComponents.month = _maximumComponents.month;
        NSInteger row = _currentComponents.month - (_includeTotal ? 0 : 1);
        [_pickerView reloadComponent:_monthColumn];
        [_pickerView selectRow:row inComponent:_monthColumn animated:YES];
    }
}

// 限定日期
- (void)limitedDay{
    if (!(_pickerType & UUCustomDatePickerDay)) return;
    if (_currentComponents.year == _minimumComponents.year
        && _currentComponents.month == _minimumComponents.month
        && _currentComponents.day <= _minimumComponents.day) {
        _currentComponents.day = _minimumComponents.day;
        NSInteger row = _currentComponents.day - (_includeTotal ? 0 : 1);
        [_pickerView reloadComponent:_dayColumn];
        [_pickerView selectRow:row inComponent:_dayColumn animated:YES];
        
    }
    if (_currentComponents.year == _maximumComponents.year
        && _currentComponents.month == _maximumComponents.month
        && _currentComponents.day >= _maximumComponents.day) {
        _currentComponents.day = _maximumComponents.day;
        NSInteger row = _currentComponents.day - (_includeTotal ? 0 : 1);
        [_pickerView reloadComponent:_dayColumn];
        [_pickerView selectRow:row inComponent:_dayColumn animated:YES];
        
    }
}

@end
