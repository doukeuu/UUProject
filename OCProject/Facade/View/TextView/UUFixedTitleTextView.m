//
//  UUFixedTitleTextView.m
//  OCProject
//
//  Created by Pan on 2020/7/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUFixedTitleTextView.h"

@interface UUFixedTitleTextView () <UITextViewDelegate>

@end

@implementation UUFixedTitleTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self generateSubviews];
    }
    return self;
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 输入框视图
    UITextView *textView = [[UITextView alloc] initWithFrame:self.bounds];
    textView.backgroundColor = UIColor.whiteColor;
    textView.font = [UIFont systemFontOfSize:16];
    textView.textColor = UIColor.blackColor;
    textView.delegate = self;
    [self addSubview:textView];
    
    // 标题标签
    CGRect rect = CGRectMake(12, 20, 80, textView.font.lineHeight);
    _titleLabel = [[UILabel alloc] initWithFrame:rect];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = UIColor.lightGrayColor;
    _titleLabel.text = @"输入原因：";
    [textView addSubview:_titleLabel];
    
    // 边距及首行缩进
    CGFloat top = _titleLabel.frame.origin.y;
    CGFloat left = _titleLabel.frame.origin.x - textView.textContainer.lineFragmentPadding;
    textView.textContainerInset = UIEdgeInsetsMake(top, left, left, left); // 四周内边距
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_titleLabel.bounds];
    textView.textContainer.exclusionPaths = @[path]; // 首行缩进标题宽度
    
    // 占位符标签
    rect = CGRectMake(CGRectGetMaxX(_titleLabel.frame), 20, 120, _titleLabel.bounds.size.height);
    _placeholderLabel = [[UILabel alloc] initWithFrame:rect];
    _placeholderLabel.font = [UIFont systemFontOfSize:16];
    _placeholderLabel.textColor = UIColor.lightGrayColor;
    _placeholderLabel.text = @"请填写原因";
    [textView addSubview:_placeholderLabel];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholderLabel.hidden = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView endEditing:YES];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.hasText;
}

@end
