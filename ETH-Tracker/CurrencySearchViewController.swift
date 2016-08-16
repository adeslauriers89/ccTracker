//
//  CurrencySearchViewController.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-08-15.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit

class CurrencySearchViewController: UITableViewController {
    
    //MARK: Properties

//    var currencyPairs = [String]()
//    var filteredPairs = [String]()
    
    var currencyPairs = [CurrencyPair]()
    var filteredPairs = [CurrencyPair]()
    
    let dataManager = DataManager.sharedManager
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    
    //MARK: ViewController Life Cycle
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.getCurrencyPairs { (pairs) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.currencyPairs = pairs
                
//                let fetchedPairs = pairs
//                
//                for pair in fetchedPairs {
//                    
//                    let pairName = pair.name
//                    
//                    self.currencyPairs.append(pairName)
//                }
                
                self.tableView.reloadData()
            })
            
        }
      
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.scopeButtonTitles = ["All", "BTC", "ETH", "USDT"]
        searchController.searchBar.delegate = self
    }
    
    //MARK: TableView
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredPairs.count
        }
        return currencyPairs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CurrencyCell
        
        let pair: CurrencyPair
        if searchController.active && searchController.searchBar.text != "" {
            pair = filteredPairs[indexPath.row]
            cell.tapAction = { (cell) in
                print("suh \(self.filteredPairs[indexPath.row].name)")
            }
        } else {
            pair = currencyPairs[indexPath.row]
            cell.tapAction = { (cell) in
                print("suh \(self.currencyPairs[indexPath.row].name)")
            }
        }

        cell.currencyPairLabel.text = pair.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if searchController.active && searchController.searchBar.text != "" {
            print("hey \(filteredPairs[indexPath.row].name)")
        } else {
            print("hey \(currencyPairs[indexPath.row].name)")
        }
    }
    
    //MARK: - General Functions
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPairs = currencyPairs.filter { pair in
            let categoryMatch = (scope == "All")  || (pair.baseCurrency == scope)
            
            return categoryMatch && pair.name.lowercaseString.containsString(searchText.lowercaseString)
         //   return pair.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
 
}

extension CurrencySearchViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        
      //  filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension CurrencySearchViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
