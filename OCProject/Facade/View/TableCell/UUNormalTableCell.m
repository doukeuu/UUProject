//
//  UUNormalTableCell.m
//  OCProject
//
//  Created by Pan on 2020/6/17.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUNormalTableCell.h"
#import "UIView+UU.h"

@implementation UUNormalTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
        self.cellHeight = 70*SCREEN_RATIO;
    }
    return self;
}

- (void)dealloc {
    [self.actionButton removeObserver:self forKeyPath:@"selected" context:nil];
}

#pragma mark - Subviews

- (UIImageView *)headerImageView {
    if (_headerImageView) return _headerImageView;
    CGRect frame = CGRectMake(16, 10 * SCREEN_RATIO, _cellHeight - 20 * SCREEN_RATIO, _cellHeight - 20 * SCREEN_RATIO);
    _headerImageView = [[UIImageView alloc] initWithFrame:frame];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_headerImageView];
    return _headerImageView;
}

// 标题
- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(self.headerImageView.right + 15 * SCREEN_RATIO, self.headerImageView.top, SCREEN_WIDTH - self.headerImageView.right - 30 * SCREEN_RATIO, self.headerImageView.height);
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = UIColor.grayColor;
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel) return _contentLabel;
    self.titleLabel.height /= 2.0;
    CGRect frame = CGRectMake(self.contentLabel.left, self.contentLabel.bottom, self.contentLabel.width, self.contentLabel.height);
    _contentLabel = [[UILabel alloc] initWithFrame:frame];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_contentLabel];
    return _contentLabel;
}

- (UIButton *)actionButton {
    if (_actionButton) return _actionButton;
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionButton.frame = CGRectMake(SCREEN_WIDTH - 85 * SCREEN_RATIO, (_cellHeight - 30) / 2.0, 70 * SCREEN_RATIO, 30);
    _actionButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_actionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [_actionButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    _actionButton.layer.cornerRadius = _actionButton.height / 2;
    _actionButton.layer.borderWidth = 1.0;
    _actionButton.layer.borderColor = [UIColor greenColor].CGColor;
    [_actionButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    [self.contentView addSubview:_actionButton];
    
    self.contentLabel.width = SCREEN_WIDTH - self.headerImageView.right - 15 * SCREEN_RATIO - self.actionButton.width - 25 * SCREEN_RATIO;
    if (_contentLabel) {
        _contentLabel.width = self.contentLabel.width;
    }
    return _actionButton;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([object isEqual:self.actionButton]) {
        UIColor *borderColor = self.actionButton.isSelected ? [UIColor lightGrayColor] : [UIColor greenColor];
        self.actionButton.layer.borderColor = borderColor.CGColor;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// 是否显示右向指示箭头
- (void)setShowAccessory:(BOOL)showAccessory {
    _showAccessory = showAccessory;
    self.accessoryType = showAccessory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    self.contentLabel.width = SCREEN_WIDTH - self.titleLabel.right - 10 - (showAccessory ? 34 : 10);
}

// 适应标题宽度，不超过屏幕一半
- (void)adjustTitleWidth {
    if (self.titleLabel.text.length == 0) return;
    CGFloat width = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}].width;
    if (width > SCREEN_WIDTH / 2.f - 16) {
        width = SCREEN_WIDTH / 2.f - 16;
    }
    if (width < 70) {
        width = 70;
    }
    self.titleLabel.width = width;
    self.contentLabel.frame = CGRectMake(self.titleLabel.right + 10, 0, SCREEN_WIDTH - self.titleLabel.right - 20, self.cellHeight);
}

// 适应内容高度
- (void)adjustContentHeight {
    if (_contentLabel.text.length == 0) return;
    CGFloat height = [_contentLabel.text boundingRectWithSize:CGSizeMake(_contentLabel.width, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName: _contentLabel.font}
                                                      context:nil].size.height;
    if (height > self.cellHeight - 8) {
        _titleLabel.height = height + 8;
        _contentLabel.height = height + 8;
        self.height = height + 8;
        
    } else {
        self.height = self.cellHeight;
    }
}

@end
