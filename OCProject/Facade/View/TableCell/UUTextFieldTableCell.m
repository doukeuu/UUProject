//
//  UUTextFieldTableCell.m
//  OCProject
//
//  Created by Pan on 2020/6/17.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUTextFieldTableCell.h"
#import "UITextField+UU.h"
#import "UIView+UU.h"

@implementation UUTextFieldTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cellHeight = 49;
        [self configureSubviews];
    }
    return self;
}

// 适应标题宽度
- (void)adjustTitleWidth {
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    if (titleSize.width > self.titleLabel.width) {
        self.titleLabel.width = titleSize.width;
        self.inputField.frame = CGRectMake(self.titleLabel.right + 10, 0, SCREEN_WIDTH - self.titleLabel.right - 20, self.cellHeight);
    }
}


#pragma mark - Configure Subview

// 设置Frame
- (void)configureSubviews {
    self.titleLabel.frame = CGRectMake(16, 0, 70, self.cellHeight);
    self.inputField.frame = CGRectMake(self.titleLabel.right + 10, 0, SCREEN_WIDTH - self.titleLabel.right - 20, self.cellHeight);
}

// 标题标签
- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = UIColor.grayColor;
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    return _titleLabel;
}

// 输入框
- (UITextField *)inputField {
    if (_inputField) return _inputField;
    _inputField = [[UITextField alloc] init];
    _inputField.font = [UIFont systemFontOfSize:15];
    _inputField.textColor = UIColor.blackColor;
    _inputField.returnKeyType = UIReturnKeyDone;
    [_inputField limitInputStringLength:50];
    [self addSubview:_inputField];
    return _inputField;
}


#pragma mark - Property Setter

// 限制输入的字数
- (void)setLimitedCount:(NSUInteger)limitedCount {
    if (_limitedCount == limitedCount) return;
    _limitedCount = limitedCount;
    [self.inputField limitInputStringLength:limitedCount];
}

// 是否显示箭头指示标志
- (void)setShowAccessory:(BOOL)showAccessory {
    _showAccessory = showAccessory;
    self.accessoryType = showAccessory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    self.inputField.width = SCREEN_WIDTH - self.titleLabel.right - 10 - (showAccessory ? 34 : 10);
}

@end
