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

class ProfileViewController: SuperViewController {
    @IBOutlet weak var top: NSLayoutConstraint!
    
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet var viewChart: Chart!
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
        let vc = self.getStoryboardWithIdentifier(identifier: "DevicesViewController") as! DevicesViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
            return 1116
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
