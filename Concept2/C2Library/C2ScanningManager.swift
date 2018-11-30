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

class C2ScanningManager: NSObject, CBCentralManagerDelegate {
    
    //MARK: Singleton Share ScanningManager
    static let shared = C2ScanningManager()

    var isRunning: Bool = false
    
    let centralManager: CBCentralManager
    
    var delegate: C2ScanningManagerDelegate?
    
    override init() {
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
        self.centralManager.delegate = self
        self.isRunning = true
        self.centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    private func stop() {
        self.centralManager.stopScan()
        self.centralManager.delegate = nil
        self.isRunning = false
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
        self.delegate?.C2ScanningManagerDidDiscover(peripheral)
        
    }
}
