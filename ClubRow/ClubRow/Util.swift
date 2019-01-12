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
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: input)
        
        let targetDateFormatter = DateFormatter()
        targetDateFormatter.dateFormat = format
        return targetDateFormatter.string(from: date!)
    }
    
    static func convertUnixTimeToDateString(_ unix: Int, format: String) -> String? {
        let date = Date(timeIntervalSince1970: TimeInterval(unix))
        
        let targetDateFormatter = DateFormatter()
        targetDateFormatter.dateFormat = format
        return targetDateFormatter.string(from: date)
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
    
    static func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    static func convertTypeString(_ number: Int) -> String {
        switch number {
        case 0:
            return "Distance"
        case 1:
            return "Calories"
        case 2:
            return "Speed"
        case 3:
            return "Strokes Per Minute"
        case 4:
            return "Wattage"
        default:
            return "Unknown"
        }
        
    }
    
    static func convertUnitString(_ number: Int) -> String {
        switch number {
        case 0:
            return "m"
        case 1:
            return "cal"
        case 2:
            return "m/s"
        case 3:
            return ""
        case 4:
            return "wat"
        default:
            return "Unknown"
        }
    }
    
    static func convertTypeToKey(_ number: Int) -> String {
        switch number {
        case 0:
            return "distance"
        case 1:
            return "calories"
        case 2:
            return "speed"
        case 3:
            return "strokes_per_minute"
        case 4:
            return "wattage"
        default:
            return "Unknown"
        }
    }
}
