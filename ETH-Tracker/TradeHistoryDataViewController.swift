//
//  TradeHistoryDataViewController.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-07-05.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit

class TradeHistoryDataViewController: UIViewController {
    
    //MARK: Properties
    
    var dataManager = DataManager()
    
    // one min view & labels
    
    @IBOutlet weak var oneMinView: UIView!
    @IBOutlet weak var oneMinTotalBuysLabel: UILabel!
    @IBOutlet weak var oneMinBuysValueLabel: UILabel!
    @IBOutlet weak var oneMinTotalSellsLabel: UILabel!
    @IBOutlet weak var oneMinSellsValueLabel: UILabel!
    @IBOutlet weak var oneMinTotalTradesLabel: UILabel!
    @IBOutlet weak var oneMinNetValueLabel: UILabel!
    @IBOutlet weak var oneMinRefreshButton: UIButton!

    
    // 5 min view & labels
    
    @IBOutlet weak var fiveMinView: UIView!
    @IBOutlet weak var fiveMinTotalBuysLabel: UILabel!
    @IBOutlet weak var fiveMinBuysValueLabel: UILabel!
    @IBOutlet weak var fiveMinTotalSellsLabel: UILabel!
    @IBOutlet weak var fiveMinSellsValueLabel: UILabel!
    @IBOutlet weak var fiveMinTotalTradesLabel: UILabel!
    @IBOutlet weak var fiveMinNetValueLabel: UILabel!
    @IBOutlet weak var fiveMinRefreshButton: UIButton!
    
    // 30 min view & labels
    
    @IBOutlet weak var thirtyMinView: UIView!
    @IBOutlet weak var thirtyMinTotalBuysLabel: UILabel!
    @IBOutlet weak var thirtyMinBuysValueLabel: UILabel!
    @IBOutlet weak var thirtyMinTotalSellsLabel: UILabel!
    @IBOutlet weak var thirtyMinSellsValueLabel: UILabel!
    @IBOutlet weak var thirtyMinTotalTradesLabel: UILabel!
    @IBOutlet weak var thirtyMinNetValueLabel: UILabel!
    @IBOutlet weak var thirtyMinRefreshButton: UIButton!
    let thirtyMinActivityWheel = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    
    // 2 hr view & labels
    
    @IBOutlet weak var twoHourView: UIView!
    @IBOutlet weak var twoHourTotalBuysLabel: UILabel!
    @IBOutlet weak var twoHourBuysValueLabel: UILabel!
    @IBOutlet weak var twoHourTotalSellsLabel: UILabel!
    @IBOutlet weak var twoHourSellsValueLabel: UILabel!
    @IBOutlet weak var twoHourTotalTradesLabel: UILabel!
    @IBOutlet weak var twoHourNetValueLabel: UILabel!
    @IBOutlet weak var twoHourRefreshButton: UIButton!
    
    // 12 hr view & labels
    
    @IBOutlet weak var twelveHourView: UIView!
    @IBOutlet weak var twelveHourTotalBuysLabel: UILabel!
    @IBOutlet weak var twelveHourBuysValueLabel: UILabel!
    @IBOutlet weak var twelveHourTotalSellsLabel: UILabel!
    @IBOutlet weak var twelveHourSellsValueLabel: UILabel!
    @IBOutlet weak var twelveHourTotalTradesLabel: UILabel!
    @IBOutlet weak var twelveHourNetValueLabel: UILabel!
    @IBOutlet weak var twelveHourRefreshButton: UIButton!
    
    // 24 hr view & labels
    
    @IBOutlet weak var oneDayView: UIView!
    @IBOutlet weak var oneDayTotalBuysLabel: UILabel!
    @IBOutlet weak var oneDayBuysValueLabel: UILabel!
    @IBOutlet weak var oneDayTotalSellsLabel: UILabel!
    @IBOutlet weak var oneDaySellsValueLabel: UILabel!
    @IBOutlet weak var oneDayTotalTradesLabel: UILabel!
    @IBOutlet weak var oneDayNetValueLabel: UILabel!
    @IBOutlet weak var oneDayRefreshButton: UIButton!
    

    //MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(colorLiteralRed: 217.0/255.0, green: 217.0/255.0 , blue: 217.0/255.0, alpha: 1.0)
            

