//
//  UUSearchPatternKeyCell.m
//  OCProject
//
//  Created by Pan on 2020/7/23.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUSearchPatternKeyCell.h"

@interface UUSearchPatternKeyCell ()
{
    UILabel *_contentLabel; // 内容标签
}
@end

@implementation UUSearchPatternKeyCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self generateSubviews];
    }
    return self;
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 内容标签
    _contentLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _contentLabel.font = FONT(16);
    _contentLabel.textColor = UIColor.lightGrayColor;
    [self.contentView addSubview:_contentLabel];
}

#pragma mark - Setter

// 关键字内容
- (void)setContentKey:(NSString *)contentKey {
    _contentKey = [contentKey copy];
    _contentLabel.text = _contentKey;
}

@end
