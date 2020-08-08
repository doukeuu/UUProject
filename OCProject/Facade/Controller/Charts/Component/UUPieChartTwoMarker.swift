//
//  UUPieChartTwoMarker.swift
//  OCProject
//
//  Created by Pan on 2020/8/4.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

class UUPieChartTwoMarker: MarkerView {

    private var dotView: UIView!     // 圆点视图
    private var titleLabel: UILabel! // 标题标签
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ChartColorTemplates.colorFromString("#030303").withAlphaComponent(0.5)
        self.offset.y = -self.frame.size.height / 2.0
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        generateSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 生成子视图
    private func generateSubviews() {
        var rect = CGRect(x: 17, y: 19, width: 10, height: 10)
        // 圆点视图
        dotView = UIView(frame: rect)
        dotView.layer.cornerRadius = 5
        dotView.layer.masksToBounds = true
        self.addSubview(dotView)
        
        // 标题标签
        rect = CGRect(x: 35, y: 0, width: 100, height: self.bounds.height)
        titleLabel = UILabel(frame: rect)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2;
        self.addSubview(titleLabel)
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let pieEntry = entry as! PieChartDataEntry
        
        let data = chartView?.data as! PieChartData
        let colors = data.dataSets.first?.colors
        let index = Int(pieEntry.x)
        if let colorArr = colors, colorArr.count > 0 {
            dotView.backgroundColor = colorArr[index % colorArr.count]
        }
        
        let title = pieEntry.label ?? ""
        titleLabel.text = title
        
        let font = titleLabel.font ?? UIFont.systemFont(ofSize: 16)
        let titleW = (title as NSString).size(withAttributes: [NSAttributedString.Key.font: font]).width
        let viewWidth = 35 + titleW + 18
        let width = min(viewWidth, chartView!.bounds.width / 2)
        self.frame.size.width = width
        titleLabel.frame.size.width = width - 35 - 18
    }
    
    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        guard let chart = chartView else { return self.offset }
        
        var offset = self.offset
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
        if point.x + offset.x < 0.0 {
            offset.x = -point.x
        } else if point.x + width + offset.x > chart.bounds.size.width {
            offset.x = chart.bounds.size.width - point.x - width - 2
        }
        
        if point.y + offset.y < 0 {
            offset.y = -point.y
        } else if point.y + height + offset.y > chart.bounds.size.height {
            offset.y = chart.bounds.size.height - point.y - height
        }
        return offset
    }

}
