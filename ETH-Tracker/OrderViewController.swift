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
    
    var dataManager = DataManager.sharedManager
    
    @IBOutlet weak var buyOrderView: UIView!
    @IBOutlet weak var sellOrderView: UIView!
    @IBOutlet weak var buyOrderValueLabel: UILabel!
    @IBOutlet weak var sellOrderValueLabel: UILabel!
    
    @IBOutlet weak var percentBuyLabel: UILabel!
    @IBOutlet weak var percentSellLabel: UILabel!
    
    
    @IBOutlet weak var orderBookRefreshButton: UIButton!
    
    var defaultPercent: Double {
        get {
            if let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("orderPercent") as? Double {
                return returnValue
            } else {
                return 1.0
            }
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "orderPercent")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var percentToSearch = Double()
    
    
    //MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewStyles()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getOrderBookData(defaultPercent)
        
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
        
        getOrderBookData(percentToSearch)
        
    }
    
    @IBAction func changePercentButtonPressed(sender: UIButton) {
        var inputTextField: UITextField?
        
        let percentChangeAlert = UIAlertController(title: "Change Percentage", message: "Input a different % to search with. Suggested range 0.01 - 3.0", preferredStyle: UIAlertControllerStyle.Alert)
        
        percentChangeAlert.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            textField.placeholder = "1.0"
            inputTextField = textField
        }
        
        let setDefaultAction = UIAlertAction(title: "Set as default", style: .Default) { (action: UIAlertAction) in
            
            if let text = inputTextField?.text {
                
                let percentInput = NSNumberFormatter().numberFromString(text)
                
                if let percent = percentInput as Double? {
                    
                    self.percentToSearch = percent
                    self.defaultPercent = percent
                    self.getOrderBookData(percent)
                    
                }
                
                
            }
        }
        
        let enterAction = UIAlertAction(title: "Enter", style: .Default) { (action: UIAlertAction) in
            
            if let text = inputTextField?.text  {
                
                let percentInput = NSNumberFormatter().numberFromString(text)
                
                if let percentInput = percentInput {
                    
                    self.percentToSearch = Double(percentInput)
                    self.getOrderBookData(Double(percentInput))
                    
                }
            }
        }
        percentChangeAlert.addAction(enterAction)
        percentChangeAlert.addAction(setDefaultAction)
        percentChangeAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(percentChangeAlert, animated: true, completion: nil)
        
    }
    
    
    //MARK: Data Functions
    
    
    func getOrderBookData(forPercent: Double) {
        
        var percentForSearch = forPercent
        
        if percentForSearch == 0.0 {
            percentForSearch = self.defaultPercent
        }
        
        
        dataManager.fetchOrderBook(dataManager.selectedCurrencyPair, percentInput: percentForSearch) { (result) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let orderBook  = result
                
                self.buyOrderValueLabel.text = String(format: "%0.3f \(self.dataManager.quoteCurrency)", orderBook.buysValue)
                self.sellOrderValueLabel.text = String(format: "%0.3f \(self.dataManager.quoteCurrency)", orderBook.sellsValue)
                
                self.percentBuyLabel.text = "\(percentForSearch)% of current price"
                self.percentSellLabel.text = "\(percentForSearch)% of current price"
                
                
            })
        }
    }
    
}
