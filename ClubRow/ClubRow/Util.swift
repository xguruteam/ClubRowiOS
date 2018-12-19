//
//  Util.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/26/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

class Util: NSObject {
    
    static func validateEmail(emailStr: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
    
    static func convertTimeStamp(_ input: String, format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        let date = dateFormatter.date(from: input)
        
        let targetDateFormatter = DateFormatter()
        targetDateFormatter.dateFormat = format
        return targetDateFormatter.string(from: date!)
    }
    
    static func generateNumberOfClassesText(_ number: Int) -> String {
        switch number {
        case 0:
            return "No Class"
        case 1:
            return "1 Class"
        default:
            return "\(number) Classes"
        }
    }
    
    static func generateNumberOfLobbiesText(_ number: Int) -> String {
        switch number {
        case 0:
            return "No Lobby"
        case 1:
            return "1 Lobby"
        default:
            return "\(number) Lobbies"
        }
    }
}
