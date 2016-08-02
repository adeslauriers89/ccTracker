//
//  Ticker.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-07-02.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import Foundation

class Ticker {
    
    var currentPrice: Double
    var percentChange: Double
    var volume: Double
    var high24Hr: Double
    var low24Hr: Double
    var currencyPair = ""
    
    init(currentPrice: Double, percentChange: Double, volume: Double, high24Hr: Double, low24Hr: Double) {
        self.currentPrice = currentPrice
        self.percentChange = percentChange
        self.volume = volume
        self.high24Hr = high24Hr
        self.low24Hr = low24Hr
    }

}


