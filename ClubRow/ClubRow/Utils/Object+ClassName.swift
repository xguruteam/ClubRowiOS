//
//  Object+ClassName.swift
//  SwiftEntryKit_Example
//
//  Created by Luccas on 4/25/18.
//  Copyright (c) 2018 Luccas. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
