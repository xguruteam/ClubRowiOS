//
//  SummaryOneViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/8/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import SwiftChart
import CRRefresh
import MKProgress
import Alamofire
import SwiftyJSON


class SummaryOneViewController: SuperViewController, LineChartDelegate {

    @IBOutlet weak var lblClassName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewChart: LineChart!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblCalories: UILabel!
    
    @IBOutlet weak var lblSpeed: UILabel!
    
    @IBOutlet weak var lblStrokes: UILabel!
    
    @IBOutlet weak var lblWattage: UILabel!
    
    var history: [String: Any]!
    var statistics: [[String: Any]]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblDate.text = Util.convertTimeStamp("\(history["inserted_at"] as! String)Z", format: "MM/dd/yyyy")
        lblClassName.text = history["class_name"] as? String
        
        viewChart.animation.enabled = true
        viewChart.area = false
        viewChart.x.grid.visible = false
        viewChart.y.grid.visible = false
        viewChart.y.labels.visible = false
        viewChart.x.labels.visible = true
        viewChart.delegate = self
        viewChart.colors = [
            UIColor(rgb: 0xF8C7CD),
            UIColor(rgb: 0x93FFE9),
            UIColor(rgb: 0xFFC793),
            UIColor(rgb: 0xB693FF),
            UIColor(rgb: 0x93DFFF),
        ]
//        viewChart.dots.color = UIColor.red
        initGraph()
        
        self.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            
            guard let id = self?.history["id"] as? Int else {
                self?.tableView.cr.endHeaderRefresh()
                self?.statistics = []
                self?.updateGraph()
                return
            }
            
            MKProgress.show()
            
            // history
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Token token=\(appDelegate.g_token)"
            ]
            let url = SERVER_URL + "statistics/session/\(id)"
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
                        
                        self?.statistics = data
                        self?.statistics = [
                            ["distance": 10, "wattage": 3, "speed": 5, "strokes_per_minute": 8, "calories": 2],
                            ["distance": 3, "wattage": 10, "speed": 1, "strokes_per_minute": 4, "calories": 3],
                            ["distance": 20, "wattage": 7, "speed": 7, "strokes_per_minute": 2, "calories": 5],
                            ["distance": 5, "wattage": 15, "speed": 0, "strokes_per_minute": 8, "calories": 7],
                        ]
                        
                    }
                    if error == true {
                        self?.tableView.cr.endHeaderRefresh()
                        MKProgress.hide()
                        self?.statistics = []
                        self?.updateGraph()
                    }
                    else {
                        self?.tableView.cr.endHeaderRefresh()
                        MKProgress.hide()
                        self?.updateGraph()
                    }
            }
        }
        
        self.tableView.cr.beginHeaderRefresh()

    }
    
    func initGraph() {
        self.viewChart.clear()
        self.viewChart.addLine([0, 0])
        self.viewChart.addLine([0, 0])
        self.viewChart.addLine([0, 0])
        self.viewChart.addLine([0, 0])
        self.viewChart.addLine([0, 0])
    }
    
    func updateGraph() {
        
        DispatchQueue.main.async {
            // simple arrays
            
//            print(self.statistics)
            
            if self.statistics.count == 0 {
                self.initGraph()
                return
            }
            
            self.viewChart.clear()
            
            var data: [CGFloat]
            data = self.statistics.map({ (point) -> CGFloat in
                return CGFloat(point["distance"] as? Int ?? 0)
            })
            self.viewChart.addLine(data)
            data = self.statistics.map({ (point) -> CGFloat in
                return CGFloat(point["calories"] as? Int ?? 0)
            })
            self.viewChart.addLine(data)
            data = self.statistics.map({ (point) -> CGFloat in
                return CGFloat(point["speed"] as? Int ?? 0)
            })
            self.viewChart.addLine(data)
            data = self.statistics.map({ (point) -> CGFloat in
                return CGFloat(point["strokes_per_minute"] as? Int ?? 0)
            })
            self.viewChart.addLine(data)
            data = self.statistics.map({ (point) -> CGFloat in
                return CGFloat(point["wattage"] as? Int ?? 0)
            })
            self.viewChart.addLine(data)

//
//            let data: [CGFloat] = [3, 4, -2, 11, 13, 15, 3, 4, -2, 11, 13, 15]
//            let data2: [CGFloat] = [1, 3, 5, 13, 17, 20, 1, 3, 5, 13, 17, 40]
//
//            // simple line with custom x axis labels
//            let xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jan", "Feb", "Mar", "Apr", "May", "Jun"]
//            self.viewChart.addLine(data)
//            self.viewChart.addLine(data2)
//            self.viewChart.x.labels.values = xLabels

        }

    }
    
    @IBAction func onSummary(_ sender: Any) {
        let vc = self.getStoryboardWithIdentifier(identifier: "SummaryViewController") as! SummaryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onButtonClick(_ sender: UIButton) {
        
        let vc = self.getStoryboardWithIdentifier(identifier: "SummaryTwoViewController") as! SummaryTwoViewController
        vc.type = sender.tag
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
    
    @IBAction func onGraph(_ sender: Any) {
        let vc = self.getStoryboardWithIdentifier(identifier: "SummaryTwoViewController") as! SummaryTwoViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        lblDistance.text = "\(Int(yValues[0]))"
        lblCalories.text = "\(Int(yValues[1]))"
        lblSpeed.text = "\(Int(yValues[2]))"
        lblStrokes.text = "\(Int(yValues[3]))"
        lblWattage.text = "\(Int(yValues[4]))"
    }
    
}
