//
//  UIView+UU.h
//  OCProject
//
//  Created by Pan on 2020/5/11.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (UU)

// 简化view的frame相关参数获取代码
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

/// 获取视图控制器，可能为nil
- (UIViewController *)viewController;
/// 截图
- (UIImage *)screenShot;
@end

NS_ASSUME_NONNULL_END
