//
//  UUImitateWeChatView.m
//  OCProject
//
//  Created by Pan on 2020/8/8.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUImitateWeChatView.h"
#import "UIButton+UU.h"
#import <Masonry/Masonry.h>

@interface UUImitateWeChatView ()
{
    UIButton *_selectButton; // 选择按钮
}
@end

@implementation UUImitateWeChatView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_HEX(0xF3F5F7);
        [self generateSubviews];
    }
    return self;
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 选择按钮
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.titleLabel.font = FONT(14);
    [_selectButton setImage:[UIImage imageNamed:@"select_nor"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"select_sel"] forState:UIControlStateSelected];
    [_selectButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [_selectButton setTitle:@"全选" forState:UIControlStateNormal];
    [_selectButton addTarget:self action:@selector(clickSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectButton];
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    [_selectButton resetImageTitlePosition:ButtonImageLeftTitleRight space:12];
    
    // 删除按钮
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.backgroundColor = UIColor.redColor;
    deleteButton.titleLabel.font = FONT(16);
    [deleteButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(80);
    }];
    
    // 完成按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.backgroundColor = UIColor.blueColor;
    doneButton.titleLabel.font = FONT(16);
    [doneButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.equalTo(deleteButton.mas_left);
        make.width.mas_equalTo(80);
    }];
}

#pragma mark - Setter

// 是否全选
- (void)setIsAllSelected:(BOOL)isAllSelected {
    _isAllSelected = isAllSelected;
    _selectButton.selected = _isAllSelected;
}

#pragma mark - Respond

// 点击全选按钮
- (void)clickSelectButton:(UIButton *)button {
    button.selected = !button.isSelected;
    _isAllSelected = button.isSelected;
    if ([self.delegate respondsToSelector:@selector(imitateWeChatView:didClickAt:)]) {
        UUImitateWeChatAction action = button.isSelected ? UUImitateWeChatSelected : UUImitateWeChatDeselect;
        [self.delegate imitateWeChatView:self didClickAt:action];
    }
}

// 点击删除按钮
- (void)clickDeleteButton {
    if ([self.delegate respondsToSelector:@selector(imitateWeChatView:didClickAt:)]) {
        [self.delegate imitateWeChatView:self didClickAt:UUImitateWeChatDelete];
    }
}

// 点击完成按钮
- (void)clickDoneButton {
    if ([self.delegate respondsToSelector:@selector(imitateWeChatView:didClickAt:)]) {
        [self.delegate imitateWeChatView:self didClickAt:UUImitateWeChatDone];
    }
}

@end
