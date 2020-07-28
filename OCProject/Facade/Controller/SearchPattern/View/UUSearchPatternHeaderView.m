//
//  UUSearchPatternHeaderView.m
//  OCProject
//
//  Created by Pan on 2020/7/23.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUSearchPatternHeaderView.h"

@implementation UUSearchPatternHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        [self generateSubviews];
    }
    return self;
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 搜索历史标签
    CGRect rect = CGRectMake(0, 0, 100, self.bounds.size.height);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:rect];
    titleLabel.font = FONT_WEIGHT(14, UIFontWeightMedium);
    titleLabel.textColor = UIColor.blackColor;
    titleLabel.text = @"搜索历史";
    [self addSubview:titleLabel];
    
    // 删除按钮
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(self.bounds.size.width - 40, 0, 40, self.bounds.size.height);
    deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [deleteButton setImage:[UIImage imageNamed:@"delete_gray"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
}

#pragma mark - Respond

// 点击删除按钮
- (void)clickDeleteButton {
    if ([self.delegte respondsToSelector:@selector(headerViewDidClickDeleteButton:)]) {
        [self.delegte headerViewDidClickDeleteButton:self];
    }
}

@end
