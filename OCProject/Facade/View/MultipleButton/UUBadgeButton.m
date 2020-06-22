//
//  UUBadgeButton.m
//  OCProject
//
//  Created by Pan on 2020/6/22.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUBadgeButton.h"

#define kBadgeWidth 15

@interface UUBadgeButton ()

@property (nonatomic, strong) UIImageView *badgeImageView; // 角标图片视图
@end

@implementation UUBadgeButton

- (void)setBadgeValue:(NSString *)badgeValue {
    
    _badgeValue = [badgeValue copy];
    if (!_badgeValue || _badgeValue.length == 0 || [_badgeValue isEqualToString:@"0"]) {
        [self removeBadgeLabel];
    } else if (!_badgeLabel) {
        [self generateBadgeLabel];
        self.badgeMinSize = 10;
        [self updateBadgeValueAnimated:NO];
    } else {
        [self updateBadgeValueAnimated:YES];
    }
}

- (void)setBadgeImage:(UIImage *)badgeImage {
    
    _badgeImage = badgeImage;
    if (!_badgeImage) {
        self.badgeImageView.hidden = YES;
    } else if (!_badgeImageView) {
        [self generateBadgeImageView];
        self.badgeImageView.image = _badgeImage;
        [self updateImageBadgeFrame];
    } else {
        [self updateImageBadgeFrame];
    }
}

- (void)setBadgeMinSize:(CGFloat)badgeMinSize {
    
    _badgeMinSize = badgeMinSize;
    if (_badgeLabel) [self updateBadgeFrame];
}

#pragma mark - Label Badge

// 生成角标标签
- (void)generateBadgeLabel {
    
    CGRect frame = CGRectMake(self.frame.size.width - kBadgeWidth/2-5, -kBadgeWidth/2+3, kBadgeWidth, kBadgeWidth);
    _badgeLabel = [[UILabel alloc] initWithFrame:frame];
    _badgeLabel.backgroundColor = [UIColor redColor];
    _badgeLabel.font = [UIFont systemFontOfSize:10];
    _badgeLabel.textColor = [UIColor whiteColor];
    _badgeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_badgeLabel];
}

// 移除角标标签
- (void)removeBadgeLabel {
    
    [UIView animateWithDuration:0.2 animations:^{
        self->_badgeLabel.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self->_badgeLabel removeFromSuperview];
        self->_badgeLabel = nil;
    }];
}

// 获取标签尺寸
- (CGSize) badgeExpectedSize {
    
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:self.badgeLabel.frame];
    duplicateLabel.text = self.badgeLabel.text;
    duplicateLabel.font = self.badgeLabel.font;
    
    [duplicateLabel sizeToFit];
    CGSize expectedLabelSize = duplicateLabel.frame.size;
    return expectedLabelSize;
}

// 更新角标frame
- (void)updateBadgeFrame {
    
    CGSize expectedSize = [self badgeExpectedSize];
    CGFloat maxHeight = MAX(expectedSize.height, self.badgeMinSize);
    CGFloat maxWidth = MAX(expectedSize.width, self.badgeMinSize);
    CGFloat padding = maxWidth - expectedSize.width;
    if (padding < 6) maxWidth = maxWidth - padding + 6;;
    
    CGRect tempFrame = self.badgeLabel.frame;
    tempFrame.size.width = maxWidth;
    tempFrame.size.height = maxHeight;
    self.badgeLabel.frame = tempFrame;
    self.badgeLabel.layer.cornerRadius = maxHeight / 2;
    self.badgeLabel.clipsToBounds = YES;
}

// 更新角标值时的动画
- (void)updateBadgeValueAnimated:(BOOL)animated {
    
    if (animated && ![self.badgeLabel.text isEqualToString:self.badgeValue]) {
        CABasicAnimation *basic = [[CABasicAnimation alloc] init];
        basic.fromValue = @(1.5);
        basic.toValue = @(1.0);
        basic.duration = 0.3;
        basic.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f];
        [self.badgeLabel.layer addAnimation:basic forKey:@"labelBounces"];
    }
    self.badgeLabel.text = self.badgeValue;
    [UIView animateWithDuration:0.3 animations:^{
        [self updateBadgeFrame];
    }];
}

#pragma mark - Image Badge

// 生成角标图片视图
- (void)generateBadgeImageView {
    
    CGRect frame = CGRectMake(self.frame.size.width-kBadgeWidth*2, 0, kBadgeWidth*2-5, kBadgeWidth-2);
    _badgeImageView = [[UIImageView alloc] initWithFrame:frame];
    [self addSubview:_badgeImageView];
}

- (void)updateImageBadgeFrame {
    
    self.badgeImageView.hidden = NO;
    UIImage *image = self.badgeImageView.image;
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    self.badgeImageView.frame = CGRectMake(self.frame.size.width - imageW, 0, imageW, imageH);
}

@end
