//
//  UUPlaceholderView.m
//  OCProject
//
//  Created by Pan on 2020/7/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUPlaceholderView.h"

@interface UUPlaceholderView ()

@property (nonatomic, strong) UIView *contentView;    // 内容视图
@property (nonatomic, strong) UIImageView *imageView; // 图片
@property (nonatomic, strong) UILabel *label;         // 标签
@property (nonatomic, strong) UIButton *button;       // 按钮

@end

@implementation UUPlaceholderView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.contentView];
    }
    return self;
}

// 根据类型加载空数据占位视图，仅限UITableView及UICollectionView
- (void)setupEmptyType:(UUPlaceholderViewType)type {
    if(type == UUPlaceholderErrorNetwork){
        self.imageView.image = [UIImage imageNamed:@"empty_error"];
        self.label.text = @"网络出现错误了!";
        self.button.backgroundColor = UIColor.blueColor;
        [self.button setTitle:@"刷    新" forState:UIControlStateNormal];
        
    } else if (type == UUPlaceholderEmptyOrder) {
        self.imageView.image = [UIImage imageNamed:@"empty_order"];
        self.label.text = @"暂无工单";
        
    }  else if (type == UUPlaceholderEmptyMessage) {
        self.imageView.image = [UIImage imageNamed:@"empty_message"];
        self.label.text = @"消息列表为空";
        
    } else if (type == UUPlaceholderEmptySearch) {
        self.imageView.image = [UIImage imageNamed:@"empty_search"];
        self.label.text = @"搜索为空";
    
    } else if (type == UUPlaceholderEmptyInventory) {
        self.imageView.image = [UIImage imageNamed:@"empty_order"];
        self.label.text = @"暂无可用的净水设备";
    
    } else if (type == UUPlaceholderEmptyMateriel) {
        self.imageView.image = [UIImage imageNamed:@"empty_order"];
        self.label.text = @"暂无可用的滤芯物料";
    
    } else {
        self.imageView.image = [UIImage imageNamed:@"empty_data"];
        self.label.text = @"暂无数据...";
    }
    [self setupConstraints];
    [UIView performWithoutAnimation:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - Subviews

- (UIView *)contentView {
    if (_contentView) return _contentView;
    _contentView = [[UIView alloc] init];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    return _contentView;
}

- (UIImageView *)imageView {
    if (_imageView) return _imageView;
    _imageView = [[UIImageView alloc] init];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_contentView addSubview:_imageView];
    return _imageView;
}

- (UILabel *)label {
    if (_label) return _label;
    _label = [[UILabel alloc] init];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.font = [UIFont systemFontOfSize:14];
    _label.textColor = [UIColor lightGrayColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.numberOfLines = 0;
    [_contentView addSubview:_label];
    return _label;
}

- (UIButton *)button {
    if (_button) return _button;
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.layer.cornerRadius = 5.0;
    _button.titleLabel.font = [UIFont systemFontOfSize:15];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    [_button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_button];
    return _button;
}

#pragma mark - Layout

// 设置约束
- (void)setupConstraints {
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [self addConstraint:centerY];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:@{@"contentView": self.contentView}]];
    
    if (self.verticalOffset != 0 && self.constraints.count > 0) {
        centerY.constant = self.verticalOffset;
    }
    CGFloat padding = 16.0;
    CGFloat verticalSpace = 12.0;
    NSMutableArray *subviewStrings = [NSMutableArray array];
    NSMutableDictionary *views = [NSMutableDictionary dictionary];
    NSMutableDictionary *metrics = [@{@"padding": @(padding)} mutableCopy];
    NSMutableString *verticalFormat = [NSMutableString new];
    
    if (_imageView) {
        [subviewStrings addObject:@"imageView"];
        views[[subviewStrings lastObject]] = _imageView;
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    }
    if (_label) {
        [subviewStrings addObject:@"label"];
        views[[subviewStrings lastObject]] = _label;
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[label]-(padding@750)-|" options:0 metrics:metrics views:views]];
    }
    if (_button) {
        CGFloat buttonWidth = _button.intrinsicContentSize.width + 60;
        metrics[@"buttonWidth"] = @(buttonWidth);
        [subviewStrings addObject:@"button"];
        views[[subviewStrings lastObject]] = _button;
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[button(buttonWidth)]-(padding@750)-|"options:0 metrics:metrics views:views]];
    }
    for (int i = 0; i < subviewStrings.count; i++) {
        NSString *string = subviewStrings[i];
        [verticalFormat appendFormat:@"[%@]", string];
        if (i < subviewStrings.count-1) {
            [verticalFormat appendFormat:@"-(%.f@750)-", verticalSpace];
        }
    }
    if (verticalFormat.length > 0) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", verticalFormat]
                                                                                 options:0 metrics:metrics views:views]];
    }
}

// 点击刷新按钮
- (void)clickButton:(id)sender {
    void(^block)(void) = [self.superview valueForKey:@"actionBlock"];
    if (block) block();
}

@end
