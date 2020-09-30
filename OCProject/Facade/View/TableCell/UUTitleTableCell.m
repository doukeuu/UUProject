//
//  UUTitleTableCell.m
//  OCProject
//
//  Created by Pan on 2020/9/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUTitleTableCell.h"
#import <Masonry/Masonry.h>

@interface UUTitleTableCell ()
{
    UITableViewCellStyle _cellType; // 单元格类型
    UIImageView *_iconView;  // 图标视图
    UILabel *_titleLabel;    // 标题标签
    UILabel *_stateLabel;    // 详情标签
    UIImageView *_arrowView; // 箭头视图
    UIView *_lineView;       // 分割线视图
}
@end

@implementation UUTitleTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _cellType = style;
        _leftMargin = 15;
        _rightMargin = -15;
        _middleSpace = 5;
        _showIndicator = YES;
    }
    return self;
}

#pragma mark - Subviews

// 图标视图
- (UIImageView *)iconView {
    if (_iconView) return _iconView;
    _iconView = [[UIImageView alloc] init];
    _iconView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_iconView];
    [self constrainSubviews];
    return _iconView;
}

// 标题标签
- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = UIColor.blackColor;
    _titleLabel.numberOfLines = 0;
    [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:_titleLabel];
    [self constrainSubviews];
    return _titleLabel;
}

// 详情标签
- (UILabel *)stateLabel {
    if (_stateLabel) return _stateLabel;
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.font = [UIFont systemFontOfSize:14];
    _stateLabel.textColor = UIColor.lightGrayColor;
    _stateLabel.numberOfLines = 0;
    [_stateLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:_stateLabel];
    [self constrainSubviews];
    return _stateLabel;
}

// 箭头视图
- (UIImageView *)arrowView {
    if (_arrowView) return _arrowView;
    _arrowView = [[UIImageView alloc] init];
    _arrowView.contentMode = UIViewContentModeCenter;
    _arrowView.image = [UIImage imageNamed:@"arrow_right_black"];
    [self.contentView addSubview:_arrowView];
    [self constrainSubviews];
    return _arrowView;
}

// 分割线视图
- (UIView *)lineView {
    if (_lineView) return _lineView;
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = UIColor.lightGrayColor;
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    return _lineView;
}

#pragma mark - Setter

// 图标名称
- (void)setIconName:(NSString *)iconName {
    _iconName = [iconName copy];
    if (!_iconName || iconName.length == 0) return;
    self.iconView.image = [UIImage imageNamed:_iconName];
    [self constrainSubviews];
}

// 是否展示指示图标
- (void)setShowIndicator:(BOOL)showIndicator {
    _showIndicator = showIndicator;
    if (showIndicator) {
        self.arrowView.hidden = NO;
    } else {
        if (_arrowView) _arrowView.hidden = YES;
    }
}

// 图标名称
- (void)setIndicatorName:(NSString *)indicatorName {
    _indicatorName = [indicatorName copy];
    if (!_indicatorName || _indicatorName.length == 0) return;
    self.arrowView.image = [UIImage imageNamed:_indicatorName];
    self.arrowView.hidden = !self.showIndicator;
    [self constrainSubviews];
}

#pragma mark - Constraints

// 约束子视图
- (void)constrainSubviews {
    CGFloat leftMargin = self.leftMargin;
    CGFloat rightMargin = self.rightMargin;
    CGFloat middleSpace = self.middleSpace;
    UIView *leftView = nil;
    
    if (_iconView) {
        CGSize iconSize = _iconView.image.size;
        [_iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(leftMargin);
            make.width.mas_equalTo(iconSize.width);
            make.height.mas_equalTo(iconSize.height);
        }];
        leftView = _iconView;
    }
    
    if (_arrowView) {
        CGSize arrowSize = _arrowView.image.size;
        [_arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(rightMargin);
            make.width.mas_equalTo(arrowSize.width);
            make.height.mas_equalTo(arrowSize.height);
        }];
    }
    
    if (_cellType == UITableViewCellStyleSubtitle) {
        if (_titleLabel) {
            [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView.mas_centerY).mas_offset(-middleSpace);
                if (leftView) {
                    make.left.equalTo(leftView.mas_right).mas_offset(12);
                } else {
                    make.left.mas_equalTo(leftMargin);
                }
                if (_arrowView) {
                    make.right.equalTo(self->_arrowView.mas_left);
                } else {
                    make.right.mas_equalTo(rightMargin);
                }
            }];
        }
        
        if (_stateLabel) {
            [_stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_centerY).mas_offset(middleSpace);
                if (leftView) {
                    make.left.equalTo(leftView.mas_right).mas_offset(12);
                } else {
                    make.left.mas_equalTo(leftMargin);
                }
                if (_arrowView) {
                    make.right.equalTo(self->_arrowView.mas_left);
                } else {
                    make.right.mas_equalTo(rightMargin);
                }
            }];
        }
        
    } else {
        if (_titleLabel) {
            [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                if (leftView) {
                    make.left.equalTo(leftView.mas_right).mas_offset(12);
                } else {
                    make.left.mas_equalTo(leftMargin);
                }
            }];
            leftView = _titleLabel;
        }
        
        if (_stateLabel) {
            [_stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                if (leftView) {
                    make.left.equalTo(leftView.mas_right);
                } else {
                    make.left.mas_equalTo(leftMargin);
                }
            }];
            leftView = _stateLabel;
        }
        
        if (leftView) {
            [leftView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (_arrowView) {
                    make.right.equalTo(self->_arrowView.mas_left);
                } else {
                    make.right.mas_equalTo(rightMargin);
                }
            }];
        }
    }

}

@end
