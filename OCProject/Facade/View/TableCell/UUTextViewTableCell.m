//
//  UUTextViewTableCell.m
//  OCProject
//
//  Created by Pan on 2020/6/17.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUTextViewTableCell.h"
#import "UIView+UU.h"
#import "UITextView+UU.h"

@implementation UUTextViewTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cellHeight = 150;
    }
    return self;
}


#pragma mark - Configure Subview

// 标题标签
- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = UIColor.grayColor;
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    _titleLabel.frame = CGRectMake(16, 10, SCREEN_WIDTH - 16 * 2, 21);
    if (_textView) {
        _textView.frame = CGRectMake(12, _titleLabel.bottom + 5, SCREEN_WIDTH - 12 * 2, self.cellHeight - _titleLabel.bottom - 10);
    }
    return _titleLabel;
}

// 输入框
- (UITextView *)textView {
    if (_textView) return _textView;
    _textView = [[UITextView alloc] init];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textColor = UIColor.blackColor;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.limitCount = 200;
    [self addSubview:_textView];
    _textView.frame = CGRectMake(12, 8, SCREEN_WIDTH - 12 * 2, self.cellHeight - 16);
    if (_titleLabel) {
        _textView.frame = CGRectMake(12, _titleLabel.bottom + 5, SCREEN_WIDTH - 12 * 2, self.cellHeight - _titleLabel.bottom - 10);
    }
    return _textView;
}

#pragma mark - Property Setter

// 限制输入的字数
- (void)setLimitedCount:(NSUInteger)limitedCount {
    if (_limitedCount == limitedCount) return;
    _limitedCount = limitedCount;
    _textView.limitCount = _limitedCount;
}

@end
