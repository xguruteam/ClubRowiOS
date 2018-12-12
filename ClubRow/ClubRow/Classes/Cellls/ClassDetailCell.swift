//
//  ClassDetailCell.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/14/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

protocol ClassDetailCellDelegate {
    func classDetailCell(didSelect indexPath: IndexPath)
}

class ClassDetailCell: UITableViewCell {

    @IBOutlet weak var joinClassBtn: UIButton!
    @IBOutlet weak var classView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var viewDot: UIView!
    @IBOutlet weak var lblClassTime: UILabel!
    
    
    var indexPath: IndexPath!
    var delegate: ClassDetailCellDelegate!
    
    
    
    @IBAction func onTakeAction(_ sender: Any) {
        self.delegate.classDetailCell(didSelect: self.indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // corner
        joinClassBtn.backgroundColor = #colorLiteral(red: 1, green: 0.5294117647, blue: 0.5843137255, alpha: 1)
        joinClassBtn.layer.cornerRadius = 8
        
        classView.layer.shadowOffset = CGSize(width: 0, height: 4)
        classView.layer.shadowOpacity = 0.16
        classView.layer.shadowRadius = 4
        
        classView.layer.cornerRadius = 20
        classView.layer.masksToBounds = false
        
        // gradient
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = gradientView.bounds
//
//        let colorTop = UIColor(red: 31 / 255.0, green: 32 / 255.0, blue: 45 / 255.0, alpha: 0.15).cgColor
//        let colorBottom = UIColor(red: 31 / 255.0, green: 32 / 255.0, blue: 45 / 255.0, alpha: 1.0).cgColor
//
//        gradientLayer.colors = [colorTop, colorBottom]
//        gradientView.layer.addSublayer(gradientLayer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
