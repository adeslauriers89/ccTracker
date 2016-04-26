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
        

        
        lastMinuteHistoryLabel.text = dataManager.lastMinuteInfo
        lastFiveMinuteHistoryLabel.text = dataManager.lastFiveMinsInfo
        lastThirtyMinuteHistoryLabel.text = dataManager.last30MinsInfo
        
        lastTwoHourHistoryLabel.text = dataManager.last2HrsInfo
        lastSixHourHistoryLabel.text = dataManager.last6HrsInfo
        lastTwelveHourHistoryLabel.text = dataManager.last12HrsInfo
        lastTwentyFourHourHistoryLabel.text = dataManager.last24HrsInfo
      
    }


    

    /*
    // MARK: - Navigation

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
