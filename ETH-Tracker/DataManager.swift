//
//  DataManager.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-03-29.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import Foundation


class DataManager {
    
    var tradesInLast24Hrs = [Trade]()
    var last24HrsInfo: String = ""
    
    var tradesInLast12Hrs = [Trade]()
    var last12HrsInfo: String = ""
    
    var tradesInLast6Hrs = [Trade]()
    var last6HrsInfo: String = ""
    
    var tradesInLast2Hrs = [Trade]()
    var last2HrsInfo: String = ""
    
    var tradesInLast30Mins = [Trade]()
    var last30MinsInfo: String = ""
    
    var tradesInLast5Mins = [Trade]()
    var lastFiveMinsInfo: String = ""
    
    var tradesInLastMinute = [Trade]()
    var lastMinuteInfo: String = ""
    
    var totalTradesSold = Int()
    var totalTradesBought = Int()
    
    var soldTradesValue = Float()
    var boughtTradesValue = Float()
    var tradesNetValue = Float()
  
    var buyOrders = [Order]()
    var sellOrders = [Order]()
    
    var totalAmountPendingAsks = Double()
    var totalAmountPendingBids = Double()
    
    var totalAmountSellOrdersWithinOnePercent = Double()
    var totalAmountBuyOrdersWithinOnePercent = Double()
    
    var ethCurrentValue = Double()
    
    var sellOrdersWithinOnePercent = [Order]()
    var buyOrdersWithinOnePercent = [Order]()
    
    var buyOrderInfo: String = ""
    var sellOrderInfo: String = ""
    

    var tradeHistory = [Trade]()
    var historyInfo: String = ""
    
    var startUnix = Int()
    var endUnix = Int()
    
