//
//  Order.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-04-07.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import Foundation

class Order {
    
    var price: Double
    var amount: Double
    
    init(price: Double, amount: Double) {
        self.price = price
        self.amount = amount
    }
    
}