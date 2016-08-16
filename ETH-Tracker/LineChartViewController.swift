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
    
    var dataManager = DataManager.sharedManager
    
    var intervals = Int()
    
    var totalBuyValue = Double()
    var totalSellValue = Double()
    var netValueOfTrades = Double()
    
    var dataPointsArray = [String]()
    
    var netValueOfIntervals = [Double]()
    var activityWheel = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    
    @IBOutlet weak var timePeriodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var intervalLabel: UILabel!
    
    //MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityWheel.center = view.center
        activityWheel.hidesWhenStopped = true
        activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityWheel)
        
        view.backgroundColor = UIColor(colorLiteralRed: 217.0/255.0, green: 217.0/255.0 , blue: 217.0/255.0, alpha: 1.0)

     
        lineChartView.delegate = self
        lineChartView.descriptionTextColor = UIColor.blackColor()
        lineChartView.descriptionText = ""
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getHistory30Min()
        
    }
    
    //MARK: Chart Methods
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Net value of trades in \(dataManager.baseCurrency)")
        let lineChartData =  LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
    }
    
    
    func splitTradesIntoTimeIntervals(trades: [Trade], timeInterval: Int, start: Int, end: Int)  {
        
        var tradeHistoryInIntervals = [[Trade]]()
        var intervalOfTrades = [Trade]()
        let tradesToSplit = trades
        
        let realtime = NSDate(timeIntervalSince1970: Double(start))
        
        print("Start in realtime \(realtime))")
        print("START IN 1st \(start)")
        
        var startTime = start
        let endTime = end
        
        var timeIntervalEnd = startTime + timeInterval
        
        let timePeriodToSplit: Int = endTime - startTime
        
        let numberOfIntervals = timePeriodToSplit/timeInterval
        
        for i in 0..<numberOfIntervals {
            intervalOfTrades.removeAll()
            
            for trade in tradesToSplit {
                if (trade.timeInt >= startTime) && (trade.timeInt < timeIntervalEnd) {
                    intervalOfTrades.append(trade)
                    
                }
            }
            
            tradeHistoryInIntervals.insert(intervalOfTrades, atIndex: i)
            
            
            startTime += timeInterval
            timeIntervalEnd += timeInterval
            
        }
        
     //   calculateNetValueOfTrades(tradeHistoryInIntervals)
        getDatesForIntervals(start, timeInterval: timeInterval, numberOfIntervals: numberOfIntervals,trades: tradeHistoryInIntervals)
        
    }
    
    func getDatesForIntervals(startTime: Int, timeInterval: Int, numberOfIntervals: Int, trades: [[Trade]]) {
        
        var dateStringCollection = [String]()
        var startingInterval = startTime
        
        if dataPointsArray.isEmpty == false {
            dataPointsArray.removeAll()
        }
        
        
        for _ in 0..<numberOfIntervals {
            
            let dateForInterval = NSDate(timeIntervalSince1970: Double(startingInterval))
            
      //      print("\(i)date \(dateForInterval)")
            
            let dateString = String(dateForInterval)
            
            let separatedDates = dateString.componentsSeparatedByString(" ")
            
            print(separatedDates[1])
            
            dateStringCollection.append(separatedDates[1])
            
            startingInterval += timeInterval
        }
        
        print(dateStringCollection)
        
        dataPointsArray = dateStringCollection
        
        calculateNetValueOfTrades(trades)
        
    }
    
    
    func calculateNetValueOfTrades(trades: [[Trade]]) {
        
        var tradesNetValue = Double()
        var netValuesOfTradeIntervals = [Double]()

      //  getDatesFromTradeHistory(trades)
   
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
            
            tradesNetValue = Double(self.totalBuyValue - self.totalSellValue)
            
            netValuesOfTradeIntervals.append(tradesNetValue)

        }
        print(netValuesOfTradeIntervals)
        
        setChart(dataPointsArray, values: netValuesOfTradeIntervals)
        
      
    }
    
    func netValueReset() {
        self.totalSellValue = 0
        self.totalBuyValue = 0
    }
    
