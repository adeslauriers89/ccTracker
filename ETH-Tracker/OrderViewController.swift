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
    
    @IBOutlet weak var buyOrderLabel: UILabel!
    @IBOutlet weak var sellOrderLabel: UILabel!
    
    
    //MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       buyOrderLabel.text = dataManager.buyOrderInfo       
//        sellOrderLabel.text = dataManager.sellOrderInfo
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
       // dataManager.getOrderBook()
        
        dataManager.fetchOrderBook { (result) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in

            
            let obj  = result
            
            self.buyOrderLabel.text = "Buys: \(obj.totalBuys) Value \(obj.buysValue)"
            self.sellOrderLabel.text = "Buys: \(obj.totalSells) Value \(obj.sellsValue)"
            })
        }
        
    }
   
    

}
