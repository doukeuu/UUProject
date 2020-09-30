//
//  UUImitatedCalendarSectionView.swift
//  SwiftProject
//
//  Created by Pan on 2020/9/30.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

class UUImitatedCalendarSectionView: UICollectionReusableView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        label.textColor = .black
        label.frame = CGRect(x: 0, y: 0, width: 100, height: self.bounds.height)
        self.addSubview(label)
        return label
    }()
    
    public var components: DateComponents? {
        willSet {
            if newValue == nil { return }
            titleLabel.text = "\(newValue!.month!)月"
            if newValue!.year == UUImitatedCalendarHandler.todayComponents.year &&
                newValue!.month == UUImitatedCalendarHandler.todayComponents.month {
                titleLabel.textColor = .red
            } else {
                titleLabel.textColor = .black
            }
            let buttonWidth = self.bounds.width / 7.0
            titleLabel.frame.origin.x = buttonWidth * CGFloat(newValue!.weekday! - 1) + 12
        }
    }
    
}
