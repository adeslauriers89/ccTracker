//
//  CurrencyCell.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-08-15.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    
    var tapAction: ((UITableViewCell) -> Void)?
    
    @IBOutlet weak var currencyPairLabel: UILabel!
    
    
    @IBAction func setButtonPressed(sender: UIButton) {
        tapAction?(self)
    }
    
    

}
