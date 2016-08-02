//
//  OrderViewController.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-04-14.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    //MARK: Properties
    
    var dataManager = DataManager()
    
    @IBOutlet weak var buyOrderView: UIView!
    @IBOutlet weak var sellOrderView: UIView!
    @IBOutlet weak var buyOrderValueLabel: UILabel!
    @IBOutlet weak var sellOrderValueLabel: UILabel!
    
    @IBOutlet weak var orderBookRefreshButton: UIButton!
    
    
    //MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewStyles()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getOrderBookData()
        
    }
   
    //MARK: UI Functions
    
    func configureViewStyles() {
        
        buyOrderView.layer.borderWidth = 1.0
        buyOrderView.layer.borderColor = UIColor.blackColor().CGColor
        buyOrderView.layer.cornerRadius = 5.0
        
        sellOrderView.layer.borderWidth = 1.0
        sellOrderView.layer.borderColor = UIColor.blackColor().CGColor
        sellOrderView.layer.cornerRadius = 5.0
        
        orderBookRefreshButton.layer.cornerRadius = 5.0
        
        view.backgroundColor = UIColor(colorLiteralRed: 217.0/255.0, green: 217.0/255.0 , blue: 217.0/255.0, alpha: 1.0)

    }
    
    //MARK: Actions 
    
    
    @IBAction func refreshOrderBookButtonPressed(sender: UIButton) {
        
        getOrderBookData()
        
    }
    
    //MARK: Data Functions
    
    
    func getOrderBookData() {
        dataManager.fetchOrderBook { (result) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let orderBook  = result
                
                self.buyOrderValueLabel.text = String(format: "%0.3f ETH", orderBook.buysValue)
                self.sellOrderValueLabel.text = String(format: "%0.3f ETH", orderBook.sellsValue)
                
                
                print("buys \(orderBook.totalBuys) number of sells \(orderBook.totalSells)")
                
            })
        }
    }
    

}
