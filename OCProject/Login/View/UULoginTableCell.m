//
//  UULoginTableCell.m
//  OCProject
//
//  Created by Pan on 2020/6/17.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UULoginTableCell.h"
#import "UITextField+UU.h"

@interface UULoginTableCell ()
{
    CGFloat _ratio;      // 屏幕宽度同375的比例
    CGFloat _margin;     // 左右边距
    CGFloat _cellHeight; // 单元格高度
}
@end

@implementation UULoginTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _ratio = SCREEN_RATIO;
        _margin = 10;
        _cellHeight = 50;
        
        [self configureSeperatorLine];
    }
    return self;
}

#pragma mark - Subviews

// 输入框
- (UITextField *)inputField {
    if (_inputField) return _inputField;
    _inputField = [[UITextField alloc] init];
    _inputField.frame = CGRectMake(_margin, 9 * _ratio, SCREEN_WIDTH - _margin * 2, _cellHeight - 9 * _ratio);
    _inputField.font = [UIFont systemFontOfSize:(13 * _ratio)];
    _inputField.textColor = [UIColor blackColor];
    _inputField.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:_inputField];
    return _inputField;
}

// 操作按钮
- (UIButton *)actionButton {
    if (_actionButton) return _actionButton;
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionButton.frame = CGRectMake(SCREEN_WIDTH - _margin - 70 * _ratio, 15 * _ratio, 70 * _ratio, _cellHeight - 19 * _ratio);
    _actionButton.titleLabel.font = [UIFont systemFontOfSize:(13 * _ratio)];
    [_actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.contentView addSubview:_actionButton];
    return _actionButton;
}

// 分割线
- (void)configureSeperatorLine {
    CGRect lineFrame = CGRectMake(_margin, _cellHeight - 0.5, SCREEN_WIDTH - _margin * 2, 0.5);
    UIView *lineView = [[UIView alloc] initWithFrame:lineFrame];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_actionButton) {
        CGFloat width = _actionButton.hidden ? SCREEN_WIDTH - _margin * 2 : _actionButton.frame.origin.x - _margin - 4;
        self.inputField.frame = CGRectMake(_margin, 9 * _ratio, width, _cellHeight - 9 * _ratio);
    }
}

#pragma mark - Setter

// 限制输入的字数
- (void)setLimitedCount:(NSUInteger)limitedCount {
    if (_limitedCount == limitedCount) return;
    _limitedCount = limitedCount;
    [self.inputField limitInputStringLength:limitedCount];
}

@end
