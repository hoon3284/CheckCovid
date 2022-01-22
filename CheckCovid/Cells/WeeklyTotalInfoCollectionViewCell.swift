//
//  WeeklyTotalInfoCollectionViewCell.swift
//  CheckCovid
//
//  Created by wickedRun on 2022/01/18.
//

import UIKit
import Charts

class WeeklyTotalInfoCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var barChartView: BarChartView!
    
    let dateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "ko_KR")
    
        return dateFormatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.drawGridBackgroundEnabled = false
//        barChartView.drawValueAboveBarEnabled = false
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.drawAxisLineEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = false
    }
    
    func setChart(xAxis: [String], yAxis: [Int]) {
        let doubleYAxis = yAxis.map(Double.init)
        
        var dataEntries = [BarChartDataEntry]()
        
        for i in 0..<xAxis.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: doubleYAxis[i])

            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "확진자 수")
        
        chartDataSet.colors = [.systemRed]
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        barChartView.data = chartData
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxis)
        barChartView.barData?.barWidth = 0.35
    }
}
