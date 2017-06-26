//
//  ChartView+Extensions.swift
//  EconoApp
//
//  Created by Vinicius Vieira on 13/06/17.
//  Copyright © 2017 Vinicius Vieira. All rights reserved.
//

import UIKit
import Charts

extension LineChartView {
    
    func setData(dataPoints: [String], values: [Double], label: String, lineColor: UIColor? = .black, drawCirclesEnabled: Bool = false, drawValuesEnabled: Bool = false) {
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i + 1), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: label)
        
        chartDataSet.drawCirclesEnabled = drawCirclesEnabled
        chartDataSet.drawValuesEnabled = drawValuesEnabled
        
        chartDataSet.circleColors = [lineColor?.inverse() ?? .white]
        chartDataSet.circleRadius = 3
        chartDataSet.circleHoleColor = lineColor
        chartDataSet.circleHoleRadius = 1
        
        chartDataSet.lineWidth = 2
        chartDataSet.colors = [lineColor ?? .black]
        
        chartDataSet.highlightLineDashLengths = [5.0, 2.5]
        chartDataSet.highlightColor = .black
        chartDataSet.highlightLineWidth = 1.0
        
        let gradientColors = [UIColor.white.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [0.4, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        chartDataSet.drawFilledEnabled = true // Draw the Gradient
        
        let chartData = LineChartData(dataSets: [chartDataSet])
        
        self.data = chartData
        self.animate(xAxisDuration: 0.7)
    }
    
    func showGrid() {
        leftAxis.enabled = true
        leftAxis.drawAxisLineEnabled = true
        leftAxis.axisLineColor = UIColor.white
        leftAxis.gridColor = UIColor.white
        leftAxis.labelTextColor = UIColor.white
    }
    
}

extension ChartViewBase {
    
    func selectIn(tableView: UITableView, arrayCount: Int, xEntry: Int) -> IndexPath {
        let selectedIndexPath = IndexPath(row: arrayCount - xEntry, section: 0)
        tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .middle)
        return selectedIndexPath
    }
    
}
