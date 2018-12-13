//
//  UIView+Box.swift
//  ClubRow
//
//  Created by Guru on 12/12/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

extension UIView {
    func makeBox() {
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.16
        self.layer.shadowRadius = 4
        
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = false
    }
    
    func makeBottomShadow() {
        
    }
    
    func makeTopShadow() {
        
    }
}