   // var testlast24hrs = [Trade]()

    
//    func getTradesLast24Hrs() {
//        
//        testlast24hrs.removeAll()
//        
//        startTime = Int(NSDate().timeIntervalSince1970) - unixConstants.oneDay
//        endTime = Int(NSDate().timeIntervalSince1970)
//        
//        let historyTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "https://poloniex.com/public?command=returnTradeHistory&currencyPair=BTC_ETH&start=\(startTime)&end=\(endTime)")!) { (data,response,error) -> Void in
//            
//            if let fetchedHistory = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as!
//                [[String: AnyObject]]) {
//                    
//                    self.buySellCounterReset()
//                    
//                    for historyDict in fetchedHistory {
//                        
//                        let newTrade = Trade()
//                        newTrade.date = historyDict["date"] as! String
//                        newTrade.type = historyDict["type"] as! String
//                        newTrade.rate = (historyDict["rate"]!.floatValue)
//                        newTrade.amount = (historyDict["amount"]!.floatValue)
//                        newTrade.total = (historyDict["total"]!.floatValue)
//                        
//                        self.testlast24hrs.append(newTrade)
//                        
//                        if newTrade.type == "buy" {
//                            self.boughtTradesValue = newTrade.total + self.boughtTradesValue
//                            self.totalTradesBought += 1
//                        } else {
//                            self.soldTradesValue = newTrade.total + self.soldTradesValue
//                            self.totalTradesSold += 1
//                        }
//                        
//                    }
//              
//                    self.last24HrsInfo = "Last 24 Hrs: \(self.testlast24hrs.count) trades. \(self.totalTradesBought) buys for \(self.boughtTradesValue) BTC. \(self.totalTradesSold) sells for \(self.soldTradesValue) BTC"
//                    
//                    print(self.last24HrsInfo)
//            }
//            
//        }
//        historyTask.resume()
//        
//    }
    

    
    func getOrderBook() {
        
        resetOrderBook()
        
            let orderTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "https://poloniex.com/public?command=returnOrderBook&currencyPair=BTC_ETH&depth=500")!) { (data, response, error) -> Void in
            
            if let fetchedOrders = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]) {

                for bid in (fetchedOrders["bids"] as? [AnyObject])! {

                    let newOrder = Order()
                    newOrder.price = bid[0].doubleValue
                    newOrder.amount = bid.lastObject as! Double
                    
                    self.totalAmountPendingBids = newOrder.amount + self.totalAmountPendingBids
                    
                    self.buyOrders.append(newOrder)
                }
                
                //print(fetchedOrders["asks"])
                
                for ask in (fetchedOrders["asks"] as? [AnyObject])! {
                    
                    
                    let newOrder = Order()
                    newOrder.price = ask[0].doubleValue
                    newOrder.amount = ask[1].doubleValue
                    
                    self.totalAmountPendingAsks = newOrder.amount + self.totalAmountPendingAsks
                    
                    
                    self.sellOrders.append(newOrder)
                }
             
                
                }
            self.getCurrentPrice()
           
        }
        
        orderTask.resume()
    }
 
    func getCurrentPrice() {
        
        let urlPath = "https://poloniex.com/public?command=returnTicker"
        let endPoint = NSURL(string: urlPath)
        
        let tickerTask = NSURLSession.sharedSession().dataTaskWithURL(endPoint!) { (data, response, error) -> Void in
            
            if let fetchedTicker = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [String : AnyObject]) {
                
                
                
                if let eth: AnyObject = fetchedTicker["BTC_ETH"] {
                    if let ethDict = eth as? [String : AnyObject] {
                        print(ethDict)
                        
                        if let lastPrice: Double = ethDict["last"]?.doubleValue {
                            print("Current price is \(lastPrice)")
                            self.ethCurrentValue = lastPrice
                        }
                        
                    }
                }
           
            }
            self.getOrdersWithinOnePercent()
        }
        tickerTask.resume()
    }
    
    func getOrdersWithinOnePercent() {
        
        orderCounterReset()
   
        for order in self.sellOrders {
            //print("sell amnt \(order.amount)")
            let difference: Double = self.ethCurrentValue / order.price
            
            if difference >= 0.99009900 {
                self.sellOrdersWithinOnePercent.append(order)
                
                self.totalAmountSellOrdersWithinOnePercent = order.amount + self.totalAmountSellOrdersWithinOnePercent
            }
        }
        
        for order in self.buyOrders {
           // print("buy amnt \(order.amount)")
            let difference: Double = self.ethCurrentValue / order.price
            if difference <= 1.01010101 {
                self.buyOrdersWithinOnePercent.append(order)
                
                self.totalAmountBuyOrdersWithinOnePercent = order.amount + self.totalAmountBuyOrdersWithinOnePercent
            }
        }
        
        sellOrderInfo = "Out of 500 pending sell orders there are \(self.sellOrdersWithinOnePercent.count) within 1% of the current ETH price, for a total value of \(self.totalAmountSellOrdersWithinOnePercent) ETH"
        
        print(sellOrderInfo)
        
        buyOrderInfo = "Out of 500 pending buy orders there are \(self.buyOrdersWithinOnePercent.count) within 1% of the current ETH price, for a total value of \(self.totalAmountBuyOrdersWithinOnePercent) ETH "
        
        print(buyOrderInfo)
    }


    

    func orderCounterReset() {
        self.totalAmountSellOrdersWithinOnePercent = 0
        self.totalAmountBuyOrdersWithinOnePercent = 0
        
        self.sellOrdersWithinOnePercent.removeAll()
        self.buyOrdersWithinOnePercent.removeAll()
    }
    
    func buySellCounterReset() {
        self.totalTradesSold = 0
        self.totalTradesBought = 0
        
        self.boughtTradesValue = 0
        self.soldTradesValue = 0
    }
    
    func resetOrderBook() {
        sellOrders.removeAll()
        buyOrders.removeAll()
        
    }
    
    
