//
//  UUNativeDatePicker.m
//  OCProject
//
//  Created by Pan on 2020/6/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUNativeDatePicker.h"

@interface UUNativeDatePicker ()
{
    CGRect _frame;     // 整个Picker视图的frame
    BOOL _isAnimated;  // 是否动画
}
@property (nonatomic, strong) UIView *contentView;       // 内容视图
@end

@implementation UUNativeDatePicker

// 不限期限
+ (void)showPickerWithTitle:(NSString *)title completion:(void (^)(NSDate *))completion {
    [self showPickerWithTitle:title minDate:nil maxDate:nil completion:completion];
}

// 从现在开始
+ (void)showPickerBeginNowWithTitle:(NSString *)title completion:(void (^)(NSDate *))completion {
    [self showPickerWithTitle:title minDate:[NSDate date] maxDate:nil completion:completion];
}

// 截止到现在
+ (void)showPickerUntilNowWithTitle:(NSString *)title completion:(void (^)(NSDate *))completion {
    [self showPickerWithTitle:title minDate:nil maxDate:[NSDate date] completion:completion];
}

// 过去一年
+ (void)showPickerForLastYearWithTitle:(NSString *)title completion:(void (^)(NSDate *))completion {
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-365*24*60*60];
    NSDate *endDate = [NSDate date];
    [self showPickerWithTitle:title minDate:startDate maxDate:endDate completion:completion];
}

// 根据标题、起始时间、终止时间和回调设置时间选择器
+ (void)showPickerWithTitle:(NSString *)title
                    minDate:(NSDate *)minDate
                    maxDate:(NSDate *)maxDate
                 completion:(void (^)(NSDate *))completion {
 
    UIView *currentView = [UIApplication sharedApplication].keyWindow;
    [currentView endEditing:YES];
    
    UUNativeDatePicker *picker = [[UUNativeDatePicker alloc] initWithFrame:currentView.bounds];
    picker.titleLabel.text = title;
    picker.selectionBlock = completion;
    
    if (minDate && maxDate && ([minDate compare:maxDate] != NSOrderedAscending)) {
        minDate = nil;
        maxDate = nil;
    }
    picker.datePicker.minimumDate = minDate;
    picker.datePicker.maximumDate = maxDate;
    [currentView addSubview:picker];
    [picker showAnimated:YES];
}


#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

// 初始化
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
    
    // 时间选择器
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.frame = CGRectMake(0, height*0.15, width, height*0.7);
    datePicker.datePickerMode = UIDatePickerModeDate;
    [contentView addSubview:datePicker];
    self.datePicker = datePicker;
    
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

// 点触视图空白区域
- (void)tapCommonPickerView {
    [self hideAnimated:_isAnimated];
}

// 点击取消按钮
- (void)clickCancelButton {
    [self hideAnimated:_isAnimated];
}

// 点击确定按钮
- (void)clickDetermineButton {
    if (self.selectionBlock) self.selectionBlock(self.datePicker.date);
    [self hideAnimated:_isAnimated];
}

@end
