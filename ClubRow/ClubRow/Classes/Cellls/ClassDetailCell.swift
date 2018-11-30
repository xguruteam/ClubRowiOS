//
//  ClassDetailCell.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/14/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

class ClassDetailCell: UITableViewCell {

    @IBOutlet weak var joinClassBtn: UIButton!
    @IBOutlet weak var classView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // corner
        joinClassBtn.backgroundColor = #colorLiteral(red: 1, green: 0.5294117647, blue: 0.5843137255, alpha: 1)
        joinClassBtn.layer.cornerRadius = 8
        
        classView.layer.cornerRadius = 20
        
        // gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        
        let colorTop = UIColor(red: 31 / 255.0, green: 32 / 255.0, blue: 45 / 255.0, alpha: 0.15).cgColor
        let colorBottom = UIColor(red: 31 / 255.0, green: 32 / 255.0, blue: 45 / 255.0, alpha: 1.0).cgColor
        
        gradientLayer.colors = [colorTop, colorBottom]
        gradientView.layer.addSublayer(gradientLayer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
