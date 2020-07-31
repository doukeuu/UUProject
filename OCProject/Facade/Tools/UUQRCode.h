//
//  UUQRCode.h
//  OCProject
//
//  Created by Pan on 2020/7/31.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUQRCode : NSObject

/// 生成二维码图片，包含logo
+ (UIImage *)QRCodeImageWithContent:(NSString *)content codeSize:(CGFloat)codeSize logoName:(NSString *)logoName;
/// 生成二维码图片，包含logo边框设置
+ (UIImage *)QRCodeImageWithContent:(NSString *)content
                           codeSize:(CGFloat)codeSize
                           logoName:(NSString *)logoName
                           logoSize:(CGSize)logoSize
                        borderWidth:(CGFloat)borderWidth
                        borderColor:(UIColor *)borderColor
                             radius: (CGFloat)radius;
/// 生成二维码图片
+ (UIImage *)QRCodeImageWithContent:(NSString *)content codeSize:(CGFloat)codeSize;

@end

NS_ASSUME_NONNULL_END
