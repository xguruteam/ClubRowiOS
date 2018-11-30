//
//  ClassesCell.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/14/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

protocol ClassesCellDelegate: class {
    func clickedViewClassesBtn(_ sender: ClassesCell)
}

class ClassesCell: UITableViewCell {

    @IBOutlet weak var classView: UIView!
    @IBOutlet weak var classBtn: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    var delegate: ClassesCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        classView.layer.cornerRadius = 20
        classBtn.layer.cornerRadius = 8
        
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

        // Configure the view for t®he selected state
    }

    @IBAction func onViewClassBtn(_ sender: Any) {
        delegate?.clickedViewClassesBtn(self)
    }
}
