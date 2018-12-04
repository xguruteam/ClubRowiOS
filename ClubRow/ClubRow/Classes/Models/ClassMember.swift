//
//  ClassMember.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/8/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import Foundation

class ClassMember {
    
    var name: String
    var distance: String  // working_progress
    var cal: String
    var speed: String
    var strokes: String
    var wattage: String
    
//    init(data: NSDictionary) {
//        name = data.allKeys[0] as! String
//        print("name========", name)
//        let dic = data[name] as! NSDictionary
//        distance = dic["distance"] as! String
//    }
    
    init(name_: String, distance_: String, cal_: String, speed_: String, strokes_: String, wattage_: String) {
        
        name = name_
        distance = distance_
        cal = cal_
        speed = speed_
        strokes = strokes_
        wattage = wattage_
    }
}
