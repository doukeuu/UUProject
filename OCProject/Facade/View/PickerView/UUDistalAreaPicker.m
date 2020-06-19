//
//  UUDistalAreaPicker.m
//  OCProject
//
//  Created by Pan on 2020/6/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUDistalAreaPicker.h"

@interface UUDistalAreaPicker () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    BOOL _isIncludeAll;       // 是否包含全部选项
    CGRect _frame;            // 整个Picker视图的frame
    NSArray *_cityArray;      // 城市数组
    NSArray *_districtArray;  // 辖区数组
    UIView *_bezelView;       // 背景框视图
}
@property (nonatomic, strong) NSArray *provinceArray;   // 省份数组
@property (nonatomic, strong) UIPickerView *pickerView; // 选择器视图
@end

@implementation UUDistalAreaPicker

- (instancetype)initWithIncludeAll:(BOOL)includeAll {
    if (self = [super init]) {
        _isIncludeAll = includeAll;
        [self commonInitilize];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInitilize];
    }
    return self;
}

- (void)commonInitilize {
    UIColor *backColor = COLOR_HEX(0x030303);
    self.backgroundColor = [backColor colorWithAlphaComponent:0.5];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat height = FIT_HEIGHT(280);
    _frame = CGRectMake(0, frame.size.height - height - BOTTOM_SAFE_AREA, frame.size.width, height + BOTTOM_SAFE_AREA);
    [self generateSubviews];
    [self configDataArray];
}

// 初始化数据
- (void)configDataArray {
    NSString *path = [UUDistalAreaPicker documentPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        _provinceArray = [NSArray arrayWithContentsOfFile:path];
        [self reloadArrayForRow:0 arrayType:1];
        [self reloadArrayForRow:0 arrayType:2];
        [_pickerView reloadAllComponents];
    } else {
//        [ProgressHUD showHUDInView:self];
//        __weak typeof(self) weakSelf = self;
//        [NetworkManager get:@"area" suffix:nil params:nil success:^(id  _Nullable result) {
//            [ProgressHUD hideHUDInView:weakSelf];
//            if (!result || ![result isKindOfClass:[NSArray class]]) return ;
//            weakSelf.provinceArray = [AreaPickerView parseTotalAddressInfo:result];
//            [weakSelf reloadArrayForRow:0 arrayType:1];
//            [weakSelf reloadArrayForRow:0 arrayType:2];
//            [weakSelf.pickerView reloadAllComponents];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                [weakSelf.provinceArray writeToFile:path atomically:YES];
//            });
//        } failure:^(NSError * _Nonnull error) {
//            [ProgressHUD hideHUDInView:weakSelf];
//            [ProgressHUD showText:@"获取地址失败"];
//        }];
    }
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 背景框视图
    _bezelView = [[UIView alloc] initWithFrame:_frame];
    _bezelView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bezelView];
    
    CGFloat width = _frame.size.width;
    CGFloat height = _frame.size.height;
    // 取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 80, 40);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bezelView addSubview:cancelButton];
    // 标题标签
    CGRect frame = CGRectMake((width - 80) / 2, 0, 80, 40);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = UIColor.lightGrayColor;
    titleLabel.text = @"选择省市区";
    [_bezelView addSubview:titleLabel];
    // 确定按钮
    UIButton *determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    determineButton.frame = CGRectMake(width - 80, 0, 80, 40);
    determineButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [determineButton setTitle:@"确定" forState:UIControlStateNormal];
    [determineButton setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [determineButton addTarget:self action:@selector(determineButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bezelView addSubview:determineButton];
    // 分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, width, 1)];
    lineView.backgroundColor = UIColor.lightGrayColor;
    [_bezelView addSubview:lineView];
    // 选择器视图
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.frame = CGRectMake(0, 30, width, height - 30 - BOTTOM_SAFE_AREA);
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_bezelView addSubview:_pickerView];
    // 添加手势
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlankGesture)]];
}

#pragma mark - Show & Hide

