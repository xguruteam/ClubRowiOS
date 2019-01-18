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
    @IBOutlet weak var scrollChart: UIScrollView!
    
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

        lblDate.text = Util.convertUnixTimeToDateString(history["inserted_at"] as! Int, format: "MM/dd/yyyy")
        lblClassName.text = history["class_name"] as? String
        
        
        viewChart.animation.enabled = true
        viewChart.area = false
        viewChart.x.grid.visible = true
        viewChart.y.grid.visible = true
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
            let url = SERVER_URL + KEY_API_LOAD_STATISTIC_SESSION_PROGRESS + "\(id)"
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
                        
                        guard let snapshots = data["workout_snapshots"] as? [[String: Any]] else {
                            error = true
                            break
                        }
                        
                        if snapshots.count == 0 {
                            error = true
                            break
                        }
                        
                        self?.statistics = snapshots
                        
                        if snapshots.count < 2 {
                            self?.statistics.append(snapshots[0])
                        }
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
        self.viewChart.x.labels.values = ["00:00:00", "00:00:00"]
        
        if self.viewChart.x.labels.values.count < 8 {
            self.viewChart.frame = CGRect(x: 0, y: 0, width: self.scrollChart.bounds.width, height: 270)
        }
        else {
            self.viewChart.frame = CGRect(x: 0, y: 0, width: self.viewChart.x.labels.values.count * 50, height: 270)
        }
        self.scrollChart.contentSize = self.viewChart.frame.size
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
                return CGFloat(truncating: point["distance"] as? NSNumber ?? 0)
            })
            self.viewChart.addLine(data)
            data = self.statistics.map({ (point) -> CGFloat in
                return CGFloat(truncating: point["calories"] as? NSNumber ?? 0)
            })
            self.viewChart.addLine(data)
            data = self.statistics.map({ (point) -> CGFloat in
                return CGFloat(truncating: point["speed"] as? NSNumber ?? 0)
            })
            self.viewChart.addLine(data)
            data = self.statistics.map({ (point) -> CGFloat in
                return CGFloat(truncating: point["strokes_per_minute"] as? NSNumber ?? 0)
            })
            self.viewChart.addLine(data)
            data = self.statistics.map({ (point) -> CGFloat in
                return CGFloat(truncating: point["wattage"] as? NSNumber ?? 0)
            })
            self.viewChart.addLine(data)
            
            self.viewChart.x.labels.values = self.statistics.map({ (point) -> String in
                let elapsed = point["seconds_since_workout_started"] as? Int ?? 0
                let (h, m, s) = Util.secondsToHoursMinutesSeconds(seconds: elapsed)
                return NSString(format: "%02d:%02d:%02d", h, m, s) as String
            })
            
            if self.viewChart.x.labels.values.count < 8 {
                self.viewChart.frame = CGRect(x: 0, y: 0, width: self.scrollChart.bounds.width, height: 270)
            }
            else {
                self.viewChart.frame = CGRect(x: 0, y: 0, width: self.viewChart.x.labels.values.count * 50, height: 270)
            }
            self.scrollChart.contentSize = self.viewChart.frame.size
            
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { [weak self] (_) in
                self?.viewChart.selectPoint(0)
            })
            
            

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
        vc.history = self.history
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
        vc.history = self.history
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        lblDistance.text = "\(Int(yValues[0]))m"
        lblCalories.text = "\(Int(yValues[1]))cal"
        lblSpeed.text = "\(Int(yValues[2]))m/s"
        lblStrokes.text = "\(Int(yValues[3]))s/m"
        lblWattage.text = "\(Int(yValues[4]))wat"
    }
    
}
