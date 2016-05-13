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
    
//    var startTime = Int()
//    var endTime = Int()
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
    
    
    func splitTradesIntoTimeIntervals(trades: [Trade], timeInterval: Int, start: Int, end: Int)  {
        
        var tradeHistoryInIntervals = [[Trade]]()
        var intervalOfTrades = [Trade]()
        
        var startTime = start + unixConstants.sevenHours
        let endTime = end + unixConstants.sevenHours
        var timeIntervalEnd = startTime + timeInterval
        
        let timePeriodToSplit: Int = endTime - startTime
        
        let numberOfIntervals = timePeriodToSplit/timeInterval
        
        for i in 0..<numberOfIntervals {
            intervalOfTrades.removeAll()
            
            for trade in trades {
                if (trade.timeInt >= startTime) && (trade.timeInt < timeIntervalEnd) {
                    print(trade.total)
                    intervalOfTrades.append(trade)
                }
            }
            
            tradeHistoryInIntervals.insert(intervalOfTrades, atIndex: i)
            
            startTime += timeInterval
            timeIntervalEnd += timeInterval
            
            print(intervalOfTrades.count)

            
        }
        
        calculateNetValueOfTrades(tradeHistoryInIntervals)
        
        
    }
    
    
    func calculateNetValueOfTrades(trades: [[Trade]]) {
        
        var tradesNetValue = Float()
        var netValuesOfTradeIntervals = [Float]()
   
        for tradeGroup in trades {
            tradesNetValue = 0
            self.netValueReset()
            
            for trade in tradeGroup {
                if trade.type == "buy" {
                    self.totalBuyValue = trade.total + self.totalBuyValue
                } else {
                    self.totalSellValue = trade.total + self.totalSellValue
                }
            }
            
            tradesNetValue = self.totalBuyValue - self.totalSellValue
                print(" TRADES NET VALUE \(tradesNetValue)")
            
            netValuesOfTradeIntervals.append(tradesNetValue)

        }
        
    }
    
    func netValueReset() {
        self.totalSellValue = 0
        self.totalBuyValue = 0
    }
    
    //MARK : Actions
    
    @IBAction func thirtyMinButtonPressed(sender: UIButton) {
        
//        dataManager.getTradeHistory(unixConstants.thirtyMins) { (result) in
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//
//                let start = result.start
//                let end = result.end
//                
//                print("30 min start \(start) end \(end)")
//                let thirtyMinArray = result.trades
//                
//                self.splitTradesIntoTimeIntervals(thirtyMinArray, timeInterval: unixConstants.oneMin, start: start, end: end)
//                
//            })
//        }
        
        dataManager.getTradeHistory(unixConstants.oneMin) { (result) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let start = result.start + unixConstants.sevenHours
                let end  = result.end + unixConstants.sevenHours
                
                print("stort 1 min \(start) NED \(end)")
 
            })
        }
        
        dataManager.getTradeHistory(unixConstants.fiveMins) { (result) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let start = result.start
                let end = result.end
                let fiveMinsArray = result.trades
                
                print("five min start \(start) end \(end) ")
                
                self.splitTradesIntoTimeIntervals(fiveMinsArray, timeInterval: unixConstants.oneMin, start: start, end: end)
            
                
            })
        }
        

        
//        dataManager.getTradeHistory(unixConstants.twelveHours) { (result) in
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            
//                let start = result.start
//                let end = result.end
//                let twelveHourArray = result.trades
//                print("12 hr start \(start) end \(end)")
//                
//                self.splitTradesIntoTimeIntervals(twelveHourArray, timeInterval: unixConstants.thirtyMins, start: start, end: end)
//            
//            })
//        }
//        
//        dataManager.getTradeHistory(unixConstants.twoWeeks) { (result) in
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                
//                let start = result.start
//                let end = result.end
//                let twoWeekArray = result.trades
//                print("2 week start \(start) end \(end)")
//                
//                self.splitTradesIntoTimeIntervals(twoWeekArray, timeInterval: unixConstants.twelveHours, start: start, end: end)
//                
//            })
//        }
        
        
    }


}

// 30 Minutes with 1 minute intervals
// 2 Hours with 5 minute intervals
// 12 Hours with 30 minute intervals
// 2 days with 2 hour intervals
// 15 days with 12 Hour intervals
