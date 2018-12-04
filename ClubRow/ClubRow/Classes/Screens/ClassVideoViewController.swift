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
    
    @IBOutlet weak var distanceTableView: UITableView!
    @IBOutlet weak var calTableView: UITableView!
    @IBOutlet weak var speedTableView: UITableView!
    @IBOutlet weak var strokesTableView: UITableView!
    @IBOutlet weak var wattageTableView: UITableView!
    
    var time: Int = 0
    var distance: Int = 0
    var speed: Int = 0
    var wattage: String = "0"
    var calories: String = "0"
    var strokes_per_minute: String = "0"
    var isShowingPanels: Bool = true
    var lobbyState: String = ""
    var classMembers = [ClassMember]()
    var membersForDistance = [ClassMember]()
    var membersForCal = [ClassMember]()
    var membersForSpeed = [ClassMember]()
    var membersForStrokes = [ClassMember]()
    var membersForWattage = [ClassMember]()
    
    @IBOutlet weak var playerListPanel: UIView!
    @IBOutlet weak var topBarPanel: UIView!
    @IBOutlet weak var startingTimePanel: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var speedView: UIView!
    
    @IBOutlet weak var lblLobbyState: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var labelTotalDistance: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        timeLabel.text = "\(time)s"
        distanceLabel.text = "\(distance)m"
        speedLabel.text = "\(speed)m/s"
        
        
        self.distanceTableView.delegate = self
        self.distanceTableView.dataSource = self

        
        // Do any additional setup after loading the view.
        
        let _ = C2ScanningManager.shared
        
        C2ScanningManager.shared.addDelegate(self)
        
        SocketManager.sharedManager.delegate = self
        
        if lobbyState == KEY_LOBBY_STATE_ACCEPTING || lobbyState == KEY_LOBBY_STATE_FINISHED {
            self.startingTimePanel.isHidden = false
            if lobbyState == KEY_LOBBY_STATE_FINISHED {
                self.lblLobbyState.text = MSG_LOBBY_FINISHED
            }
        } else {
            self.startingTimePanel.isHidden = true
        }
        sortMembers()
    }
    
    func sortMembers() {
        if classMembers.count == 0 {
            return
        }
        membersForDistance = classMembers.sorted(by: {Int32($0.distance)! > Int32($1.distance)!})
        membersForCal = classMembers.sorted(by: {Int32($0.cal)! > Int32($1.cal)!})
        membersForSpeed = classMembers.sorted(by: {Int32($0.speed)! > Int32($1.speed)!})
        membersForStrokes = classMembers.sorted(by: {Int32($0.strokes)! > Int32($1.strokes)!})
        membersForWattage = classMembers.sorted(by: {Int32($0.wattage)! > Int32($1.wattage)!})
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        
        C2ScanningManager.shared.removeDelegate(self)
    }
    
    func canRotate() -> Void {}

    @IBAction func onClose(_ sender: Any) {
        
//        SocketManager.sharedManager.socket.disconnect()
        SocketManager.sharedManager.leaveChannel()
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapBackground(_ sender: Any) {
        if isShowingPanels {
            return
        } else {
            hidePanels(isHide: false)
            isShowingPanels = true
        }
    }
    
    @IBAction func onHidePanels(_ sender: Any) {
        hidePanels(isHide: true)
        isShowingPanels = false
    }
    func hidePanels(isHide: Bool) {
        
        UIView.animate(withDuration: 0.3, animations: {
            if isHide {
                self.topBarPanel.alpha = 0.0
                self.timeView.alpha = 0.0
                self.distanceView.alpha = 0.0
                self.speedView.alpha = 0.0
                self.playerListPanel.alpha = 0.0
                if self.lobbyState == KEY_LOBBY_STATE_ACCEPTING || self.lobbyState == KEY_LOBBY_STATE_FINISHED{
                    self.startingTimePanel.alpha = 0.0
                }
                
            } else {
                self.topBarPanel.alpha = 1.0
                self.timeView.alpha = 1.0
                self.distanceView.alpha = 1.0
                self.speedView.alpha = 1.0
                self.playerListPanel.alpha = 1.0
                if self.lobbyState == KEY_LOBBY_STATE_ACCEPTING || self.lobbyState == KEY_LOBBY_STATE_FINISHED{
                    self.startingTimePanel.alpha = 1.0
                }
            }
            
        }) { (isCompleted) in
            
        }
    }
}

