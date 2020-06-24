//
//  UUMultitypeLabel.m
//  OCProject
//
//  Created by Pan on 2020/6/24.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUMultitypeLabel.h"

@implementation UUMultitypeLabel

+ (UILabel *)redBadgeLabel {
    CGFloat ratio = [UIScreen mainScreen].bounds.size.width / 375.0;
    UILabel *badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, 15 * ratio, 15 * ratio)];
    badgeLabel.backgroundColor = [UIColor redColor];
    badgeLabel.font = [UIFont systemFontOfSize:(11 * ratio)];
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.layer.cornerRadius = 15 * ratio / 2.0f;
    badgeLabel.layer.masksToBounds = YES;
    
    return badgeLabel;
}

/// 居左，字号，字体颜色
+ (UILabel *)labelWithLeftFontSize:(CGFloat)fontSize
                            textColor:(UIColor *)textColor {
    return [self labelWithText:nil fontSize:fontSize textColor:textColor numberOfLines:1 textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor]];
}

/// 居中，字号，字体颜色
+ (UILabel *)labelWithCenterFontSize:(CGFloat)fontSize
                              textColor:(UIColor *)textColor {
    return [self labelWithText:nil fontSize:fontSize textColor:textColor numberOfLines:1 textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor whiteColor]];
}

/// 居右，字号，字体颜色
+ (UILabel *)labelWithRightFontSize:(CGFloat)fontSize
                             textColor:(UIColor *)textColor {
    return [self labelWithText:nil fontSize:fontSize textColor:textColor numberOfLines:1 textAlignment:NSTextAlignmentRight backgroundColor:[UIColor whiteColor]];
}

/// 字号，字体颜色，对其方式，背景颜色
+ (UILabel *)labelWithFontSize:(CGFloat)fontSize
                        textColor:(UIColor *)textColor
                    textAlignment:(NSTextAlignment)alignment
                  backgroundColor:(UIColor *)backgroundColor {
    return [self labelWithText:nil fontSize:fontSize textColor:textColor numberOfLines:1 textAlignment:NSTextAlignmentCenter backgroundColor:backgroundColor];
}

/// 内容，字号，字体颜色，行数，对其方式
+ (UILabel *)labelWithText:(NSString *)text
                     fontSize:(CGFloat)fontSize
                    textColor:(UIColor *)textColor
                numberOfLines:(NSInteger)lineNumber
                textAlignment:(NSTextAlignment)alignment {
    return [self labelWithText:text fontSize:fontSize textColor:textColor numberOfLines:lineNumber textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor whiteColor]];
}

/// 内容，字号，字体颜色，对其方式
+ (UILabel *)labelWithText:(NSString *)text
                     fontSize:(CGFloat)fontSize
                    textColor:(UIColor *)textColor
                textAlignment:(NSTextAlignment)alignment {
    return [self labelWithText:text fontSize:fontSize textColor:textColor numberOfLines:1 textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor whiteColor]];
}

/// 内容，字号，字体颜色，行数，对其方式，背景色
+ (UILabel *)labelWithText:(NSString *)text
                     fontSize:(CGFloat)fontSize
                    textColor:(UIColor *)textColor
                numberOfLines:(NSInteger)lineNumber
                textAlignment:(NSTextAlignment)alignment
              backgroundColor:(UIColor *)backgroundColor {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = textColor;
    label.numberOfLines = lineNumber;
    label.textAlignment = alignment;
    label.backgroundColor = backgroundColor;
    return label;
}

@end
