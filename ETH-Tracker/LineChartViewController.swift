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
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Net value of trades in BTC")
        let lineChartData =  LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
    }
    
    
    func splitTradesIntoTimeIntervals(trades: [Trade], timeInterval: Int, start: Int, end: Int)  {
        
        var tradeHistoryInIntervals = [[Trade]]()
        var intervalOfTrades = [Trade]()
        
        var startTime = start
        let endTime = end
        
        var timeIntervalEnd = startTime + timeInterval
        
        let timePeriodToSplit: Int = endTime - startTime
        
        let numberOfIntervals = timePeriodToSplit/timeInterval
        
        for i in 0..<numberOfIntervals {
            intervalOfTrades.removeAll()
            
            for trade in trades {
                if (trade.timeInt >= startTime) && (trade.timeInt < timeIntervalEnd) {
                    intervalOfTrades.append(trade)
                }
            }
            
            tradeHistoryInIntervals.insert(intervalOfTrades, atIndex: i)
            
            startTime += timeInterval
            timeIntervalEnd += timeInterval
            
        }
        
        calculateNetValueOfTrades(tradeHistoryInIntervals)
        
        
    }
    
    
    func calculateNetValueOfTrades(trades: [[Trade]]) {
        
        var tradesNetValue = Double()
        var netValuesOfTradeIntervals = [Double]()
        
        getDatesFromTradeHistory(trades)
   
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
    
    func getDatesFromTradeHistory(history: [[Trade]]) {
        
        if dataPointsArray.isEmpty == false {
            dataPointsArray.removeAll()
        }
        
        var datesFromHistory = [String]()
        var trimmedDatesArray = [String]()
        
        for historyInterval in history {
            
            if let dateString = historyInterval.last?.date {
                trimmedDatesArray = dateString.componentsSeparatedByString(" ")
            }
            
            datesFromHistory.append(trimmedDatesArray.last!)
            
        }
        dataPointsArray = datesFromHistory
        
    }
    
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

            dataManager.getHistory(timeConstants.twoHours, fromTime: dataManager.currentTime, completion: { (result) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let historyData = result.tradeInfo
                    let twoHourTrades = result.trades
                    
                    self.intervalLabel.text = "Intervals: Five minutes"
                    
                    self.splitTradesIntoTimeIntervals(twoHourTrades, timeInterval: timeConstants.fiveMins, start: historyData.startTimeUnix, end: historyData.endTimeUnix)
                    self.activityWheel.stopAnimating()
                    
                })
                
            })
        case 2:
            
            self.timePeriodSegmentedControl.userInteractionEnabled = false

            dataManager.getHistory(timeConstants.twelveHours, fromTime: dataManager.currentTime, completion: { (result) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    let historyData = result.tradeInfo
                    let twelveHourTrades = result.trades
                    
                    self.intervalLabel.text = "Intervals: Thirty minutes"
                    
                    self.splitTradesIntoTimeIntervals(twelveHourTrades, timeInterval: timeConstants.thirtyMins, start: historyData.startTimeUnix, end: historyData.endTimeUnix)
                    self.activityWheel.stopAnimating()
                    
                    self.timePeriodSegmentedControl.userInteractionEnabled = true

                })
            })
            


        case 3:
            dataManager.getHistory(timeConstants.twelveHours, fromTime: dataManager.currentTime, completion: { (result) in
                
                    var firstTradesArray = result.trades
                    let firstHistoryData = result.tradeInfo
                    
                    print("first array count \(firstTradesArray.count)")
                    print("first arrays oldest trade =  \(firstTradesArray.last?.date)")

                    
                    let adjustedEndtime = firstHistoryData.startTimeUnix - 1
                    
                    self.dataManager.getHistory(timeConstants.twelveHours, fromTime: adjustedEndtime, completion: { (result) in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                        let secondTradesArray = result.trades
                        let secondHistoryData = result.tradeInfo
                        
                        
                        print("second array count \(secondTradesArray.count)")
                        print("second arrays oldest trade =  \(secondTradesArray.last?.date)")
                        
                        firstTradesArray.appendContentsOf(secondTradesArray)
                        print("combined array count: \(firstTradesArray.count)")
                        print("combined array earliest date: \(firstTradesArray.last?.date)")
                        print("combined array oldest date: \(firstTradesArray.first?.date)")
                        
                        print("combined array start \(firstTradesArray.last?.timeInt) and end \(firstTradesArray.first?.timeInt)")


                        
                        secondHistoryData.endTimeUnix = firstHistoryData.endTimeUnix
                        print("hist data start \(secondHistoryData.startTimeUnix) and end \(secondHistoryData.endTimeUnix)")
                        
                        self.intervalLabel.text = "Intervals: One hour"
                        
                        self.splitTradesIntoTimeIntervals(firstTradesArray, timeInterval: timeConstants.oneHour, start: secondHistoryData.startTimeUnix, end: secondHistoryData.endTimeUnix)
                        self.activityWheel.stopAnimating()
                        
                          })
                    })
                    
   
              
            })

        case 4:
            dataManager.getHistory(timeConstants.twoDays, fromTime: dataManager.currentTime, completion: { (result) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let historyData = result.tradeInfo
                    let twoDayTrades = result.trades
                    
                    self.intervalLabel.text = "Intervals: Two Hours"
                    
                    self.splitTradesIntoTimeIntervals(twoDayTrades, timeInterval: timeConstants.twoHours, start: historyData.startTimeUnix, end: historyData.endTimeUnix)
                    self.activityWheel.stopAnimating()
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
        dataManager.getHistory(timeConstants.thirtyMins, fromTime: dataManager.currentTime, completion: { (result) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let historyData = result.tradeInfo
                let thirtyMinTrades = result.trades
                
                self.intervalLabel.text = "Intervals: One Minute"
                
                self.splitTradesIntoTimeIntervals(thirtyMinTrades, timeInterval: timeConstants.oneMin, start: historyData.startTimeUnix, end: historyData.endTimeUnix)
                self.activityWheel.stopAnimating()
            })
        })
    }
    
}






























