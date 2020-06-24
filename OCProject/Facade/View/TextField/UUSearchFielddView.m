//
//  UUSearchFielddView.m
//  OCProject
//
//  Created by Pan on 2020/6/24.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUSearchFielddView.h"
#import "UIView+UU.h"
#import "UITextField+UU.h"

@implementation UUSearchFielddView

- (UITextField *)inputField {
    if(_inputField != nil) {
        return _inputField;
    }
    _inputField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _inputField.textColor = [UIColor whiteColor];
    _inputField.returnKeyType = UIReturnKeySearch;
    _inputField.borderStyle = UITextBorderStyleRoundedRect;
    _inputField.placeholder = @"请输入关键字";
    [_inputField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _inputField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 0)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:@"search"];
    _inputField.leftView = imageView;
    _inputField.leftViewMode = UITextFieldViewModeAlways;
    
    [self addSubview:_inputField];
    return _inputField;
}

- (UIButton *)actionButton {
    if(_actionButton != nil) {
        return _actionButton;
    }
    _actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _actionButton.frame = CGRectMake(self.width - 45, 0, 45, self.height);
    _actionButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    _actionButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _actionButton.layer.cornerRadius = 5.0f;
    _actionButton.layer.masksToBounds = YES;
    _actionButton.layer.borderWidth = 0.1;
    _actionButton.layer.borderColor = [[UIColor blackColor] CGColor];
    [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_actionButton];
    
    self.inputField.frame = CGRectMake(0, 0, self.width - 50, self.height);
    return _actionButton;
}

+ (UITextField *)textFieldForNavigationSearch {
    UITextField *searchField = [self textFieldWithSearchIcon];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    searchField.frame = CGRectMake(8, 8, screenWidth - 40 - 16, 44 - 16);
#ifdef __IPHONE_11_0
    if (@available(iOS 11, *)) {
        CGRect frame = searchField.frame;
        frame.size.width = screenWidth - 40 - 16 - 16;
        searchField.frame = frame;
    }
#endif
    return searchField;
}

+ (UITextField *)textFieldWithSearchIcon {
    UITextField *searchField = [[UITextField alloc] init];
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.font = [UIFont systemFontOfSize:15];
    searchField.placeholder = @"搜索";
    searchField.returnKeyType = UIReturnKeyGoogle;
    [searchField limitInputStringLength:50];
    
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 28, 16)];
    searchImage.image = [UIImage imageNamed:@"search_Register"];
    searchImage.contentMode = UIViewContentModeScaleAspectFit;
    searchField.leftView = searchImage;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    return searchField;
}


@end
