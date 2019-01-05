//
//  ProfileViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/2/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import SwiftChart
import CoreBluetooth
import Device

import CRRefresh
import MKProgress
import Alamofire
import SwiftyJSON


class ProfileViewController: SuperViewController {
    @IBOutlet weak var top: NSLayoutConstraint!
    
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet var viewChart: Chart!
    
    var histories: [[String: Any]]! = []
    var average: [String: Any]! = [:]
    var statistics: [[String: Any]]! = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
//        resizeTopView()

        let series1 = ChartSeries([0, 6, 2, 8, 4, 7, 3, 10, 8])
        series1.color = ChartColors.yellowColor()
        series1.area = false
        
        let series2 = ChartSeries([1, 0, 0.5, 0.2, 0, 1, 0.8, 0.3, 1])
        series2.color = ChartColors.redColor()
        series2.area = false
        
        let series3 = ChartSeries([9, 8, 10, 8.5, 9.5, 10])
        series3.color = ChartColors.purpleColor()
        series3.area = false
        
        let series4 = ChartSeries([5, 4, 5.5, 4.2, 3.5, 4, 3.8, 3.3, 4])
        series4.color = ChartColors.blueColor()
        series4.area = false
        
        let series5 = ChartSeries([3, 2, 3.5, 1.2, 3, 2, 3.8, 3.3, 4])
        series5.color = ChartColors.purpleColor()
        series5.area = false
        
//        viewChart.add([series1, series2, series3, series4, series5])
        
        
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
    
    func loadHistory() {
        // history
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Token token=\(appDelegate.g_token)"
        ]
        let url = SERVER_URL + "statistics/history"
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
            
                    self.histories = data
                    
                    self.loadGraph()
                }
                if error == true {
                    self.onLoadError()
                }
                
        }
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
                    
                    self.loadHistory()

                }
                if error == true {
                    self.onLoadError()
                }
                
        }
    }
    
    func loadGraph() {
        // history
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Token token=\(appDelegate.g_token)"
        ]
        let url = SERVER_URL + "statistics/session/\(1)"
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
                    
                    self.statistics = data
                    
                }
                if error == true {
                    self.onLoadError()
                }
                else {
                    self.onLoadFinish()
                }
        }
    }
    
    func onLoadError() {
        histories = []
        average = [:]
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
        let vc = self.getStoryboardWithIdentifier(identifier: "SummaryOneViewController") as! SummaryOneViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSummary(_ sender: Any) {
        let vc = self.getStoryboardWithIdentifier(identifier: "SummaryViewController") as! SummaryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSetting(_ sender: Any) {
        
        let alert = UIAlertController(title: "Settings", message: "Where would you like to go?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Scan", style: .default, handler: { (_) in
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
        switch "\(Device.version())" {
        case "simulator":
            let string = UIDevice().modelName
            let start = String.Index(encodedOffset: 6)
            let end = String.Index(encodedOffset: 8)
            let substring = String(string[start..<end])
            print(substring)
            
            if substring == "10" {
                top.constant = 44
            } else {
                top.constant = 0
            }
        case "iPhoneX":
            top.constant = 44
        case "iPhoneXS":
            top.constant = 44
        case "iPhoneXS_Max":
            top.constant = 44
        case "iPhoneXR":
            top.constant = 44
        default:
            top.constant = 0
            print("unkown")
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("====", indexPath.row)
        switch indexPath.row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailCell") as! ProfileDetailCell
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHistoryCell") as! ProfileHistoryCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 1090
        default:
            return 49
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.getStoryboardWithIdentifier(identifier: "SummaryOneViewController") as! SummaryOneViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
