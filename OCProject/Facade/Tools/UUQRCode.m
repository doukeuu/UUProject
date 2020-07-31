//
//  UUQRCode.m
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUQRCode.h"

@implementation UUQRCode

// 生成二维码图片，包含logo
+ (UIImage *)QRCodeImageWithContent:(NSString *)content codeSize:(CGFloat)codeSize logoName:(NSString *)logoName {
    CGSize logoSize = CGSizeMake(codeSize / 5.5, codeSize / 5.5);
    return [self QRCodeImageWithContent:content codeSize:codeSize logoName:logoName
                               logoSize:logoSize borderWidth:5 borderColor:UIColor.whiteColor radius:5];
}

// 生成二维码图片，包含logo边框设置
+ (UIImage *)QRCodeImageWithContent:(NSString *)content
                           codeSize:(CGFloat)codeSize
                           logoName:(NSString *)logoName
                           logoSize:(CGSize)logoSize
                        borderWidth:(CGFloat)borderWidth
                        borderColor:(UIColor *)borderColor
                             radius: (CGFloat)radius  {
    
    UIImage *orginQRImage = [self QRCodeImageWithContent:content codeSize:codeSize];
    if (!logoName || logoName.length == 0) { return  orginQRImage; }
    
    CGFloat logoX = (orginQRImage.size.width -logoSize.width) / 2;
    CGFloat logoY = (orginQRImage.size.height -logoSize.height) / 2;
    CGRect logoRect = CGRectMake(logoX, logoY, logoSize.width, logoSize.height);
    UIImage *logoImage = [self logoImageWithName:logoName borderWidth:borderWidth borderColor:borderColor radious:radius];
    
    UIGraphicsBeginImageContextWithOptions(orginQRImage.size, NO, 0);
    [orginQRImage drawInRect:CGRectMake(0, 0, orginQRImage.size.width, orginQRImage.size.height)];
    [logoImage drawInRect:logoRect];
    UIImage * finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

// 生成二维码图片
+ (UIImage *)QRCodeImageWithContent:(NSString *)content codeSize:(CGFloat)codeSize {
    
    if (content == nil || content.length == 0 || codeSize <= 0) { return  nil; }
    codeSize = MAX(100, codeSize);
    codeSize = MIN(CGRectGetWidth([UIScreen mainScreen].bounds), codeSize);
    
    // 通过滤镜创建二维码
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *infoData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    
    // 创建bitmap
    CGRect extent = CGRectIntegral(outputImage.extent);
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [ciContext createCGImage:outputImage fromRect:extent];
    
    // 重绘bitmap
    CGFloat scale = MIN(codeSize/CGRectGetWidth(extent), codeSize/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGBitmapInfo bitmapInfo = (CGBitmapInfo)kCGImageAlphaNone;
    CGContextRef bitmapContext = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, bitmapInfo);
    CGContextSetInterpolationQuality(bitmapContext, kCGInterpolationNone);
    CGContextScaleCTM(bitmapContext, scale, scale);
    CGContextDrawImage(bitmapContext, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapContext);
    UIImage *finalImage = [UIImage imageWithCGImage:scaledImage];
    
    // 释放
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(bitmapContext);
    CGImageRelease(bitmapImage);
    CGImageRelease(scaledImage);
    return finalImage;
}

// 生成logo图标
+ (UIImage *)logoImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth
                   borderColor:(UIColor *)borderColor radious:(CGFloat)radious {
    if (borderWidth <= 0) {
        return [UIImage imageNamed:name];
    }
    if (borderColor == nil) {
        borderColor = [UIColor whiteColor];
    }
    UIImage *logoImage = [UIImage imageNamed:name];
    if (logoImage == nil) {
        return logoImage;
    }
    
    CGRect rect = CGRectMake(0, 0, logoImage.size.width + 2 * borderWidth, logoImage.size.height + 2 * borderWidth);
    CGRect innerRect = CGRectInset(rect, borderWidth, borderWidth);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, borderColor.CGColor);
    CGContextFillRect(context, rect);
    [logoImage drawInRect:innerRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
