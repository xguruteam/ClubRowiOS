//
//  ProfileViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/2/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import CoreBluetooth

import CRRefresh
import MKProgress
import Alamofire
import SwiftyJSON


class ProfileViewController: SuperViewController {
    @IBOutlet weak var top: NSLayoutConstraint!
    
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet var viewChart: LineChart!
    @IBOutlet weak var scrollChart: UIScrollView!
    
    var histories: [[String: Any]]! = []
    var average: [String: Any]! = ["distance": 0, "calories": 0, "speed": 0, "strokes_per_minute": 0, "wattage": 0]
    var statistics: [[String: Any]]! = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
//        resizeTopView()

        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        // shadow
        titleView.layer.shadowColor = UIColor.black.cgColor
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        titleView.layer.shadowOpacity = 0.07
        titleView.layer.shadowRadius = 3
     
        self.profileTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            MKProgress.show()
            
            self?.loadAverage()
        }
        
        self.profileTableView.cr.beginHeaderRefresh()

    }
    
    func loadAverage() {
        // API
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Token token=\(appDelegate.g_token)"
        ]
        let url = SERVER_URL + KEY_API_LOAD_STATISTIC_TODAY
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
                    
                    self.average = ["distance": 0, "calories": 0, "speed": 0, "strokes_per_minute": 0, "wattage": 0]
                    
                    if let totals = data["totals"] as? [String: Any] {
                        self.average.merge(totals, uniquingKeysWith: { (_, new) -> Any in
                            new
                        })
                    }
                    
                    if let max = data["max"] as? [String: Any] {
                        self.average.merge(max, uniquingKeysWith: { (_, new) -> Any in
                            new
                        })
                    }
                    
                    self.loadHistory()

                }
                if error == true {
                    self.onLoadError(0)
                }
                
        }
    }
    
    func loadHistory() {
        // history
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Token token=\(appDelegate.g_token)"
        ]
        let url = SERVER_URL + KEY_API_LOAD_STATISTIC_HISTORY
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
                    
                    self.histories = data.sorted {
                        let first = $0["inserted_at"] as? Int ?? 0
                        let second = $1["inserted_at"] as? Int ?? 0
                        return first > second
                    }
                    
                    self.loadGraph()
                }
                if error == true {
                    self.onLoadError(1)
                }
                
        }
    }

    func loadGraph() {
        
        guard let lastHistory = self.histories.first else {
            self.statistics = []
            onLoadFinish()
            return
        }
        
        
        // history
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Token token=\(appDelegate.g_token)"
        ]
        let url = SERVER_URL + KEY_API_LOAD_STATISTIC_SESSION_PROGRESS + "\(lastHistory["id"] as! Int)"
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
                    
                    self.statistics = snapshots.reduce(into: [], { (result, current) in
                        guard let last = result?.last else {
                            result?.append(current)
                            return
                        }
                        
                        let distance = (last["distance"] as? Double ?? 0) + (current["distance"] as? Double ?? 0)
                        let calories = (last["calories"] as? Double ?? 0) + (current["calories"] as? Double ?? 0)
                        
                        let new = current.merging(
                            ["distance": distance,
                             "calories": calories],
                            uniquingKeysWith: { (old, new) -> Any in
                                new
                        })
                        result?.append(new)
                    })
                    
