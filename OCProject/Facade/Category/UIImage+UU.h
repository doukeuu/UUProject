//
//  UIImage+UU.h
//  OCProject
//
//  Created by Pan on 2020/5/13.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (UU)

/// 大于固定尺寸1242时，就缩小图片
- (UIImage *)imageWithScaleFixedSize;

/// 根据尺寸，等比例缩放图片，长边决定
- (UIImage *)imageScaleInSize:(CGSize)size;

/// 根据尺寸，等比例缩放图片，短边决定
- (UIImage *)imageScaleToSize:(CGSize)size;

/// 根据尺寸，缩放剪切图片，居中剪切
- (UIImage *)imageScaleAndClipToSize:(CGSize)size;

/// 根据尺寸，缩放剪切图片，并切圆角，居中剪切
- (UIImage *)imageScaleAndClipToSize:(CGSize)size withCorner:(CGFloat)corner;

/// 拉伸异形TabBar背景图片
- (UIImage *)stretchToFitTabBarSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
