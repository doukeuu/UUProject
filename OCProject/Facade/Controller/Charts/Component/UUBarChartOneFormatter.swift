//
//  UUBarChartOneFormatter.swift
//  OCProject
//
//  Created by Pan on 2020/8/3.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

class UUBarChartOneFormatter: NSObject, IAxisValueFormatter {

    /// X轴显示的值数组
    private var xValues: [String] = ["asdfs"]
    
    @objc init(xValues: [String]) {
        super.init()
        self.xValues = xValues
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        if xValues.count > index {
            return xValues[index]
        } else {
            return "\(value)"
        }
    }
    
}
