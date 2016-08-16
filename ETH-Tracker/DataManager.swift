//
//  DataManager.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-03-29.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import Foundation
import UIKit


class DataManager {

    static let sharedManager = DataManager()
    
    //static let pair = "currencyPair"
    
//    var selectedCurrencyPair: String = "BTC_ETH" {
//        didSet {
//            print("The value of myProperty changed from \(oldValue) to \(selectedCurrencyPair)")
//        }
//    }
    
    var selectedCurrencyPair: String = ""
    
    var defaultCurrencyPair: String {
        get {
            if let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("currencyPair") as? String {
                return returnValue
            } else {
                return "BTC_ETH"
            }
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "currencyPair")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var baseCurrency: String = ""
    
    var quoteCurrency: String = ""

    
    
   // let session =  NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    
    
    var dataTasks = [NSURLSessionDataTask]()
    
    var currentTime: Int {
        get {
            return Int(NSDate().timeIntervalSince1970)
        }
    }
    
    func splitCurrencyPair() {
        
        var pairToSplit = selectedCurrencyPair
        
        if pairToSplit == "" {
            pairToSplit = defaultCurrencyPair
        }
        
        let splitPairArray = pairToSplit.componentsSeparatedByString("_")
        
        print(splitPairArray)
        
        baseCurrency = splitPairArray[0]
        quoteCurrency = splitPairArray[1]
        
        print("Base \(baseCurrency)")
        print("Quote \(quoteCurrency)")
    }
    
//    func getCurrencyPairs(completion:[String] -> Void) {
//        
//        let urlPath = "https://poloniex.com/public?command=returnTicker"
//        let endPoint = NSURL(string: urlPath)
//        var currencyPairs = [String]()
//        
//        let currencyPairTask = NSURLSession.sharedSession().dataTaskWithURL(endPoint!) { (data, response, error) -> Void in
//            
//            if error != nil {
//                let currentVC = self.findCurrentVC()
//                
//                let alertController = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .Alert)
//                let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
//                    return
//                })
//                
//                alertController.addAction(okAction)
//                
//                dispatch_async(dispatch_get_main_queue(), {
//                    currentVC!.presentViewController(alertController, animated: true, completion: nil)
//                })
//                print("ERROR: \(error)")
//            }
//            
//            if let unWrappedData = data {
//                guard let fetchedPairs = (try? NSJSONSerialization.JSONObjectWithData(unWrappedData, options: NSJSONReadingOptions.AllowFragments) as! [String : AnyObject]) else {return}
//                
//                for pair in fetchedPairs {
//                    let pairName = pair.0
//                    
//                    currencyPairs.append(pairName)
//                }
//            }
//            completion(currencyPairs)
//        }
//        currencyPairTask.resume()
//    }

    
    func getCurrencyPairs(completion:[CurrencyPair] -> Void) {
        
        let urlPath = "https://poloniex.com/public?command=returnTicker"
        let endPoint = NSURL(string: urlPath)
        var currencyPairs = [CurrencyPair]()
        
        let currencyPairTask = NSURLSession.sharedSession().dataTaskWithURL(endPoint!) { (data, response, error) -> Void in
            
            if error != nil {
                let currentVC = self.findCurrentVC()
                
                let alertController = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
                    return
                })
                
                alertController.addAction(okAction)
                
                dispatch_async(dispatch_get_main_queue(), {
                    currentVC!.presentViewController(alertController, animated: true, completion: nil)
                })
                print("ERROR: \(error)")
            }
            
            if let unWrappedData = data {
                guard let fetchedPairs = (try? NSJSONSerialization.JSONObjectWithData(unWrappedData, options: NSJSONReadingOptions.AllowFragments) as! [String : AnyObject]) else {return}
                
                
                
                for pair in fetchedPairs {
                    let newPair = CurrencyPair(name: pair.0)
                    
                    let splitPairArray = newPair.name.componentsSeparatedByString("_")
                    
                    newPair.baseCurrency = splitPairArray[0]
                    newPair.quoteCurrency = splitPairArray[1]
                    
                    
                    currencyPairs.append(newPair)
                }
            }
            completion(currencyPairs)
        }
        currencyPairTask.resume()
    }
    
    func getTicker(forPair: String,completion:(Ticker) -> Void) {
        
        let urlPath = "https://poloniex.com/public?command=returnTicker"
        let endPoint = NSURL(string: urlPath)
        
        var chosenPair = forPair
        
        if chosenPair == "" {
            
            chosenPair = defaultCurrencyPair
        }
        
        let tickerTask = NSURLSession.sharedSession().dataTaskWithURL(endPoint!) { (data, response, error) -> Void in
            
            if error != nil {
                let currentVC = self.findCurrentVC()
                
                let alertController = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
                    return
                })
                
                alertController.addAction(okAction)
                
                dispatch_async(dispatch_get_main_queue(), {
                    currentVC!.presentViewController(alertController, animated: true, completion: nil)
                })
                print("ERROR: \(error)")
            }
            
            if let unWrappedData = data {
                guard let fetchedTicker = (try? NSJSONSerialization.JSONObjectWithData(unWrappedData, options: NSJSONReadingOptions.AllowFragments) as! [String : AnyObject]) else  {return}
                
//                if let eth: AnyObject = fetchedTicker["BTC_ETH"] {
//                    if let ethTickerDict = eth as? [String : AnyObject] {
//                        
//                        guard let currentPrice = ethTickerDict["last"]?.doubleValue,
//                            var percentChange = ethTickerDict["percentChange"]?.doubleValue,
//                            let volume = ethTickerDict["baseVolume"]?.doubleValue,
//                            let high24Hr = ethTickerDict["high24hr"]?.doubleValue,
//                            let low24Hr = ethTickerDict["low24hr"]?.doubleValue else {return}
//                        
//                        percentChange *= 100
//                        
//                        let ethTicker = Ticker(currentPrice: currentPrice, percentChange: percentChange, volume: volume, high24Hr: high24Hr, low24Hr: low24Hr)
//                        
//                        completion(ethTicker)
//                    }
//                }
                
                if let pair: AnyObject = fetchedTicker[chosenPair] {
                    if let pairTickerDict = pair as? [String : AnyObject] {
                        
                        guard let currentPrice = pairTickerDict["last"]?.doubleValue,
                            var percentChange = pairTickerDict["percentChange"]?.doubleValue,
                            let volume = pairTickerDict["baseVolume"]?.doubleValue,
                            let high24Hr = pairTickerDict["high24hr"]?.doubleValue,
                            let low24Hr = pairTickerDict["low24hr"]?.doubleValue else {return}
                        
                        percentChange *= 100
                        
                        let pairTicker = Ticker(currentPrice: currentPrice, percentChange: percentChange, volume: volume, high24Hr: high24Hr, low24Hr: low24Hr)
                        
                        print("Curr price \(pairTicker.currentPrice) High \(pairTicker.high24Hr) lo \(pairTicker.low24Hr)")
                        
                        
                        completion(pairTicker)
                    }
                }
                ///////////////
                
                ////
            } else {
                print("No connection")
            }
        }
        tickerTask.resume()
        
    }
    

    
    func fetchOrderBook(forPair: String,completion:(result:(totalBuys: Int, buysValue: Double, totalSells: Int, sellsValue: Double)) -> Void ) {
        
        var totalAmountPendingBuys: Double = 0.0
        var totalAmountPendingSells: Double = 0.0
        var buyOrdersArray = [Order]()
        var sellOrdersArray = [Order]()
        var currentPrice = Double()
        
        var pairToSearch = forPair
        
        if pairToSearch == "" {
            pairToSearch = defaultCurrencyPair
        }
        
        
        
        let url = "https://poloniex.com/public?command=returnOrderBook&currencyPair=\(pairToSearch)&depth=500"
        
        let orderTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) -> Void in
            
            
            if let unWrappedData = data {
                if let fetchedOrders = (try? NSJSONSerialization.JSONObjectWithData(unWrappedData, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]) {
                    
                    let fetchedBuyOrders = fetchedOrders["bids"] as! [AnyObject]
                    
                    
                    for buy in fetchedBuyOrders {
                        
                        guard let price = buy[0].doubleValue,
                            let amount = buy[1].doubleValue else {return}
                        
                        let newBuy = Order(price: price, amount: amount)
                        
                        totalAmountPendingBuys = newBuy.amount + totalAmountPendingBuys
                        
                        buyOrdersArray.append(newBuy)
                    }
                    
                    let fetchedSellOrders = fetchedOrders["asks"] as! [AnyObject]
                    
                    for sell in fetchedSellOrders {
                        
                        guard let price = sell[0].doubleValue,
                            let amount = sell[1].doubleValue else {return}
                        
                        let newSell = Order(price: price, amount: amount)
                        
                        totalAmountPendingSells = newSell.amount + totalAmountPendingSells
                        sellOrdersArray.append(newSell)
                    }
                }
            } else {
                print("no connection or no data recieved")
            }
            
            self.getTicker(pairToSearch, completion: { (Ticker) in
                
        
                
                currentPrice = Ticker.currentPrice
                
                self.findOrdersWithinOnePercentCurrentPrice(buyOrdersArray, sellOrders: sellOrdersArray, currentPrice: currentPrice, completion: { (result) in
                    
                    completion(result: (totalBuys: result.totalBuys, buysValue: result.buysValue, totalSells: result.totalSells, sellsValue: result.sellsValue))
                    
                })
                
            })
            
        }
        
        orderTask.resume()
    }
    
    
    func findOrdersWithinOnePercentCurrentPrice(buyOrders: [Order], sellOrders: [Order],currentPrice: Double, completion: (result: (totalBuys: Int, buysValue: Double, totalSells: Int, sellsValue: Double) ) -> Void )  {
        
        var sellsWithinOnePercent = [Order]()
        var totalValueSellsWithinOnePercent:Double = 0.0
        var buysWithinOnePercent = [Order]()
        var totalValueBuysWithinOnePercent:Double = 0.0
        
        
        for order in sellOrders {
            let difference: Double = currentPrice / order.price
            
            if difference >= 0.99009900 {
                sellsWithinOnePercent.append(order)
                
                totalValueSellsWithinOnePercent = order.amount + totalValueSellsWithinOnePercent
            }
        }
        
        for order in buyOrders {
            let difference: Double = currentPrice / order.price
            
            if difference <= 1.01010101 {
                buysWithinOnePercent.append(order)
                
                totalValueBuysWithinOnePercent = order.amount + totalValueBuysWithinOnePercent
                
            }
        }
        
        completion(result: (totalBuys: buysWithinOnePercent.count, buysValue: totalValueBuysWithinOnePercent, totalSells: sellsWithinOnePercent.count, sellsValue: totalValueSellsWithinOnePercent))
    }

    
    
    func getHistory(forTimePeriod: Int, fromTime: Int,completion: (result: (trades: [Trade], tradeInfo: HistoryData) ) -> Void) {
        
        var completedTrades = [Trade]()
        let startTime = fromTime - forTimePeriod
//        let currencyPair = "BTC_ETH"
        var currencyPair = selectedCurrencyPair
        if currencyPair == "" {
            currencyPair = defaultCurrencyPair
        }
        let urlPath = "https://poloniex.com/public?command=returnTradeHistory&currencyPair=\(currencyPair)&start=\(startTime)&end=\(fromTime)"
        
        let historyTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlPath)!) { (data, response, error) -> Void in
            
            if error != nil {
                let currentVC = self.findCurrentVC()
                
                let alertController = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
                    return
                })
                
                alertController.addAction(okAction)
                
                dispatch_async(dispatch_get_main_queue(), {
                    currentVC!.presentViewController(alertController, animated: true, completion: nil)
                })
                print("ERROR: \(error)")
            }
            
            if let unWrappedData = data {
                if let fetchedHistory = (try? NSJSONSerialization.JSONObjectWithData(unWrappedData, options: NSJSONReadingOptions.AllowFragments) as!
                    [[String: AnyObject]]) {
                    
                    for completedTrade in fetchedHistory {
                        
                        guard let date = completedTrade["date"] as? String,
                            let type = completedTrade["type"] as? String,
                            let rate = completedTrade["rate"]?.doubleValue,
                            let amount = completedTrade["amount"]?.doubleValue,
                            let total = completedTrade["total"]?.doubleValue else {return}
                        
                        let timeInt = self.timeStampToUnix(date)
                        
                        let newTrade = Trade(date: date, type: type, timeInt: timeInt, rate: rate, amount: amount, total: total)
                        
                        completedTrades.append(newTrade)
                    }
                }
            }
            
            let tradeInfo = self.caluclateHistoryData(completedTrades)
            tradeInfo.startTimeUnix = startTime
            tradeInfo.endTimeUnix = fromTime

            completion(result: (trades: completedTrades, tradeInfo: tradeInfo))
            
        }
