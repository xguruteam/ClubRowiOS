//
//  PM5TableViewController.swift
//  Concept2
//
//  Created by Luccas Beck on 9/14/18.
//  Copyright © 2018 Luccas Beck. All rights reserved.
//

import UIKit
import CoreBluetooth

class PM5TableViewController: UITableViewController, PM5ScannerDelegate, C2ScanningManagerDelegate {
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
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(PM5TableViewController.toggleScanStop(_:)))
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
        // going to turn on scanning.
        if PM5Scanner.shared.isAvailable() == false {

            let alert = UIAlertController(title: "Bluetooth", message: "Concept2 requires Bluetooth to scan PM5s :(", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                Log.d("You will no longer be able to scan PM5s :(")
            }))

            present(alert, animated: true, completion: nil)

            return
        }
        self.devices = [CBPeripheral]()
//        C2ScanningManager.shared.delegate = self
//        C2ScanningManager.shared.startScan()
        PM5Scanner.shared.delegate = self
        PM5Scanner.shared.start()
    }
    
    func stopScanning() {
        PM5Scanner.shared.stop()
//        C2ScanningManager.shared.stopScan()
//        C2ScanningManager.shared.delegate = nil
//        self.status = false
    }
    
    func pm5ScannerDidStart(_ scanner: PM5Scanner) {
        self.status = true;
    }
    
    func pm5ScannerDidStop(_ scanner: PM5Scanner) {
        self.status = false
    }
    
    func pm5Scanner(_ scanner: PM5Scanner, didDiscover device: CBPeripheral) {
        self.devices.append(device)
    }

    func pm5ScannerDidConnectDevice(_ scanner: PM5Scanner) {
        
    }
    
    func pm5ScannerDidDisconnectDevice(_ scanner: PM5Scanner) {
        
    }
    
    func pm5ScannerDidReceiveData(_ scanner: PM5Scanner, characteristic: CBCharacteristic) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let _ = PM5Scanner.shared.isAvailable() // alert at the first to turn on Bluetooth
//        let _ = C2ScanningManager.shared
        
        self.status = false
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.devices.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
//        if cell == nil {
//            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
//        }

        cell.textLabel?.text = self.devices[indexPath.row].name ?? "Unknow"
        cell.detailTextLabel?.text = self.devices[indexPath.row].identifier.uuidString

        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "ShowDetail":
            guard let detailViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedProductCell = sender as? UITableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedProductCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedDevice = self.devices[indexPath.row]
            detailViewController.device = selectedDevice
            PM5Scanner.shared.stop()
//            C2ScanningManager.shared.stopScan()
//            C2ConnectionManager.shared.connectTo(selectedDevice)
//            self.status = false
        default:
            fatalError("unknow segue")
        }
    }

}
