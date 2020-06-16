//
//  UUNormalCollectionCell.m
//  OCProject
//
//  Created by Pan on 2020/6/16.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUNormalCollectionCell.h"
#import "UIView+UU.h"

@interface UUNormalCollectionCell ()

@property (nonatomic, strong) UIImageView *arrowView; // 指示箭头
@end

@implementation UUNormalCollectionCell

#pragma mark - Configure Subview

// 响应按钮
- (UIButton *)actionButton {
    if (_actionButton) return _actionButton;
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionButton.frame = CGRectMake(16, 0, self.bounds.size.width - 32, self.bounds.size.height);
    _actionButton.layer.cornerRadius = 5.f;
    _actionButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_actionButton];
    return _actionButton;
}

// 图片视图
- (UIImageView *)imageView {
    if (_imageView) return _imageView;
    CGRect frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _imageView = [[UIImageView alloc] initWithFrame:frame];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_imageView];
    return _imageView;
}

// 标题
- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    CGRect frame = CGRectMake(16, 1, self.bounds.size.width - 16, self.bounds.size.height - 2);
    _titleLabel = [[UILabel alloc] initWithFrame:frame];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = UIColor.lightGrayColor;
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    return _titleLabel;
}

// 内容
- (UILabel *)contentLabel {
    if (_contentLabel) return _contentLabel;
    CGRect frame = CGRectMake(self.titleLabel.right + 10, 1, self.width - self.titleLabel.right - 20, self.height - 2);
    _contentLabel = [[UILabel alloc] initWithFrame:frame];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textColor = UIColor.blackColor;
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    return _contentLabel;
}

// 指示箭头
- (UIImageView *)arrowView {
    if (_arrowView) return _arrowView;
    CGRect frame = CGRectMake(self.width - 10 - 15, 1, 15, self.height - 2);
    _arrowView = [[UIImageView alloc] initWithFrame:frame];
    _arrowView.contentMode = UIViewContentModeScaleAspectFit;
    _arrowView.image = [UIImage imageNamed:@"right_arrow_More"];
    [self addSubview:_arrowView];
    return _arrowView;
}

// 底部分割线
- (UIView *)bottomLine {
    if (_bottomLine) return _bottomLine;
    CGRect frame = CGRectMake(16, self.height - 1, self.width - 16, 1);
    _bottomLine = [[UIView alloc] initWithFrame:frame];
    _bottomLine.backgroundColor = UIColor.lightGrayColor;
    [self addSubview:_bottomLine];
    return _bottomLine;
}

// 是否显示右向指示箭头
- (void)setShowAccessory:(BOOL)showAccessory {
    if (_showAccessory == showAccessory) return;
    _showAccessory = showAccessory;
    self.arrowView.hidden = !showAccessory;
}


#pragma mark - Adjust Width

// 调整标题和内容的宽度
- (void)adjustTitleAndContentWidth {
    _titleLabel.width = [self titleWidthForAdjusted];
    if (_contentLabel && _contentLabel.hidden == NO) {
        _contentLabel.width = [self contentWidthForAdjusted];
    }
}

// 调整标题宽度
- (CGFloat)titleWidthForAdjusted {
    if (_fixTitleWidth > 0) return _fixTitleWidth;
    CGFloat width = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName: _titleLabel.font}].width;
    CGFloat cellWidth = self.width;
    if (_contentLabel && _contentLabel.hidden == NO) {
        return width > cellWidth / 2 - 16 ? cellWidth / 2 - 16: width;
    } else if (_showAccessory) {
        return cellWidth - 16 - 34;
    } else {
        return width > cellWidth - 16 - 10 ? cellWidth - 16 - 10 : width;
    }
}

// 调整内容宽度
- (CGFloat)contentWidthForAdjusted {
    return self.width - 16 - _titleLabel.width - 10 - (_showAccessory ? 34 : 10);
}

@end
