//
//  LineChartViewController.swift
//  ETH-Tracker
//
//  Created by Adam DesLauriers on 2016-04-26.
//  Copyright © 2016 Adam DesLauriers. All rights reserved.
//

import UIKit
import Charts

class LineChartViewController: UIViewController, ChartViewDelegate {

    //MARK: Properties
    
    var dataManager = DataManager()
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    //MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineChartView.delegate = self
        lineChartView.descriptionTextColor = UIColor.blackColor()
        
        
       
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Value Bought")
        
    }


}


