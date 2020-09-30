//
//  UUMenuSegmentedView.h
//  OCProject
//
//  Created by Pan on 2020/9/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UUMenuSegmentedView;

@protocol UUMenuSegmentedViewDelegate <NSObject>
/// 代理方法，返回选择的标题tag值
- (void)segmentedView:(UUMenuSegmentedView *)segmentedView tapTitleAtIndex:(NSInteger)index;
@optional
/// 代理方法，点击下拉按钮
- (void)segmentedView:(UUMenuSegmentedView *)segmentedView didClickButton:(UIButton *)button;
@end


@interface UUMenuSegmentedView : UIView

@property (nonatomic, strong) UIFont *titleFont;          // 标题字体
@property (nonatomic, strong) UIColor *normalColor;       // 标题正常颜色
@property (nonatomic, strong) UIColor *selectedColor;     // 标题选中时颜色
@property (nonatomic, strong) UIColor *markLineColor;     // 标志线颜色
@property (nonatomic, assign) CGFloat titleSpacing;       // 标题间距
@property (nonatomic, strong) UIColor *buttonBackColor;   // 下拉按钮背景色
@property (nonatomic, strong) UIColor *buttonShadowColor; // 下拉按钮边缘阴影色
@property (nonatomic, assign) id<UUMenuSegmentedViewDelegate> delegate; // 方法代理

/// 重写初始化方法，同时获取标题数组
- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titleArray;
/// 重新添加标题数组
- (void)resetTitleArray:(NSArray *)titleArray;
/// 选择根据标题tag值选择标题
- (void)titleShouldSelectedAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
