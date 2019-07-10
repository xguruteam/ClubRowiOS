//
//  Theme.swift
//  ClubRow
//
//  Created by Guru on 7/10/19.
//  Copyright © 2019 CREATORSNEVERDIE. All rights reserved.
//

import UIKit

extension String {
    
    static var titleFontName: String {
        return "BebasNeue"
    }
    
    static var textFontName: String {
        return "AvenirNext-DemiBold"
    }
}

struct Theme {
    
    static let titleTextAttributes: [NSAttributedString.Key: Any] = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let font = UIFont(name: .titleFontName, size: 36)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: UIColor("#141212", alpha: 0.71) as Any,
            .paragraphStyle: paragraphStyle,
        ]
        return attributes
    }()
    
    static let additionalActionTextAttributes: [NSAttributedString.Key: Any] = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        let font = UIFont(name: .textFontName, size: 9)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: UIColor("#0A0707", alpha: 0.55) as Any,
            .paragraphStyle: paragraphStyle,
        ]
        return attributes
    }()
}
