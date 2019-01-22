//
//  DevicesViewController.swift
//  ClubRow
//
//  Created by Luccas Beck on 10/21/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import CoreBluetooth

class DevicesViewController: SuperViewController, UITableViewDelegate, UITableViewDataSource, C2ScanningManagerDelegate, C2ConnectionManagerDelegate {
    @IBOutlet weak var rightBarButtonItem: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let _ = C2ScanningManager.shared
        let _ = C2ConnectionManager.shared
        
        C2ScanningManager.shared.addDelegate(self)
        
        self.status = false
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBack(_ sender: Any) {
        stopScanning()
        C2ScanningManager.shared.removeDelegate(self)
        self.navigationController?.popViewController(animated: true)
    }
    
    var devices = [CBPeripheral]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var status = false {
        didSet {
            var title = "Start"
            if status == true {
                title = "Stop"
            }
            self.rightBarButtonItem.setTitle(title, for: .normal)
        }
    }
    
    @IBAction func toggleScanStop(_ sender: Any) {
        if self.status == false {
            startScanning()
        }
        else {
            stopScanning()
        }
    }
    
    func startScanning() {
        self.devices = [CBPeripheral]()
        C2ScanningManager.shared.delegate = self
        C2ScanningManager.shared.startScan()
    }
    
    func stopScanning() {
        C2ScanningManager.shared.stopScan()
        C2ScanningManager.shared.delegate = nil
        self.status = false
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        //        if cell == nil {
        //            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
        //        }

        cell.textLabel?.text = self.devices[indexPath.row].name ?? "Unknow"
        cell.detailTextLabel?.text = self.devices[indexPath.row].identifier.uuidString

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDevice = self.devices[indexPath.row]
        stopScanning()
//        C2ConnectionManager.shared.connectTo(selectedDevice)
        C2ScanningManager.shared.connectTo(selectedDevice)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func C2ScanningManagerDidStartScan() {
        self.status = true
    }
    
    func C2ScanningManagerDidStopScan(with error: String?) {
        self.status = false
        C2ScanningManager.shared.delegate = nil
    }
    
    func C2ScanningManagerDidDiscover(_ device: CBPeripheral) {
        self.devices.append(device)
    }
    
    func C2ConnectionManagerDidConnect(_ deviceName: String) {
        let alert = UIAlertController(title: "ClubRow", message: "\(deviceName) is connected successfully!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//            C2ConnectionManager.shared.removeDelegate(self)
//            self.navigationController?.popViewController(animated: true)
            self.onBack(self)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func C2ConnectionManagerFailConnect() {
        let alert = UIAlertController(title: "ClubRow", message: "This device is unable to connect.\n Please try another device!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func C2ConnectionManagerDidReceiveData(_ parameter: CBCharacteristic) {
    }
}
