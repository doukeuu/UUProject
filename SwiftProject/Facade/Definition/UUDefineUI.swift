//
//  UUDefineUI.swift
//  SwiftProject
//
//  Created by Pan on 2020/8/28.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

// 屏幕宽、高、比例
let SCREEN_BOUNDS = UIScreen.main.bounds
let SCREEN_WIDTH  = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_RATIO  = (SCREEN_WIDTH / 375.0)


// 状态条、导航条、TabBar、安全区高度
let STATUS_HEIGHT    = UIApplication.shared.statusBarFrame.size.height
let NAVIGATOR_HEIGHT = (STATUS_HEIGHT + 44.0)
let BOTTOM_SAFE_AREA = CGFloat(STATUS_HEIGHT > 20.0 ? 34.0 : 0.0)
let TABBAR_HEIGHT    = (BOTTOM_SAFE_AREA + 49.0)


// 颜色
let COLOR_THEME  = UIColor(hexString: "#4b4bfd") // 主题蓝色
let COLOR_RED    = UIColor(hexString: "#fe4f65") // 红色
let COLOR_GRAY   = UIColor(hexString: "#666666") // 灰色
let COLOR_BROWN  = UIColor(hexString: "#d5a974") // 棕色
let COLOR_ORANGE = UIColor(hexString: "#F5A623") // 橙色
let COLOR_LIGHT_GRAY = UIColor(hexString: "#999999") // 浅灰色
let COLOR_SEPARATION = UIColor(hexString: "#f0f0f0") // 线条色
let COLOR_DISABLED   = UIColor(hexString: "#b3bfd0") // 置灰色


// 适配宽高
func FIT_WIDTH(_ w: CGFloat) -> CGFloat { return SCREEN_WIDTH / 375 * w }
func FIT_HEIGHT(_ h: CGFloat) -> CGFloat { return SCREEN_HEIGHT / 667 * h }


// 字体
func FONT(_ size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
    return UIFont.systemFont(ofSize: size, weight: weight)
}
