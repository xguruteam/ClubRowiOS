//
//  ParameterView.swift
//  ClubRow
//
//  Created by Guru on 1/4/19.
//

import UIKit

@IBDesignable
class ParameterView2: UIView {
    
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
        
        let colorTop = UIColor(rgb: 0xF8C7CD).cgColor
        let colorBottom = UIColor(rgb: 0xFF8795).cgColor
        
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
