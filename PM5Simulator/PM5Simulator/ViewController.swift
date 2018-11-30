//
//  ViewController.swift
//  PM5Simulator
//
//  Created by Luccas Beck on 9/14/18.
//  Copyright © 2018 Luccas Beck. All rights reserved.
//

import UIKit
import Dispatch
import CoreBluetooth
import os.log

class ViewController: UIViewController, CBPeripheralManagerDelegate {

    let PM_LOCAL_NAME = "PM5 Simulator"
    let PM_PRIMARY1_UUID = "CE061800-43E5-11E4-916C-0800200C9A66"
    let PM_SERVICE_UUID = "CE060030-43E5-11E4-916C-0800200C9A66"
    let PM_CHAR31_UUID = "CE060031-43E5-11E4-916C-0800200C9A66"
    let PM_CHAR32_UUID = "CE060032-43E5-11E4-916C-0800200C9A66"
    let PM_CHAR33_UUID = "CE060033-43E5-11E4-916C-0800200C9A66"
    let PM_CHAR34_UUID = "CE060034-43E5-11E4-916C-0800200C9A66"
    let PM_CHAR35_UUID = "CE060035-43E5-11E4-916C-0800200C9A66"
    let PM_CHAR36_UUID = "CE060036-43E5-11E4-916C-0800200C9A66"
    let PM_CHAR37_UUID = "CE060037-43E5-11E4-916C-0800200C9A66"
    let PM_CHAR38_UUID = "CE060038-43E5-11E4-916C-0800200C9A66"
    let PM_CHAR39_UUID = "CE060039-43E5-11E4-916C-0800200C9A66"
    let PM_CHAR3A_UUID = "CE06003A-43E5-11E4-916C-0800200C9A66"

    var status: Bool = false
    let peripheralManager = CBPeripheralManager(delegate: nil, queue: DispatchQueue(label: "advertisingQueue", attributes: .concurrent), options: [CBPeripheralManagerOptionShowPowerAlertKey: true])
    
    var char1: CBMutableCharacteristic!
    var char2: CBMutableCharacteristic!
    var char3: CBMutableCharacteristic!
    var char4: CBMutableCharacteristic!
    var char5: CBMutableCharacteristic!
    var char6: CBMutableCharacteristic!
    var char7: CBMutableCharacteristic!
    var char8: CBMutableCharacteristic!
    var char9: CBMutableCharacteristic!
    var charA: CBMutableCharacteristic!
    var central: CBCentral!

    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var buttonStartStop: UIButton!
    
    @IBAction func changeParam1(_ sender: Any) {
        if self.central != nil {
            self.peripheralManager .updateValue(Data(bytes: [0xE0, 0x2E, 0, 0x20, 0x4E, 0]), for: self.char1, onSubscribedCentrals: [self.central])
        }
    }
    
    @IBAction func changeParam2(_ sender: Any) {
        if self.central != nil {
            self.peripheralManager .updateValue(Data(bytes: [0, 0, 0, 0x40, 0x1F, 15]), for: self.char2, onSubscribedCentrals: [self.central])
        }
    }
    
    @IBAction func changeParam3(_ sender: Any) {
        if self.central != nil {
            self.peripheralManager .updateValue(Data(bytes: [0, 0, 0, 0, 0, 0, 0, 0, 0xC0, 0x12, 0x90, 0x01, 0xA4, 0x06, 0,]), for: self.char3, onSubscribedCentrals: [self.central])
        }
    }
    
    @IBAction func changeParam9(_ sender: Any) {
        if self.central != nil {
            self.peripheralManager .updateValue(Data(bytes: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xB]), for: self.char9, onSubscribedCentrals: [self.central])
        }
    }
    
    @IBAction func changeParamA(_ sender: Any) {
        if self.central != nil {
            self.peripheralManager .updateValue(Data(bytes: [0, 0, 0, 0, 0, 0, 0, 0, 0x93, 0x14, 0x7A, 0x0D]), for: self.charA, onSubscribedCentrals: [self.central])
        }
    }
    
    @IBAction func toggleStartStop(_ sender: Any) {
        if self.status == false {
            self.status = true
            buttonStartStop.setTitle("Stop Advertising", for: .normal)
            startAdvertising()
        }
        else {
            self.status = false
            buttonStartStop.setTitle("Start Advertising", for: .normal)
            stopAdvertising()
        }
    }
    
    func startAdvertising() {
        let service1 = CBMutableService(type: CBUUID(string: PM_SERVICE_UUID), primary: true)
        self.char1 = CBMutableCharacteristic(type: CBUUID(string: PM_CHAR31_UUID), properties: .notify, value: nil, permissions: .readable)
        self.char2 = CBMutableCharacteristic(type: CBUUID(string: PM_CHAR32_UUID), properties: .notify, value: nil, permissions: .readable)
        self.char3 = CBMutableCharacteristic(type: CBUUID(string: PM_CHAR33_UUID), properties: .notify, value: nil, permissions: .readable)
        self.char4 = CBMutableCharacteristic(type: CBUUID(string: PM_CHAR34_UUID), properties: .notify, value: nil, permissions: .readable)
        self.char5 = CBMutableCharacteristic(type: CBUUID(string: PM_CHAR35_UUID), properties: .notify, value: nil, permissions: .readable)
        self.char6 = CBMutableCharacteristic(type: CBUUID(string: PM_CHAR36_UUID), properties: .notify, value: nil, permissions: .readable)
        self.char7 = CBMutableCharacteristic(type: CBUUID(string: PM_CHAR37_UUID), properties: .notify, value: nil, permissions: .readable)
        self.char8 = CBMutableCharacteristic(type: CBUUID(string: PM_CHAR38_UUID), properties: .notify, value: nil, permissions: .readable)
        self.char9 = CBMutableCharacteristic(type: CBUUID(string: PM_CHAR39_UUID), properties: .notify, value: nil, permissions: .readable)
        self.charA = CBMutableCharacteristic(type: CBUUID(string: PM_CHAR3A_UUID), properties: .notify, value: nil, permissions: .readable)
        service1.characteristics = [char1, char2, char3, char4, char5, char6, char7, char8, char9, charA]
        self.peripheralManager.add(service1)
        self.peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey: PM_LOCAL_NAME, CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: PM_PRIMARY1_UUID)]])
    }
    
    func stopAdvertising() {
        self.peripheralManager.stopAdvertising()
        self.peripheralManager.removeAllServices()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.peripheralManager.delegate = self
        buttonStartStop.setTitle("Start Advertising", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if error != nil {
//            os_log("add service error - %@", log: OSLog.default, type: .error, (error?.localizedDescription)!)
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if error != nil {
//            os_log("advertising error - %@", log: OSLog.default, type: .error, (error?.localizedDescription)!)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        NSLog("didSubscribe")
        self.central = central
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
//        os_log("didUnSubscribe")
        self.central = nil
    }

}

