//
//  SummaryTwoViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/10/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import ScrollableGraphView
import CRRefresh
import Alamofire
import SwiftyJSON
import MKProgress

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
    
    var max: Double = 0
    
    var average: [String: Any]! = ["distance": 0, "calories": 0, "speed": 0, "strokes_per_minute": 0, "wattage": 0]
    
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

        self.tableview.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            MKProgress.show()
            
            // API
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Token token=\(appDelegate.g_token)"
            ]
            let url = SERVER_URL + "statistics/user/\(appDelegate.g_userID)/daily"
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    var error = false
                    switch response.result
                    {
                    case .failure( _):
                        error = true
                        
                    case .success( _):
                        
                        guard let raw = response.result.value as? [String: Any] else {
                            error = true
                            break
                        }
                        
                        guard let data = raw["data"] as? [[String: Any]] else {
                            error = true
                            break
                        }
                        
                        self?.xAxisLabels = []
                        self?.barPlotData =  data.map({ (point) -> Double in
                            var para1, para2 : String
                            switch self?.type {
                            case 0, 1:
                                para1 = "totals"
                            default:
                                para1 = "means"
                            }
                            para2  = Util.convertTypeToKey((self?.type)!)
                            
                            let block1 = point[para1] as! [String: Any]
                            let block2 = block1[para2] as! NSNumber
                            let label = Util.convertUnixTimeToDateString(point["date"] as! Int, format: "MMM dd")

                            self?.xAxisLabels.append(label!)
                            return Double(truncating: block2)
                        })

                        self?.max = self?.barPlotData.max() ?? 0
                        self?.numberOfDataItems = self?.barPlotData.count ?? 0
                       
//                        self?.instructors = data
                        
                    }
                    
                    if error == true {
//                        self?.instructors = []
                        self?.barPlotData = []
                        self?.xAxisLabels = []
                        
                        DispatchQueue.main.async(execute: {
                            self?.graph.rangeMax = 100
                            self?.graph.rangeMin = 0
                            self?.graph.reload()
                            self?.view.makeToast(MSG_INSTRUCTORS_FAILED_LOAD_ALL_INSTRUCTORS)
                        })
                    }
                    else {
                        DispatchQueue.main.async(execute: {
                            self?.graph.rangeMax = self?.max ?? 100
                            self?.graph.rangeMin = 0
                            self?.graph.reload()
                        })
                    }
                    
                    self?.loadAverage()
            }
        }
        
        self.tableview.cr.beginHeaderRefresh()

    }
    
    func loadAverage() {
        // API
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Token token=\(appDelegate.g_token)"
        ]
        let url = SERVER_URL + "/statistics/average?period=day"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                var error = false
                switch response.result
                {
                case .failure( _):
                    error = true
                    
                case .success( _):
                    
                    guard let raw = response.result.value as? [String: Any] else {
                        error = true
                        break
                    }
                    
                    guard let data = raw["data"] as? [String: Any] else {
                        error = true
                        break
                    }
                    
                    self.average = data
                    
                }
                
                if error == true {
                    self.average = ["distance": 0, "calories": 0, "speed": 0, "strokes_per_minute": 0, "wattage": 0]
                }
                
                DispatchQueue.main.async(execute: {
                    self.lblAverage.text = "\((self.average[Util.convertTypeToKey(self.type)] as? NSNumber) ?? 0)"
                    self.tableview.cr.endHeaderRefresh()
                    MKProgress.hide()
                })

        }
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
    
    private var numberOfDataItems = 0
    
    // Data for graphs with a single plot
    private lazy var barPlotData: [Double] =  []
    
    // Labels for the x-axis
    
    private lazy var xAxisLabels: [String] =  []
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
    
}

