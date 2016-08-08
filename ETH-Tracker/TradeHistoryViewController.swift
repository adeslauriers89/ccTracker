//
//  TradeHistoryViewController.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-04-14.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit

class TradeHistoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Properties
    
    var dataManager = DataManager()
    
    @IBOutlet weak var lastMinuteHistoryLabel: UILabel!
    @IBOutlet weak var lastFiveMinuteHistoryLabel: UILabel!
    @IBOutlet weak var lastThirtyMinuteHistoryLabel: UILabel!
    @IBOutlet weak var lastTwoHourHistoryLabel: UILabel!
    @IBOutlet weak var lastSixHourHistoryLabel: UILabel!
    @IBOutlet weak var lastTwelveHourHistoryLabel: UILabel!
    @IBOutlet weak var lastTwentyFourHourHistoryLabel: UILabel!
    
    
    @IBOutlet weak var picker: UIPickerView!
    
    
    var pickerData = [String]()
    

    //MARK: ViewController Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        dataManager.getCurrencyPairs { (pairs) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.pickerData = pairs
            
                let indexOfBtcEth = self.pickerData.indexOf("BTC_ETH")
                
                self.picker.reloadAllComponents()
                
                if self.pickerData.count == 0 {
                    print("0000000")
                } else {
                    
                    
                    self.picker.selectRow(indexOfBtcEth!, inComponent: 0, animated: true)
                }
                
            
              })
        }
        
        
        
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
     //   print("hihi \(pickerData.count)")
        
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row]
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        dataManager.combineHistory(timeConstants.fifteenMins, timesToCombine: 24) { (result) in
            
            let trades = result.trades
            let info = result.tradeInfo
            
            print("COUNT FROM HERE \(trades.count)")
            print("THE FINAL START \(info.startTimeUnix) END \(info.endTimeUnix)")

            
        }
        
        
        dataManager.getHistory(timeConstants.sixHours, fromTime: dataManager.currentTime) { (result) in
            
            
            let history = result.tradeInfo
            
        print("8 HOUR FUNC: Total buys \(history.totalBuys) value \(history.totalBuyValue). Total sells \(history.totalSells) sell value \(history.totalSellValue). Total trades \(history.totalTrades) value \(history.netValue)")
            
            print("START ^HR \(history.startTimeUnix) END ^HR \(history.endTimeUnix)")
            
        }
        
    }
    
    //MARK: Actions
    
    @IBAction func setPairButtonPressed(sender: UIButton) {
        
        let selectedValue = pickerData[picker.selectedRowInComponent(0)]
        
        print(selectedValue)
        
    }

    


}



//        dataManager.getHistory(timeConstants.twoHours, fromTime: dataManager.currentTime) { (result) in
//            var historyDataArray = [HistoryData]()
//
//            var firstTradesArray = result.trades
//            let firstHistoryData = result.tradeInfo
//            historyDataArray.append(firstHistoryData)
//
//         //   print(firstHistoryData.startTimeUnix)
//
//            var adjustedEndTime = firstHistoryData.startTimeUnix - 1
//
//         //   print("adj \(adjustedEndTime)")
//
//            self.dataManager.getHistory(timeConstants.twoHours, fromTime: adjustedEndTime, completion: { (result) in
//
//                let secondTradesArray = result.trades
//                let secondHistoryData = result.tradeInfo
//                historyDataArray.append(secondHistoryData)
//
//                firstTradesArray.appendContentsOf(secondTradesArray)
//
//                adjustedEndTime = secondHistoryData.startTimeUnix - 1
//               // print("adj \(adjustedEndTime)")
//
//
//                    self.dataManager.getHistory(timeConstants.twoHours, fromTime: adjustedEndTime, completion: { (result) in
//
//                        let thirdTradesArray = result.trades
//                        let thirdHistoryData = result.tradeInfo
//                        historyDataArray.append(thirdHistoryData)
//
//                        firstTradesArray.appendContentsOf(thirdTradesArray)
//
//                        var combinedTotalBuys = Int()
//                        var combinedBuyValue = Double()
//                        var combinedTotalSells = Int()
//                        var combinedSellValue = Double()
//                        var combinedNetValue = Double()
//                        var combinedTotalTrades = Int()
//
//                        for historyData in historyDataArray {
//
//                            combinedTotalBuys += historyData.totalBuys
//                            combinedBuyValue += historyData.totalBuyValue
//                            combinedTotalSells += historyData.totalSells
//                            combinedSellValue += historyData.totalSellValue
//                            combinedNetValue += historyData.netValue
//                            combinedTotalTrades += historyData.totalTrades
//
//                        }
//
//                    //    print("Total buys \(combinedTotalBuys) value \(combinedBuyValue), total sells \(combinedTotalSells) value \(combinedSellValue), total trades \(combinedTotalTrades) value \(combinedNetValue)")
//                    })
//                })
//        }





