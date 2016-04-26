//
//  ViewController.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-03-29.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    //MARK: Properties
    
    var dataManager = DataManager()
    
  

    //MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        //dataManager.getLast200Trades()
//        dataManager.getTradesLast24Hrs()
//        dataManager.getTradesLast12Hrs()
//        dataManager.getTradesLast6Hrs()
//        dataManager.getTradesLast2Hrs()
      //  dataManager.getTradesLast30Mins()
     //   dataManager.getTradesLastMinute()
        
        dataManager.getOrderBook()
        
      //  dataManager.getCurrentPrice()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
           
    }
    
    //MARK: TableView Delegates
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! EthTableViewCell!
        
        cell.backgroundColor = UIColor.blueColor()
        
        
        return cell
        
    }
    
    //MARK: Actions
    
    
    
    // number of rows in table view
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.animals.count
//    }
//    
    // create a cell for each table view row
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
//        
//        cell.textLabel?.text = self.animals[indexPath.row]
//        
//        return cell
//    }




}

