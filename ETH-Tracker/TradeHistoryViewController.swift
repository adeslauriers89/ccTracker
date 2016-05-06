//
//  TradeHistoryViewController.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-04-14.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit

class TradeHistoryViewController: UIViewController {

    //MARK: Properties
    
    var dataManager = DataManager()
    
    @IBOutlet weak var lastMinuteHistoryLabel: UILabel!
    @IBOutlet weak var lastFiveMinuteHistoryLabel: UILabel!
    @IBOutlet weak var lastThirtyMinuteHistoryLabel: UILabel!
    @IBOutlet weak var lastTwoHourHistoryLabel: UILabel!
    @IBOutlet weak var lastSixHourHistoryLabel: UILabel!
    @IBOutlet weak var lastTwelveHourHistoryLabel: UILabel!
    @IBOutlet weak var lastTwentyFourHourHistoryLabel: UILabel!
    
    
    //MARK: ViewController Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        dataManager.getTradeHistory(unixConstants.oneMin) { (result) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.lastMinuteHistoryLabel.text = "Last Minute: \(result.info)"
                print(result.trades)
            })
        }
        
        dataManager.getTradeHistory(unixConstants.fiveMins) { (result) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.lastFiveMinuteHistoryLabel.text = "Last 5 Mins: \(result.info)"
            })
        }
        
        dataManager.getTradeHistory(unixConstants.thirtyMins) { (result) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.lastThirtyMinuteHistoryLabel.text = "Last 30 Mins: \(result.info)"
            })
        }
        
        dataManager.getTradeHistory(unixConstants.twoHours) { (result) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.lastTwoHourHistoryLabel.text = "Last 2 Hrs: \(result.info)"
            })
        }
        
        dataManager.getTradeHistory(unixConstants.sixHours) { (result) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.lastSixHourHistoryLabel.text = "Last 6 Hrs: \(result.info)"
            })
        }
        
        dataManager.getTradeHistory(unixConstants.twelveHours) { (result) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.lastTwelveHourHistoryLabel.text = "Last 12 Hrs: \(result.info)"
            })
        }
        
        dataManager.getTradeHistory(unixConstants.oneDay) { (result) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.lastTwentyFourHourHistoryLabel.text = "Last 24 Hrs: \(result.info)"
            })
        }
     
        
        
      
    }
    



    

    /*
    // MARK: - Navigation

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
