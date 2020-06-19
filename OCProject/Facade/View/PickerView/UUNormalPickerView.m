//
//  UUNormalPickerView.m
//  OCProject
//
//  Created by Pan on 2020/6/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUNormalPickerView.h"

@interface UUNormalPickerView ()
<
    UIPickerViewDataSource,
    UIPickerViewDelegate
>
{
    UIView *_bezelView;        // 背景框视图
    UIPickerView *_pickerView; // 选择器视图
    UILabel *_titleLabel;      // 标题标签
    NSArray *_contentArray;    // 内容数组
}
@property (nonatomic, copy) void(^completionBlock)(NSInteger index, NSString *title); // 选择后回调
@end

@implementation UUNormalPickerView

+ (void)showPickerWithTitle:(NSString *)title texts:(NSArray *)texts completion:(void (^)(NSInteger, NSString * _Nonnull))block {
    if (!texts || texts.count == 0) return;
    
    UUNormalPickerView *picker = [[UUNormalPickerView alloc] init];
    picker.frame = [UIScreen mainScreen].bounds;
    picker->_titleLabel.text = title;
    picker->_contentArray = texts;
    picker.completionBlock = block;
    [[UIApplication sharedApplication].keyWindow addSubview:picker];
    [picker showPickerView];
    [picker->_pickerView reloadAllComponents];
}

- (instancetype)init {
    if (self = [super init]) {
        UIColor *backColor = COLOR_HEX(0x030303);
        self.backgroundColor = [backColor colorWithAlphaComponent:0.5];
        self.alpha = 0.0;
        [self generateSubviews];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"== %@", [self class]);
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = FIT_HEIGHT(280);
    CGRect frame = CGRectMake(0, SCREEN_HEIGHT - height - BOTTOM_SAFE_AREA, width, height + BOTTOM_SAFE_AREA);
    // 背景框视图
    _bezelView = [[UIView alloc] initWithFrame:frame];
    _bezelView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bezelView];
    
    // 取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 80, 40);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bezelView addSubview:cancelButton];
    
    // 标题标签
    frame = CGRectMake(80, 0, width - 80 - 80, 40);
    _titleLabel = [[UILabel alloc] initWithFrame:frame];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = UIColor.lightGrayColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bezelView addSubview:_titleLabel];
    
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
    
    // 选择器
    // 选择器视图
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.frame = CGRectMake(0, 30, width, height - 30 - BOTTOM_SAFE_AREA);
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_bezelView addSubview:_pickerView];
}

#pragma mark - Show & Hide

// 展示选择器
- (void)showPickerView {
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

// 点击取消按钮
- (void)cancelButtonClicked {
    [self hidePickerView];
}

// 点击确定按钮
- (void)determineButtonClicked {
    NSInteger selectedIndex = [_pickerView selectedRowInComponent:0];
    if (selectedIndex == -1) selectedIndex = 0;
    UILabel *label = (UILabel *)[_pickerView viewForRow:selectedIndex forComponent:0];
    if (self.completionBlock) self.completionBlock(selectedIndex, label.text);
    [self hidePickerView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(_bezelView.frame, point)) return;
    [self hidePickerView];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _contentArray.count;
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView *firstLine = [pickerView.subviews objectAtIndex:1];
    firstLine.backgroundColor = UIColor.grayColor;
    CGRect frame = firstLine.frame;
    frame.origin.x = 30;
    frame.size.width = pickerView.bounds.size.width - 60;
    firstLine.frame = frame;
    
    UIView *secondLine = [pickerView.subviews objectAtIndex:2];
    secondLine.backgroundColor = UIColor.grayColor;
    frame = secondLine.frame;
    frame.origin.x = 30;
    frame.size.width = pickerView.bounds.size.width - 60;
    secondLine.frame = frame;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    label.textColor = UIColor.blackColor;
    label.textAlignment = NSTextAlignmentCenter;
    CGFloat width = [pickerView rowSizeForComponent:component].width;
    CGFloat height = [pickerView rowSizeForComponent:component].height;
    label.frame = CGRectMake(0, 0, width, height);
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _contentArray[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.bounds.size.width - 60;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

@end