extension ClassVideoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        var valueToSet: String = ""
        if tableView == self.distanceTableView {
            
            let tmpCell: ClassMemberForDistanceCell = tableView.dequeueReusableCell(withIdentifier: "ClassMemberForDistanceCell") as! ClassMemberForDistanceCell
            valueToSet = "\(membersForDistance[indexPath.row].distance)m"
            
            tmpCell.numberLabel.text = "\(indexPath.row + 1)st"
            tmpCell.nameLabel.text = "\(membersForDistance[indexPath.row].name)"
            tmpCell.valueLabel.text = valueToSet
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if membersForDistance[indexPath.row].name == appDelegate.g_token {
                tmpCell.viewForBackPlayerList.isHidden = false
                tmpCell.numberLabel.textColor = UIColor.black
                tmpCell.nameLabel.textColor = UIColor.black
                tmpCell.valueLabel.textColor = UIColor.black
            } else {
                tmpCell.viewForBackPlayerList.isHidden = true
                tmpCell.numberLabel.textColor = UIColor.white
                tmpCell.nameLabel.textColor = UIColor.white
                tmpCell.valueLabel.textColor = UIColor.white
            }
            cell = tmpCell
        } else if tableView == self.calTableView {
            let tmpCell: ClassMemberForCalCell = tableView.dequeueReusableCell(withIdentifier: "ClassMemberForCalCell") as! ClassMemberForCalCell
            valueToSet = "\(membersForCal[indexPath.row].cal)cal"
            tmpCell.numberLabel.text = "\(indexPath.row + 1)st"
            tmpCell.nameLabel.text = "\(membersForCal[indexPath.row].name)"
            tmpCell.valueLabel.text = valueToSet
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if membersForCal[indexPath.row].name == appDelegate.g_token {
                tmpCell.viewForBackPlayerList.isHidden = false
                tmpCell.numberLabel.textColor = UIColor.black
                tmpCell.nameLabel.textColor = UIColor.black
                tmpCell.valueLabel.textColor = UIColor.black
            } else {
                tmpCell.viewForBackPlayerList.isHidden = true
                tmpCell.numberLabel.textColor = UIColor.white
                tmpCell.nameLabel.textColor = UIColor.white
                tmpCell.valueLabel.textColor = UIColor.white
            }
            cell = tmpCell
        } else if tableView == self.speedTableView {
            let tmpCell: ClassMemberForSpeedCell = tableView.dequeueReusableCell(withIdentifier: "ClassMemberForSpeedCell") as! ClassMemberForSpeedCell
            valueToSet = "\(membersForSpeed[indexPath.row].speed)m/s"
            tmpCell.numberLabel.text = "\(indexPath.row + 1)st"
            tmpCell.nameLabel.text = "\(membersForSpeed[indexPath.row].name)"
            tmpCell.valueLabel.text = valueToSet
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if membersForSpeed[indexPath.row].name == appDelegate.g_token {
                tmpCell.viewForBackPlayerList.isHidden = false
                tmpCell.numberLabel.textColor = UIColor.black
                tmpCell.nameLabel.textColor = UIColor.black
                tmpCell.valueLabel.textColor = UIColor.black
            } else {
                tmpCell.viewForBackPlayerList.isHidden = true
                tmpCell.numberLabel.textColor = UIColor.white
                tmpCell.nameLabel.textColor = UIColor.white
                tmpCell.valueLabel.textColor = UIColor.white
            }
            cell = tmpCell
        } else if tableView == self.strokesTableView {
            let tmpCell: ClassMemberForStrokesCell = tableView.dequeueReusableCell(withIdentifier: "ClassMemberForStrokesCell") as! ClassMemberForStrokesCell
            valueToSet = "\(membersForStrokes[indexPath.row].strokes)st"
            tmpCell.numberLabel.text = "\(indexPath.row + 1)st"
            tmpCell.nameLabel.text = "\(membersForStrokes[indexPath.row].name)"
            tmpCell.valueLabel.text = valueToSet
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if membersForStrokes[indexPath.row].name == appDelegate.g_token {
                tmpCell.viewForBackPlayerList.isHidden = false
                tmpCell.numberLabel.textColor = UIColor.black
                tmpCell.nameLabel.textColor = UIColor.black
                tmpCell.valueLabel.textColor = UIColor.black
            } else {
                tmpCell.viewForBackPlayerList.isHidden = true
                tmpCell.numberLabel.textColor = UIColor.white
                tmpCell.nameLabel.textColor = UIColor.white
                tmpCell.valueLabel.textColor = UIColor.white
            }
            cell = tmpCell
        } else {
            let tmpCell: ClassMemberForWattageCell = tableView.dequeueReusableCell(withIdentifier: "ClassMemberForWattageCell") as! ClassMemberForWattageCell
            valueToSet = "\(membersForWattage[indexPath.row].wattage)wa"
            tmpCell.numberLabel.text = "\(indexPath.row + 1)st"
            tmpCell.nameLabel.text = "\(membersForWattage[indexPath.row].name)"
            tmpCell.valueLabel.text = valueToSet
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if membersForWattage[indexPath.row].name == appDelegate.g_token {
                tmpCell.viewForBackPlayerList.isHidden = false
                tmpCell.numberLabel.textColor = UIColor.black
                tmpCell.nameLabel.textColor = UIColor.black
                tmpCell.valueLabel.textColor = UIColor.black
            } else {
                tmpCell.viewForBackPlayerList.isHidden = true
                tmpCell.numberLabel.textColor = UIColor.white
                tmpCell.nameLabel.textColor = UIColor.white
                tmpCell.valueLabel.textColor = UIColor.white
            }
            cell = tmpCell
        }
        
        return cell
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
        
