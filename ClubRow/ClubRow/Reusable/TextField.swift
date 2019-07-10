//
//  TextField.swift
//  ClubRow
//
//  Created by Guru on 7/10/19.
//  Copyright © 2019 CREATORSNEVERDIE. All rights reserved.
//

import UIKit

class TextField: UITextField {

    convenience init(placeholder: String, action: String? = nil) {
        self.init()
        
        let font = UIFont(name: .textFontName, size: 16)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: UIColor("#0A0707", alpha: 0.2) as Any,
        ]
        
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        
        defaultTextAttributes = [
            .font: font as Any,
            .foregroundColor: UIColor("#0A0707", alpha: 0.55) as Any,
        ]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .appTextFieldBackgroundColor
        cornerRadius = 18
        heightAnchor.constraint(equalToConstant: 45).isActive = true
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: frame.size.height))
        leftViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: frame.size.height))
        rightViewMode = .always
        tintColor = UIColor("#0A0707", alpha: 0.55)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
