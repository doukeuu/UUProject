//
//  UITextView+UU.m
//  OCProject
//
//  Created by Pan on 2020/5/15.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UITextView+UU.h"
#import <objc/runtime.h>

static const void *placeholderKey = &placeholderKey;
static const void *limitCountKey  = &limitCountKey;

@implementation UITextView (UU)

#pragma mark - Exchange Method

+ (void)initialize {
    [super initialize];
    
    method_exchangeImplementations(class_getInstanceMethod(self, NSSelectorFromString(@"setText:")),
                                   class_getInstanceMethod(self, @selector(rewriteSetText:)));
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(layoutSubviews)),
                                   class_getInstanceMethod(self, @selector(rewriteLayoutSubviews)));
}

// 重写setText方法
- (void)rewriteSetText:(NSString *)text {
    
    [self rewriteSetText:text];
    self.placeholderLabel.hidden = text.length > 0;
}

// 重写layoutSubviews方法
- (void)rewriteLayoutSubviews {
    
    UIEdgeInsets textInset = self.textContainerInset;
    CGFloat linePadding = self.textContainer.lineFragmentPadding;
    CGFloat borderWidth = self.layer.borderWidth;
    CGFloat x = linePadding + textInset.left + borderWidth;
    CGFloat y = textInset.top + borderWidth;
    CGFloat width = CGRectGetWidth(self.bounds) - x - textInset.right - 2 * borderWidth;
    CGFloat height = [self.placeholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
    self.placeholderLabel.frame = CGRectMake(x, y, width, height);
    
    [self rewriteLayoutSubviews];
}

#pragma mark - Property

- (UILabel *)placeholderLabel {
    UILabel *label = objc_getAssociatedObject(self, placeholderKey);
    if (!label) {
        label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        
        objc_setAssociatedObject(self, placeholderKey, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextDidChange)
                                                     name:UITextViewTextDidChangeNotification object:nil];
    }
    return label;
}

- (void)setLimitCount:(NSInteger)limitCount {
    objc_setAssociatedObject(self, limitCountKey, @(limitCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextDidChange)
                                                 name:UITextViewTextDidChangeNotification object:nil];
}

- (NSInteger)limitCount {
    return [objc_getAssociatedObject(self, limitCountKey) integerValue];
}

// 响应通知方法
- (void)handleTextDidChange {
    self.placeholderLabel.hidden = self.hasText;
    if (self.limitCount == 0) return;
    
    UITextRange *textRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:textRange.start offset:0];
    if (position) return;
    if (self.text.length > self.limitCount) {
        self.text = [self.text substringToIndex:self.limitCount];
    }
}

#ifdef DEBUG

- (void)_firstBaselineOffsetFromTop {}
- (void)_baselineOffsetFromBottom {}

#endif

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

@end
