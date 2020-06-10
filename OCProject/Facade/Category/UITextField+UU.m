//
//  UITextField+UU.m
//  OCProject
//
//  Created by Pan on 2020/5/15.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UITextField+UU.h"
#import <objc/runtime.h>

@interface UITextField ()
@property (strong, nonatomic) NSNumber *characterLength; // 字符长度，适合短字符串
@property (strong, nonatomic) NSNumber *stringLength;    // 字符长度，适合长字符串
@end

static const void *characterKey = &characterKey;
static const void *stringKey = &stringKey;
const void *kShouldInputAccessoryView = &kShouldInputAccessoryView;

@implementation UITextField (UU)

// 限定输入字符长度，一个中文字符相当于两个英文字符，适合少量字符输入
- (void)limitInputCharacterLength:(NSInteger)length {
    self.characterLength = @(length);
    [self addTarget:self action:@selector(textFieldEditingChangedCharacter) forControlEvents:UIControlEventEditingChanged];
}

// 限定字符串长度，中英文都算一个字符，适合大量字符串输入
- (void)limitInputStringLength:(NSInteger)length {
    self.stringLength = @(length);
    [self addTarget:self action:@selector(textFieldEditingChangedString) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Getter & Setter

- (NSNumber *)characterLength {
    return objc_getAssociatedObject(self, characterKey);
}

- (void)setCharacterLength:(NSNumber *)characterLength {
    objc_setAssociatedObject(self, characterKey, characterLength, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)stringLength {
    return objc_getAssociatedObject(self, stringKey);
}

- (void)setStringLength:(NSNumber *)stringLength {
    objc_setAssociatedObject(self, stringKey, stringLength, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldInputAccessoryView {
    return [objc_getAssociatedObject(self, kShouldInputAccessoryView) boolValue];
}

- (void)setShouldInputAccessoryView:(BOOL)shouldInputAccessoryView {
    objc_setAssociatedObject(self, kShouldInputAccessoryView, @(shouldInputAccessoryView), OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (shouldInputAccessoryView) {
        self.inputAccessoryView = [self generateInputAccessoryButton];
    }
}

#pragma mark - Generate Views

// 生成按钮
- (UIView *)generateInputAccessoryButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    button.backgroundColor = [UIColor colorWithRed:210/255.0 green:213/255.0 blue:219/255.0 alpha:1.0];
    button.imageView.contentMode = UIViewContentModeCenter;
    [button setImage:[self generateImage] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickAccessoryButton:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = CGRectMake(0, 39, [UIScreen mainScreen].bounds.size.width, 1);
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [button addSubview:lineView];
    
    return button;
}

// 生成向下箭头
- (UIImage *)generateImage {
    CGSize size = CGSizeMake(40, 30);
    UIGraphicsBeginImageContext(size);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(5, 10)];
    [path addLineToPoint:CGPointMake(20, 20)];
    [path addLineToPoint:CGPointMake(35, 10)];
    [path setLineCapStyle:kCGLineCapSquare];
    [path setLineWidth:1];
    [[UIColor lightGrayColor] setStroke];
    [path stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Respond

// 字符改动通知响应方法
- (void)textFieldEditingChangedCharacter {
    // 限定长度
    NSInteger limitLength = [self.characterLength integerValue];
    // 所输入的全部字符（含输入高亮区域）
    NSString *oldString = self.text;
    // 选择区域
    UITextRange *range = [self markedTextRange];
    // 中文输入时，高亮部分
    UITextPosition *position = [self positionFromPosition:range.start offset:0];
    // 当输入确认后，即高亮部分消失
    if (!position) {
        // 按照这种编码方式，一个汉字的长度相当于两个英文字符
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSInteger oldDataLength = [[oldString dataUsingEncoding:encoding] length];
        // 判定输入的总字符串长度
        if (oldDataLength > limitLength * 2) {
            // 考虑中文和英文字符长度不一，用循环进行筛选
            for (NSInteger i = limitLength - 1; i < [oldString length]; i++) {
                NSString *newString = [oldString substringToIndex:i];
                NSData *newData = [newString dataUsingEncoding:encoding];
                if ([newData length] >= limitLength * 2) {
                    // 截取限定长度的字符
                    NSData *data = [newData subdataWithRange:NSMakeRange(0, limitLength * 2)];
                    NSString *result = [[NSString alloc] initWithData:data encoding:encoding];
                    // 当出现中文同英文一起输入时，可能导致编码错误，加1即可；非中英文也可导致编码错误，会清空输入；
                    if (!result) {
                        data = [newData subdataWithRange:NSMakeRange(0, limitLength * 2 + 1)];
                        result = [[NSString alloc] initWithData:data encoding:encoding];
                    }
                    self.text = result;
                    break;
                }
            }
        }
    }
}

// 字符串改动通知响应方法
- (void)textFieldEditingChangedString {
    // 限定长度
    NSInteger limitLength = self.stringLength.integerValue;
    // 选择区域
    UITextRange *range = self.markedTextRange;
    // 中文输入时，高亮部分
    UITextPosition *position = [self positionFromPosition:range.start offset:0];
    // 当输入确认后，即高亮部分消失
    if (!position) {
        // 判定输入的总字符串长度
        if (self.text.length > limitLength) {
            self.text = [self.text substringToIndex:limitLength];
        }
    }
}

// 点击按钮
- (void)clickAccessoryButton:(UIButton *)button {
    [self resignFirstResponder];
}

@end
