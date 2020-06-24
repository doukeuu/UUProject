//
//  UUMultitypeLabel.h
//  OCProject
//
//  Created by Pan on 2020/6/24.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUMultitypeLabel : UILabel

// 一般在右上角的数字标记标签
+ (UILabel *)redBadgeLabel;

/// 居左，字号，字体颜色
+ (UILabel *)labelWithLeftFontSize:(CGFloat)fontSize
                            textColor:(UIColor *)textColor;

/// 居中，字号，字体颜色
+ (UILabel *)labelWithCenterFontSize:(CGFloat)fontSize
                              textColor:(UIColor *)textColor;

/// 居右，字号，字体颜色
+ (UILabel *)labelWithRightFontSize:(CGFloat)fontSize
                             textColor:(UIColor *)textColor;

/// 字号，字体颜色，对其方式，背景颜色
+ (UILabel *)labelWithFontSize:(CGFloat)fontSize
                        textColor:(UIColor *)textColor
                    textAlignment:(NSTextAlignment)alignment
                  backgroundColor:(UIColor *)backgroundColor;

/// 内容，字号，字体颜色，行数，对其方式
+ (UILabel *)labelWithText:(NSString *)text
                     fontSize:(CGFloat)fontSize
                    textColor:(UIColor *)textColor
                numberOfLines:(NSInteger)lineNumber
                textAlignment:(NSTextAlignment)alignment;

/// 内容，字号，字体颜色，对其方式
+ (UILabel *)labelWithText:(NSString *)text
                     fontSize:(CGFloat)fontSize
                    textColor:(UIColor *)textColor
                textAlignment:(NSTextAlignment)alignment;

/// 内容，字号，字体颜色，行数，对其方式，背景色
+ (UILabel *)labelWithText:(NSString * _Nullable)text
                     fontSize:(CGFloat)fontSize
                    textColor:(UIColor *)textColor
                numberOfLines:(NSInteger)lineNumber
                textAlignment:(NSTextAlignment)alignment
              backgroundColor:(UIColor *)backgroundColor;

@end

NS_ASSUME_NONNULL_END
