//
//  PM5Scanner.swift
//  Concept2
//
//  Created by Luccas Beck on 9/14/18.
//  Copyright © 2018 Luccas Beck. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol PM5ScannerDelegate {
    func pm5ScannerDidStart(_ scanner: PM5Scanner)
    func pm5ScannerDidStop(_ scanner: PM5Scanner)
    func pm5Scanner(_ scanner: PM5Scanner, didDiscover device: CBPeripheral)
    
    func pm5ScannerDidConnectDevice(_ scanner: PM5Scanner)
    func pm5ScannerDidDisconnectDevice(_ scanner: PM5Scanner)
    
    func pm5ScannerDidReceiveData(_ scanner: PM5Scanner, characteristic: CBCharacteristic)
}

class PM5Scanner:NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    static let PM5_PRIMARY1_UUID = "CE061800-43E5-11E4-916C-0800200C9A66"
    static let PM5_PRIMARY2_UUID = "CE061801-43E5-11E4-916C-0800200C9A66"
    static let PM5_SERVICE_UUID = "CE060030-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR31_UUID = "CE060031-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR32_UUID = "CE060032-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR33_UUID = "CE060033-43E5-11E4-916C-0800200C9A66"

    //MARK: Singleton Share Scanner
    static let shared = PM5Scanner()

    let centralManger: CBCentralManager
    var delegate: PM5ScannerDelegate? = nil
    
    override init() {
        self.centralManger = CBCentralManager(delegate: nil, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        super.init()
        self.centralManger.delegate = self
    }
    
    func isAvailable() -> Bool {
        if self.centralManger.state == .poweredOn {
            return true;
        }
        
        return false;
    }
    
    func start() {
        if isAvailable() == false {
            self.delegate?.pm5ScannerDidStop(self)
            return
        }
        self.delegate?.pm5ScannerDidStart(self)
        
        self.centralManger.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stop() {
        self.centralManger.stopScan()
        self.delegate?.pm5ScannerDidStop(self)
    }
    
    
    //MARK: CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            self.delegate?.pm5ScannerDidStop(self)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        Log.d("discover a peripheral - \(peripheral.name ?? "Unknown")")
        self.delegate?.pm5Scanner(self, didDiscover: peripheral)
        
    }
    
    //MARK: Connector
    func connectTo(_ peripheral: CBPeripheral) {
        stop()
        self.centralManger.connect(peripheral, options: nil)
    }
    
    func disconnetFrom(_ peripheral: CBPeripheral) {
        self.centralManger.cancelPeripheralConnection(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Log.d("\(peripheral.name ?? "Unknown") is connected")
        self.delegate?.pm5ScannerDidConnectDevice(self)
        
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: PM5Scanner.PM5_SERVICE_UUID)])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        Log.d("\(peripheral.name ?? "Unknown") is not able to connect")
        self.delegate?.pm5ScannerDidDisconnectDevice(self)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        Log.d("\(peripheral.name ?? "Unknown") is disconnected")
        self.delegate?.pm5ScannerDidDisconnectDevice(self)
        
        peripheral.delegate = nil
    }
    
    //MARK: CBPeripheralDelegate
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            Log.e((error?.localizedDescription)!)
            return
        }
        
        if let services = peripheral.services {
            for service in services {
                Log.d("discovered service - \(service.uuid.uuidString)")
                
                if service.uuid.uuidString == PM5Scanner.PM5_SERVICE_UUID {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            Log.e((error?.localizedDescription)!)
            return
        }
        
        if let chars = service.characteristics {
            for char in chars {
                Log.d("discovered characteristic - \(char.uuid.uuidString)")
                
                switch char.uuid.uuidString {
                case PM5Scanner.PM5_CHAR31_UUID,
                     PM5Scanner.PM5_CHAR32_UUID,
                     PM5Scanner.PM5_CHAR33_UUID:
                        peripheral.setNotifyValue(true, for: char)
                default:
                    continue
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            Log.e((error?.localizedDescription)!)
            return
        }
        
        if characteristic.isNotifying {
            Log.d("start subscribing from - \(characteristic.uuid.uuidString)")
        }
        else {
            Log.d("end subscribing from - \(characteristic.uuid.uuidString)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            Log.e((error?.localizedDescription)!)
            return
        }
        
        Log.d("received data - \(String(data: characteristic.value!, encoding: .utf8))")
        
        self.delegate?.pm5ScannerDidReceiveData(self, characteristic: characteristic)
    }
}
