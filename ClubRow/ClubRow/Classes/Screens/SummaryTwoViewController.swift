//
//  SummaryTwoViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/10/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import ScrollableGraphView

class SummaryTwoViewController: SuperViewController, ScrollableGraphViewDataSource {
    
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblAverage: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var graph: ScrollableGraphView!
    @IBOutlet weak var lblValue: UILabel!
    
    
    @IBOutlet weak var lblType2: UILabel!
    @IBOutlet weak var lblUnit2: UILabel!
    @IBOutlet weak var lblClassAverage: UILabel!
    @IBOutlet weak var lblDuration2: UILabel!
    
    @IBOutlet weak var lblTypeTop: UILabel!
    var type: Int = 0
    
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let typeString = Util.convertTypeString(type)
        lblTypeTop.text = typeString
        lblType.text = typeString
        lblType2.text = typeString
        let unitString = Util.convertUnitString(type)
        lblUnit.text = unitString
        lblUnit2.text = unitString
        
        
        let graphView = graph!
        graphView.dataSource = self
        // Setup the plot
        let barPlot = BarPlot(identifier: "bar")
        
        barPlot.barWidth = 25
        barPlot.barLineWidth = 1
        barPlot.barLineColor = UIColor.colorFromHex(hexString: "#10E5C0")
        barPlot.barColor = UIColor.colorFromHex(hexString: "#15ECC1")
        
        barPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        barPlot.animationDuration = 1
        
        // Setup the reference lines
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.black.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.black
        
        referenceLines.dataPointLabelColor = UIColor.black.withAlphaComponent(0.5)
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#FFFFFF")
        
        graphView.shouldAnimateOnStartup = true
        
        graphView.rangeMax = 100
        graphView.rangeMin = 0
        
        // Add everything
        graphView.addPlot(plot: barPlot)
        graphView.addReferenceLines(referenceLines: referenceLines)

    }
    
    @IBAction func onSummary(_ sender: Any) {
        let vc = self.getStoryboardWithIdentifier(identifier: "SummaryViewController") as! SummaryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Data Properties
    
    private var numberOfDataItems = 29
    
    // Data for graphs with a single plot
    private lazy var barPlotData: [Double] =  self.generateRandomData(self.numberOfDataItems, max: 100, shouldIncludeOutliers: false)
    
    // Labels for the x-axis
    
    private lazy var xAxisLabels: [String] =  self.generateSequentialLabels(self.numberOfDataItems, text: "FEB")
    // MARK: ScrollableGraphViewDataSource protocol
    // #########################################################
    
    // You would usually only have a couple of cases here, one for each
    // plot you want to display on the graph. However as this is showing
    // off many graphs with different plots, we are using one big switch
    // statement.
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        
        switch(plot.identifier) {
            
        // Data for the graphs with a single plot
        case "bar":
            return barPlotData[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        // Ensure that you have a label to return for the index
        return xAxisLabels[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        return numberOfDataItems
    }
    
    private func generateRandomData(_ numberOfItems: Int, max: Double, shouldIncludeOutliers: Bool = true) -> [Double] {
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
            
            if(shouldIncludeOutliers) {
                if(arc4random() % 100 < 10) {
                    randomNumber *= 3
                }
            }
            
            data.append(randomNumber)
        }
        return data
    }
    
    private func generateRandomData(_ numberOfItems: Int, variance: Double, from: Double) -> [Double] {
        
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            
            let randomVariance = Double(arc4random()).truncatingRemainder(dividingBy: variance)
            var randomNumber = from
            
            if(arc4random() % 100 < 50) {
                randomNumber += randomVariance
            }
            else {
                randomNumber -= randomVariance
            }
            
            data.append(randomNumber)
        }
        return data
    }
    
    private func generateSequentialLabels(_ numberOfItems: Int, text: String) -> [String] {
        var labels = [String]()
        for i in 0 ..< numberOfItems {
            labels.append("\(text) \(i+1)")
        }
        return labels
    }
}

