//
//  UUPieChartOneRenderer.swift
//  OCProject
//
//  Created by Pan on 2020/8/3.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

class UUPieChartOneRenderer: PieChartRenderer {

    open override func drawValues(context: CGContext)
    {
        guard
            let chart = chart,
            let data = chart.data
            else { return }

        let center = chart.centerCircleBox

        // get whole the radius
        let radius = chart.radius
        let rotationAngle = chart.rotationAngle
        var drawAngles = chart.drawAngles
        var absoluteAngles = chart.absoluteAngles

        let phaseX = animator.phaseX
        let phaseY = animator.phaseY

        var labelRadiusOffset = radius / 10.0 * 3.0

        if chart.drawHoleEnabled
        {
            labelRadiusOffset = (radius - (radius * chart.holeRadiusPercent)) / 2.0
        }

        let labelRadius = radius - labelRadiusOffset

        var dataSets = data.dataSets

        let yValueSum = (data as! PieChartData).yValueSum

        let drawEntryLabels = chart.isDrawEntryLabelsEnabled
        let usePercentValuesEnabled = chart.usePercentValuesEnabled
        let entryLabelColor = chart.entryLabelColor
        let entryLabelFont = chart.entryLabelFont

        var angle: CGFloat = 0.0
        var xIndex = 0

        context.saveGState()
        defer { context.restoreGState() }

        for i in 0 ..< dataSets.count
        {
            guard let dataSet = dataSets[i] as? IPieChartDataSet else { continue }

            let drawValues = dataSet.isDrawValuesEnabled

            if !drawValues && !drawEntryLabels && !dataSet.isDrawIconsEnabled
            {
                continue
            }

            let iconsOffset = dataSet.iconsOffset

            let xValuePosition = dataSet.xValuePosition
            let yValuePosition = dataSet.yValuePosition

            let valueFont = dataSet.valueFont
            let entryLabelFont = dataSet.entryLabelFont
            let lineHeight = valueFont.lineHeight
            let pointSize = valueFont.pointSize

            guard let formatter = dataSet.valueFormatter else { continue }

            for j in 0 ..< dataSet.entryCount
            {
                guard let e = dataSet.entryForIndex(j) else { continue }
                let pe = e as? PieChartDataEntry

                if xIndex == 0
                {
                    angle = 0.0
                }
                else
                {
                    angle = absoluteAngles[xIndex - 1] * CGFloat(phaseX)
                }

                let sliceAngle = drawAngles[xIndex]
                let sliceSpace = getSliceSpace(dataSet: dataSet)
                let sliceSpaceMiddleAngle = sliceSpace / (labelRadius * .pi / 180)

                // offset needed to center the drawn text in the slice
                let angleOffset = (sliceAngle - sliceSpaceMiddleAngle / 2.0) / 2.0

                angle = angle + angleOffset

                let transformedAngle = rotationAngle + angle * CGFloat(phaseY)

                let value = usePercentValuesEnabled ? e.y / yValueSum * 100.0 : e.y
                let valueText = formatter.stringForValue(
                    value,
                    entry: e,
                    dataSetIndex: i,
                    viewPortHandler: viewPortHandler)

                let sliceXBase = cos(transformedAngle * .pi / 180)
                let sliceYBase = sin(transformedAngle * .pi / 180)

                let drawXOutside = drawEntryLabels && xValuePosition == .outsideSlice
                let drawYOutside = drawValues && yValuePosition == .outsideSlice
                let drawXInside = drawEntryLabels && xValuePosition == .insideSlice
                let drawYInside = drawValues && yValuePosition == .insideSlice

                let valueTextColor = dataSet.valueTextColorAt(j)
                let entryLabelColor = dataSet.entryLabelColor

                if (drawXOutside || drawYOutside) && (pe?.value ?? 0.0) > 0.0 // 值为零，则不展示
                {
                    let valueLineLength1 = dataSet.valueLinePart1Length
                    let valueLineLength2 = dataSet.valueLinePart2Length
                    let valueLinePart1OffsetPercentage = dataSet.valueLinePart1OffsetPercentage

                    var pt2: CGPoint
                    var labelPoint: CGPoint
                    var labelPoint2: CGPoint
                    var align: NSTextAlignment

                    var line1Radius: CGFloat

                    if chart.drawHoleEnabled
                    {
                        line1Radius = (radius - (radius * chart.holeRadiusPercent)) * valueLinePart1OffsetPercentage + (radius * chart.holeRadiusPercent)
                    }
                    else
                    {
                        line1Radius = radius * valueLinePart1OffsetPercentage
                    }

                    let polyline2Length = dataSet.valueLineVariableLength
                        ? labelRadius * valueLineLength2 * abs(sin(transformedAngle * .pi / 180))
                        : labelRadius * valueLineLength2

                    let pt0 = CGPoint(
                        x: line1Radius * sliceXBase + center.x,
                        y: line1Radius * sliceYBase + center.y)

                    let pt1 = CGPoint(
                        x: labelRadius * (1 + valueLineLength1) * sliceXBase + center.x,
                        y: labelRadius * (1 + valueLineLength1) * sliceYBase + center.y)

                    if transformedAngle.truncatingRemainder(dividingBy: 360.0) >= 90.0 && transformedAngle.truncatingRemainder(dividingBy: 360.0) <= 270.0
                    {
                        pt2 = CGPoint(x: pt1.x - polyline2Length, y: pt1.y)
                        align = .left //.right
                        // 前半段起始位置
                        labelPoint = CGPoint(x: pt2.x + 5, y: pt2.y - lineHeight * 2)
                        // 后半段起始位置
                        labelPoint2 = CGPoint(x: pt2.x + 8 + pointSize * 2, y: pt2.y - lineHeight * 2)
                    }
                    else
                    {
                        pt2 = CGPoint(x: pt1.x + polyline2Length, y: pt1.y)
                        align = .left
                        // 前半段起始位置
                        labelPoint = CGPoint(x: pt1.x + 5, y: pt2.y - lineHeight * 2)
                        // 后半段起始位置
                        labelPoint2 = CGPoint(x: pt1.x + 8 + pointSize * 2, y: pt2.y - lineHeight * 2)
                    }

                    DrawLine: do
                    {
                        if dataSet.useValueColorForLine
                        {
                            context.setStrokeColor(dataSet.color(atIndex: j).cgColor)
                            context.setFillColor(dataSet.color(atIndex: j).cgColor)
                        }
                        else if let valueLineColor = dataSet.valueLineColor
                        {
                            context.setStrokeColor(valueLineColor.cgColor)
                            context.setFillColor(valueLineColor.cgColor)
                        }
                        else
                        {
                            return
                        }
                        context.setLineWidth(dataSet.valueLineWidth)

                        // 圆点
                        context.move(to: CGPoint(x: pt0.x, y: pt0.y))
                        context.addArc(center: pt0, radius: 2, startAngle: 0, endAngle: CGFloat(Double.pi) * 2, clockwise: false)
                        
                        context.drawPath(using: CGPathDrawingMode.fill)
                        
                        // 折线
                        context.move(to: CGPoint(x: pt0.x, y: pt0.y))
                        context.addLine(to: CGPoint(x: pt1.x, y: pt1.y))
                        context.addLine(to: CGPoint(x: pt2.x, y: pt2.y))

                        context.drawPath(using: CGPathDrawingMode.stroke)
                    }
                    
                    if drawXOutside && drawYOutside
                    {
                        ChartUtils.drawText(
                            context: context,
                            text: valueText,
                            point: labelPoint,
                            align: align,
                            attributes: [NSAttributedString.Key.font: valueFont, NSAttributedString.Key.foregroundColor: valueTextColor]
                        )

                        if j < data.entryCount && pe?.label != nil
                        {
                            ChartUtils.drawText(
                                context: context,
                                text: pe!.label!,
                                point: CGPoint(x: labelPoint.x, y: labelPoint.y + lineHeight),
                                align: align,
                                attributes: [
                                    NSAttributedString.Key.font: entryLabelFont ?? valueFont,
                                    NSAttributedString.Key.foregroundColor: entryLabelColor ?? valueTextColor]
                            )
                        }
                    }
                    else if drawXOutside
                    {
                        if j < data.entryCount && pe?.label != nil
                        {
                            ChartUtils.drawText(
                                context: context,
                                text: pe!.label!,
                                point: CGPoint(x: labelPoint.x, y: labelPoint.y + lineHeight / 2.0),
                                align: align,
                                attributes: [
                                    NSAttributedString.Key.font: entryLabelFont ?? valueFont,
                                    NSAttributedString.Key.foregroundColor: entryLabelColor ?? valueTextColor]
                            )
                        }
                    }
                    else if drawYOutside
                    {
                        let textPrefix = valueText.prefix(2)
                        let indexPrefix = valueText.index(valueText.startIndex, offsetBy: 2)
                        let textSuffix = valueText.suffix(from: indexPrefix)
                        
                        ChartUtils.drawText(
                            context: context,
                            text: String(textPrefix),
                            point: CGPoint(x: labelPoint.x, y: labelPoint.y + lineHeight / 2.0),
                            align: align,
                            attributes: [NSAttributedString.Key.font: valueFont, NSAttributedString.Key.foregroundColor: UIColor.black]
                        )
                        ChartUtils.drawText(
                            context: context,
                            text: String(textSuffix),
                            point: CGPoint(x: labelPoint2.x, y: labelPoint2.y + lineHeight / 2.0),
                            align: align,
                            attributes: [NSAttributedString.Key.font: valueFont, NSAttributedString.Key.foregroundColor: valueTextColor]
                        )
                    }
                }

                if drawXInside || drawYInside
                {
                    // calculate the text position
                    let x = labelRadius * sliceXBase + center.x
                    let y = labelRadius * sliceYBase + center.y - lineHeight

                    if drawXInside && drawYInside
                    {
                        ChartUtils.drawText(
                            context: context,
                            text: valueText,
                            point: CGPoint(x: x, y: y),
                            align: .center,
                            attributes: [NSAttributedString.Key.font: valueFont, NSAttributedString.Key.foregroundColor: valueTextColor]
                        )

                        if j < data.entryCount && pe?.label != nil
                        {
                            ChartUtils.drawText(
                                context: context,
                                text: pe!.label!,
                                point: CGPoint(x: x, y: y + lineHeight),
                                align: .center,
                                attributes: [
                                    NSAttributedString.Key.font: entryLabelFont ?? valueFont,
                                    NSAttributedString.Key.foregroundColor: entryLabelColor ?? valueTextColor]
                            )
                        }
                    }
                    else if drawXInside
                    {
                        if j < data.entryCount && pe?.label != nil
                        {
                            ChartUtils.drawText(
                                context: context,
                                text: pe!.label!,
                                point: CGPoint(x: x, y: y + lineHeight / 2.0),
                                align: .center,
                                attributes: [
                                    NSAttributedString.Key.font: entryLabelFont ?? valueFont,
                                    NSAttributedString.Key.foregroundColor: entryLabelColor ?? valueTextColor]
                            )
                        }
                    }
                    else if drawYInside
                    {
                        ChartUtils.drawText(
                            context: context,
                            text: valueText,
                            point: CGPoint(x: x, y: y + lineHeight / 2.0),
                            align: .center,
                            attributes: [NSAttributedString.Key.font: valueFont, NSAttributedString.Key.foregroundColor: valueTextColor]
                        )
                    }
                }

                if let icon = e.icon, dataSet.isDrawIconsEnabled
                {
                    // calculate the icon's position

                    let x = (labelRadius + iconsOffset.y) * sliceXBase + center.x
                    var y = (labelRadius + iconsOffset.y) * sliceYBase + center.y
                    y += iconsOffset.x

                    ChartUtils.drawImage(context: context,
                                         image: icon,
                                         x: x,
                                         y: y,
                                         size: icon.size)
                }

                xIndex += 1
            }
        }
    }
    
}
