//
//  Button.swift
//  ClubRow
//
//  Created by Guru on 7/10/19.
//  Copyright © 2019 CREATORSNEVERDIE. All rights reserved.
//

import UIKit

class Button: UIButton {

    convenience init(title: String, backgroundColor: UIColor) {
        self.init(type: .system)
        
        let font = UIFont(name: .textFontName, size: 16)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: UIColor("#222121", alpha: 0.71) as Any,
        ]

        setAttributedTitle(NSAttributedString(string: title, attributes: attributes), for: .normal)
        self.backgroundColor = backgroundColor
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
        cornerRadius = 27
        heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
