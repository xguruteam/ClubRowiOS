//
//  C2ConnectionManager.swift
//  Concept2
//
//  Created by Luccas Beck on 10/20/18.
//  Copyright © 2018 Luccas Beck. All rights reserved.
//

import Foundation
import CoreBluetooth

class C2ConnectionManager:NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    static let PM5_PRIMARY1_UUID = "CE061800-43E5-11E4-916C-0800200C9A66"
    static let PM5_PRIMARY2_UUID = "CE061801-43E5-11E4-916C-0800200C9A66"
    static let PM5_SERVICE_UUID = "CE060030-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR31_UUID = "CE060031-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR32_UUID = "CE060032-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR33_UUID = "CE060033-43E5-11E4-916C-0800200C9A66"
    
    //MARK: Singleton Share ConnectionManager
    static let shared = C2ConnectionManager()
    
    private var delegates = [C2ConnectionManagerDelegate]()
    
    let centralManager: CBCentralManager
    
    var currentDevice: CBPeripheral?
    var isConnected: Bool = false
    
    override init() {
        self.centralManager = CBCentralManager(delegate: nil, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: false])
        super.init()
        self.centralManager.delegate = self
    }
    
    open func addDelegate(_ delegate: C2ConnectionManagerDelegate) {
        self.delegates.append(delegate)
    }
    
    open func removeDelegate(_ delegate: C2ConnectionManagerDelegate) {
        var i: Int = 0
        for item in self.delegates {
            let obj1 = delegate as! NSObject
            let obj2 = item as! NSObject
            if obj2.isEqual(obj1) {
                break
            }
            i = i + 1
        }
        self.delegates.remove(at: i)
    }
    
    open func connectTo(_ device: CBPeripheral) {
        
        let prevDevice = currentDevice
        currentDevice = device
        
        if isConnected == true {
            self.centralManager.cancelPeripheralConnection(prevDevice!)
        }
        
        isConnected = true
        
        self.centralManager.connect(currentDevice!, options: nil)
    }
    
    open func disconnect() {
        if isConnected == true {
            self.centralManager.cancelPeripheralConnection(currentDevice!)
        }
        
        currentDevice = nil
        isConnected = false
    }
    
    //MARK: Notify to Delegates
    func didConnect() {
        for delegate in self.delegates {
            delegate.C2ConnectionManagerDidConnect(currentDevice?.name ?? "Unknown")
        }
    }
    
    func failConnect() {
        for delegate in self.delegates {
            delegate.C2ConnectionManagerFailConnect()
        }
    }
    
    func didReceiveData(_ parameter: CBCharacteristic) {
        for delegate in self.delegates {
            delegate.C2ConnectionManagerDidReceiveData(parameter)
        }
    }
    
    //MARK: CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if isConnected == true {
            if peripheral.isEqual(currentDevice) {
                didConnect()
                peripheral.delegate = self
                peripheral.discoverServices([CBUUID(string: C2ConnectionManager.PM5_SERVICE_UUID)])
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if isConnected == true {
            if peripheral.isEqual(currentDevice) {
                isConnected = false
                currentDevice = nil
                failConnect()
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        // try to re-connect
        if isConnected == true {
            if peripheral.isEqual(currentDevice) {
                self.centralManager.connect(currentDevice!, options: nil)
            }
        }
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
                
                if service.uuid.uuidString == C2ConnectionManager.PM5_SERVICE_UUID {
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
                case C2ConnectionManager.PM5_CHAR31_UUID,
                     C2ConnectionManager.PM5_CHAR32_UUID,
                     C2ConnectionManager.PM5_CHAR33_UUID:
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
        
        Log.d("received data - \(String(describing: String(data: characteristic.value!, encoding: .utf8)))")
        
        didReceiveData(characteristic)
    }

}
