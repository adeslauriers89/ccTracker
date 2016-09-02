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
                
                self.presentAlertViewController(self.filteredPairs[indexPath.row])
                
            }
        } else {
            pair = currencyPairs[indexPath.row]
            cell.tapAction = { (cell) in
                
                self.presentAlertViewController(self.currencyPairs[indexPath.row])
            }
        }
        
        cell.currencyPairLabel.text = pair.name
        
        return cell
    }
    
    
    //MARK: - General Functions
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPairs = currencyPairs.filter { pair in
            let categoryMatch = (scope == "All")  || (pair.baseCurrency == scope)
            
            return categoryMatch && pair.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    func presentAlertViewController(forSelectedPair: CurrencyPair) {
        
        let alertController = UIAlertController(title: forSelectedPair.name, message: "Search with selected pair or set as default", preferredStyle: .Alert)
        
        let searchAction = UIAlertAction(title: "Search", style: .Default) { (action: UIAlertAction) in
            
            self.dataManager.selectedCurrencyPair = forSelectedPair.name
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        }
        
        let setDefaultAction = UIAlertAction(title: "Set as default", style: .Default) { (action: UIAlertAction) in
            
            self.dataManager.defaultCurrencyPair = forSelectedPair.name
            self.dataManager.selectedCurrencyPair = forSelectedPair.name
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction) in
        }
        
        alertController.addAction(searchAction)
        alertController.addAction(setDefaultAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
}

extension CurrencySearchViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension CurrencySearchViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