//        labelTotalDistance.text = "\(time) s : \(distance) m : \(speed) m/s"
    }
}

extension ClassVideoViewController: SocketConnectionManagerDelegate {
    
    func onErrorGetData() {
    
    }
    
    func SocketDidOpen(msg: String) {
        
    }
    
    func SocketDidClose(msg: String) {
        
    }
    
    func SocketDidJoin(members: [ClassMember]) {
        
        classMembers = members
        sortMembers()
        self.distanceTableView.reloadData()
        self.calTableView.reloadData()
        self.speedTableView.reloadData()
        self.strokesTableView.reloadData()
        self.wattageTableView.reloadData()
    }
    
    func SocketDidPushOnCannel(message: String) {
        
    }
    
    func onNewParticipant(member: ClassMember) {
        classMembers.append(member)
        sortMembers()
        self.distanceTableView.reloadData()
        self.calTableView.reloadData()
        self.speedTableView.reloadData()
        self.strokesTableView.reloadData()
        self.wattageTableView.reloadData()
        
        self.view.makeToast("\(member.name) has joined to this workout")
    }
    
    func onStartWorkout() {
        self.view.makeToast("Workout has been started")
        self.startingTimePanel.isHidden = true
        self.lobbyState = KEY_LOBBY_STATE_PROGRESS
    }
    
    func onFinishWorkout() {
        self.view.makeToast("Workout has been finished")
        self.lobbyState = KEY_LOBBY_STATE_FINISHED
        self.lblLobbyState.text = MSG_LOBBY_FINISHED
        self.startingTimePanel.isHidden = false
    }
    
    func onLeaderboardUpdated(members: [ClassMember]) {
        classMembers = members
        sortMembers()
        self.distanceTableView.reloadData()
        self.calTableView.reloadData()
        self.speedTableView.reloadData()
        self.strokesTableView.reloadData()
        self.wattageTableView.reloadData()
    }
    
}
