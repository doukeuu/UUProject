//
//  UUDefineUI.h
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#ifndef UUDefineUI_h
#define UUDefineUI_h

// 屏幕宽、高
#define SCREEN_RECT   [UIScreen mainScreen].bounds
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_RATIO  (SCREEN_WIDTH / 375.0)
#define FIT_WIDTH(x)  (SCREEN_WIDTH / 375.0 * x)
#define FIT_HEIGHT(x) (SCREEN_HEIGHT / 667.0 * x)

// 状态条、导航条、TabBar高度
#define STATUS_HEIGHT    (UIApplication.sharedApplication.statusBarFrame.size.height)
#define NAVIGATOR_H      (STATUS_HEIGHT + 44.0)
#define TABBAR_HEIGHT    (BOTTOM_SAFE_AREA + 49.0)
#define BOTTOM_SAFE_AREA (STATUS_HEIGHT > 20.0 ? 34.0 : 0.0)

// 颜色设置
#define COLOR_RGB(r,g,b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define COLOR_RGBA(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define COLOR_HEX(value)     [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 \
                                             green:((float)((value & 0xFF00) >> 8))/255.0    \
                                              blue:((float)(value & 0xFF))/255.0 alpha:1.0]

//  定义通用字体大小
#define FONT(size)         [UIFont systemFontOfSize:(size * SCREEN_RATIO)]
#define FONT_WEIGHT(s, w)  [UIFont systemFontOfSize:(s * SCREEN_RATIO) weight:w]

#endif /* UUDefineUI_h */