//    func getDatesFromTradeHistory(history: [[Trade]]) {
//        
//        if dataPointsArray.isEmpty == false {
//            dataPointsArray.removeAll()
//        }
//        
//        var datesFromHistory = [String]()
//        var trimmedDatesArray = [String]()
//        
//        for historyInterval in history {
//            
//            if let dateString = historyInterval.last?.date {
//                trimmedDatesArray = dateString.componentsSeparatedByString(" ")
//            }
//            
//            
//            
//            datesFromHistory.append(trimmedDatesArray.last!)
//            
//        }
//        dataPointsArray = datesFromHistory
//        print("BAd 1 \(datesFromHistory)")
//        
//    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
 
        print("\(entry.value) for the hour of \(dataPointsArray[entry.xIndex])")
    }
    
    
 
    //MARK : Actions
    
    
    @IBAction func timePeriodSelected(sender: UISegmentedControl) {
        activityWheel.startAnimating()
        
        switch timePeriodSegmentedControl.selectedSegmentIndex {
        case 0:
        
            getHistory30Min()
            
        case 1:
            
            self.timePeriodSegmentedControl.userInteractionEnabled = false
            
            dataManager.combineHistory(timeConstants.thirtyMins, timesToCombine: 4, completion: { (result) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let historyData = result.tradeInfo
                    let twoHourTrades = result.trades
                    
                    self.intervalLabel.text = "Intervals: 5 Minutes"
                    
                    self.splitTradesIntoTimeIntervals(twoHourTrades, timeInterval: timeConstants.fiveMins, start: historyData.startTimeUnix, end: historyData.endTimeUnix)
                    self.activityWheel.stopAnimating()
                    
                    self.timePeriodSegmentedControl.userInteractionEnabled = true
                    
                })
            })
            
        case 2:
            
            self.timePeriodSegmentedControl.userInteractionEnabled = false
            
            dataManager.combineHistory(timeConstants.oneHour, timesToCombine: 6, completion: { (result) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let historyData = result.tradeInfo
                    let sixHourTrades = result.trades
                    
                    self.intervalLabel.text = "Intervals: 15 Minutes"
                    
                    self.splitTradesIntoTimeIntervals(sixHourTrades, timeInterval: timeConstants.fifteenMins, start: historyData.startTimeUnix, end: historyData.endTimeUnix)
                    self.activityWheel.stopAnimating()
                    
                    
                    self.timePeriodSegmentedControl.userInteractionEnabled = true
                    
                })
            })
        
        case 3:
            
            
            self.timePeriodSegmentedControl.userInteractionEnabled = false
            
            
            dataManager.combineHistory(timeConstants.oneHour, timesToCombine: 12, completion: { (result) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    let historyData = result.tradeInfo
                    let twelveHourTrades = result.trades
                    
                    self.intervalLabel.text = "Intervals: 30 Minutes"
                    
                    self.splitTradesIntoTimeIntervals(twelveHourTrades, timeInterval: timeConstants.thirtyMins, start: historyData.startTimeUnix, end: historyData.endTimeUnix)
                    self.activityWheel.stopAnimating()
                    
                    self.timePeriodSegmentedControl.userInteractionEnabled = true
                    
                })
            })

        case 4:
            
            self.timePeriodSegmentedControl.userInteractionEnabled = false
            
            dataManager.combineHistory(timeConstants.oneHour, timesToCombine: 24, completion: { (result) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    let historyData = result.tradeInfo
                    let oneDayTrades = result.trades
                    
                    self.intervalLabel.text = "Intervals: 1 Hour"
                    
                    self.splitTradesIntoTimeIntervals(oneDayTrades, timeInterval: timeConstants.oneHour, start: historyData.startTimeUnix, end: historyData.endTimeUnix)
                    self.activityWheel.stopAnimating()
                    
                    self.timePeriodSegmentedControl.userInteractionEnabled = true
                    
                })
            })


        default:
            break
        }
    }

    @IBAction func saveChartButtonPressed(sender: UIBarButtonItem) {
        lineChartView.saveToCameraRoll()
        
    }
    
    func getHistory30Min() {
        self.timePeriodSegmentedControl.userInteractionEnabled = false
        
        
        dataManager.getHistory(timeConstants.thirtyMins, fromTime: dataManager.currentTime, completion: { (result) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let historyData = result.tradeInfo
                let thirtyMinTrades = result.trades
                
                self.intervalLabel.text = "Intervals: 1 Minute"
                
                self.splitTradesIntoTimeIntervals(thirtyMinTrades, timeInterval: timeConstants.oneMin, start: historyData.startTimeUnix, end: historyData.endTimeUnix)
                self.activityWheel.stopAnimating()
                
                self.timePeriodSegmentedControl.userInteractionEnabled = true

                
            })
        })
    }
    
}






























