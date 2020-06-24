//
//  UUSelectionPopupView.h
//  OCProject
//
//  Created by Pan on 2020/6/23.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 弹出视图样式
typedef NS_ENUM(NSInteger, PopupSelectionViewStyle) {
    
    PopupSelectionViewStyleOrdinary,  // 全宽样式，默认
    PopupSelectionViewStyleRightHalf, // 右半边样式
    PopupSelectionViewStyleCheckMark  // 横条加对号样式
};

// 弹出动画
typedef NS_ENUM(NSInteger, PopupSelectionViewAnimation) {
    
    PopupSelectionViewPopFromTop,        // 从顶部弹出，默认
    PopupSelectionViewPopFromBottom,     // 从底部弹出
    PopupSelectionViewScaleFromRightTop, // 从右上角放大弹出
    PopupSelectionViewScaleFromPoint     // 从指定点开始
};

// 返回点击的行下标，点击空白处返回-1
typedef void (^PopupSelectionViewSelectedBlock)(NSInteger index);


@interface UUSelectionPopupView : UIView

@property (nonatomic, strong) NSArray *titleArray;     // 标题数组
@property (nonatomic, strong) NSArray *imageArray;     // 图标数组，显示在标题左边
@property (nonatomic, assign) NSInteger selectedIndex; // CheckMark样式下，显示对号的下标数

@property (nonatomic, assign) CGPoint popupPoint; // 弹出位置


@property (nonatomic, assign) PopupSelectionViewStyle style;                 // 弹出框样式
@property (nonatomic, assign) PopupSelectionViewAnimation animationType;     // 弹出动画样式
@property (nonatomic, copy)   PopupSelectionViewSelectedBlock selectedBlock; // 选择的列表下标回调，没选择返回-1

/**
 列表弹出视图，默认样式，默认动画，左边无图标
 
 @param view       弹出视图所在的父视图
 @param titleArray 标题数组，不能为空，列表数量以标题数量为准
 @param block      点击选择时的回调，
 */
+ (void)popupToView:(UIView *)view titles:(NSArray *)titleArray selected:(PopupSelectionViewSelectedBlock)block;

// 初始化视图，View为弹出视图所在的视图
- (instancetype)initWithView:(UIView *)view;
// 弹出视图
- (void)popViewAnimated;
// 隐藏视图
- (void)hideViewAnimated;
@end

NS_ASSUME_NONNULL_END
