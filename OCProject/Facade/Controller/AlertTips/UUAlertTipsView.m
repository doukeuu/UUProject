//
//  UUAlertTipsView.m
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUAlertTipsView.h"
#import "UIView+UU.h"

@interface UUAlertTipsView ()
{
    UIView *_bezelView;     // 背景视图
    NSInteger _buttonCount; // 按钮数量，最多两个，最少0个
}
@property (nonatomic, strong) UILabel *titleLabel;   // 标题标签
@property (nonatomic, strong) UILabel *messageLabel; // 消息标签

@property (nonatomic, copy) void(^firstHandler)(void);  // 第一个按钮点击回调
@property (nonatomic, copy) void(^secondHandler)(void); // 第二个按钮点击回调
@end

@implementation UUAlertTipsView

#pragma mark - Public

// 根据标题和消息声明类
+ (instancetype)customizedWithTitle:(NSString *)title message:(NSString *)message {
    UUAlertTipsView *alert = [[UUAlertTipsView alloc] init];
    if (title) alert.titleLabel.text = title;
    if (message) alert.messageLabel.text = message;
    return alert;
}

// 根据富文本标题和消息声明类
+ (instancetype)customizedWithAttributedTitle:(nullable NSAttributedString *)title message:(nullable NSAttributedString *)message {
    UUAlertTipsView *alert = [[UUAlertTipsView alloc] init];
    if (title) alert.titleLabel.attributedText = title;
    if (message) alert.messageLabel.attributedText = message;
    return alert;
}

// 根据标题和类型添加响应按钮
- (void)addActionWithTitle:(NSString *)title type:(UUAlertTipsButtonType)type handler:(void (^)(void))handler {
    if (_buttonCount >= 2) return;
    _buttonCount ++;
    [self generalButtonWithTitle:title type:type tag:_buttonCount];
    if (_buttonCount == 1) {
        self.firstHandler = handler;
    } else {
        self.secondHandler = handler;
    }
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

- (void)setIsLeftText:(BOOL)isLeftText{
    if (isLeftText) {
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
    }
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 背景视图
    _bezelView = [[UIView alloc] init];
    _bezelView.backgroundColor = [UIColor whiteColor];
    _bezelView.layer.cornerRadius = 5.f;
    _bezelView.layer.masksToBounds = YES;
    [self addSubview:_bezelView];
    // 添加点触手势
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAlert:)];
//    [self addGestureRecognizer:tap];
}

// 标题标签
- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _titleLabel.textColor = UIColor.blackColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [_bezelView addSubview:_titleLabel];
    return _titleLabel;
}

// 消息标签
- (UILabel *)messageLabel {
    if (_messageLabel) return _messageLabel;
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.font = [UIFont systemFontOfSize:14];
    _messageLabel.textColor = UIColor.blackColor;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.numberOfLines = 0;
    [_bezelView addSubview:_messageLabel];
    return _messageLabel;
}

// 生成操作按钮
- (UIButton *)generalButtonWithTitle:(NSString *)title type:(UUAlertTipsButtonType)type tag:(NSInteger)tag {
    UIColor *backColor = type == UUAlertTipsButtonWhite ? [UIColor whiteColor] : UIColor.blueColor;
    UIColor *titleColor = type == UUAlertTipsButtonWhite ? UIColor.blueColor : [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = backColor;
    button.layer.cornerRadius = 4.f;
    button.layer.borderColor = UIColor.blueColor.CGColor;
    button.layer.borderWidth = 1.f;
    button.tag = tag;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bezelView addSubview:button];
    return button;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat bezelWidth = [UIScreen mainScreen].bounds.size.width - 42 * 2;
    if (_titleLabel) {
        CGFloat height = [self textHeightWithLabel:_titleLabel width:bezelWidth - 30];
        _titleLabel.frame = CGRectMake(15, 20, bezelWidth - 30, height);
    }
    if (_messageLabel) {
        CGFloat y = _titleLabel ? CGRectGetMaxY(_titleLabel.frame) + 20 : 20;
        CGFloat height = [self textHeightWithLabel:_messageLabel width:bezelWidth - 30];
        _messageLabel.frame = CGRectMake(15, y, bezelWidth - 30, height);
    }
    if (_titleLabel && !_messageLabel && _buttonCount > 0) {
        _titleLabel.top = 45;
    } else if (!_titleLabel && _messageLabel && _buttonCount > 0) {
        _messageLabel.top = 45;
    }
    for (UIView *subview in _bezelView.subviews) {
        if (![subview isKindOfClass:[UIButton class]]) continue;
        CGFloat x = 30;
        CGFloat y = 20;
        CGFloat width = bezelWidth - 30 * 2;
        if (_buttonCount == 2 && subview.tag == 2) {
            x = (bezelWidth + 30) / 2;
        }
        if (_messageLabel) {
            y += CGRectGetMaxY(_messageLabel.frame) + 10;
        } else if (_titleLabel) {
            y += CGRectGetMaxY(_titleLabel.frame) + 10;
        }
        if (_buttonCount == 2) {
            width = (bezelWidth - 30 * 3) / 2;
        }
        subview.frame = CGRectMake(x, y, width, 37);
    }
    UIView *subview = [_bezelView.subviews lastObject];
    _bezelView.frame = CGRectMake(0, 0, bezelWidth, CGRectGetMaxY(subview.frame) + 20);
    _bezelView.center = self.center;
}

// 计算文本高度
- (CGFloat)textHeightWithLabel:(UILabel *)label width:(CGFloat)width {
    NSString *text = label.text;
    CGFloat height = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:label.font}
                                        context:nil].size.height;
    return height > 20 ? height : 20;
}

#pragma mark - Action

// 点击按钮
- (void)actionButtonClick:(UIButton *)button {
    if (button.tag == 1) {
        if (self.firstHandler) self.firstHandler();
    } else {
        if (self.secondHandler) self.secondHandler();
    }
    [self hideAlertView];
}

// 点触背景
//- (void)tapAlert:(UIGestureRecognizer *)gesture {
//    CGPoint point = [gesture locationInView:self];
//    if (CGRectContainsPoint(_bezelView.frame, point)) return;
//    [self hideAlertView];
//}

#pragma mark - Popup & Hide

// 弹出视图
- (void)popupAlertView {
    if (self.superview) return;
    self.frame = [UIScreen mainScreen].bounds;self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}

// 在一定时间间隔内弹出并隐藏视图
- (void)popupAlertViewWithDuration:(NSTimeInterval)interval {
    if (self.superview) return;
    self.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideAlertView) withObject:nil afterDelay:interval];
    }];
}

// 隐藏视图
- (void)hideAlertView {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