//                    if snapshots.count < 2 {
//                        self.statistics.append(snapshots[0])
//                    }
                    
                }
                if error == true {
                    self.onLoadError(2)
                }
                else {
                    self.onLoadFinish()
                }
        }
    }
    
    func onLoadError(_ type: Int) {
        switch type {
        case 1:
            histories = []
            statistics = []
        case 2:
            statistics = []
        default:
            histories = []
            average = ["distance": 0, "calories": 0, "speed": 0, "strokes_per_minute": 0, "wattage": 0]
            statistics = []
        }
        DispatchQueue.main.async(execute: {
            //                            self?.collectionView.reloadData()
            self.profileTableView.cr.endHeaderRefresh()
            self.profileTableView.reloadData()
            MKProgress.hide()
            //                            self?.view.makeToast(MSG_INSTRUCTORS_FAILED_LOAD_ALL_INSTRUCTORS)
        })
    }
    
    func onLoadFinish() {
        DispatchQueue.main.async(execute: {
            self.profileTableView.cr.endHeaderRefresh()
            self.profileTableView.reloadData()
            MKProgress.hide()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onViewSummary(_ sender: Any) {
        
        guard let lastHistory = self.histories.first else {
            self.statistics = []
            onLoadFinish()
            return
        }
        
        let vc = self.getStoryboardWithIdentifier(identifier: "SummaryOneViewController") as! SummaryOneViewController
        vc.history = lastHistory
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSummary(_ sender: Any) {
        let vc = self.getStoryboardWithIdentifier(identifier: "SummaryViewController") as! SummaryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSetting(_ sender: Any) {
        
        let alert = UIAlertController(title: "Settings", message: "Where would you like to go?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Connect Concept2", style: .default, handler: { (_) in
            let vc = self.getStoryboardWithIdentifier(identifier: "DevicesViewController") as! DevicesViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (_) in
            UserDefaults.standard.set(nil, forKey: KEY_TOKEN)
            UserDefaults.standard.synchronize()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.g_token = ""
            RootViewController.instance.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func onDetails(_ sender: Any) {
        let vc = self.getStoryboardWithIdentifier(identifier: "SummaryTwoViewController") as! SummaryTwoViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //
    func resizeTopView() {
//        switch "\(Device.version())" {
//        case "simulator":
//            let string = UIDevice().modelName
//            let start = String.Index(encodedOffset: 6)
//            let end = String.Index(encodedOffset: 8)
//            let substring = String(string[start..<end])
//            print(substring)
//            
//            if substring == "10" {
//                top.constant = 44
//            } else {
//                top.constant = 0
//            }
//        case "iPhoneX":
//            top.constant = 44
//        case "iPhoneXS":
//            top.constant = 44
//        case "iPhoneXS_Max":
//            top.constant = 44
//        case "iPhoneXR":
//            top.constant = 44
//        default:
//            top.constant = 0
//            print("unkown")
//        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailCell") as! ProfileDetailCell
            cell.selectionStyle = .none
            
            
            cell.labelDistance.text = "\((average["distance"] as? NSNumber) ?? 0)"
            cell.labelCalories.text = "\((average["calories"] as? NSNumber) ?? 0)"
            cell.labelSpeed.text = "\(average["speed"] as? NSNumber ?? 0)"
            cell.labelStrokes.text = "\(average["strokes_per_minute"] as? NSNumber ?? 0)"
            cell.labelWattage.text = "\(average["wattage"] as? NSNumber ?? 0)"
            
            
            cell.viewChart.animation.enabled = true
            cell.viewChart.area = false
            cell.viewChart.x.grid.visible = true
            cell.viewChart.y.grid.visible = true
            cell.viewChart.y.labels.visible = false
            cell.viewChart.x.labels.visible = true
            cell.viewChart.colors = [
                UIColor(rgb: 0xF8C7CD),
                UIColor(rgb: 0x93FFE9),
                UIColor(rgb: 0xFFC793),
                UIColor(rgb: 0xB693FF),
                UIColor(rgb: 0x93DFFF),
            ]
            
            if self.statistics.count == 0 {
                cell.viewChart.clear()
                cell.viewChart.addLine([0, 0])
                cell.viewChart.addLine([0, 0])
                cell.viewChart.addLine([0, 0])
                cell.viewChart.addLine([0, 0])
                cell.viewChart.addLine([0, 0])
                cell.viewChart.x.labels.values = ["00:00:00", "00:00:00"]
            }
            else {
                
                var chartSamples: [[String: Any]] = []
                chartSamples.append([
                    "distance": 0,
                    "calories": 0,
                    "speed": 0,
                    "strokes_per_minute": 0,
                    "wattage": 0,
                    "seconds_since_workout_started": 0
                    ])
                chartSamples.append(contentsOf: self.statistics)
            
                cell.viewChart.clear()
                
                var data: [CGFloat]
                
                data = chartSamples.map({ (point) -> CGFloat in
                    return CGFloat(truncating: point["distance"] as? NSNumber ?? 0)
                })
                data = Util.reduce(samples: data, multipler: 1.0)
                cell.viewChart.addLine(data)
                
                data = chartSamples.map({ (point) -> CGFloat in
                    return CGFloat(truncating: point["calories"] as? NSNumber ?? 0)
                })
                data = Util.reduce(samples: data, multipler: 0.8)
                cell.viewChart.addLine(data)
                
                data = chartSamples.map({ (point) -> CGFloat in
                    return CGFloat(truncating: point["speed"] as? NSNumber ?? 0)
                })
                data = Util.reduce(samples: data, multipler: 0.4)
                cell.viewChart.addLine(data)
                
                data = chartSamples.map({ (point) -> CGFloat in
                    return CGFloat(truncating: point["strokes_per_minute"] as? NSNumber ?? 0)
                })
                data = Util.reduce(samples: data, multipler: 0.7)
                cell.viewChart.addLine(data)
                
                data = chartSamples.map({ (point) -> CGFloat in
                    return CGFloat(truncating: point["wattage"] as? NSNumber ?? 0)
                })
                data = Util.reduce(samples: data, multipler: 0.9)
                cell.viewChart.addLine(data)
                
                cell.viewChart.x.labels.values = chartSamples.map({ (point) -> String in
                    let elapsed = point["seconds_since_workout_started"] as? Int ?? 0
                    let (h, m, s) = Util.secondsToHoursMinutesSeconds(seconds: elapsed)
                    return NSString(format: "%02d:%02d:%02d", h, m, s) as String
                })
                
            }
            
            if cell.viewChart.x.labels.values.count < 8 {
                cell.viewChart.frame = CGRect(x: 0, y: 0, width: cell.scrollChart.bounds.width, height: 270)
            }
            else {
                cell.viewChart.frame = CGRect(x: 0, y: 0, width: cell.viewChart.x.labels.values.count * 50, height: 270)
            }
            cell.scrollChart.contentSize = cell.viewChart.frame.size

            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHistoryCell") as! ProfileHistoryCell
            cell.selectionStyle = .none
            
            let history = histories[indexPath.row - 1]
            cell.lblDate.text = Util.convertUnixTimeToDateString(history["inserted_at"] as! Int, format: "MM/dd/yyyy")
            cell.lblClassName.text = history["class_name"] as? String
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 1095
        default:
            return 49
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.histories.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        let vc = self.getStoryboardWithIdentifier(identifier: "SummaryOneViewController") as! SummaryOneViewController
        vc.history = histories[indexPath.row - 1]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
