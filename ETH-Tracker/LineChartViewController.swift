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
    var fiveMinsArray = [Trade]()
    
    var startTime = Int()
    var endTime = Int()
    var intervals = Int()
    
    var totalBuyValue = Float()
    var totalSellValue = Float()
    var netValueOfTrades = Float()
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    //MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineChartView.delegate = self
        lineChartView.descriptionTextColor = UIColor.blackColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
      
        
    }
    
    //MARK: Chart Methods
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Value Bought")
        
    }
    
    
    
    func splitTradesIntoTimeIntervals(trades: [Trade], timeInterval: Int, startTime: Int, endTime: Int) {
        
        // change name of seven hours to something that involves time difference
        
        let netArray : [Float] = []
        
        let startTimeInt = startTime + unixConstants.sevenHours
        let endTimeInt = endTime + unixConstants.sevenHours
        
        self.totalBuyValue = 0
        self.totalSellValue = 0
        
        let timePeriodToSplit: Int = endTimeInt - startTimeInt
        
        let numberOfIntervals = timePeriodToSplit/timeInterval
        
        print("start \(startTimeInt) ned \(endTimeInt)")
        
        for trade in trades {
            
            //            if (trade.timeInt >= startTime) && (trade.timeInt <= startTime + timeInterval)
            if (trade.timeInt <= endTimeInt) && (trade.timeInt >= endTimeInt - timeInterval) {
                print(trade.timeInt)
                calculateNetValueOfTrades(trade)
                
                self.netValueOfTrades = self.totalBuyValue - self.totalSellValue
                print("net \(self.netValueOfTrades)")
                
                
                
            } else {
                
            }
            
        }
        
    }
    
    func calculateNetValueOfTrades(trade: Trade) {
        
        if trade.type == "buy" {
            self.totalBuyValue = trade.total + self.totalBuyValue
        } else {
            self.totalSellValue = trade.total + self.totalSellValue
        }
        
    }
    
    //MARK : Actions
    
    @IBAction func thirtyMinButtonPressed(sender: UIButton) {
        
        dataManager.getTradeHistory(unixConstants.thirtyMins) { (result) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in

                
                let startTime = result.start
                let endTime = result.end
                
                print("30 min start \(startTime) end \(endTime)")
                let thirtyMinArray = result.trades
                
                self.splitTradesIntoTimeIntervals(thirtyMinArray, timeInterval: unixConstants.oneMin, startTime: startTime, endTime: endTime)
                
            })
        }
        
        dataManager.getTradeHistory(unixConstants.oneMin) { (result) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
 
            })
        }
        
        dataManager.getTradeHistory(unixConstants.twelveHours) { (result) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
                let startTime = result.start
                let endTime = result.end
                let twelveHourArray = result.trades
                print("12 hr start \(startTime) end \(endTime)")
                
                self.splitTradesIntoTimeIntervals(twelveHourArray, timeInterval: unixConstants.thirtyMins, startTime: startTime, endTime: endTime)
            
            })
        }
        
        dataManager.getTradeHistory(unixConstants.twoWeeks) { (result) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let startTime = result.start
                let endTime = result.end
                let twoWeekArray = result.trades
                print("2 week start \(startTime) end \(endTime)")
                
                self.splitTradesIntoTimeIntervals(twoWeekArray, timeInterval: unixConstants.twelveHours, startTime: startTime, endTime: endTime)
                
            })
        }
        
        
    }


}

// 30 Minutes with 1 minute intervals
// 2 Hours with 5 minute intervals
// 12 Hours with 30 minute intervals
// 2 days with 2 hour intervals
// 15 days with 12 Hour intervals


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