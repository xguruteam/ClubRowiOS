//
//  Log.swift
//  Concept2
//
//  Created by Luccas Beck on 9/14/18.
//  Copyright © 2018 Luccas Beck. All rights reserved.
//

import Foundation
import os.log

//MARK: Log functions
class Log {
    static func e(_ message: String) {
        if #available(iOS 10.0, *) {
            os_log("%@", log: OSLog.default, type: .error, message)
        } else {
            print("\(message)")
        }
    }
    
    static func d(_ message: String) {
        if #available(iOS 10.0, *) {
            os_log("%@", log: OSLog.default, type: .debug, message)
        } else {
            print("\(message)")
        }
    }
}
