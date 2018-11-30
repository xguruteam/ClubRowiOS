//
//  ClassVideoViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/8/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import CoreBluetooth
import KRProgressHUD

class ClassVideoViewController: SuperViewController {
    
    @IBOutlet weak var leaderboardTableView: UITableView!
    
    var time: Int = 0
    var distance: Int = 0
    var speed: Int = 0
    var wattage: String = ""
    var calories: String = ""
    var strokes_per_minute: String = ""
    
    var classMembers = [ClassMember]()

    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var speedView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!

    @IBOutlet weak var labelTotalDistance: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.1764705882, alpha: 0.86)
        distanceView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.1764705882, alpha: 0.86)
        speedView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.1764705882, alpha: 0.86)
        
        timeView.layer.cornerRadius = 20
        distanceView.layer.cornerRadius = 20
        speedView.layer.cornerRadius = 20

        
        timeLabel.textColor = UIColor.white
        distanceLabel.textColor = UIColor.white
        speedLabel.textColor = UIColor.white
        
        
        
        //
        timeLabel.text = "\(time)s"
        distanceLabel.text = "\(distance)m"
        speedLabel.text = "\(speed)m/s"
        
        
        self.leaderboardTableView.delegate = self
        self.leaderboardTableView.dataSource = self

        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        // Do any additional setup after loading the view.
        
        let _ = C2ScanningManager.shared
        
        C2ScanningManager.shared.addDelegate(self)
        
        SocketManager.sharedManager.delegate = self
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        
        C2ScanningManager.shared.removeDelegate(self)
    }
    
    func canRotate() -> Void {}

    @IBAction func onClose(_ sender: Any) {
        
//        SocketManager.sharedManager.socket.disconnect()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
//    */

}

extension ClassVideoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "cellName")
        //        let bgImage = cell?.viewWithTag(100) as! UIImageView
        //        let lblName = cell?.viewWithTag(200) as! UILabel
        //
        //        if (indexPath.row == 0){
        //            bgImage.image = UIImage.init(imageLiteralResourceName: "bg_white.png")
        //            lblName.textColor = UIColor.black
        //        } else {
        //            bgImage.image = nil
        //            lblName.textColor = UIColor.white
        //        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassMemberCell") as! ClassMemberCell
        
        cell.numberLabel.text = "\(indexPath.row + 1)st"
        cell.nameLabel.text = "\(classMembers[indexPath.row].name)"
        cell.distanceLabel.text = "\(classMembers[indexPath.row].distance)m"
        
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let cell = tableView.cellForRow(at: indexPath)
        //        let bgImage = cell?.viewWithTag(100) as! UIImageView
        //        let lblName = cell?.viewWithTag(200) as! UILabel
        
    }

}

extension ClassVideoViewController: C2ConnectionManagerDelegate {
    
    func C2ConnectionManagerDidConnect() {
    }
    
    func C2ConnectionManagerFailConnect() {
    }
    
    func C2ConnectionManagerDidReceiveData(_ parameter: CBCharacteristic) {
        if parameter.uuid.uuidString == C2ScanningManager.PM5_CHAR31_UUID {
            if let value = parameter.value {
                let data = [UInt8](value).map { (i) -> Int in
                    Int(i)
                }
                Log.e("0x31================ \(data)")
                time = Int(Float(data[0] + (data[1] << 8) + (data[2] << 16)) * 10 / 1000.0)
                distance = Int(Float(data[3] + (data[4] << 8) + (data[5] << 16)) / 10.0)
                
                self.timeLabel.text = "\(time)s"
                self.distanceLabel.text = "\(distance)m"
                
                SocketManager.sharedManager.pushOnChannel(distance: "\(distance)", wattage: "\(wattage)", speed: "\(speed)", calories: "\(calories)", strokes_per_minute: "\(strokes_per_minute)")
            }
        }
        
        if parameter.uuid.uuidString == C2ScanningManager.PM5_CHAR32_UUID {
            if let value = parameter.value {
                let data = [UInt8](value).map { (i) -> Int in
                    Int(i)
                }
                Log.e("0x32=================== \(data)")
                speed = Int(Float(data[3] + (data[4] << 8)) / 1000.0)
                strokes_per_minute = "\(data[5])"
            }
            
            self.speedLabel.text = "\(speed)m/s"
            
            SocketManager.sharedManager.pushOnChannel(distance: "\(distance)", wattage: "\(wattage)", speed: "\(speed)", calories: "\(calories)", strokes_per_minute: "\(strokes_per_minute)")
        }
        
        if parameter.uuid.uuidString == C2ScanningManager.PM5_CHAR33_UUID {
            if let value = parameter.value {
                let data = [UInt8](value).map { (i) -> Int in
                    Int(i)
                }
                Log.e("0x33================ \(data)")
                wattage = "\(data[10] + (data[11] << 8))"
                calories = "\(data[12] + (data[13] << 8))"
            }
            
            SocketManager.sharedManager.pushOnChannel(distance: "\(distance)", wattage: "\(wattage)", speed: "\(speed)", calories: "\(calories)", strokes_per_minute: "\(strokes_per_minute)")
        }
        
        labelTotalDistance.text = "\(time) s : \(distance) m : \(speed) m/s"
    }
}

extension ClassVideoViewController: SocketConnectionManagerDelegate {
    func SocketDidOpen(msg: String) {
        
    }
    
    func SocketDidClose(msg: String) {
        
    }
    
    func SocketDidJoin(members: [ClassMember]) {
        
        classMembers = members
        self.leaderboardTableView.reloadData()
    }
    
    func SocketDidPushOnCannel(message: String) {
        
    }
    
}
