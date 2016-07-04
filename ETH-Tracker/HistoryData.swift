//
//  HistoryData.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-07-04.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import Foundation

class HistoryData {
    
    var totalTrades:Int
    var totalBuys:Int
    var totalSells:Int
    var totalBuyValue:Double
    var totalSellValue:Double
    var netValue:Double
    var startTimeUnix = Int()
    var endTimeUnix = Int()
    
    
    init(totalBuys: Int, totalBuyValue: Double, totalSells: Int, totalSellValue: Double, netValue: Double, totalTrades: Int) {
        self.totalBuys = totalBuys
        self.totalBuyValue = totalBuyValue
        self.totalSells = totalSells
        self.totalSellValue = totalSellValue
        self.netValue = netValue
        self.totalTrades = totalTrades

    }

}