//        dataTasks.append(historyTask)
        historyTask.resume()
        
    }
    
    func combineHistory(timePeriod: Int, timesToCombine: Int, completion:(result: (trades: [Trade], tradeInfo: HistoryData)) -> Void) {
        
        let group = dispatch_group_create()
        
        var fetchedTrades = [Trade]()
        var fetchedHistoryData = [HistoryData]()
        var timeToSearchFrom = currentTime
    
        for i in 0..<timesToCombine {

            if (i == timesToCombine - 1) {
                dispatch_group_enter(group)
                getHistory(timePeriod - i, fromTime: timeToSearchFrom, completion: { (result) in
                    
                    let trades = result.trades
                    let tradeInfo = result.tradeInfo
                    
                    fetchedTrades.appendContentsOf(trades)
                    
                    fetchedHistoryData.append(tradeInfo)
                    
                    print("trades count \(fetchedTrades.count)")
                    print("Time number : \(i)")
                    print("Start \(tradeInfo.startTimeUnix) End \(tradeInfo.endTimeUnix)")
                    
                    dispatch_group_leave(group)
                })
            } else {
                
                dispatch_group_enter(group)
                getHistory(timePeriod, fromTime: timeToSearchFrom, completion: { (result) in
                    
                    let trades = result.trades
                    let tradeInfo = result.tradeInfo
                    
                    fetchedTrades.appendContentsOf(trades)
                    fetchedHistoryData.append(tradeInfo)
                    
//                    print("trades count \(fetchedTrades.count)")
//                    print("Time number : \(i)")
//                    print("Start \(tradeInfo.startTimeUnix) End \(tradeInfo.endTimeUnix)")

                    dispatch_group_leave(group)
                })
                

            }
            
            timeToSearchFrom -= timePeriod + 1
            
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { 
            
            
            print("HIST DATA COUNT \(fetchedHistoryData.count)")
            print("TRADES COUNTTTTT \(fetchedTrades.count)")
                        
            let histData = self.combineHistoryData(fetchedHistoryData)
            
            print("COMBINED HIST DATA: Total buys \(histData.totalBuys) value \(histData.totalBuyValue). Total sells \(histData.totalSells) value \(histData.totalSellValue). Total Trades \(histData.totalTrades) value \(histData.netValue)")
            
            
            
            
            completion(result: (trades: fetchedTrades, tradeInfo: histData))

        }

    }
    
    
    func combineHistoryData(dataToCombine: [HistoryData]) -> HistoryData{
        
        var combinedTotalBuys = Int()
        var combinedBuyValue = Double()
        var combinedTotalSells = Int()
        var combinedSellValue = Double()
        var combinedTotalTrades = Int()
        var combinedNetValue = Double()
        
        var startTimes = [Int]()
        var endTimes = [Int]()
        
        for data in dataToCombine {
            
            combinedTotalBuys += data.totalBuys
            combinedBuyValue += data.totalBuyValue
            combinedTotalSells += data.totalSells
            combinedSellValue += data.totalSellValue
            combinedNetValue += data.netValue
            combinedTotalTrades += data.totalTrades
            
            startTimes.append(data.startTimeUnix)
            endTimes.append(data.endTimeUnix)
            
        }
        
        let startTime = getEarliestTime(startTimes)
        let endTime = getLatestTime(endTimes)
        
    
        let histData = HistoryData(totalBuys: combinedTotalBuys, totalBuyValue: combinedBuyValue, totalSells: combinedTotalSells, totalSellValue: combinedSellValue, netValue: combinedNetValue, totalTrades: combinedTotalTrades)
        histData.startTimeUnix = startTime
        histData.endTimeUnix = endTime
        
        return histData
        
    }
    
    
    func getEarliestTime(times: [Int]) -> Int {
        
        var earliest = Int()
        
        earliest = times.first!
        
        for time in times {
//            print("TIME \(time)")
            
            if time < earliest {
                earliest = time
            }
//            print(" earliest time \(earliest)")
            
        }
        
        return earliest
    }
    
    func getLatestTime(times: [Int]) -> Int {
        
        var latest = Int()
        
        latest = times.first!
        
        for time in times {
//            print("TIME \(time)")
            
            if time > latest {
                latest = time
            }
//            print(" LATEST time \(latest)")
            
        }
        return latest
    }
    
    
    
    func timeStampToUnix(time: String) -> Int {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        let unixTime = Int((dateFormatter.dateFromString(time)!.timeIntervalSince1970))
        
        return unixTime
    }
    
    
    func caluclateHistoryData(tradeHistory: [Trade]) -> HistoryData {
        
        var totalBuys:Int = 0
        var totalBuyValue:Double = 0.0
        var totalSells:Int = 0
        var totalSellValue:Double = 0.0
        var netValue:Double = 0.0
        
        for trade in tradeHistory {
            
            if trade.type == "buy" {
                totalBuys += 1
                totalBuyValue = trade.total + totalBuyValue
            } else {
                totalSells += 1
                totalSellValue = trade.total + totalSellValue
            }
        }
        
        netValue = totalBuyValue - totalSellValue
        
        let tradeHistoryData = HistoryData(totalBuys: totalBuys, totalBuyValue: totalBuyValue, totalSells: totalSells, totalSellValue: totalSellValue, netValue: netValue, totalTrades: tradeHistory.count)
        
        return tradeHistoryData
    }
    
    func findCurrentVC() -> UIViewController? {
        guard let navigationController = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController else { return nil }
        return navigationController.viewControllers.last
    }
    
    func cancelDownloads() {
        
       // let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
//        session.getTasksWithCompletionHandler { (dataTasks: [NSURLSessionDataTask], uploadTasks: [NSURLSessionUploadTask], downloadTasks: [NSURLSessionDownloadTask]) in
        
        NSURLSession.sharedSession().getTasksWithCompletionHandler { (dataTasks: [NSURLSessionDataTask], uploadTasks: [NSURLSessionUploadTask], downloadTasks: [NSURLSessionDownloadTask]) in
           
        
            for task in dataTasks {
                
                task.cancel()
                print("Datatask cancelled \(task)")
                
            }
            
            for task in downloadTasks {
                
                task.cancel()
                print("DL cancelled \(task)")
            }
        }
        

        }
        

}
