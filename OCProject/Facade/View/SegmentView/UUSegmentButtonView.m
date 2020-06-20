//
//  UUSegmentButtonView.m
//  OCProject
//
//  Created by Pan on 2020/6/20.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUSegmentButtonView.h"
#import "UIView+UU.h"

@interface UUSegmentButtonView ()
{
    UIScrollView *_scrollView; // 滚动视图
    UIButton *_selectedButton; // 选择的按钮
    
    NSMutableArray *_buttonArray; // 按钮数组
    CGFloat _allTitleWidth;       // 标题总宽度，用于设置间距
}
@end

@implementation UUSegmentButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self commonInitialize];
        [self generateSubviews];
    }
    return self;
}

// 初始化属性
- (void)commonInitialize {
    _currentIndex = 0;
    _buttonSpacing = 0;
    _normalFont = FONT(17);
    _selectFont = FONT_WEIGHT(17, UIFontWeightMedium);
    _normalColor = UIColor.blackColor;
    _selectColor = UIColor.blueColor;
    _markLineWidth = 0.0;
    _markLineHeight = 2.0;
    _repeatClick = NO;
    _buttonArray = [[NSMutableArray alloc] init];
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 滚动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:_scrollView];
    
    // 按钮下面标记线
    _markLineLayer = [[CALayer alloc] init];
    _markLineLayer.backgroundColor = UIColor.blueColor.CGColor;
    [_scrollView.layer addSublayer:_markLineLayer];
    
    // 底部分割线
    _separatorLayer = [[CALayer alloc] init];
    _separatorLayer.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
    _separatorLayer.backgroundColor = UIColor.lightGrayColor.CGColor;
    [_scrollView.layer addSublayer:_separatorLayer];
}

// 生成按钮
- (UIButton *)generateButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = _normalFont;
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:_normalColor forState:UIControlStateNormal];
    [button setTitleColor:_selectColor forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

// 更新按钮属性
- (void)updateButtons {
    NSInteger titleCount = _titleArray.count;
    _allTitleWidth = 0.0;
    for (NSInteger j = 0; j < titleCount; j ++) {
        NSString *title = _titleArray[j];
        UIButton *button = _buttonArray[j];
        button.titleLabel.font = _normalFont;
        button.tag = j;
        if (j == _currentIndex) {
            button.selected = YES;
            button.titleLabel.font = _selectFont;
            _selectedButton = button;
        }
        NSInteger imageCount = _imageArray.count;
        if (imageCount > 0) {
            NSString *imageName = _imageArray[j % imageCount];
            UIImage *image = [UIImage imageNamed:imageName];
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [button setImage:image forState:UIControlStateNormal];
        }
        [button setTitleColor:_normalColor forState:UIControlStateNormal];
        [button setTitleColor:_selectColor forState:UIControlStateSelected];
        [button setTitle:title forState:UIControlStateNormal];
        _allTitleWidth += button.titleLabel.intrinsicContentSize.width;
    }
}

// 重新设置当前按钮样式
- (void)resetCurrentButtonStyle:(UIButton *)button {
    button.selected = YES;
    button.titleLabel.font = _selectFont;
    _selectedButton.selected = NO;
    _selectedButton.titleLabel.font = _normalFont;
    _selectedButton = button;
    [self configMarkLineLayerFrame];
}

#pragma mark - Setter

// 标题数组
- (void)setTitleArray:(NSArray *)titleArray {
    if (!titleArray || titleArray.count == 0) return;
    if (_titleArray == titleArray) return;
    _titleArray = titleArray;
    [self balanceButtonsWithTitles];
}

// 图片名数组
- (void)setImageArray:(NSArray *)imageArray {
    if (!imageArray || imageArray.count == 0) return;
    if (_imageArray == imageArray) return;
    _imageArray = imageArray;
    [self updateButtons];
}

// 当前选择下标
- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex == currentIndex) return;
    _currentIndex = currentIndex;
    if (_currentIndex >= 0 && _currentIndex < _buttonArray.count) {
        [self resetCurrentButtonStyle:_buttonArray[_currentIndex]];
    }
}

// 按钮常态字体
- (void)setNormalFont:(UIFont *)normalFont {
    _normalFont = normalFont;
    [self updateButtons];
}

// 按钮选中字体
- (void)setSelectFont:(UIFont *)selectFont {
    _selectFont = selectFont;
    [self updateButtons];
}

// 按钮常态颜色
- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [self updateButtons];
}

// 按钮选中颜色
- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    [self updateButtons];
}

// 保持按钮及标题数量相等
- (void)balanceButtonsWithTitles {
    NSInteger titleCount = _titleArray.count;
    NSInteger buttonCount = _buttonArray.count;
    NSInteger bigCount = MAX(titleCount, buttonCount);
    
    // 保持标题数量和按钮数量相等
    for (NSInteger i = 0; i < bigCount; i ++) {
        if (i >= titleCount) {
            UIButton *button = _buttonArray.lastObject;
            [button removeFromSuperview];
            [_buttonArray removeObject:button];
            continue;
        }
        if (i >= buttonCount) {
            UIButton *button = [self generateButton];
            [_scrollView addSubview:button];
            [_buttonArray addObject:button];
        }
    }
    [self updateButtons];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger count = _buttonArray.count;
    if (count == 0) return;
    CGFloat width = _scrollView.bounds.size.width;
    CGFloat height = _scrollView.bounds.size.height;
    CGFloat spacing = (width - _allTitleWidth) / (count + 1) / 2; // 字符间距等宽
    if (self.buttonSpacing > spacing) { // 设置间距
        spacing = self.buttonSpacing;
    }
    CGFloat buttonX = spacing;
    for (NSInteger i = 0; i < count; i ++) {
        UIButton *button = _buttonArray[i];
        CGFloat buttonWidth = button.titleLabel.intrinsicContentSize.width + spacing * 2;
        button.frame = CGRectMake(buttonX, 0, buttonWidth, height);
        buttonX += buttonWidth;
    }
    UIButton *button = _buttonArray[count - 1];
    _scrollView.contentSize = CGSizeMake(CGRectGetMaxX(button.frame), _scrollView.bounds.size.height);
    
    [self configMarkLineLayerFrame];
}

// 设置标记线frame
- (void)configMarkLineLayerFrame {
    CGFloat buttonTitleWidth = _selectedButton.titleLabel.intrinsicContentSize.width;
    CGFloat markWidth = _markLineWidth > 0 ? _markLineWidth : buttonTitleWidth;
    CGFloat markX = _selectedButton.left + (_selectedButton.width - markWidth) / 2;
    _markLineLayer.frame = CGRectMake(markX, _scrollView.height - _markLineHeight - 1, markWidth, _markLineHeight);
}

#pragma mark - Respond

// 按钮点击
- (void)clickButton:(UIButton *)button {
    if (self.repeatClick && button.isSelected) { // 重复点击
        if ([self.delegate respondsToSelector:@selector(segmentButtonView:didClickAtIndex:)]) {
            [self.delegate segmentButtonView:self didClickAtIndex:button.tag];
        }
        return;
    }
    if (button.isSelected) return;
    _currentIndex = button.tag;
    [self resetCurrentButtonStyle:button];
    [_scrollView scrollRectToVisible:button.frame animated:YES];
    if ([self.delegate respondsToSelector:@selector(segmentButtonView:didClickAtIndex:)]) {
        [self.delegate segmentButtonView:self didClickAtIndex:button.tag];
    }
}


@end