        thirtyMinActivityWheel.center = thirtyMinView.center
        thirtyMinActivityWheel.hidesWhenStopped = true
        thirtyMinActivityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        thirtyMinView.addSubview(thirtyMinActivityWheel)

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchOneMinuteData()
        fetchFiveMinuteData()
        fetchThirtyMinuteData()
       // fetchTwoHourData()
        fetchTwelveHourData()
       // fetchOneDayData()
        
        
        
        configureViewStyle()
        

        

        }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    //MARK: Data Functions
    
    func fetchOneMinuteData() {
        
        dataManager.getHistory(timeConstants.oneMin, fromTime: dataManager.currentTime) { (result) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in

                
                let tradeHistoryData = result.tradeInfo
                
                self.oneMinTotalBuysLabel.text = "Buys: \(tradeHistoryData.totalBuys)"
                self.oneMinBuysValueLabel.text = String(format:"Buys Value: %0.3fBTC", tradeHistoryData.totalBuyValue)
                self.oneMinTotalSellsLabel.text = "Sells: \(tradeHistoryData.totalSells)"
                self.oneMinSellsValueLabel.text = String(format:"Sells Value: %0.3fBTC", tradeHistoryData.totalSellValue)
                self.oneMinTotalTradesLabel.text = "Total Trades: \(tradeHistoryData.totalTrades)"
                
                if tradeHistoryData.netValue >= 0.0 {
                    self.oneMinNetValueLabel.textColor = UIColor.greenColor()
                } else if tradeHistoryData.netValue <= 0.0 {
                    self.oneMinNetValueLabel.textColor = UIColor.redColor()
                } else {
                    self.oneMinNetValueLabel.textColor = UIColor.blackColor()
                }
                
                self.oneMinNetValueLabel.text = String(format: "%0.3fBTC", tradeHistoryData.netValue)
                

            })
        }
    }
    
    func fetchFiveMinuteData() {
        dataManager.getHistory(timeConstants.fiveMins, fromTime: dataManager.currentTime) { (result) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let tradeHistoryData = result.tradeInfo
                
                self.fiveMinTotalBuysLabel.text = "Buys: \(tradeHistoryData.totalBuys)"
                self.fiveMinBuysValueLabel.text = String(format:"Buys Value: %0.3fBTC", tradeHistoryData.totalBuyValue)
                self.fiveMinTotalSellsLabel.text = "Sells: \(tradeHistoryData.totalSells)"
                self.fiveMinSellsValueLabel.text = String(format:"Sells Value: %0.3fBTC", tradeHistoryData.totalSellValue)
                self.fiveMinTotalTradesLabel.text = "Total Trades: \(tradeHistoryData.totalTrades)"
                
                if tradeHistoryData.netValue >= 0.0 {
                    self.fiveMinNetValueLabel.textColor = UIColor.greenColor()
                } else if tradeHistoryData.netValue <= 0.0 {
                    self.fiveMinNetValueLabel.textColor = UIColor.redColor()
                } else {
                    self.fiveMinNetValueLabel.textColor = UIColor.blackColor()
                }
                
                self.fiveMinNetValueLabel.text = String(format: "%0.3fBTC", tradeHistoryData.netValue)
            })
        }
    }
    
    func fetchThirtyMinuteData() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        

        dataManager.getHistory(timeConstants.thirtyMins, fromTime: dataManager.currentTime) { (result) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.thirtyMinActivityWheel.startAnimating()

                
                let tradeHistoryData = result.tradeInfo
                
                self.thirtyMinTotalBuysLabel.text = "Buys: \(tradeHistoryData.totalBuys)"
                self.thirtyMinBuysValueLabel.text = String(format:"Buys Value: %0.3fBTC", tradeHistoryData.totalBuyValue)
                self.thirtyMinTotalSellsLabel.text = "Sells: \(tradeHistoryData.totalSells)"
                self.thirtyMinSellsValueLabel.text = String(format:"Sells Value: %0.3fBTC", tradeHistoryData.totalSellValue)
                self.thirtyMinTotalTradesLabel.text = "Total Trades: \(tradeHistoryData.totalTrades)"
                
                if tradeHistoryData.netValue >= 0.0 {
                    self.thirtyMinNetValueLabel.textColor = UIColor.greenColor()
                } else if tradeHistoryData.netValue <= 0.0 {
                    self.thirtyMinNetValueLabel.textColor = UIColor.redColor()
                } else {
                    self.thirtyMinNetValueLabel.textColor = UIColor.blackColor()
                }
                
                self.thirtyMinNetValueLabel.text = String(format: "%0.3fBTC", tradeHistoryData.netValue)
                self.thirtyMinActivityWheel.stopAnimating()

                
            })
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func fetchTwoHourData() {
        dataManager.getHistory(timeConstants.twoHours, fromTime: dataManager.currentTime) { (result) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let tradeHistoryData = result.tradeInfo
                
                self.twoHourTotalBuysLabel.text = "Buys: \(tradeHistoryData.totalBuys)"
                self.twoHourBuysValueLabel.text = String(format:"Buys Value: %0.3fBTC", tradeHistoryData.totalBuyValue)
                self.twoHourTotalSellsLabel.text = "Sells: \(tradeHistoryData.totalSells)"
                self.twoHourSellsValueLabel.text = String(format:"Sells Value: %0.3fBTC", tradeHistoryData.totalSellValue)
                self.twoHourTotalTradesLabel.text = "Total Trades: \(tradeHistoryData.totalTrades)"
                
                if tradeHistoryData.netValue >= 0.0 {
                    self.twoHourNetValueLabel.textColor = UIColor.greenColor()
                } else if tradeHistoryData.netValue <= 0.0 {
                    self.twoHourNetValueLabel.textColor = UIColor.redColor()
                } else {
                    self.twoHourNetValueLabel.textColor = UIColor.blackColor()
                }
                
                self.twoHourNetValueLabel.text = String(format: "%0.3fBTC", tradeHistoryData.netValue)
            })
        }
    }
    
    func fetchTwelveHourData() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        dataManager.getHistory(timeConstants.twelveHours, fromTime: dataManager.currentTime) { (result) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let tradeHistoryData = result.tradeInfo
                
                
                self.twelveHourTotalBuysLabel.text = "Buys: \(tradeHistoryData.totalBuys)"
                self.twelveHourBuysValueLabel.text = String(format:"Buys Value: %0.3fBTC", tradeHistoryData.totalBuyValue)
                self.twelveHourTotalSellsLabel.text = "Sells: \(tradeHistoryData.totalSells)"
                self.twelveHourSellsValueLabel.text = String(format:"Sells Value: %0.3fBTC", tradeHistoryData.totalSellValue)
                self.twelveHourTotalTradesLabel.text = "Total Trades: \(tradeHistoryData.totalTrades)"
                
                if tradeHistoryData.netValue >= 0.0 {
                    self.twelveHourNetValueLabel.textColor = UIColor.greenColor()
                } else if tradeHistoryData.netValue <= 0.0 {
                    self.twelveHourNetValueLabel.textColor = UIColor.redColor()
                } else {
                    self.twelveHourNetValueLabel.textColor = UIColor.blackColor()
                }
                
                self.twelveHourNetValueLabel.text = String(format: "%0.3fBTC", tradeHistoryData.netValue)
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
        }
    }
    
    func fetchOneDayData() {
        dataManager.getHistory(timeConstants.twelveHours, fromTime: dataManager.currentTime, completion: { (result) in
            
            var firstTradesArray = result.trades
            let firstHistoryData = result.tradeInfo

            
            let adjustedEndtime = firstHistoryData.startTimeUnix - 1
            
            self.dataManager.getHistory(timeConstants.twelveHours, fromTime: adjustedEndtime, completion: { (result) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let secondTradesArray = result.trades
                    let secondHistoryData = result.tradeInfo

                    firstTradesArray.appendContentsOf(secondTradesArray)

                    secondHistoryData.endTimeUnix = firstHistoryData.endTimeUnix
                    
                    let combinedHistoryData = HistoryData(totalBuys: firstHistoryData.totalBuys + secondHistoryData.totalBuys, totalBuyValue: firstHistoryData.totalBuyValue + secondHistoryData.totalBuyValue, totalSells: firstHistoryData.totalSells + secondHistoryData.totalSells, totalSellValue: firstHistoryData.totalSellValue + secondHistoryData.totalSellValue, netValue: firstHistoryData.netValue + secondHistoryData.netValue, totalTrades: firstHistoryData.totalTrades + secondHistoryData.totalTrades)
                    
                   print("Combined data: Buys: \(combinedHistoryData.totalBuys), B Values: \(combinedHistoryData.totalBuyValue), Sells: \(combinedHistoryData.totalSells), S values: \(combinedHistoryData.totalSellValue), Total trades: \(combinedHistoryData.totalTrades) net value: \(combinedHistoryData.netValue)")
                    
                    
                    self.oneDayTotalBuysLabel.text = "Buys: \(combinedHistoryData.totalBuys)"
                    self.oneDayBuysValueLabel.text = String(format:"Buys Value: %0.3fBTC", combinedHistoryData.totalBuyValue)
                    self.oneDayTotalSellsLabel.text = "Sells: \(combinedHistoryData.totalSells)"
                    self.oneDaySellsValueLabel.text = String(format:"Sells Value: %0.3fBTC", combinedHistoryData.totalSellValue)
                    self.oneDayTotalTradesLabel.text = "Total Trades: \(combinedHistoryData.totalTrades)"
                    
                    if combinedHistoryData.netValue >= 0.0 {
                        self.oneDayNetValueLabel.textColor = UIColor.greenColor()
                    } else if combinedHistoryData.netValue <= 0.0 {
                        self.oneDayNetValueLabel.textColor = UIColor.redColor()
                    } else {
                        self.oneDayNetValueLabel.textColor = UIColor.blackColor()
                    }
                    
                    self.oneDayNetValueLabel.text = String(format: "%0.3fBTC", combinedHistoryData.netValue)
                    
                })
            })
            
        })
        
        
        
    }
    
    //MARK: UI Functions
    
    func configureViewStyle() {
        
//        var activityWheel = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
//        
//        activityWheel.center = view.center
//        activityWheel.hidesWhenStopped = true
//        activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        view.addSubview(activityWheel)
        
//        oneMinActivityWheel.center = oneMinView.center
//        oneMinActivityWheel.hidesWhenStopped = true
//        oneMinActivityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        view.addSubview(oneMinActivityWheel)
//        
        oneMinView.layer.borderWidth = 1.0
        oneMinView.layer.borderColor = UIColor.blackColor().CGColor
        oneMinView.layer.cornerRadius = 5.0
        oneMinRefreshButton.layer.cornerRadius = 5.0
        
        fiveMinView.layer.borderWidth = 1.0
        fiveMinView.layer.borderColor = UIColor.blackColor().CGColor
        fiveMinView.layer.cornerRadius = 5.0
        fiveMinRefreshButton.layer.cornerRadius = 5.0
        
        thirtyMinView.layer.borderWidth = 1.0
        thirtyMinView.layer.borderColor = UIColor.blackColor().CGColor
        thirtyMinView.layer.cornerRadius = 5.0
        thirtyMinRefreshButton.layer.cornerRadius = 5.0
        
        twoHourView.layer.borderWidth = 1.0
        twoHourView.layer.borderColor = UIColor.blackColor().CGColor
        twoHourView.layer.cornerRadius = 5.0
        twoHourRefreshButton.layer.cornerRadius = 5.0

        twelveHourView.layer.borderWidth = 1.0
        twelveHourView.layer.borderColor = UIColor.blackColor().CGColor
        twelveHourView.layer.cornerRadius = 5.0
        twelveHourRefreshButton.layer.cornerRadius = 5.0
        
        oneDayView.layer.borderWidth = 1.0
        oneDayView.layer.borderColor = UIColor.blackColor().CGColor
        oneDayView.layer.cornerRadius = 5.0
        oneDayRefreshButton.layer.cornerRadius = 5.0

    }
    
    
    //MARK: Actions
    
    
    @IBAction func refreshOneMinButtonPressed(sender: UIButton) {
        fetchOneMinuteData()
    }
    
    @IBAction func refreshFiveMinButtonPressed(sender: UIButton) {
        fetchFiveMinuteData()
    }
    
    @IBAction func refreshThirtyMinButtonPressed(sender: UIButton) {
        fetchThirtyMinuteData()
    }
    
    @IBAction func refreshTwoHourButtonPressed(sender: UIButton) {
        fetchTwoHourData()
    }
    
    @IBAction func refreshTwelveHourButtonPressed(sender: UIButton) {
        fetchTwelveHourData()
    }
    
    @IBAction func refreshOneDayButtonPressed(sender: UIButton) {
        fetchOneDayData()
    }
        
    }




    


