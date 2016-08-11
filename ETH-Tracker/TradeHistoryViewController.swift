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
    
    var dataManager = DataManager.sharedManager
    
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
            
//                let indexOfBtcEth = self.pickerData.indexOf("BTC_ETH")
                
                var indexOfSelectedPair: Int
                
                
                if self.dataManager.selectedCurrencyPair == "" {
                     indexOfSelectedPair = self.pickerData.indexOf(self.dataManager.defaultCurrencyPair)!
                } else {
                    indexOfSelectedPair = self.pickerData.indexOf(self.dataManager.selectedCurrencyPair)!
                }
                
                
                
                
                self.picker.reloadAllComponents()
                
                if self.pickerData.count == 0 {
                    print("0")
                } else {
                    
                    
                    self.picker.selectRow(indexOfSelectedPair, inComponent: 0, animated: true)
                }
                
            
              })
        }
        
        
        
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row]
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        dataManager.combineHistory(timeConstants.fifteenMins, timesToCombine: 24) { (result) in
//            
//            let trades = result.trades
//            let info = result.tradeInfo
//            
//            print("COUNT FROM HERE \(trades.count)")
//            print("THE FINAL START \(info.startTimeUnix) END \(info.endTimeUnix)")
//
//            
//        }
//        
//        
//        dataManager.getHistory(timeConstants.sixHours, fromTime: dataManager.currentTime) { (result) in
//            
//            
//            let history = result.tradeInfo
//            
//        print("8 HOUR FUNC: Total buys \(history.totalBuys) value \(history.totalBuyValue). Total sells \(history.totalSells) sell value \(history.totalSellValue). Total trades \(history.totalTrades) value \(history.netValue)")
//            
//            print("START ^HR \(history.startTimeUnix) END ^HR \(history.endTimeUnix)")
//            
//        }
        
    }
    
    //MARK: Actions
    
    @IBAction func setPairButtonPressed(sender: UIButton) {
        
        print("Current Pair = \(dataManager.selectedCurrencyPair)")
        
        let selectedValue = pickerData[picker.selectedRowInComponent(0)]
        
        
        dataManager.selectedCurrencyPair = selectedValue
        
        print("New Pair = \(dataManager.selectedCurrencyPair)")
        
    }

    


}




