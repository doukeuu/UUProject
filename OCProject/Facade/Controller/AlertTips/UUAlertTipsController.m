//
//  UUAlertTipsController.m
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUAlertTipsController.h"
#import "UIView+UU.h"

@interface UUAlertTipsController ()

@property (nonatomic, assign) NSInteger buttonCount; // 按钮数量，最多两个，最少0个
@property (nonatomic, strong) UIView *bezelView;     // 背景视图
@property (nonatomic, strong) UILabel *titleLabel;   // 标题标签
@property (nonatomic, strong) UILabel *messageLabel; // 消息标签

@property (nonatomic, copy) void(^firstHandler)(void);  // 第一个按钮点击回调
@property (nonatomic, copy) void(^secondHandler)(void); // 第二个按钮点击回调
@end

@implementation UUAlertTipsController

// 根据标题和消息声明类
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self generateSubviews];
        self.titleLabel.text = title;
        self.messageLabel.text = message;
    }
    return self;
}

// 根据富文本标题和消息声明类
- (instancetype)initWithAttributedTitle:(NSAttributedString *)title message:(NSAttributedString *)message {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self generateSubviews];
        self.titleLabel.attributedText = title;
        self.messageLabel.attributedText = message;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [COLOR_HEX(0x030303) colorWithAlphaComponent:0.5];
    [self.view addSubview:self.bezelView];
    [self configureSubview];
}

// 根据标题和类型添加响应按钮
- (void)addAction:(NSString *)title type:(UUAlertTipsActionType)type handler:(void(^ _Nullable)(void))handler {
    if (self.buttonCount >= 2) return;
    self.buttonCount += 1;
    [self generateButton:title type:type tag:self.buttonCount];
    if (self.buttonCount == 1) {
        self.firstHandler = handler;
    } else {
        self.secondHandler = handler;
    }
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {

    // 背景视图
    _bezelView = [[UIView alloc] init];
    _bezelView.backgroundColor = UIColor.whiteColor;
    _bezelView.layer.cornerRadius = 10;
    _bezelView.layer.masksToBounds = YES;
    
    // 标题标签
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = FONT_WEIGHT(16, UIFontWeightMedium);
    _titleLabel.textColor = UIColor.blackColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [_bezelView addSubview:_titleLabel];

    // 消息标签
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.font = FONT(14);
    _messageLabel.textColor = UIColor.blackColor;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.numberOfLines = 0;
    [_bezelView addSubview:_messageLabel];
}

// 生成操作按钮
- (void)generateButton:(NSString *)title type:(UUAlertTipsActionType)type tag:(NSInteger)tag {
    UIColor *backColor = type == UUAlertTipsActionWhiteBack ? UIColor.whiteColor : UIColor.blueColor;
    UIColor *titleColor = type == UUAlertTipsActionWhiteBack ? UIColor.blueColor : UIColor.whiteColor;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = backColor;
    button.layer.cornerRadius = 5;
    button.layer.borderColor = UIColor.blueColor.CGColor;
    button.layer.borderWidth = 1;
    button.tag = tag;
    button.titleLabel.font = FONT(15);
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickActionButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.bezelView addSubview:button];
}

#pragma mark - Layout

// 布局子视图
- (void)configureSubview {
    CGFloat bezelWidth = FIT_WIDTH(270);
    CGFloat contentWidth = bezelWidth - 30;
    CGFloat titleHeight = [self textHeight:self.titleLabel width:contentWidth];
    CGFloat messageHeight = [self textHeight:self.messageLabel width:contentWidth];

    self.titleLabel.frame = CGRectMake(15, 20, contentWidth, titleHeight);
    CGFloat messageY = titleHeight > 0 ? self.titleLabel.bottom + 20 : 20;
    self.messageLabel.frame = CGRectMake(15, messageY, contentWidth, messageHeight);
    
    if (titleHeight > 0 && messageHeight == 0 && self.buttonCount > 0) {
        self.titleLabel.top = 45;
    } else if (titleHeight == 0 && messageHeight > 0 && self.buttonCount > 0) {
        self.messageLabel.top = 45;
    }
    
    for (UIView *subview in self.bezelView.subviews) {
        if (![subview isKindOfClass:[UIButton class]]) continue;
        CGFloat x = 30;
        CGFloat y = 20;
        CGFloat width = bezelWidth - 30 * 2;
        if (self.buttonCount == 2 && subview.tag == 2) {
            x = (bezelWidth + 30) / 2;
        }
        if (messageHeight > 0) {
            y += self.messageLabel.bottom + 10;
        } else if (titleHeight > 0) {
            y += self.titleLabel.bottom + 10;
        }
        if (self.buttonCount == 2) {
            width = (bezelWidth - 30 * 3) / 2;
        }
        subview.frame = CGRectMake(x, y, width, 37);
    }
    UIView *subview = self.bezelView.subviews.lastObject;
    self.bezelView.frame = CGRectMake(0, 0, bezelWidth, subview.bottom + 20);
    self.bezelView.center = self.view.center;
}

// 计算文本高度
- (CGFloat)textHeight:(UILabel *)label width:(CGFloat)width {
    NSString *text = label.text;
    if (!text || text.length == 0) return 0;
    CGFloat height = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName: label.font}
                                        context:nil].size.height;
    return height > 20 ? height : 20;
}

#pragma mark - Setter

// 居左显示
- (void)setMessageAlignmentLeft:(BOOL)messageAlignmentLeft {
    _messageAlignmentLeft = messageAlignmentLeft;
    _messageLabel.textAlignment = _messageAlignmentLeft ? NSTextAlignmentLeft : NSTextAlignmentCenter;
}

#pragma mark - Respond

// 点击按钮
- (void)clickActionButton:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
        if (button.tag == 1) {
            if (self.firstHandler) self.firstHandler();
        } else {
            if (self.secondHandler) self.secondHandler();
        }
    }];
}

@end