// 展示选择器
- (void)showPickerView {
    if (self.superview) return;
    self.alpha = 0.0;
    self.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _bezelView.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        self->_bezelView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

// 隐藏选择器
- (void)hidePickerView {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
        self->_bezelView.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Respond

// 点击空白区域
- (void)tapBlankGesture {
    [self hidePickerView];
}

// 点击取消按钮
- (void)cancelButtonClicked {
    [self hidePickerView];
}

// 点击确定按钮
- (void)determineButtonClicked {
    NSString *province = [self selectedTitleForComponent:0];
    NSString *city = [self selectedTitleForComponent:1];
    NSString *district = [self selectedTitleForComponent:2];
    if (province || city || district) {
        if (self.areaSelectedBlock) self.areaSelectedBlock(province, city, district);
    }
    [self hidePickerView];
}

// 获取选择的内容
- (NSString *)selectedTitleForComponent:(NSInteger)component {
    NSInteger row = [_pickerView selectedRowInComponent:component];
    if (row == -1) row = 0;
    return [self titleForRow:row arrayType:component];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _provinceArray.count;
    } else if (component == 1) {
        return _cityArray.count;
    } else {
        return _districtArray.count;
    }
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    [pickerView.subviews objectAtIndex:1].backgroundColor = UIColor.grayColor;
    [pickerView.subviews objectAtIndex:2].backgroundColor = UIColor.grayColor;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    label.textColor = UIColor.blackColor;
    label.textAlignment = NSTextAlignmentCenter;
    CGFloat width = [pickerView rowSizeForComponent:component].width- 5;
    CGFloat height = [pickerView rowSizeForComponent:component].height;
    label.frame = CGRectMake(0, 0, width, height);
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self titleForRow:row arrayType:component];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [self reloadArrayForRow:row arrayType:component + 1];
        [pickerView selectRow:0 inComponent:component + 1 animated:NO];
        [pickerView reloadComponent:component + 1];
        
        [self reloadArrayForRow:0 arrayType:component + 2];
        [pickerView selectRow:0 inComponent:component + 2 animated:NO];
        [pickerView reloadComponent:component + 2];
    } else if (component == 1) {
        [self reloadArrayForRow:row arrayType:component + 1];
        [pickerView selectRow:0 inComponent:component + 1 animated:NO];
        [pickerView reloadComponent:component + 1];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return _frame.size.width * 2 / 8;
    } else if (component == 1) {
        return _frame.size.width * 3 / 8;
    } else {
        return _frame.size.width * 3 / 8 - 10;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

#pragma mark - Utility

// 获取展示区所在行的标题，type = 0 省份，1 城市，2 辖区
- (NSString *)titleForRow:(NSInteger)row arrayType:(NSInteger)type {
    if (type == 0) {
        if (_provinceArray.count <= row) return nil;
        return [_provinceArray[row] objectForKey:@"name"];
    } else if (type == 1) {
        if (_cityArray.count <= row) return nil;
        return [_cityArray[row] objectForKey:@"name"];
    } else {
        if (_districtArray.count <= row) return nil;
        return [_districtArray[row] objectForKey:@"name"];
    }
}

// 更新信息数组，type = 0 省份，1 城市，2 辖区
- (void)reloadArrayForRow:(NSInteger)row arrayType:(NSInteger)type {
    if (type == 1) {
        if (_provinceArray.count <= row) {
            _cityArray = nil;
            return;
        }
        if (_isIncludeAll) {
            NSMutableArray *tmpCities = [[_provinceArray[row] objectForKey:@"cities"] mutableCopy];
            [tmpCities insertObject:@{@"name": @"全部"} atIndex:0];
            _cityArray = [tmpCities copy];
        } else {
            _cityArray = [_provinceArray[row] objectForKey:@"cities"];
        }
    } else if (type == 2) {
        if (_cityArray.count <= row) {
            _districtArray = nil;
            return;
        }
        if (_isIncludeAll) {
            if (row == 0) {
                _districtArray = nil;
            } else {
                NSMutableArray *tmpAreas = [[_cityArray[row] objectForKey:@"areas"] mutableCopy];
                [tmpAreas insertObject:@{@"name": @"全部"} atIndex:0];
                _districtArray = [tmpAreas copy];
            }
        } else {
            _districtArray = [_cityArray[row] objectForKey:@"areas"];
        }
    }
}

#pragma mark - Request & Store Address

// 获取所有地址信息
+ (void)acquireTotalAddress {
//    [NetworkManager get:@"area" suffix:nil params:nil success:^(id  _Nullable result) {
//        if (!result || ![result isKindOfClass:[NSArray class]]) return ;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSArray *totalArray = [self parseTotalAddressInfo:result];
//            [totalArray writeToFile:[self documentPath] atomically:YES];
//        });
//    } failure:nil];
}

// 解析地址数据
+ (NSArray *)parseTotalAddressInfo:(NSArray *)result {
    NSMutableArray *totalArray = [NSMutableArray array];
    // 添加省份到数组
    for (NSDictionary *dic in result) {
        if ([dic[@"level"] integerValue] != 1) continue;
        NSMutableDictionary *provinceDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSMutableArray *cityArray = [NSMutableArray array];
        [provinceDic setObject:cityArray forKey:@"cities"];
        [totalArray addObject:provinceDic];
    }
    // 添加市到各省cities数组
    for (NSDictionary *dic in result) {
        if ([dic[@"level"] integerValue] != 2) continue;
        for (NSMutableDictionary *provinceDic in totalArray) {
            if ([dic[@"pid"] integerValue] != [provinceDic[@"id"] integerValue]) continue;
            NSMutableArray *cityArray = provinceDic[@"cities"];
            NSMutableDictionary *ciyDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSMutableArray *areaArray = [NSMutableArray array];
            [ciyDic setObject:areaArray forKey:@"areas"];
            [cityArray addObject:ciyDic];
        }
    }
    // 添加各区县到各省市中的areas数组
    for (NSDictionary *dic in result) {
        if ([dic[@"level"] integerValue] != 3) continue;
        BOOL isStored = NO;
        for (NSMutableDictionary *provinceDic in totalArray) {
            NSMutableArray *cityArray = provinceDic[@"cities"];
            for (NSDictionary *cityDic in cityArray) {
                if ([dic[@"pid"] integerValue] != [cityDic[@"id"] integerValue]) continue;
                NSMutableArray *areaArray = cityDic[@"areas"];
                [areaArray addObject:dic];
                isStored = YES;
                break;
            }
            if (isStored) break;
        }
    }
    return [totalArray copy];
}

//  document文件夹地址
+ (NSString *)documentPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [path stringByAppendingPathComponent:@"totalAddress.plist"];
}

@end
