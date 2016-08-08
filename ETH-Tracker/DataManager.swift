//
//  DataManager.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-03-29.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import Foundation


class DataManager {

   // var tradeHistory = [Trade]()
    var currencyPair = String()
    
    var currentTime: Int {
        get {
            return Int(NSDate().timeIntervalSince1970)
        }
    }
    
    func getCurrencyPairs(completion:[String] -> Void) {
        
        let urlPath = "https://poloniex.com/public?command=returnTicker"
        let endPoint = NSURL(string: urlPath)
        var currencyPairs = [String]()
        
        let currencyPairTask = NSURLSession.sharedSession().dataTaskWithURL(endPoint!) { (data, response, error) -> Void in
            
            if error != nil {
                print("ERROR: \(error)")
            }
            
            if let unWrappedData = data {
                guard let fetchedPairs = (try? NSJSONSerialization.JSONObjectWithData(unWrappedData, options: NSJSONReadingOptions.AllowFragments) as! [String : AnyObject]) else {return}
                
                for pair in fetchedPairs {
                    let pairName = pair.0
                    
                    currencyPairs.append(pairName)
                }
            }
            completion(currencyPairs)
        }
        currencyPairTask.resume()
    }
    
    
    func getTicker(completion:(Ticker) -> Void) {
        
        let urlPath = "https://poloniex.com/public?command=returnTicker"
        let endPoint = NSURL(string: urlPath)
        
        let tickerTask = NSURLSession.sharedSession().dataTaskWithURL(endPoint!) { (data, response, error) -> Void in
            
            
            if let unWrappedData = data {
                guard let fetchedTicker = (try? NSJSONSerialization.JSONObjectWithData(unWrappedData, options: NSJSONReadingOptions.AllowFragments) as! [String : AnyObject]) else  {return}
                
                if let eth: AnyObject = fetchedTicker["BTC_ETH"] {
                    if let ethTickerDict = eth as? [String : AnyObject] {
                        
                        guard let currentPrice = ethTickerDict["last"]?.doubleValue,
                            var percentChange = ethTickerDict["percentChange"]?.doubleValue,
                            let volume = ethTickerDict["baseVolume"]?.doubleValue,
                            let high24Hr = ethTickerDict["high24hr"]?.doubleValue,
                            let low24Hr = ethTickerDict["low24hr"]?.doubleValue else {return}
                        
                        percentChange *= 100
                        
                        let ethTicker = Ticker(currentPrice: currentPrice, percentChange: percentChange, volume: volume, high24Hr: high24Hr, low24Hr: low24Hr)
                        
                        completion(ethTicker)
                    }
                }
            } else {
                print("No connection")
            }
        }
        tickerTask.resume()
        
    }
    

    
    func fetchOrderBook(completion:(result:(totalBuys: Int, buysValue: Double, totalSells: Int, sellsValue: Double)) -> Void ) {
        
        var totalAmountPendingBuys: Double = 0.0
        var totalAmountPendingSells: Double = 0.0
        var buyOrdersArray = [Order]()
        var sellOrdersArray = [Order]()
        var currentPrice = Double()
        
        let url = "https://poloniex.com/public?command=returnOrderBook&currencyPair=BTC_ETH&depth=500"
        
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
            
            self.getTicker({ (Ticker) in
                
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
        let currencyPair = "BTC_ETH"
        let urlPath = "https://poloniex.com/public?command=returnTradeHistory&currencyPair=\(currencyPair)&start=\(startTime)&end=\(fromTime)"
        
        let historyTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlPath)!) { (data, response, error) -> Void in
            if error != nil {
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
            
            print("NET OF INTERVAL \(data.netValue)")
            
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
    

}



/////// OLD FUNCS TO GET ORDER BOOK AND FILTER OUT THE ONES WITHIN 1 PERCENT ////////

//
//    func getOrderBook() {
//
//        resetOrderBook()
//
//            let orderTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "https://poloniex.com/public?command=returnOrderBook&currencyPair=BTC_ETH&depth=500")!) { (data, response, error) -> Void in
//
//            if let fetchedOrders = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]) {
//
//                for bid in (fetchedOrders["bids"] as? [AnyObject])! {
//
//                    let newOrder = Order()
//                    newOrder.price = bid[0].doubleValue
//                    newOrder.amount = bid[1].doubleValue
//
//                    self.totalAmountPendingBids = newOrder.amount + self.totalAmountPendingBids
//
//                    self.buyOrders.append(newOrder)
//                }
//
//
//                for ask in (fetchedOrders["asks"] as? [AnyObject])! {
//
//                    let newOrder = Order()
//                    newOrder.price = ask[0].doubleValue
//                    newOrder.amount = ask[1].doubleValue
//
//                    self.totalAmountPendingAsks = newOrder.amount + self.totalAmountPendingAsks
//                    self.sellOrders.append(newOrder)
//                }
//            }
//            self.getCurrentPrice()
//
//        }
//
//        orderTask.resume()
//    }

//
//
//
//func getCurrentPrice() {
//    
//    let urlPath = "https://poloniex.com/public?command=returnTicker"
//    let endPoint = NSURL(string: urlPath)
//    
//    let tickerTask = NSURLSession.sharedSession().dataTaskWithURL(endPoint!) { (data, response, error) -> Void in
//        
//        if let fetchedTicker = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [String : AnyObject]) {
//            
//            if let eth: AnyObject = fetchedTicker["BTC_ETH"] {
//                if let ethDict = eth as? [String : AnyObject] {
//                    print(ethDict)
//                    
//                    if let lastPrice: Double = ethDict["last"]?.doubleValue {
//                        print("Current price is \(lastPrice)")
//                        self.ethCurrentValue = lastPrice
//                    }
//                    
//                }
//            }
//        }
//        self.getOrdersWithinOnePercent()
//    }
//    tickerTask.resume()
//}
//
//
//func getOrdersWithinOnePercent() {
//    
//    orderCounterReset()
//    
//    for order in self.sellOrders {
//        let difference: Double = self.ethCurrentValue / order.price
//        
//        if difference >= 0.99009900 {
//            self.sellOrdersWithinOnePercent.append(order)
//            
//            self.totalAmountSellOrdersWithinOnePercent = order.amount + self.totalAmountSellOrdersWithinOnePercent
//        }
//    }
//    
//    for order in self.buyOrders {
//        let difference: Double = self.ethCurrentValue / order.price
//        if difference <= 1.01010101 {
//            self.buyOrdersWithinOnePercent.append(order)
//            
//            self.totalAmountBuyOrdersWithinOnePercent = order.amount + self.totalAmountBuyOrdersWithinOnePercent
//        }
//    }
//    
//    sellOrderInfo = "Out of 500 pending sell orders there are \(self.sellOrdersWithinOnePercent.count) within 1% of the current ETH price, for a total value of \(self.totalAmountSellOrdersWithinOnePercent) ETH"
//    
//    print(sellOrderInfo)
//    
//    buyOrderInfo = "Out of 500 pending buy orders there are \(self.buyOrdersWithinOnePercent.count) within 1% of the current ETH price, for a total value of \(self.totalAmountBuyOrdersWithinOnePercent) ETH "
//    
//    print(buyOrderInfo)
//}


//
//
//
//    func orderCounterReset() {
//        self.totalAmountSellOrdersWithinOnePercent = 0
//        self.totalAmountBuyOrdersWithinOnePercent = 0
//
//        self.sellOrdersWithinOnePercent.removeAll()
//        self.buyOrdersWithinOnePercent.removeAll()
//    }
//

//
//    func resetOrderBook() {
//        sellOrders.removeAll()
//        buyOrders.removeAll()
//
//    }



///// OLD GET HISTORY METHOD AND SUB METHODS ////


//    func getTradeHistory(forTimePeriod: Int, completion: (result: (trades: [Trade], info: String, start: Int, end: Int) ) -> Void) {
//
//        let startTime = Int(NSDate().timeIntervalSince1970) - forTimePeriod
//        let endTime = Int(NSDate().timeIntervalSince1970)
//
//
//        let historyTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "https://poloniex.com/public?command=returnTradeHistory&currencyPair=BTC_ETH&start=\(startTime)&end=\(endTime)")!) { (data, response, error) -> Void in
//
//            if error != nil {
//                print(error)
//            }
//
//                if let fetchedHistory = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as!
//                    [[String: AnyObject]]) {
//
//                    self.buySellCounterReset()
//
//                    if self.tradeHistory.isEmpty == false {
//                        self.tradeHistory.removeAll()
//                    }
//
//                    for historyDict in fetchedHistory {
//                        let newTrade = Trade()
//
//                        if let date = historyDict["date"] as? String {
//                            newTrade.date = date
//                        }
//                        newTrade.type = historyDict["type"] as! String
//                        newTrade.rate = (historyDict["rate"]!.doubleValue)
//                        newTrade.amount = (historyDict["amount"]!.doubleValue)
//                        newTrade.total = (historyDict["total"]!.doubleValue)
//
//                        newTrade.timeInt = self.timeStampToUnix(newTrade.date)
//
//                        self.tradeHistory.append(newTrade)
//
//                        self.tradeTypeFilter(newTrade)
//
//                    }
//                    //
//                    /// trying to reconfigure to fetch more than 50k trades
//                    //
//
//                    if (self.tradeHistory.count >= 50000) {
//                        print("Max amount is 50k")
//
//                    }
//
//                    self.tradesNetValue = self.boughtTradesValue - self.soldTradesValue
//
//                    self.historyInfo = "\(self.tradeHistory.count) trades. \(self.totalTradesBought) buys for \(self.boughtTradesValue) BTC. \(self.totalTradesSold) sells for \(self.soldTradesValue) BTC : Net Value \(self.tradesNetValue)"
//
//                    print(self.historyInfo)
//
//                    print("STARTTIME \(startTime) ENDTIME \(endTime)")
//
//                }
//
//
//            completion(result: (trades: self.tradeHistory, info: self.historyInfo, start: startTime, end: endTime))
//
//        }
//        historyTask.resume()
//    }


//        func buySellCounterReset() {
//            self.totalTradesSold = 0
//            self.totalTradesBought = 0
//
//            self.boughtTradesValue = 0
//            self.soldTradesValue = 0
//        }
//    func tradeTypeFilter(trade: Trade) {
//
//        if trade.type == "buy" {
//            self.boughtTradesValue = trade.total + self.boughtTradesValue
//            self.totalTradesBought += 1
//        } else {
//            self.soldTradesValue = trade.total + self.soldTradesValue
//            self.totalTradesSold += 1
//        }
//    }





