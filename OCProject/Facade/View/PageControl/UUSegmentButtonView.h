//
//  UUSegmentButtonView.h
//  OCProject
//
//  Created by Pan on 2020/6/20.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UUSegmentButtonView;

@protocol UUSegmentButtonViewDelegate <NSObject>

/// 点击按钮的代理
/// @param view 视图自身
/// @param index 按钮下标
- (void)segmentButtonView:(UUSegmentButtonView *)view didClickAtIndex:(NSInteger)index;
@end


@interface UUSegmentButtonView : UIView

/// 标题数组
@property (nonatomic, strong) NSArray *titleArray;
/// 图片名数组
@property (nonatomic, strong) NSArray *imageArray;
/// 当前选择下标
@property (nonatomic, assign) NSInteger currentIndex;
/// 按钮间距
@property (nonatomic, assign) CGFloat buttonSpacing;
/// 按钮常态字体
@property (nonatomic, strong) UIFont *normalFont;
/// 按钮选中字体
@property (nonatomic, strong) UIFont *selectFont;
/// 按钮常态颜色
@property (nonatomic, strong) UIColor *normalColor;
/// 按钮选中颜色
@property (nonatomic, strong) UIColor *selectColor;
/// 按钮下面标记线
@property (nonatomic, strong) CALayer *markLineLayer;
/// 固定标记线宽度
@property (nonatomic, assign) CGFloat markLineWidth;
/// 固定标记线高度
@property (nonatomic, assign) CGFloat markLineHeight;
/// 底部分割线
@property (nonatomic, strong) CALayer *separatorLayer;
/// 是否可重复点击，默认否
@property (nonatomic, assign) BOOL repeatClick;
/// 代理
@property (nonatomic, weak) id<UUSegmentButtonViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
