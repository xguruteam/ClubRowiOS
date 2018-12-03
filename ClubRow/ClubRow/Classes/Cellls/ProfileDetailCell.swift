//
//  ProfileDetailCell.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/14/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import SwiftChart
import CoreBluetooth


class ProfileDetailCell: UITableViewCell, C2ConnectionManagerDelegate {

    @IBOutlet weak var viewSummaryBtn: UIButton!
    @IBOutlet weak var viewDetailsBtn: UIButton!
    
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var caloriesView: UIView!
    @IBOutlet weak var speedView: UIView!
    @IBOutlet weak var strokesView: UIView!
    @IBOutlet weak var wattageView: UIView!
    
    @IBOutlet var viewChart: Chart!
    
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelCalories: UILabel!
    @IBOutlet weak var labelSpeed: UILabel!
    @IBOutlet weak var labelStrokes: UILabel!
    @IBOutlet weak var labelWattage: UILabel!
    
    func C2ConnectionManagerDidConnect() {
    }
    
    func C2ConnectionManagerFailConnect() {
    }
    
    func C2ConnectionManagerDidReceiveData(_ parameter: CBCharacteristic) {
        if parameter.uuid.uuidString == C2ScanningManager.PM5_CHAR31_UUID {
            if let value = parameter.value {
                let data = [UInt8](value).map { (i) -> Int in
                    Int(i)
                }
                Log.e("0x31 \(data)")
                //                label1.text = "Elapsed Time : \((data[0] + (data[1] << 8) + (data[2] << 16)) * 10) ms"
                labelDistance.text = String(format: "%.2f", Float(data[3] + (data[4] << 8) + (data[5] << 16)) / 10.0)
            }
        }
        
        if parameter.uuid.uuidString == C2ScanningManager.PM5_CHAR32_UUID {
            if let value = parameter.value {
                let data = [UInt8](value).map { (i) -> Int in
                    Int(i)
                }
                Log.e("0x32 \(data)")
                labelSpeed.text = String(format: "%.2f", Float(data[3] + (data[4] << 8)) / 1000.0)
                labelStrokes.text = "\(data[5])"
            }
        }
        
        if parameter.uuid.uuidString == C2ScanningManager.PM5_CHAR33_UUID {
            if let value = parameter.value {
                let data = [UInt8](value).map { (i) -> Int in
                    Int(i)
                }
                Log.e("0x33 \(data)")
                labelWattage.text = "\(data[10] + (data[11] << 8))"
                labelCalories.text = "\(data[12] + (data[13] << 8))"
            }
        }
        
        //        if parameter.uuid.uuidString == C2ScanningManager.PM5_CHAR3A_UUID {
        //            if let value = parameter.value {
        //                let data = [UInt8](value).map { (i) -> Int in
        //                    Int(i)
        //                }
        //                Log.e("0x3A \(data)")
        //                labelCalories.text = "\(data[8] + (data[9] << 8))"
        //            }
        //        }
        //
        //        if parameter.uuid.uuidString == C2ScanningManager.PM5_CHAR39_UUID {
        //            if let value = parameter.value {
        //                let data = [UInt8](value).map { (i) -> Int in
        //                    Int(i)
        //                }
        //                Log.e("0x39 \(data)")
        //                labelStrokes.text = "\(data[10])"
        //            }
        //        }
        //
        //        if parameter.uuid.uuidString == C2ScanningManager.PM5_CHAR3A_UUID {
        //            if let value = parameter.value {
        //                let data = [UInt8](value).map { (i) -> Int in
        //                    Int(i)
        //                }
        //                Log.e("0x3A \(data)")
        //                labelWattage.text = "\(data[10] + (data[11] << 8))"
        //            }
        //        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Initialization code
        viewSummaryBtn.layer.cornerRadius = 8
        viewDetailsBtn.layer.cornerRadius = 8
        
        gradientOn(view: distanceView)
        gradientOn(view: caloriesView)
        gradientOn(view: speedView)
        gradientOn(view: strokesView)
        gradientOn(view: wattageView)
        
        cornerRadiusOn(view: distanceView)
        cornerRadiusOn(view: caloriesView)
        cornerRadiusOn(view: speedView)
        cornerRadiusOn(view: strokesView)
        cornerRadiusOn(view: wattageView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        C2ScanningManager.shared.addDelegate(self)
        
        //chart
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
        
        viewChart.add([series1, series2, series3, series4, series5])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        // gradient
    }
    
    func gradientOn(view: UIView) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        let colorTop = UIColor(red: 147 / 255.0, green: 255 / 255.0, blue: 233 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 21 / 255.0, green: 236 / 255.0, blue: 193 / 255.0, alpha: 1.0).cgColor
        
        gradientLayer.colors = [colorTop, colorBottom]
//        view.layer.addSublayer(gradientLayer)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func cornerRadiusOn(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
    }

}
