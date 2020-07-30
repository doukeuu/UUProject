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

/// 生成纯色图片
+ (UIImage *)imageFromColor:(UIColor *)color;

/**
 绘制圆角矩形图片
 @param rect 矩形大小，X、Y应均为0
 @param color 填充颜色
 @param radius 圆角半径
 @return 圆角矩形图片
 */
+ (UIImage *)roundedRect:(CGRect)rect fillColor:(UIColor *)color cornerRadius:(CGFloat)radius;

/// 绘制渐变色图片
/// @param size 尺寸大小
/// @param startP 起始点（0～1）
/// @param endP 终止点（0～1）
/// @param startC 起始颜色
/// @param endC 终止颜色
+ (UIImage *)gradientImageSize:(CGSize)size
                    startPoint:(CGPoint)startP
                      endPoint:(CGPoint)endP
                    startColor:(UIColor *)startC
                      endColor:(UIColor *)endC;

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
