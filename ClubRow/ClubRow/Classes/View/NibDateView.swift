//
//  NibDateView.swift
//  ClubRow
//
//  Created by Luccas on 10/7/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

class NibDateView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        fromNib()
        clipsToBounds = true
        layer.cornerRadius = 5
    }
}
