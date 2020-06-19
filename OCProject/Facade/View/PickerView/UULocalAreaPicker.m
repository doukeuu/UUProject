//
//  UULocalAreaPicker.m
//  OCProject
//
//  Created by Pan on 2020/6/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UULocalAreaPicker.h"

@interface UULocalAreaPicker () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    CGRect _frame;        // 整个Picker视图的frame
    BOOL _isAnimated;     // 是否动画
    UULocalAreaPickerType _type; // 内容类型
}
@property (nonatomic, strong) UIView *contentView;      // 内容视图
@property (nonatomic, strong) UILabel * titleLabel;     // 标题
@property (nonatomic, strong) UIPickerView *pickerView; // PickerView

@property (nonatomic, strong) NSArray *provinceArray;   // 省份数组
@property (nonatomic, strong) NSArray *cityArray;       // 城市数组
@property (nonatomic, strong) NSArray *districtArray;   // 辖区数组

@property (nonatomic, copy) PickerViewCompletion selectionBlock; // 选择下标回调
@end

@implementation UULocalAreaPicker

+ (void)showAreaPickerWithTitle:(NSString *)title areaType:(UULocalAreaPickerType)type completion:(PickerViewCompletion)completion {
    UIView *currentView = [UIApplication sharedApplication].keyWindow;
    [currentView endEditing:YES];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    UULocalAreaPicker *picker = [[UULocalAreaPicker alloc] initWithFrame:currentView.bounds];
    picker->_type = type;
    picker.titleLabel.text = title;
    picker.selectionBlock = completion;
    
    picker.provinceArray = array;
    [picker reloadArrayForRow:0 arrayType:1];
    if (type == UULocalAreaPickerProvinceCityDistrict) {
        [picker reloadArrayForRow:0 arrayType:2];
    }
    [currentView addSubview:picker];
    [picker.pickerView reloadAllComponents];
    [picker showAnimated:YES];
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"== %@", [self class]);
}

// 初始化方法
- (void)commonInit {
    _frame = CGRectMake(20, SCREEN_HEIGHT/2-SCREEN_WIDTH/2+40, SCREEN_WIDTH-40, SCREEN_WIDTH-80);
    self.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.2f];
    self.alpha = 0.0f;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommonPickerView)]];
    [self createSubviews];
}

#pragma mark - Create Subview

// 创建子视图
- (void)createSubviews {
    // 内容框视图
    UIView *contentView = [[UIView alloc] initWithFrame:_frame];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.clipsToBounds = YES;
    contentView.alpha = 0.0f;
    contentView.layer.cornerRadius = 5.0f;
    [self addSubview:contentView];
    self.contentView = contentView;
    
    CGFloat width = _frame.size.width;
    CGFloat height = _frame.size.height;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, width, height * 0.15);
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
    [contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    // Picker
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.frame = CGRectMake(0, height*0.15, width, height*0.7);
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [contentView addSubview:pickerView];
    self.pickerView = pickerView;
    
    // 取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, height*(1-0.15), width/2, height*0.15);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelButton];
    
    // 确定按钮
    UIButton *determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    determineButton.frame = CGRectMake(width/2, height*(1-0.15), width/2, height*0.15);
    determineButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [determineButton setTitle:@"确定" forState:UIControlStateNormal];
    [determineButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [determineButton addTarget:self action:@selector(clickDetermineButton) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:determineButton];
    
    // 底部横线
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, height*(1-0.15), width, 1)];
    bottomLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [contentView addSubview:bottomLine];
    
    // 底部竖线
    UIView *verticalLine = [[UIView alloc] init];
    verticalLine.frame = CGRectMake(width/2, height*(1-0.15) + 8.0f, 1, height*0.15 - 16.0f);
    verticalLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [contentView addSubview:verticalLine];
}

#pragma mark - Show & Hide

