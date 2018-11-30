
//
//  BluetoothModel.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/8/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import Foundation

class BluetoothModel {
    var distance: String
    var wattage: String
    var speed: String
    var calories: String
    var strokes_per_minute: String
    
    init(distance_: String, wattage_: String, speed_: String, calories_: String, strokes_per_minute_: String) {
        distance = distance_
        wattage = wattage_
        speed = speed_
        calories = calories_
        strokes_per_minute = strokes_per_minute_
    }
}
