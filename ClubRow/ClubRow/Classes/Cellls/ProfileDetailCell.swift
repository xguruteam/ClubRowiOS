//
//  ProfileDetailCell.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/14/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import SwiftChart


class ProfileDetailCell: UITableViewCell {

    @IBOutlet weak var viewSummaryBtn: UIButton!
    @IBOutlet weak var viewDetailsBtn: UIButton!
    
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var caloriesView: UIView!
    @IBOutlet weak var speedView: UIView!
    @IBOutlet weak var strokesView: UIView!
    @IBOutlet weak var wattageView: UIView!
    
    @IBOutlet var viewChart: Chart!

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