// 显示
- (void)showAnimated:(BOOL)animated {
    _isAnimated = animated;
    NSTimeInterval time = animated ? 0.3 : 0;
    [UIView animateWithDuration:time animations:^{
        self.contentView.alpha = 1.0f;
        self.alpha = 1.0f;
    }];
}

// 隐藏
- (void)hideAnimated:(BOOL)animated {
    _isAnimated = animated;
    NSTimeInterval time = animated ? 0.3 : 0;
    [UIView animateWithDuration:time animations:^{
        self.contentView.alpha = 0.f;
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Response Method

//  点触视图空白区域
- (void)tapCommonPickerView {
    [self hideAnimated:_isAnimated];
}

// 点击取消按钮
- (void)clickCancelButton {
    [self hideAnimated:_isAnimated];
}

//  点击确定按钮
- (void)clickDetermineButton {
    NSString *province = [self selectedTitleForComponent:0];
    NSString *city = [self selectedTitleForComponent:1];
    NSString *district = nil;
    if (_type == UULocalAreaPickerProvinceCityDistrict) {
        district = [self selectedTitleForComponent:2];
    }
    if (self.selectionBlock) self.selectionBlock(province, city, district);
    [self hideAnimated:_isAnimated];
}

// 获取选择的内容
- (NSString *)selectedTitleForComponent:(NSInteger)component {
    NSInteger row = [self.pickerView selectedRowInComponent:component];
    if (row == -1) row = 0;
    return [self titleForRow:row arrayType:component];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _type == UULocalAreaPickerProvinceCityDistrict ? 3 : 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.districtArray.count;
    }
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self titleForRow:row arrayType:component];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [self reloadArrayForRow:row arrayType:component + 1];
        [pickerView selectRow:0 inComponent:component + 1 animated:YES];
        [pickerView reloadComponent:component + 1];
    }
    
    if (_type == UULocalAreaPickerProvinceCityDistrict) {
        if (component == 0) {
            [self reloadArrayForRow:0 arrayType:component + 2];
            [pickerView selectRow:0 inComponent:component + 2 animated:YES];
            [pickerView reloadComponent:component + 2];
        } else if (component == 1) {
            [self reloadArrayForRow:row arrayType:component + 1];
            [pickerView selectRow:0 inComponent:component + 1 animated:YES];
            [pickerView reloadComponent:component + 1];
        }
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    [pickerView.subviews objectAtIndex:1].backgroundColor = [UIColor greenColor];
    [pickerView.subviews objectAtIndex:2].backgroundColor = [UIColor greenColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width- 5, [pickerView rowSizeForComponent:component].height);
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (_type == UULocalAreaPickerProvinceCityDistrict) {
        if (component == 0) {
            return _frame.size.width * 2 / 8;
        } else if (component == 1) {
            return _frame.size.width * 3 / 8;
        } else {
            return _frame.size.width * 3 / 8 - 10;
        }
    }
    return _frame.size.width / 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return _frame.size.height * 0.15;
}

#pragma mark - Utility

// 获取展示区所在行的标题，type = 0 省份，1 城市，2 辖区
- (NSString *)titleForRow:(NSInteger)row arrayType:(NSInteger)type {
    if (type == 0) {
        if (self.provinceArray.count <= row) return nil;
        return [self.provinceArray[row] objectForKey:@"state"];
    } else if (type == 1) {
        if (self.cityArray.count <= row) return nil;
        return [self.cityArray[row] objectForKey:@"city"];
    } else {
        if (self.districtArray.count <= row) return nil;
        return self.districtArray[row];
    }
}

// 更新信息数组，type = 0 省份，1 城市，2 辖区
- (void)reloadArrayForRow:(NSInteger)row arrayType:(NSInteger)type {
    if (type == 1) {
        if (self.provinceArray.count <= row) self.cityArray = nil;
        self.cityArray = [self.provinceArray[row] objectForKey:@"cities"];
    } else if (type == 2) {
        if (self.cityArray.count <= row) self.districtArray = nil;
        self.districtArray = [self.cityArray[row] objectForKey:@"areas"];
    }
}

@end
