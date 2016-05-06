//
//  HomeViewController.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-04-14.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    //MARK: Properties
    
    var dataManager = DataManager()
    
    //MARK: ViewController Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let datez = "2016-04-27 01:15:16"
//        
//        
//        let strTime = "2015-07-27 19:29:50 +0000"
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        print(formatter.dateFromString(strTime))
//        
//        let date: Int = Int((formatter.dateFromString(datez)?.timeIntervalSince1970)!)
//        print("suh dude\(date)")
        
//       let bint = dataManager.getMinuteIntervals()
//        print(bint)
        
    

    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
      // dataManager.getOrderBook()
        
        
      //  dataManager.getHistoryLastMinute()
        
  //     dataManager.getHistoryLastFiveMinutes()
//        dataManager.getHistoryLastThirtyMinutes()
//        dataManager.getHistoryLastTwoHours()
//        dataManager.getHistoryLastSixHours()
//        dataManager.getHistoryLastTwelveHours()
//        dataManager.getHistoryLastDay()
//   


    }
    
    
    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueToOrderBook" {
            
            let destinationViewController = segue.destinationViewController as! OrderViewController
            destinationViewController.dataManager = dataManager
            
        } else if segue.identifier == "segueToTradeHistory" {
            
            let destinationViewController = segue.destinationViewController as! TradeHistoryViewController
            destinationViewController.dataManager = dataManager
            
        } else if segue.identifier == "segueToLineChart" {
            
            let destinationViewController = segue.destinationViewController as! LineChartViewController
            destinationViewController.dataManager = dataManager
        }
        
        
    }
    
}
