//
//  Constants.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-03-30.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import Foundation

struct dateContstants {

    static let currentDate = NSDate()
    static let unixCurrentDate = Int(currentDate.timeIntervalSince1970)
    static let unixDateTwentyFourHoursAgo = unixCurrentDate - 86400
    static let unixDateTwelveHoursAgo = unixCurrentDate - 43200
    static let unixDateSixHoursAgo = unixCurrentDate - 21600
    static let unixDateTwoHoursAgo = unixCurrentDate - 7200
    static let unixDateThirtyMinsAgo = unixCurrentDate - 1800
    static let unixDateOneMinAgo = unixCurrentDate - 60
    

}

struct unixConstants {
    
    static let oneDay = 86400
    static let twelveHours = 43200
    static let sevenHours = 25200
    static let sixHours = 21600
    static let twoHours = 7200
    static let thirtyMins = 1800
    static let fiveMins = 300
    static let oneMin = 60
    
}



