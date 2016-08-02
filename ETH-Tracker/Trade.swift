//
//  Trade.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-03-29.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import Foundation

class Trade {
    
    var date: String
    var type: String
    var timeInt: Int
    var rate: Double
    var amount: Double
    var total: Double
    
    init(date: String, type: String, timeInt: Int, rate: Double, amount: Double, total: Double) {
        self.date = date
        self.type = type
        self.timeInt = timeInt
        self.rate = rate
        self.amount = amount
        self.total = total
    }
    
    
}

