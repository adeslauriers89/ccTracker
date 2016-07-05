//
//  TradeHistoryDataViewController.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-07-05.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit

class TradeHistoryDataViewController: UIViewController {
    
    //MARK: Properties
    
    var dataManager = DataManager()
    
    @IBOutlet weak var oneMinView: UIView!
    @IBOutlet weak var oneMinTotalBuysLabel: UILabel!
    @IBOutlet weak var oneMinBuysValueLabel: UILabel!
    @IBOutlet weak var oneMinTotalSellsLabel: UILabel!
    @IBOutlet weak var oneMinSellsValueLabel: UILabel!
    @IBOutlet weak var oneMinTotalTradesLabel: UILabel!
    @IBOutlet weak var oneMinNetValueLabel: UILabel!
    
    
    
    //MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.grayColor()
        
        oneMinView.layer.borderWidth = 1.0
        oneMinView.layer.borderColor = UIColor.blackColor().CGColor
        oneMinView.layer.cornerRadius = 5.0

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        dataManager.getHistory(timeConstants.oneMin, fromTime: dataManager.currentTime) { (result) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let tradeHistoryData = result.tradeInfo
                
                self.oneMinTotalBuysLabel.text = "# Buys: \(tradeHistoryData.totalBuys)"
                self.oneMinBuysValueLabel.text = "Buys Value: \(tradeHistoryData.totalBuyValue)"
                self.oneMinTotalSellsLabel.text = "# Sells: \(tradeHistoryData.totalSells)"
                self.oneMinSellsValueLabel.text = "Sells Value: \(tradeHistoryData.totalSellValue)"
                self.oneMinTotalTradesLabel.text = "Total Trades: \(tradeHistoryData.totalTrades)"
                
                
                
                if tradeHistoryData.netValue >= 0.0 {
                    self.oneMinNetValueLabel.textColor = UIColor.greenColor()
                } else if tradeHistoryData.netValue <= 0.0 {
                    self.oneMinNetValueLabel.textColor = UIColor.redColor()
                } else {
                    self.oneMinNetValueLabel.textColor = UIColor.blackColor()
                }
                
                self.oneMinNetValueLabel.text = "\(tradeHistoryData.netValue) BTC"
                

            })
        }
        
        }
        
    }
    

    