//    func getTradeHistory(completion: (result: (trades: [Trade], info: String, start: Int, end: Int) ) -> Void) {
//        
//        endTime = Int(NSDate().timeIntervalSince1970)
//        
//        let historyTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "https://poloniex.com/public?command=returnTradeHistory&currencyPair=BTC_ETH&start=\(startTime)&end=\(endTime)")!) { (data, response, error) -> Void in
//            
//            if let fetchedHistory = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as!
//                [[String: AnyObject]]) {
//                
//                self.buySellCounterReset()
//                
//                if self.tradeHistory.isEmpty == false {
//                    self.tradeHistory.removeAll()
//                }
//
//                for historyDict in fetchedHistory {
//                    let newTrade = Trade()
//              
//                    if let date = historyDict["date"] as? String {
//                        newTrade.date = date
//                    }
//                    newTrade.type = historyDict["type"] as! String
//                    newTrade.rate = (historyDict["rate"]!.floatValue)
//                    newTrade.amount = (historyDict["amount"]!.floatValue)
//                    newTrade.total = (historyDict["total"]!.floatValue)
//
//                    newTrade.timeInt = self.timeStampToUnix(newTrade.date)
//
//                    self.tradeHistory.append(newTrade)
//                    
//                    self.tradeTypeFilter(newTrade)
//
//                }
//                
//                print("First \(self.tradeHistory.first?.timeInt)")
//                print("Last \(self.tradeHistory.last?.timeInt)")
//                
//                self.tradesNetValue = self.boughtTradesValue - self.soldTradesValue
//                    
//                self.historyInfo = "\(self.tradeHistory.count) trades. \(self.totalTradesBought) buys for \(self.boughtTradesValue) BTC. \(self.totalTradesSold) sells for \(self.soldTradesValue) BTC : Net Value \(self.tradesNetValue)"
//                
//                print(self.historyInfo)
//                
//            }
//            completion(result: (trades: self.tradeHistory, info: self.historyInfo, start: self.startTime, end: self.endTime))
//
//        }
//        historyTask.resume()
//    }
    
    
    func getTradeHistory(forTimePeriod: Int, completion: (result: (trades: [Trade], info: String, start: Int, end: Int) ) -> Void) {
        
        let startTime = Int(NSDate().timeIntervalSince1970) - forTimePeriod
        let endTime = Int(NSDate().timeIntervalSince1970)
        
        let historyTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "https://poloniex.com/public?command=returnTradeHistory&currencyPair=BTC_ETH&start=\(startTime)&end=\(endTime)")!) { (data, response, error) -> Void in
            
            if let fetchedHistory = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as!
                [[String: AnyObject]]) {
                
                self.buySellCounterReset()
                
                if self.tradeHistory.isEmpty == false {
                    self.tradeHistory.removeAll()
                }
                
                for historyDict in fetchedHistory {
                    let newTrade = Trade()
                    
                    if let date = historyDict["date"] as? String {
                        newTrade.date = date
                    }
                    newTrade.type = historyDict["type"] as! String
                    newTrade.rate = (historyDict["rate"]!.floatValue)
                    newTrade.amount = (historyDict["amount"]!.floatValue)
                    newTrade.total = (historyDict["total"]!.floatValue)
                    
                    newTrade.timeInt = self.timeStampToUnix(newTrade.date)
                    
                    self.tradeHistory.append(newTrade)
                    
                    self.tradeTypeFilter(newTrade)
                    
                }
//                
//                print("First \(self.tradeHistory.first?.timeInt)")
//                print("First \(self.tradeHistory.first?.amount)")
//                print("First \(self.tradeHistory.first?.date)")
//
//
//                
//                
//                print("Last \(self.tradeHistory.last?.timeInt)")
//                print("Last \(self.tradeHistory.last?.amount)")
//                print("Last \(self.tradeHistory.last?.date)")

                
                
                
                
               self.tradesNetValue = self.boughtTradesValue - self.soldTradesValue
                
                self.historyInfo = "\(self.tradeHistory.count) trades. \(self.totalTradesBought) buys for \(self.boughtTradesValue) BTC. \(self.totalTradesSold) sells for \(self.soldTradesValue) BTC : Net Value \(self.tradesNetValue)"
                
                print(self.historyInfo)
                
                print("STARTTIME \(startTime) ENDTIME \(endTime)")
                
            }
            completion(result: (trades: self.tradeHistory, info: self.historyInfo, start: startTime, end: endTime))
            
        }
        historyTask.resume()
    }
    
    
