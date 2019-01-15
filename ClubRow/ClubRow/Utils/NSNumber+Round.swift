//
//  NSNumber+Round.swift
//  ClubRow
//
//  Created by Guru on 1/14/19.
//

import Foundation

extension NSNumber {
    override open var description: String {
        switch self {
        case is Int, is Float:
            return self.stringValue
        default:
            let new = round(self.doubleValue * 100) / 100
            return String(new)
        }
    }
}
