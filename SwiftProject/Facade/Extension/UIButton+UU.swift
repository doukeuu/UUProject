//
//  UIButton+UU.swift
//  SwiftProject
//
//  Created by Pan on 2020/9/3.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

extension UIButton {
    
    /// 位置枚举
    enum ImageTitlePosition {
        /// image在上，title在下
        case imageTopTitleDown
        /// image在下，title在上
        case imageDownTitleTop
        /// image在左，title在右
        case imageLeftTitleRight
        /// image在右，title在左
        case imageRightTitleLeft
    }
    
    /// 重新设置 image 及 title 的位置及间距
    func resetImageTitlePosition(_ position: ImageTitlePosition, space: CGFloat) {
        let imageWith = imageView?.frame.size.width ?? 0.0
        let imageHeight = imageView?.frame.size.height ?? 0.0
        let titleWidth = titleLabel?.frame.size.width ?? 0.0
        let titleHeight = titleLabel?.frame.size.height ?? 0.0
        
        // 近图表或标题，则仍居中
        if imageWith == 0 || titleWidth == 0 { return }
                
        switch position {
        case .imageTopTitleDown:
            imageEdgeInsets = UIEdgeInsets(top: -titleHeight-space, left: titleWidth/2, bottom: 0, right: -titleWidth/2)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith, bottom: -imageHeight-space, right: 0)
        case .imageLeftTitleRight:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space/2.0, bottom: 0, right: space/2.0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: space/2.0, bottom: 0, right: -space/2.0)
        case .imageDownTitleTop:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -titleHeight-space, right: -titleWidth)
            titleEdgeInsets = UIEdgeInsets(top: -imageHeight-space, left: -imageWith, bottom: 0, right: 0)
        case .imageRightTitleLeft:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth+space/2.0, bottom: 0, right: -titleWidth-space/2.0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith-space/2.0, bottom: 0, right: imageWith+space/2.0)
        }
    }
    
}
