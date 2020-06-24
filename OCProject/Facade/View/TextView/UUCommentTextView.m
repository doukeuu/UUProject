//
//  UUCommentTextView.m
//  OCProject
//
//  Created by Pan on 2020/6/24.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUCommentTextView.h"
#import "UIView+UU.h"
#import "UITextView+UU.h"

#define ViewHeight 70

@interface UUCommentTextView ()

@property (nonatomic, strong) UITextView *inputTextView; // 输入框
@property (nonatomic, strong) UIButton *actionButton;    // 功能按钮
@end

@implementation UUCommentTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.limitNumber = 200;
        [self addSubview:self.inputTextView];
        [self addSubview:self.actionButton];
        [self configSeparatorLine];
    }
    return self;
}

- (UITextView *)inputTextView {
    if(_inputTextView != nil) return _inputTextView;
    _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(16, 8, self.width - 158, self.height-16)];
    _inputTextView.returnKeyType = UIReturnKeyDone;
    _inputTextView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    _inputTextView.font = [UIFont systemFontOfSize:14];
    _inputTextView.delegate = self;
    
    _inputTextView.layer.cornerRadius = 5.0f;
    _inputTextView.layer.borderWidth = 0.2;
    _inputTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    _inputTextView.layer.masksToBounds = YES;
    return _inputTextView;
}

- (UIButton *)actionButton {
    if(_actionButton != nil) return _actionButton;
    _actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _actionButton.frame = CGRectMake(self.width-126, 8,110, self.height-16);
    _actionButton.backgroundColor = [UIColor blueColor];
    _actionButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _actionButton.layer.cornerRadius = 5.0f;
    _actionButton.layer.masksToBounds = YES;
    [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_actionButton setTitle:@"发送" forState:UIControlStateNormal];
    [_actionButton addTarget:self action:@selector(clickActionButton) forControlEvents:UIControlEventTouchUpInside];
    return _actionButton;
}

/// 设置顶部分割线
- (void)configSeparatorLine {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
}

- (void)setPlaceholderString:(NSString *)placeholderString {
    _placeholderString = placeholderString;
    if (placeholderString.length > 0) {
        self.inputTextView.placeholderLabel.text = placeholderString;
    }
}

/// 点击发表评论按钮
- (void)clickActionButton {
    if ([self.delegate respondsToSelector:@selector(commentTextViewDidPostComment:)]) {
        [self.delegate commentTextViewDidPostComment:self.inputTextView.text];
    }
    self.inputTextView.text = @"";
    [self.inputTextView endEditing:YES];
    [self configCommentViewHeight:(ViewHeight - self.height)];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    textView.placeholderLabel.hidden = YES;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    [textView scrollRangeToVisible:range];
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    if (textView.contentSize.height <= 70) {
        [self configCommentViewHeight:textView.contentSize.height - textView.height];
    }
    
    NSString *oldString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (oldString.length > self.limitNumber) {
        textView.text = [oldString substringToIndex:self.limitNumber];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
//    textView.placeholderLabel.hidden = textView.hasText;
    return YES;
}

/// 重新设定评论输入框的高度和位置
- (void)configCommentViewHeight:(CGFloat)difference {
    if (self.height + difference >= ViewHeight) {
        self.height += difference;
        self.top -= difference;
        self.actionButton.top += difference/2;
        self.inputTextView.height += difference;
    }
}

@end
