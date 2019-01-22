//
//  Concept2Device.swift
//  ClubRow
//
//  Created by Guru on 1/22/19.
//

import UIKit
import CoreBluetooth

class Concept2Device: NSObject {

    var name: String!
    var rssi: Double!
    var id: String!
    var peripheral: CBPeripheral

    init(name: String, rssi: Double, id: String, peripheral: CBPeripheral) {
        self.name = name
        self.rssi = rssi
        self.id = id
        self.peripheral = peripheral
    }
}
