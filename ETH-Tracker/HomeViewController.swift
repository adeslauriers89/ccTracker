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
    
    
    
    @IBOutlet weak var tickerView: UIView!
    @IBOutlet weak var tickerCurrencyPairLabel: UILabel!
    @IBOutlet weak var tickerCurrentPriceLabel: UILabel!
    @IBOutlet weak var ticker24HrHighLabel: UILabel!
    @IBOutlet weak var ticker24HrLowLabel: UILabel!
    @IBOutlet weak var tickerVolumeLabel: UILabel!
    @IBOutlet weak var tickerPercentChangeLabel: UILabel!
    @IBOutlet weak var tickerRefreshButton: UIButton!
    
    
    
    //MARK: ViewController Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(colorLiteralRed: 217.0/255.0, green: 217.0/255.0 , blue: 217.0/255.0, alpha: 1.0)

        
        tickerView.layer.borderWidth = 1.0
        tickerView.layer.borderColor = UIColor.blackColor().CGColor
        tickerView.layer.cornerRadius = 5.0
        tickerRefreshButton.layer.cornerRadius = 5.0
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getTickerData()

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
            
//            let destinationViewController = segue.destinationViewController as! LineChartViewController
////            destinationViewController.dataManager = dataManager
     }
        
        
    }
    
    //MARK: Actions
    
    
    @IBAction func refreshTickerButtonPressed(sender: UIButton) {
        
        getTickerData()
    }
    
    //MARK: Data Functions
    
    
    func getTickerData() {
        
        dataManager.getTicker { (newTicker) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.tickerCurrencyPairLabel.text = "Currency Pair: ETH/BTC"
                self.tickerCurrentPriceLabel.text = "Current Price: \(String(newTicker.currentPrice))"
                self.ticker24HrHighLabel.text = "24hr High: \(String(newTicker.high24Hr))"
                self.ticker24HrLowLabel.text = "24hr Low: \(String(newTicker.low24Hr))"
                self.tickerVolumeLabel.text = String(format: "24hr Volume: %0.3f", newTicker.volume)
                
                if newTicker.percentChange > 0.0 {
                    self.tickerPercentChangeLabel.textColor = UIColor.greenColor()
                } else if newTicker.percentChange < 0.0 {
                    self.tickerPercentChangeLabel.textColor = UIColor.redColor()
                } else {
                    self.tickerPercentChangeLabel.textColor = UIColor.blackColor()
                }
                self.tickerPercentChangeLabel.text = String(format:"%0.2f",newTicker.percentChange ) + "%"
            })
        }
        
    }
    
}


