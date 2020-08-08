//
//  UUImitateWeChatCell.m
//  OCProject
//
//  Created by Pan on 2020/8/8.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUImitateWeChatCell.h"
#import <Masonry/Masonry.h>

@interface UUImitateWeChatCell ()
{
    UITableViewCellStyle _cellType; // 单元格类型
    UIView *_bezelView;             // 框架视图
    UIView *_separatorLine;         // 分割线
    UIImageView *_selectView;       // 选择图片视图
    UILabel *_titleLabel;           // 标题标签
    UIView *_dotView;               // 圆点视图
    UILabel *_timeLabel;            // 时间标签
    UILabel *_contentLabel;         // 内容标签
}
@property (nonatomic, strong) UIImageView *iconView; // 图标视图
@property (nonatomic, strong) UIImage *normalImage;  // 常态图片
@property (nonatomic, strong) UIImage *selectImage;  // 选中图片
@end

@implementation UUImitateWeChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.whiteColor;
        _cellType = style;
        [self generateSubviews];
    }
    return self;
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 框架视图
    _bezelView = [[UIView alloc] init];
    _bezelView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:_bezelView];
    [_bezelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 选择图片视图
    _selectView = [[UIImageView alloc] init];
    _selectView.contentMode = UIViewContentModeCenter;
    _selectView.image = self.normalImage;
    _selectView.hidden = YES;
    [self.contentView addSubview:_selectView];
    [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(18);
    }];
    
    // 分割线
    _separatorLine = [[UIView alloc] init];
    _separatorLine.backgroundColor = UIColor.lightGrayColor;
    [_bezelView addSubview:_separatorLine];
    [_separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
    }];
    
    // 标题标签
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = FONT(16);
    _titleLabel.textColor = UIColor.blackColor;
    [_bezelView addSubview:_titleLabel];
    CGFloat margin = _cellType == UITableViewCellStyleDefault ? 43 : 15;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(margin);
        make.right.mas_lessThanOrEqualTo(-120);
        make.height.mas_equalTo(22);
    }];
    
    // 圆点视图
    _dotView = [[UIView alloc] init];
    _dotView.layer.cornerRadius = 4;
    _dotView.backgroundColor = COLOR_HEX(0xFFB400);
    [_bezelView addSubview:_dotView];
    [_dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_titleLabel.mas_top);
        make.left.equalTo(self->_titleLabel.mas_right);
        make.width.height.mas_equalTo(8);
    }];
    
    // 箭头视图
    UIImageView *arrowView = [[UIImageView alloc] init];
    arrowView.contentMode = UIViewContentModeCenter;
    arrowView.image = [UIImage imageNamed:@"arrow_right_gray"];
    [_bezelView addSubview:arrowView];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self->_titleLabel.mas_centerY);
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(12);
    }];
    
    // 时间标签
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = FONT(14);
    _timeLabel.textColor = UIColor.lightGrayColor;
    [_bezelView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self->_titleLabel.mas_centerY);
        make.right.equalTo(arrowView.mas_left).mas_offset(-4);
        make.height.mas_equalTo(20);
    }];
    
    // 内容标签
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = FONT(14);
    _contentLabel.textColor = UIColor.lightGrayColor;
    [_bezelView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-20);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
    }];
}

// 图标视图
- (UIImageView *)iconView {
    if (_iconView) return _iconView;
    _iconView = [[UIImageView alloc] init];
    _iconView.contentMode = UIViewContentModeCenter;
    [_bezelView addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(21);
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(20);
    }];
    return _iconView;
}

// 常态图片
- (UIImage *)normalImage {
    if (_normalImage) return _normalImage;
    _normalImage = [UIImage imageNamed:@"select_nor"];
    return _normalImage;
}

// 选中图片
- (UIImage *)selectImage {
    if (_selectImage) return _selectImage;
    _selectImage = [UIImage imageNamed:@"select_sel"];
    return _selectImage;
}

#pragma mark - Setter

// 单元格下标
- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    _separatorLine.hidden = _indexPath.row == 0;
}

// 单元格是否在编辑状态
- (void)setCellEditing:(BOOL)cellEditing {
    _cellEditing = cellEditing;
    if (_cellEditing) {
        [_bezelView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(36);
        }];
        _selectView.hidden = NO;
    } else {
        [_bezelView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
        }];
        _selectView.hidden = YES;
        self.cellSelected = NO;
    }
}

// 单元格是否被选中
- (void)setCellSelected:(BOOL)cellSelected {
    _cellSelected = cellSelected;
    _selectView.image = _cellSelected ? self.selectImage : self.normalImage;
}

// 设置数据类
- (void)setupModel:(id)model {
    _titleLabel.text = @"title";
    _dotView.hidden = NO;
    _timeLabel.text = @"2020-01-01";
    _contentLabel.text = @"asdfasdfasdfasdfasdfasdf";
}

#pragma mark - Respond

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (!self.cellEditing) return;
    self.cellSelected = !self.cellSelected;
    if ([self.delegate respondsToSelector:@selector(imitateWeChatCell:didSelected:atIndexPath:)]) {
        [self.delegate imitateWeChatCell:self didSelected:self.cellSelected atIndexPath:self.indexPath];
    }
}

@end
