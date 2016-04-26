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
        

    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        dataManager.getOrderBook()
        
        dataManager.getHistoryLastFiveMinutes()
        dataManager.getHistoryLastMinute()
        dataManager.getHistoryLastThirtyMinutes()
        dataManager.getHistoryLastTwoHours()
        dataManager.getHistoryLastSixHours()
        dataManager.getHistoryLastTwelveHours()
        dataManager.getHistoryLastDay()
   


    }
    
    
    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueToOrderBook" {
            
            let destinationViewController = segue.destinationViewController as! OrderViewController
            destinationViewController.dataManager = dataManager
            
        } else if segue.identifier == "segueToTradeHistory" {
            
            let destinationViewController = segue.destinationViewController as! TradeHistoryViewController
            destinationViewController.dataManager = dataManager
        }
    }
    
}
