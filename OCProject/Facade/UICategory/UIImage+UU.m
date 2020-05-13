//
//  UIImage+UU.m
//  OCProject
//
//  Created by Pan on 2020/5/13.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UIImage+UU.h"
#import <UIImage+YYAdd.h>

@implementation UIImage (UU)

// 大于固定尺寸1242时，就缩小图片
- (UIImage *)imageWithScaleFixedSize {
    CGFloat size = 1242;
    if (self.size.width <= size && self.size.height <= size) {
        return self;
    }
    return [self imageByResizeToSize:CGSizeMake(size, size) contentMode:UIViewContentModeCenter];
}

// 根据尺寸，等比例缩放图片，长边决定
- (UIImage *)imageScaleInSize:(CGSize)size {
    CGFloat imageWidth = 0.0f, imageHeight = 0.0f;
    CGFloat ratio = self.size.width / self.size.height;
    if ((size.width / size.height) >= ratio) { // 图片完全在size内
        imageHeight = size.height;
        imageWidth = size.height * ratio;
    } else {
        imageWidth = size.width;
        imageHeight = size.width / ratio;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageHeight));
    [self drawInRect:CGRectMake(0, 0, imageWidth, imageHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 根据尺寸，等比例缩放图片，短边决定
- (UIImage *)imageScaleToSize:(CGSize)size {
    CGFloat imageWidth = 0.0f, imageHeight = 0.0f;
    CGFloat ratio = self.size.width / self.size.height;
    if ((size.width / size.height) >= ratio) { // 图片不全在size内，窄边相等，长边图片超出size
        imageWidth = size.width;
        imageHeight = size.width / ratio;
    } else {
        imageHeight = size.height;
        imageWidth = size.height * ratio;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageHeight));
    [self drawInRect:CGRectMake(0, 0, imageWidth, imageHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 根据尺寸，缩放剪切图片，居中剪切
- (UIImage *)imageScaleAndClipToSize:(CGSize)size {
    if (self.size.width == size.width && self.size.height == size.height) {
        return self; // 宽高相等，直接返回
    }
    
    UIImage *clipingImage = self;
    // 宽度相等，高度大于，或高度相等，宽度大于，不缩放
    if (self.size.width == size.width && self.size.height < size.height) { // 宽度相等，高度小，缩放
        clipingImage = [self imageScaleToSize:size];
        
    } else if (self.size.height == size.height && self.size.width < size.width) { // 高度相等，宽度小，缩放
        clipingImage = [self imageScaleToSize:size];
        
    } else if (self.size.width != size.width && self.size.height != size.height){ // 宽度、高度均不等，缩放
        clipingImage = [self imageScaleToSize:size];
    }
    
    CGFloat x = (clipingImage.size.width - size.width) / 2.0;
    CGFloat y = (clipingImage.size.height - size.height) / 2.0;
    CGRect clipedRect  = CGRectMake(x, y, size.width, size.height);
    // 居中剪切
    CGImageRef clipedRef = CGImageCreateWithImageInRect(clipingImage.CGImage, clipedRect);
    UIImage *clipedImage = [UIImage imageWithCGImage:clipedRef];
    CGImageRelease(clipedRef);
    
    return clipedImage;
}

// 根据尺寸，缩放剪切图片，并切圆角，居中剪切
- (UIImage *)imageScaleAndClipToSize:(CGSize)size withCorner:(CGFloat)corner{
    UIImage *clipingImage = self;
    // 宽高相等，或宽度相等，高度大于，或高度相等，宽度大于，不缩放
    if (self.size.width == size.width && self.size.height < size.height) { // 宽度相等，高度小，缩放
        clipingImage = [self imageScaleToSize:size];
        
    } else if (self.size.height == size.height && self.size.width < size.width) { // 高度相等，宽度小，缩放
        clipingImage = [self imageScaleToSize:size];
        
    } else if (self.size.width != size.width && self.size.height != size.height){ // 宽度、高度均不等，缩放
        clipingImage = [self imageScaleToSize:size];
    }
    
    if (corner > size.height / 2.0 || corner > size.width / 2.0) {
        corner = size.height > size.width ? size.width / 2.0 : size.height / 2.0;
    }
    
    CGFloat x = (clipingImage.size.width - size.width) / 2.0;
    CGFloat y = (clipingImage.size.height - size.height) / 2.0;
    CGRect clipedRect  = CGRectMake(x, y, size.width, size.height);
    
    // 截取图片中间部分
    CGImageRef clipedRef = CGImageCreateWithImageInRect(clipingImage.CGImage, clipedRect);
    
    UIGraphicsBeginImageContext(clipedRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    clipedRect.origin = CGPointZero; // 需改为从0点开始绘制路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRoundedRect(path, NULL, clipedRect, corner, corner);
    CGContextAddPath(context, path);
    CGContextClip(context); // 裁切上下文环境
    
    // 镜像反转平移
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -clipedRect.size.height);
    
    // 画图
    CGContextDrawImage(context, clipedRect, clipedRef);
    UIImage *clipedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(clipedRef);
    CGPathRelease(path);
    
    return clipedImage;
}

// 拉伸异形TabBar背景图片
- (UIImage *)stretchToFitTabBarSize:(CGSize)size {
    
    // 第一次拉伸右边，左边不动
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    UIImage *image = [self stretchableImageWithLeftCapWidth:width * 0.8 topCapHeight:height * 0.5];
    
    // 重绘拉伸过后的图片，不然图片不会变
    CGRect tmpRect = CGRectMake(0, 0, (width / 2 + size.width / 2), size.height);
    UIGraphicsBeginImageContextWithOptions(tmpRect.size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:tmpRect];
    UIImage *stretchImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 第二次拉伸左边，右边不动
    CGFloat stretchW = stretchImage.size.width;
    CGFloat stretchH = stretchImage.size.height;
    UIEdgeInsets insets = UIEdgeInsetsMake(stretchH * 0.5, stretchW * 0.1, stretchH * 0.3, stretchW * 0.8);
    UIImage *resultImage = [stretchImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    // 结果就是中间凸起不变，左右拉伸以适应尺寸
    return resultImage;
}

@end
