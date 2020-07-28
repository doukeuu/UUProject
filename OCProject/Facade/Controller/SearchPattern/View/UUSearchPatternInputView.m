//
//  UUSearchPatternInputView.m
//  OCProject
//
//  Created by Pan on 2020/7/23.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUSearchPatternInputView.h"

@interface UUSearchPatternInputView () <UITextFieldDelegate>

@end

@implementation UUSearchPatternInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        self.layer.cornerRadius = 16;
        [self generateSubviews];
    }
    return self;
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 搜索图标
    CGRect rect = CGRectMake(12, 0, 16, self.bounds.size.height);
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:rect];
    iconView.contentMode = UIViewContentModeCenter;
    iconView.image = [UIImage imageNamed:@"search_black"];
    [self addSubview:iconView];
    
    // 输入框
    CGFloat iconRight = CGRectGetMaxX(rect);
    rect = CGRectMake(iconRight + 8, 0, self.bounds.size.width - iconRight - 8, self.bounds.size.height);
    _textField = [[UITextField alloc] initWithFrame:rect];
    _textField.font = FONT(14);
    _textField.textColor = UIColor.blackColor;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSDictionary *attr = @{NSForegroundColorAttributeName: UIColor.lightGrayColor, NSFontAttributeName: FONT(14)};
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"输入关键字" attributes:attr];
    _textField.attributedPlaceholder = str;
    _textField.delegate = self;
    [self addSubview:_textField];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *text = [textField.text stringByTrimmingCharactersInSet:set];
    if ([self.delegate respondsToSelector:@selector(searchView:searchKey:)]) {
        [self.delegate searchView:self searchKey:text];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchViewDidClearSearchKey:)]) {
        [self.delegate searchViewDidClearSearchKey:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(searchViewKeyboardDidReturn:)]) {
        [self.delegate searchViewKeyboardDidReturn:self];
    }
    return YES;
}

@end
