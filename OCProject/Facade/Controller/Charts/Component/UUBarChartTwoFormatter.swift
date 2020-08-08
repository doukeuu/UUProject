//
//  UUBarChartTwoFormatter.swift
//  OCProject
//
//  Created by Pan on 2020/8/4.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

class UUBarChartTwoFormatter: NSObject, IAxisValueFormatter {

    /// X轴显示的值数组
    private var xValues: [String] = ["asdfs"]
    
    @objc init(xValues: [String]) {
        super.init()
        self.xValues = xValues
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        let count = xValues.count
        if count == 0 { return "" }
        var dayString = xValues[index % count]
        if dayString.count > 7 {
            dayString = (dayString as NSString).substring(from: 5)
        } else if dayString.count > 4 {
            dayString = (dayString as NSString).substring(from: 5)
        }
        return dayString
    }
    
}