//    func getHistoryLastMinute() -> (trades: [Trade] ,info: String) {
// 
//        startTime = Int(NSDate().timeIntervalSince1970) - unixConstants.oneMin
//        
//       getTradeHistory() { (result) in
//            self.lastMinuteInfo = "Last Minute: \(result.info)"
//            self.tradesInLastMinute = result.trades
//        }
//        
//        return (tradesInLastMinute, lastMinuteInfo)
//    }
//    
//    func getHistoryLastFiveMinutes() -> (trades: [Trade], info: String, start: Int, end: Int) {
//        
//        startTime = Int(NSDate().timeIntervalSince1970) - unixConstants.fiveMins
//        
//        
//        getTradeHistory { (result) in
//            self.lastFiveMinsInfo = "Last 5 Mins: \(result.info)"
//            self.tradesInLast5Mins = result.trades
//            
//            self.startUnix = result.start + unixConstants.sevenHours
//            self.endUnix = result.end + unixConstants.sevenHours
//
//        }
//        
//        return (trades: self.tradesInLast5Mins, info: self.lastFiveMinsInfo, start: self.startUnix, end: self.endUnix)
//    }
//
//    
//    func getHistoryLastThirtyMinutes() -> (trades: [Trade], info: String) {
//        
//        startTime = Int(NSDate().timeIntervalSince1970) - unixConstants.thirtyMins
//        
//        getTradeHistory { (result) in
//            self.last30MinsInfo = "Last 30 Mins: \(result.info)"
//            self.tradesInLast30Mins = result.trades
// 
//        }
//        return (tradesInLast30Mins, last30MinsInfo)
//    }
//    
//    func getHistoryLastTwoHours() -> (trades: [Trade], info: String) {
//        
//        startTime = Int(NSDate().timeIntervalSince1970) - unixConstants.twoHours
//        
//        getTradeHistory { (result) in
//            self.last2HrsInfo = "Last 2 Hrs: \(result.info)"
//            self.tradesInLast2Hrs = result.trades
//        }
//        
//        return (tradesInLast2Hrs, last2HrsInfo)
//        
//    }
//    
//    func getHistoryLastSixHours() -> (trades: [Trade], info: String) {
//        
//        startTime = Int(NSDate().timeIntervalSince1970) - unixConstants.sixHours
//        
//        getTradeHistory { (result) in
//            self.last6HrsInfo = "Last 6 Hrs: \(result.info)"
//            self.tradesInLast6Hrs = result.trades
//        }
//        
//        return (tradesInLast6Hrs, last6HrsInfo)
//    }
//    
//    func getHistoryLastTwelveHours() -> (trades: [Trade], info: String) {
//        
//        startTime = Int(NSDate().timeIntervalSince1970) - unixConstants.twelveHours
//        
//       getTradeHistory { (result) in
//            self.last12HrsInfo = "Last 12 Hrs: \(result.info)"
//            self.tradesInLast12Hrs = result.trades
//        }
//        
//        return (tradesInLast12Hrs, last12HrsInfo)
//    }
//    
//    func getHistoryLastDay() -> (trades: [Trade], info: String) {
//        
//        startTime = Int(NSDate().timeIntervalSince1970) - unixConstants.oneDay
//        
//       getTradeHistory { (result) in
//            self.last24HrsInfo = "Last 24 Hrs: \(result.info)"
//            self.tradesInLast24Hrs = result.trades
//        }
//        
//        return (tradesInLast24Hrs, last24HrsInfo)
//    }

    
    func timeStampToUnix(time: String) -> Int {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let unixTime = Int((dateFormatter.dateFromString(time)!.timeIntervalSince1970))
        
        return unixTime
    }
    
    
    func tradeTypeFilter(trade: Trade) {
        
        if trade.type == "buy" {
            self.boughtTradesValue = trade.total + self.boughtTradesValue
            self.totalTradesBought += 1
        } else {
            self.soldTradesValue = trade.total + self.soldTradesValue
            self.totalTradesSold += 1
        }
    }
    

}