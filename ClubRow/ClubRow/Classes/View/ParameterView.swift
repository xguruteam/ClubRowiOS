//
//  ParameterView.swift
//  ClubRow
//
//  Created by Guru on 1/4/19.
//

import UIKit

@IBDesignable
class ParameterView: UIView {
    
    @IBInspectable var type: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        let colorTop = UIColor(red: 147 / 255.0, green: 255 / 255.0, blue: 233 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 21 / 255.0, green: 236 / 255.0, blue: 193 / 255.0, alpha: 1.0).cgColor
        
        gradientLayer.colors = [colorTop, colorBottom]
        //        view.layer.addSublayer(gradientLayer)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
