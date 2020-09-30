//
//  UUMenuSegmentedView.m
//  OCProject
//
//  Created by Pan on 2020/9/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUMenuSegmentedView.h"
#import "UIView+UU.h"

#define lightGrayBackColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]

@interface UUMenuSegmentedView ()
{
    NSInteger _arrayCount;  // 标题数组元素个数
    CGFloat _allLabelWidth; // 所有的标题长度之和
}
@property (nonatomic, strong) UIScrollView *scrollView;   // 主滚动视图
@property (nonatomic, strong) UIButton *popupButton;      // 弹出选择视图按钮
@property (nonatomic, strong) UIView *markLineView;       // 最下方的标示线
@property (nonatomic, strong) UILabel *lastLabel;         // 最后点击的Label
@property (nonatomic, strong) NSArray *titleArray;        // 包含所有标题的数组
@property (nonatomic, strong) NSMutableArray *labelArray; // 所有Label的数组
@property (nonatomic, strong) NSMutableArray *widthArray; // 所有label宽度的数组
@end

@implementation UUMenuSegmentedView

- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titleArray{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = lightGrayBackColor;
        
        _normalColor = [UIColor grayColor];
        _selectedColor = [UIColor orangeColor];
        _markLineColor = [UIColor orangeColor];
        _buttonBackColor = lightGrayBackColor;
        _buttonShadowColor = [UIColor whiteColor];
        
        _titleFont = [UIFont systemFontOfSize:14];
        _titleSpacing = 21;
        _titleArray = titleArray;
        
        _arrayCount = titleArray.count;
        _allLabelWidth = 0.0f;
        
        self.popupButton.hidden = NO;
        [self setupScrollViewContentView];
    }
    return self;
}

#pragma mark - Setup Subview

- (NSMutableArray *)labelArray {
    if(!_labelArray) {
        _labelArray = [[NSMutableArray alloc] init];
    }
    return _labelArray;
}

- (NSMutableArray *)widthArray {
    if(!_widthArray) {
        _widthArray = [[NSMutableArray alloc] init];
    }
    return _widthArray;
}

- (UIScrollView *)scrollView {
    if(_scrollView != nil) return _scrollView;
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, self.width * 0.9, self.height);
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.userInteractionEnabled = YES;
    [self addSubview:_scrollView];
    return _scrollView;
}

- (UIButton *)popupButton {
    if(_popupButton != nil) return _popupButton;
    _popupButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _popupButton.frame = CGRectMake(self.width*0.9, 0, self.width*0.1, self.height);
    UIImage *image = [[UIImage imageNamed:@"arrow_down_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_popupButton setImage:image forState:UIControlStateNormal];
    _popupButton.backgroundColor = self.buttonBackColor;
    
    _popupButton.layer.shadowColor = [self.buttonShadowColor CGColor];
    _popupButton.layer.shadowOffset = CGSizeMake(-2, -3);
    _popupButton.layer.shadowOpacity = 0.1f;
    
    [_popupButton addTarget:self action:@selector(clickPopupButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_popupButton];
    return _popupButton;
}

- (void)setupScrollViewContentView {
    self.markLineView = [[UIView alloc] init];
    CGFloat titleWidth = self.widthArray.count > 0 ? [self.widthArray[0] floatValue] : 0;
    self.markLineView.frame = CGRectMake(self.titleSpacing, self.scrollView.height - 2, titleWidth, 2);
    self.markLineView.backgroundColor = self.markLineColor;
    [self.scrollView addSubview:_markLineView];
    
    for (NSInteger index = 0; index < _arrayCount; index ++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = self.titleFont;
        label.textColor = self.normalColor;
        if (index == 0) {
            label.textColor = self.selectedColor;
            self.lastLabel = label;
        }
        label.text = self.titleArray[index];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = index;
        
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapGestureAction:)];
        [label addGestureRecognizer:tap];
        
        [self.labelArray addObject:label];
        [self.scrollView addSubview:label];
        [self calculateLabelWidth:label withIndex:index];
    }
    CGFloat contentWidth = self.titleSpacing * (_arrayCount + 1) + _allLabelWidth;
    if (contentWidth < self.scrollView.width) {
        contentWidth = self.scrollView.width;
    }
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.scrollView.height);
}

#pragma mark - Response Method

/// 点击标题响应方法
- (void)labelTapGestureAction:(UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel *)tap.view;
    [UIView animateWithDuration:0.3 animations:^{
        self.markLineView.left = label.left;
        self.markLineView.width = [self.widthArray[label.tag] floatValue];
    }];
    if (label != self.lastLabel) {
        label.textColor = self.selectedColor;
        self.lastLabel.textColor = self.normalColor;
        self.lastLabel = label;
    }
    [self scrollTitleAtIndex:label.tag];
    
    if ([self.delegate respondsToSelector:@selector(segmentedView:tapTitleAtIndex:)]) {
        [self.delegate segmentedView:self tapTitleAtIndex:label.tag];
    }
}

