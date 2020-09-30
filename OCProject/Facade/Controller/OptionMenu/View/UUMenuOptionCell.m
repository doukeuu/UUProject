//
//  UUMenuOptionCell.m
//  OCProject
//
//  Created by Pan on 2020/9/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUMenuOptionCell.h"
#import "UIView+UU.h"

#define inset 4
#define lightGrayBackColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]

@implementation UUMenuOptionCell

- (UILabel *)nameLabel {
    if (_nameLabel != nil) return _nameLabel;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset, inset, self.width-2*inset, self.height-2*inset)];
    _nameLabel.backgroundColor = lightGrayBackColor;
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    _nameLabel.layer.cornerRadius = 5;
    _nameLabel.layer.borderWidth = 0.3;
    _nameLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    _nameLabel.layer.masksToBounds = YES;
    [self addSubview:_nameLabel];
    return _nameLabel;
}

- (UIButton *)deleteButton {
    if (_deleteButton != nil) return _deleteButton;
    _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _deleteButton.frame = CGRectMake(0, 0, inset*4, inset*4);
    UIImage *image = [[UIImage imageNamed:@"delete_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_deleteButton setImage:image forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteButton];
    return  _deleteButton;
}

- (UILabel *)markLabel {
    if (_markLabel != nil) return _markLabel;
    _markLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width-5*inset, 0, 5*inset, 3*inset)];
    _markLabel.backgroundColor = [UIColor orangeColor];
    _markLabel.textColor = [UIColor whiteColor];
    _markLabel.font = [UIFont systemFontOfSize:7];
    _markLabel.textAlignment = NSTextAlignmentCenter;
    
    _markLabel.layer.cornerRadius = 3;
    _markLabel.layer.masksToBounds = YES;
    [self addSubview:_markLabel];
    return _markLabel;
}

- (UIView *)markView {
    if (_markView != nil) return _markView;
    _markView = [[UIView alloc] initWithFrame:CGRectMake(self.width-2*inset, 0, 2*inset, 2*inset)];
    _markView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_markView];
    return _markView;
}

/// 重写方法，设置选择状态
- (void)setSelected:(BOOL)selected {
    self.nameLabel.backgroundColor = selected ? [UIColor orangeColor] : lightGrayBackColor;
    self.nameLabel.textColor = selected ? [UIColor whiteColor] : [UIColor blackColor];
}

/// 重写方法，设置高亮
- (void)setHighlighted:(BOOL)highlighted {
    self.nameLabel.backgroundColor = highlighted ? [UIColor lightGrayColor] : lightGrayBackColor;
}

/// 点击删除按钮
- (void)clickDeleteButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(menuOptionCell:didClickDeleteButton:)]) {
        [self.delegate menuOptionCell:self didClickDeleteButton:button];
    }
}

@end


@implementation UUSeparatorReusableView

- (UILabel *)descriptionLabel {
    if (_descriptionLabel != nil) return _descriptionLabel;
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, self.width-12, self.height)];
    _descriptionLabel.textColor = [UIColor grayColor];
    _descriptionLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_descriptionLabel];
    self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    return _descriptionLabel;
}
@end
