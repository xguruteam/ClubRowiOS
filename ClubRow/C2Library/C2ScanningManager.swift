//
//  PM5Scanner.swift
//  Concept2
//
//  Created by Luccas Beck on 9/14/18.
//  Copyright © 2018 Luccas Beck. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol C2ScanningManagerDelegate {
    func C2ScanningManagerDidStartScan()
    func C2ScanningManagerDidStopScan(with error: String?)
    func C2ScanningManagerDidDiscover(_ device: CBPeripheral)
}

protocol C2ConnectionManagerDelegate {
    func C2ConnectionManagerDidConnect()
    func C2ConnectionManagerFailConnect()
    func C2ConnectionManagerDidReceiveData(_ parameter: CBCharacteristic)
}

class C2ScanningManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    static let PM5_PRIMARY1_UUID = "CE061800-43E5-11E4-916C-0800200C9A66"
    static let PM5_PRIMARY2_UUID = "CE061801-43E5-11E4-916C-0800200C9A66"
    static let PM5_SERVICE_UUID = "CE060030-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR31_UUID = "CE060031-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR32_UUID = "CE060032-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR33_UUID = "CE060033-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR34_UUID = "CE060034-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR35_UUID = "CE060035-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR36_UUID = "CE060036-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR37_UUID = "CE060037-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR38_UUID = "CE060038-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR39_UUID = "CE060039-43E5-11E4-916C-0800200C9A66"
    static let PM5_CHAR3A_UUID = "CE06003A-43E5-11E4-916C-0800200C9A66"

    //MARK: Singleton Share ScanningManager
    static let shared = C2ScanningManager()

    var isRunning: Bool = false
    
    let centralManager: CBCentralManager
    
    var delegate: C2ScanningManagerDelegate?
    private var delegates = [C2ConnectionManagerDelegate]()

    var currentDevice: CBPeripheral?
    var isConnected: Bool = false
    
    override init() {
//        let concurrentQueue = DispatchQueue(label: "ScanningQueue", attributes: .concurrent)
        self.centralManager = CBCentralManager(delegate: nil, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        super.init()
        self.centralManager.delegate = self
    }
    
    open func startScan() {
        if self.centralManager.state != .poweredOn {
            self.delegate?.C2ScanningManagerDidStopScan(with: "Bluetooth is turned off.")
            return
        }

        start()
        self.delegate?.C2ScanningManagerDidStartScan()
    }
    
    open func stopScan() {
        stop()
    }
    
    private func start() {
//        self.centralManager.delegate = self
        self.isRunning = true
        self.centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    private func stop() {
        self.centralManager.stopScan()
//        self.centralManager.delegate = nil
        self.isRunning = false
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
        for item in self.delegates {
            item.C2ConnectionManagerDidConnect()
        }
    }
    
    func failConnect() {
        for item in self.delegates {
            item.C2ConnectionManagerFailConnect()
        }
    }
    
    func didReceiveData(_ parameter: CBCharacteristic) {
        for item in self.delegates {
            item.C2ConnectionManagerDidReceiveData(parameter)
        }
    }

    
    //MARK: CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            stop()
            self.delegate?.C2ScanningManagerDidStopScan(with: "Bluetooth is turned off.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        Log.d("discover a peripheral - \(peripheral.name ?? "Unknown")")
//        if peripheral.name?.starts(with: "PM5") == true {
            self.delegate?.C2ScanningManagerDidDiscover(peripheral)
//        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Log.d("didConnect: \(peripheral.identifier)")
        if isConnected == true {
            if peripheral.isEqual(currentDevice) {
                didConnect()
                peripheral.delegate = self
                peripheral.discoverServices([CBUUID(string: C2ConnectionManager.PM5_SERVICE_UUID)])
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        Log.d("didFailToConnect")
        if isConnected == true {
            if peripheral.isEqual(currentDevice) {
                isConnected = false
                currentDevice = nil
                failConnect()
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        Log.d("didDisConnectPeripheral")
        // try to re-connect
        if isConnected == true {
            if peripheral.isEqual(currentDevice) {
                let peripherals = self.centralManager.retrievePeripherals(withIdentifiers: [currentDevice!.identifier])
                
                if let item = peripherals.first {
                    currentDevice = item
                    self.centralManager.connect(currentDevice!, options: nil)
                }
                else {
                    isConnected = false
                    currentDevice = nil
                    failConnect()
                }
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
                case C2ScanningManager.PM5_CHAR31_UUID,
                     C2ScanningManager.PM5_CHAR32_UUID,
                     C2ScanningManager.PM5_CHAR33_UUID,
                     C2ScanningManager.PM5_CHAR34_UUID,
                     C2ScanningManager.PM5_CHAR35_UUID,
                     C2ScanningManager.PM5_CHAR36_UUID,
                     C2ScanningManager.PM5_CHAR37_UUID,
                     C2ScanningManager.PM5_CHAR38_UUID,
                     C2ScanningManager.PM5_CHAR39_UUID,
                     C2ScanningManager.PM5_CHAR3A_UUID:
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