/// 按钮点击响应事件
- (void)clickPopupButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(segmentedView:didClickButton:)]) {
        [self.delegate segmentedView:self didClickButton:button];
    }
}

#pragma mark - Public Method

- (void)resetTitleArray:(NSArray *)titleArray {
    if ([titleArray isEqualToArray:self.titleArray]) return;
    
    if (titleArray.count > 0) {
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.labelArray removeAllObjects];
        [self.widthArray removeAllObjects];
        self.titleArray = titleArray;
        _arrayCount = titleArray.count;
        _allLabelWidth = 0.0f;
        [self setupScrollViewContentView];
    }
}

- (void)titleShouldSelectedAtIndex:(NSInteger)index {
    if (index < self.labelArray.count) {
        UILabel *label = self.labelArray[index];
        [UIView animateWithDuration:0.3 animations:^{
            self.markLineView.left = label.left;
            self.markLineView.width = [self.widthArray[index] floatValue];
        }];
        if (label != self.lastLabel) {
            label.textColor = self.selectedColor;
            self.lastLabel.textColor = self.normalColor;
            self.lastLabel = label;
        }
        [self scrollTitleAtIndex:index];
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    if (_titleFont != titleFont) {
        _titleFont = titleFont;
        _allLabelWidth = 0.0f;
        [self.widthArray removeAllObjects];
        for (NSInteger index = 0; index < _arrayCount; index ++) {
            UILabel *label = self.labelArray[index];
            label.font = titleFont;
            [self calculateLabelWidth:label withIndex:index];
        }
        self.scrollView.contentSize = CGSizeMake(self.titleSpacing * (_arrayCount + 1) + _allLabelWidth, self.scrollView.height);
    }
}

- (void)setTitleSpacing:(CGFloat)titleSpacing {
    if (_titleSpacing != titleSpacing) {
        CGFloat difference = titleSpacing - _titleSpacing;
        _titleSpacing = titleSpacing;
        
        for (NSInteger index = 0; index < _arrayCount; index ++) {
            UILabel *label = self.labelArray[index];
            label.left += difference * (index + 1);
        }
        self.markLineView.left = titleSpacing;
        self.scrollView.contentSize = CGSizeMake(titleSpacing * (_arrayCount + 1) + _allLabelWidth, self.scrollView.height);
    }
}

- (void)setNormalColor:(UIColor *)normalColor {
    if (_normalColor != normalColor) {
        _normalColor = normalColor;
        for (UILabel *label in self.labelArray) {
            if (label.textColor == self.selectedColor) {
                continue;
            }
            label.textColor = normalColor;
        }
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    if (_selectedColor != selectedColor) {
        _selectedColor = selectedColor;
        for (UILabel *label in self.labelArray) {
            if (label.textColor == self.normalColor) {
                continue;
            }
            label.textColor = selectedColor;
        }
    }
}

- (void)setMarkLineColor:(UIColor *)markLineColor {
    if (_markLineColor != markLineColor) {
        _markLineColor = markLineColor;
        self.markLineView.backgroundColor = markLineColor;
    }
}

- (void)setButtonBackColor:(UIColor *)buttonBackColor {
    if (_buttonBackColor != buttonBackColor) {
        _buttonBackColor = buttonBackColor;
        self.popupButton.backgroundColor = buttonBackColor;
    }
}

-  (void)setButtonShadowColor:(UIColor *)buttonShadowColor {
    if (_buttonShadowColor != buttonShadowColor) {
        _buttonShadowColor = buttonShadowColor;
        self.popupButton.layer.shadowColor = [buttonShadowColor CGColor];
    }
}

#pragma mark - Utility Method

/// 根据位置计算标题的宽度
- (void)calculateLabelWidth:(UILabel *)label withIndex:(NSInteger)index{
    CGRect currentRect = [label.text boundingRectWithSize:CGSizeMake(1000, self.scrollView.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    CGFloat currentWidth = currentRect.size.width;
    label.frame = CGRectMake(self.titleSpacing * (index + 1) + _allLabelWidth, 0, currentWidth, self.scrollView.height);
    _allLabelWidth += currentWidth;
    [self.widthArray addObject:@(currentWidth)];
}

/// 滚动选择的标题到最左边
- (void)scrollTitleAtIndex:(NSInteger)index {
    if (index < _arrayCount) {
        CGFloat offsetWidth = 0.0f;
        for (NSInteger i = 0; i < index; i ++) {
            offsetWidth += (self.titleSpacing + [self.widthArray[i] floatValue]);
        }
        if (self.scrollView.contentSize.width - offsetWidth <= self.scrollView.width) {
            offsetWidth = self.scrollView.contentSize.width - self.scrollView.width;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(offsetWidth, 0);
        }];
    }
}

@end
