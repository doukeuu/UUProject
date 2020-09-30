//
//  UUImitatedCalendarDateCell.swift
//  SwiftProject
//
//  Created by Pan on 2020/9/30.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

class UUImitatedCalendarDateCell: UICollectionViewCell {

    private let lineNumber = 6 // line number, month which first day is Saturday and has 31 days need biggest lines
    private let columnNumber = 7 // column number, a week
    private var buttonArr = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        generateDateButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var dateComponents: DateComponents? {
        willSet { updateButtons(with: newValue) }
    }

    // MARK: - Subview
    
    // generate subviews
    private func generateDateButtons() {
        let buttonW = self.bounds.width / CGFloat(columnNumber)
        for line in 0..<lineNumber {
            for column in 0..<columnNumber {
                let buttonX = buttonW * CGFloat(column)
                let buttonY = buttonW * CGFloat(line)
                let button = UUImitatedCalendarDateButton(type: .custom)
                button.frame = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonW)
                button.setTitleColor(UIColor.darkGray, for: .normal)
//                button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
                self.contentView.addSubview(button)
                buttonArr.append(button)
            }
        }
    }
    
    // update button's title and hidden
    private func updateButtons(with components: DateComponents?) {
        guard let comp = components else { return }
        let begin = UUImitatedCalendarHandler.beginIndex(with: comp)
        let days = UUImitatedCalendarHandler.monthDays(with: comp)
        for index in 0..<buttonArr.count {
            let button = buttonArr[index] as! UUImitatedCalendarDateButton
            if index < begin || index >= begin + days{
                button.setTitle("", for: .normal)
                button.isHidden = true
            } else {
                button.isHidden = false
                let day = index - begin + 1
                button.setTitle("\(day)", for: .normal)
                if comp.year == UUImitatedCalendarHandler.todayComponents.year &&
                    comp.month == UUImitatedCalendarHandler.todayComponents.month &&
                    day == UUImitatedCalendarHandler.todayComponents.day {
                    button.backColor = .red
                } else {
                    button.backColor = .white
                }
            }
        }
    }
    
    @objc private func buttonClicked(_ button: UUImitatedCalendarDateButton) {
        if button.backColor == nil || button.backColor == .white {
            button.backColor = .red
        } else if button.backColor == .red {
            button.backColor = .white
        }
    }
    
}
