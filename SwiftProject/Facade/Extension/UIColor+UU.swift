//
//  UIColor+UU.swift
//  SwiftProject
//
//  Created by Pan on 2020/8/28.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

extension UIColor {

    convenience public init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    convenience public init(hex: Int, alpha: CGFloat) {
        self.init(red: CGFloat((hex>>16)&0xFF)/255.0,
                  green: CGFloat((hex>>8)&0xFF)/255.0,
                  blue: CGFloat(hex&0xFF)/255.0,
                  alpha: alpha)
    }
    
    // 十六进制颜色值初始化
    convenience public init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        var index = hex.startIndex
        if hex.hasPrefix("#") {
            index = hex.index(after: hex.startIndex)
        } else if hex.hasPrefix("0X") || hex.hasPrefix("0x") {
            index = hex.index(hex.startIndex, offsetBy: 2)
        }
        let subHex = hex.suffix(from: index)
        let length = subHex.lengthOfBytes(using: .utf8)
        
        //         RGB            RGBA          RRGGBB        RRGGBBAA
        guard length == 3 || length == 4 || length == 6 || length == 8 else {
            self.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }
        
        let rStr, gStr, bStr : Substring
        var aStr : Substring?, rang: Range<Substring.Index>
        if length < 5 {
            rang = subHex.startIndex..<subHex.index(subHex.startIndex, offsetBy: 1)
            rStr = subHex[rang]
            rang = rang.upperBound..<subHex.index(rang.upperBound, offsetBy: 1)
            gStr = subHex[rang]
            rang = rang.upperBound..<subHex.index(rang.upperBound, offsetBy: 1)
            bStr = subHex[rang]
            if length == 4 {
                rang = rang.upperBound..<subHex.index(rang.upperBound, offsetBy: 1)
                aStr = subHex[rang]
            }
        } else {
            rang = subHex.startIndex..<subHex.index(subHex.startIndex, offsetBy: 2)
            rStr = subHex[rang]
            rang = rang.upperBound..<subHex.index(rang.upperBound, offsetBy: 2)
            gStr = subHex[rang]
            rang = rang.upperBound..<subHex.index(rang.upperBound, offsetBy: 2)
            bStr = subHex[rang]
            if length == 8 {
                rang = rang.upperBound..<subHex.index(rang.upperBound, offsetBy: 2)
                aStr = subHex[rang]
            }
        }
        
        var r = 0.0, g = 0.0, b = 0.0, a = 1.0
        Scanner(string: "0x" + String(rStr)).scanHexDouble(&r)
        Scanner(string: "0x" + String(gStr)).scanHexDouble(&g)
        Scanner(string: "0x" + String(bStr)).scanHexDouble(&b)
        if aStr != nil { Scanner(string: String(aStr!)).scanHexDouble(&a) }
        
        self.init(red: CGFloat(r/255.0), green: CGFloat(g/255.0),
                  blue: CGFloat(b/255.0), alpha: CGFloat(a))
    }
    
}

// 适配黑暗模式
extension UIColor {
    
    public class var backLightGray: UIColor {
        return color(normal: UIColor(hex: 0xf0f0f0), dark: .black)
    }
    
    public class var backWhite: UIColor {
        return color(normal: .white, dark: UIColor(hex: 0x333333))
    }
    
    public class var textBlack: UIColor {
        return color(normal: UIColor(hex: 0x333333), dark: .white)
    }
    
    public class func color(normal: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (trait) -> UIColor in
                trait.userInterfaceStyle == .dark ? dark : normal
            }
        }
        return normal
    }
    
}
