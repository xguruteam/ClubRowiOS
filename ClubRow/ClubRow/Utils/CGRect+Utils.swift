//
//  CGRect.swift
//  SwiftEntryKit_Example
//
//  Created by Luccas on 4/28/18.
//  Copyright (c) 2018 Luccas. All rights reserved.
//

import UIKit

extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}
