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
    
    var dataManager = DataManager.sharedManager
    
    
    
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
        
        view.backgroundColor = colours.backGroundGrey

        
        tickerView.layer.borderWidth = 1.0
        tickerView.layer.borderColor = UIColor.blackColor().CGColor
        tickerView.layer.cornerRadius = 5.0
        tickerRefreshButton.layer.cornerRadius = 5.0
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getTickerData()
        
        dataManager.splitCurrencyPair()
        
        
        dataManager.getCurrencyPairs { (pairs) in
            
            let pears = pairs
            
            for par in pears {
                print("pears \(par.name) base: \(par.baseCurrency) and quote \(par.quoteCurrency)")
            }
        }
        
        
        
        print("TRYING WITH USER DEFAULTS \(dataManager.defaultCurrencyPair)")
        
        //dataManager.currPair = "BTC_ETH"
        //print("NEW  USER DEFAULTS \(dataManager.currPair)")

    }
        //MARK: Actions
    
    
    @IBAction func refreshTickerButtonPressed(sender: UIButton) {
        
        getTickerData()
    }
    
    //MARK: Data Functions
    
    
    func getTickerData() {
        
        dataManager.getTicker(dataManager.selectedCurrencyPair) { (newTicker) in
         
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                //"24hr Low: \(String(newTicker.low24Hr))"
                //"Current Price: \(String(newTicker.currentPrice))"
                
                
                var currencyPair = self.dataManager.selectedCurrencyPair
                
                if currencyPair == "" {
                    currencyPair = self.dataManager.defaultCurrencyPair
                }
                
                self.tickerCurrencyPairLabel.text = "Currency Pair: \(currencyPair)"
                self.tickerCurrentPriceLabel.text = String(format: "Current Price: %0.8f", newTicker.currentPrice)
                self.ticker24HrHighLabel.text = String(format: "24hr High: %0.8f", newTicker.high24Hr)
                self.ticker24HrLowLabel.text = String(format: "24hr Low: %0.8f", newTicker.low24Hr)
                self.tickerVolumeLabel.text = String(format: "24hr Volume: %0.3f \(self.dataManager.baseCurrency)", newTicker.volume)
                
                if newTicker.percentChange > 0.0 {
                    self.tickerPercentChangeLabel.textColor = colours.positiveGreen
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


