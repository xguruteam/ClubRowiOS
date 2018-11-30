//
//  ViewController.swift
//  Concept2
//
//  Created by Luccas Beck on 9/14/18.
//  Copyright © 2018 Luccas Beck. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, PM5ScannerDelegate, UINavigationControllerDelegate, C2ConnectionManagerDelegate {
    func C2ConnectionManagerDidConnect() {
    }
    
    func C2ConnectionManagerFailConnect() {
    }
    
    func C2ConnectionManagerDidReceiveData(_ parameter: CBCharacteristic) {
        if parameter.uuid.uuidString == C2ConnectionManager.PM5_CHAR31_UUID {
            if let value = parameter.value {
                let data = [UInt8](value).map { (i) -> Int in
                    Int(i)
                }
                Log.e("0x31 \(data)")
                label1.text = "Elapsed Time : \((data[0] + (data[1] << 8) + (data[2] << 16)) * 10) ms"
                label2.text = "Distance : \(Float(data[3] + (data[4] << 8) + (data[5] << 16)) / 10.0) m"
            }
        }
        if parameter.uuid.uuidString == C2ConnectionManager.PM5_CHAR32_UUID {
            if let value = parameter.value {
                let data = [UInt8](value).map { (i) -> Int in
                    Int(i)
                }
                Log.e("0x32 \(data)")
                label3.text = "Rate/min : \(data[5])"
            }
        }
        if parameter.uuid.uuidString == C2ConnectionManager.PM5_CHAR33_UUID {
            if let value = parameter.value {
                let data = [UInt8](value).map { (i) -> Int in
                    Int(i)
                }
                Log.e("0x33 \(data)")
                label4.text = "Split/500m : \((data[8] + (data[9] << 8)) * 10) ms"
                label5.text = "Watts : \(data[10] + (data[11] << 8))"
                label6.text = "Cal/hr : \(data[12] + (data[13] << 8))"
            }
        }
    }
    

    var device: CBPeripheral!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    
    @IBAction func cancel(_ sender: Any) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNVC = navigationController {
            owningNVC.popViewController(animated: true)
        }
        else {
            print("daa")
        }
        
        PM5Scanner.shared.delegate = nil
        PM5Scanner.shared.disconnetFrom(self.device)
//        C2ConnectionManager.shared.removeDelegate(self)
    }
    
    func pm5ScannerDidStart(_ scanner: PM5Scanner) {
        
    }
    
    func pm5ScannerDidStop(_ scanner: PM5Scanner) {
        
    }
    
    func pm5Scanner(_ scanner: PM5Scanner, didDiscover device: CBPeripheral) {
        
    }
    
    func pm5ScannerDidConnectDevice(_ scanner: PM5Scanner) {
        
    }
    
    func pm5ScannerDidDisconnectDevice(_ scanner: PM5Scanner) {
        PM5Scanner.shared.delegate = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    func pm5ScannerDidReceiveData(_ scanner: PM5Scanner, characteristic: CBCharacteristic) {
        if characteristic.uuid.uuidString == PM5Scanner.PM5_CHAR31_UUID {
            if let value = characteristic.value {
                let data = [UInt8](value).map { (i) -> Int in
                    Int(i)
                }
                Log.e("0x31 \(data)")
                label1.text = "Elapsed Time : \((data[0] + (data[1] << 8) + (data[2] << 16)) * 10) ms"
                label2.text = "Distance : \(Float(data[3] + (data[4] << 8) + (data[5] << 16)) / 10.0) m"
            }
        }
        if characteristic.uuid.uuidString == PM5Scanner.PM5_CHAR32_UUID {
            if let value = characteristic.value {
                let data = [UInt8](value).map { (i) -> Int in
                    Int(i)
                }
                Log.e("0x32 \(data)")
                label3.text = "Rate/min : \(data[5])"
            }
        }
        if characteristic.uuid.uuidString == PM5Scanner.PM5_CHAR33_UUID {
            if let value = characteristic.value {
                let data = [UInt8](value).map { (i) -> Int in
                    Int(i)
                }
                Log.e("0x33 \(data)")
                label4.text = "Split/500m : \((data[8] + (data[9] << 8)) * 10) ms"
                label5.text = "Watts : \(data[10] + (data[11] << 8))"
                label6.text = "Cal/hr : \(data[12] + (data[13] << 8))"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = device.name ?? "Unknown"
        label1.text = "Elapsed Time : 0 ms"
        label2.text = "Distance : 0 m"
        label3.text = "Rate/min : 0"
        label4.text = "Split/500m : 0"
        label5.text = "Watts : 0"
        label6.text = "Cal/hr : 0"
        
        PM5Scanner.shared.delegate = self
        PM5Scanner.shared.connectTo(self.device)
        
//        C2ConnectionManager.shared.addDelegate(self)
//        C2ConnectionManager.shared.connectTo(self.device)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Log.e("xxxx")
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        Log.e("bac")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

