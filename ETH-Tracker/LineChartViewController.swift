//
//  LineChartViewController.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-04-26.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Charts

class LineChartViewController: UIViewController, ChartViewDelegate {

    //MARK: Properties
    
    var dataManager = DataManager()
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    //MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineChartView.delegate = self
        lineChartView.descriptionTextColor = UIColor.blackColor()
        
        
       
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Value Bought")
        
    }


}


/*
 override func viewDidLoad() {
 super.viewDidLoad()
 
 chartsBains.delegate = self
 chartsBains.gridBackgroundColor = UIColor.redColor()
 chartsBains.descriptionTextColor = UIColor.blackColor()
 
 
 
 let monthz = ["Jan", "feb", "mar", "apr","may","jun", "jul", "aug", "sep", "oct", "nov", "dec"]
 
 let hot = ["24", "22", "20", "18", "16", "14", "12", "10", "8", "6", "4", "2", "0"]
 
 let sprayNude = hot
 
 let amount = [1000.0, 200.0, -400.0, -800.0, 0.0, 1200.0, 800.0, 600.0, -600.0, -600.0, -100.0, 500.0, 200.0]
 
 setChart(sprayNude, values: amount)
 //setChart2(monthz)
 
 
 }
 
 func setChart(dataPoints: [String], values: [Double]) {
 
 var dataEntries: [ChartDataEntry] = []
 
 for i in 0..<dataPoints.count {
 let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
 dataEntries.append(dataEntry)
 }
 
 let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "units sold")
 let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
 chartsBains.data = lineChartData
 }
 */