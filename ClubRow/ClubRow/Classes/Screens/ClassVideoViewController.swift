//
//  ClassVideoViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/8/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import CoreBluetooth
import MKProgress
import YouTubePlayer
import Toast_Swift

class ClassVideoViewController: SuperViewController {
    
    @IBOutlet weak var distanceTableView: UITableView!
    @IBOutlet weak var calTableView: UITableView!
    @IBOutlet weak var speedTableView: UITableView!
    @IBOutlet weak var strokesTableView: UITableView!
    @IBOutlet weak var wattageTableView: UITableView!
    @IBOutlet weak var playerView: YouTubePlayerView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var time: Int = 0 {
        didSet {
            guard let _ = self.timeLabel else {
                return
            }
            let (h, m, s) = Util.secondsToHoursMinutesSeconds(seconds: time)
            self.timeLabel.text = NSString(format: "%d hr %d min %d sec", h, m, s) as String
        }
    }
    var distance: Int = 0 {
        didSet {
            guard let _ = distanceLabel else {
                return
            }
            distanceLabel.text = "\(distance)m"
        }
    }
    var speed: Int = 0 {
        didSet {
            guard let _ = speedLabel else {
                return
            }
            speedLabel.text = "\(speed * 3600)m/h"
        }
    }
    var wattage: Int = 0 {
        didSet {
            guard let _ = wattageLabel else {
                return
            }
            wattageLabel.text = "\(wattage)watts"
        }
    }
    var calories: Int = 0 {
        didSet {
            guard let _ = caloriesLabel else {
                return
            }
            caloriesLabel.text = "\(calories * 1000)kcal"
        }
    }
    var strokes_per_minute: Int = 0 {
        didSet {
            guard let _ = strokeLabel else {
                return
            }
            strokeLabel.text = "\(strokes_per_minute)s/m"
        }
    }
    var pace500m: Int = 0 {
        didSet {
            guard let _ = paceLabel else {
                return
            }
            let (h, m, s) = Util.secondsToHoursMinutesSeconds(seconds: pace500m)
            paceLabel.text = NSString(format: "%d:%02d/500m", m, s) as String
        }
    }
    
    var isShowingPanels: Bool = true
    var lobbyState: String = ""
    var classMembers = [ClassMember]()
    var membersForDistance = [ClassMember]()
    var membersForCal = [ClassMember]()
    var membersForSpeed = [ClassMember]()
    var membersForStrokes = [ClassMember]()
    var membersForWattage = [ClassMember]()
    
    var lobbyId: Int = 0
    var classData: [String: Any]!
    
    @IBOutlet weak var playerListPanel: UIView!
    @IBOutlet weak var pllayerListScrollView: UIScrollView!
    @IBOutlet weak var topBarPanel: UIView!
    @IBOutlet weak var startingTimePanel: UIView!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var speedView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var wattageView: UIView!
    @IBOutlet weak var strokeView: UIView!
    @IBOutlet weak var caloriesView: UIView!
    
    @IBOutlet weak var lblLobbyState: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var wattageLabel: UILabel!
    @IBOutlet weak var strokeLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var labelTotalDistance: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnLeave: UIButton!
    @IBOutlet weak var btnLeaveWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        time = 0
        distance = 0
        speed = 0
        calories = 0
        strokes_per_minute = 0
        wattage = 0
        pace500m = 0
        
        //
//        timeLabel.text = "\(time)s"
//        distanceLabel.text = "\(distance)m"
//        speedLabel.text = "\(speed)m/s"
        
        
        self.distanceTableView.delegate = self
        self.distanceTableView.dataSource = self

        
        // Do any additional setup after loading the view.
        
        let _ = C2ScanningManager.shared
        
        C2ScanningManager.shared.addDelegate(self)
//        C2ScanningManager.shared.reconnect()
        
        SocketManager.sharedManager.delegate = self
        SocketManager.sharedManager.socketConnect(url: "ws://159.89.117.106:4000/socket/websocket", params: ["username": "test"])
        
        playerView.delegate = self
        playerView.playerVars = [
            "playsinline": "1",
            "controls": "0",
            "showinfo": "0",
            "color": "red",
            "loop": "1",
            "autoplay": "1",
            "fs":"0",
            "modestbranding": "1",
            "rel": "0",
            "cc_load_policy": "0",
            ] as YouTubePlayerView.YouTubePlayerParameters
        
        if let media = classData["media"] as? [String: Any] {
            if let url = media["url"] as? String {
                playerView.loadVideoURL(URL(string: url)!)
                loadingIndicator.isHidden = false
            }
            else {
                loadingIndicator.isHidden = true
            }
        }
        else {
            loadingIndicator.isHidden = true
        }
        
//        playerView.loadVideoID("tQvWfRolsaQ")
//        playerView.loadVideoID("_6u6UrtXUEI")
        playerView.isHidden = true

        
        pllayerListScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        MKProgress.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
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
    
    @IBAction func onClose(_ sender: Any) {
        
        playerView.stop()
        playerView.clear()
        playerView = nil
        SocketManager.sharedManager.delegate = nil
        SocketManager.sharedManager.leaveChannel()
        SocketManager.sharedManager.socket.disconnect()
        
//        self.navigationController?.popViewController(animated: true)
        
        C2ScanningManager.shared.removeDelegate(self)
        
        self.dismiss(animated: false) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissVideoWindow"), object: nil)
        }
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    @IBAction func onTapBackground(_ sender: Any) {
        if isShowingPanels {
            hidePanels(isHide: true)
            isShowingPanels = false
        } else {
            hidePanels(isHide: false)
            isShowingPanels = true
        }
    }
    
    @IBAction func onHidePanels(_ sender: Any) {
        hidePanels(isHide: true)
        isShowingPanels = false
    }
    
    @IBAction func onStartWorkout(_ sender: Any) {
        SocketManager.sharedManager.startWorkOut()
    }
    
    @IBAction func onFinishWorkout(_ sender: Any) {
        SocketManager.sharedManager.finishWorkOut()
    }
    
    func hidePanels(isHide: Bool) {
        
        UIView.animate(withDuration: 0.3, animations: {
            if isHide {
                self.topBarPanel.alpha = 0.0
                self.timeView.alpha = 0.0
                self.distanceView.alpha = 0.0
                self.speedView.alpha = 0.0
                self.playerListPanel.alpha = 0.0
                self.wattageView.alpha = 0.0
                self.strokeView.alpha = 0.0
                self.caloriesView.alpha = 0.0
                if self.lobbyState == KEY_LOBBY_STATE_ACCEPTING || self.lobbyState == KEY_LOBBY_STATE_FINISHED{
                    self.startingTimePanel.alpha = 0.0
                }
                
            } else {
                self.topBarPanel.alpha = 1.0
                self.timeView.alpha = 1.0
                self.distanceView.alpha = 1.0
                self.speedView.alpha = 1.0
                self.playerListPanel.alpha = 1.0
                self.wattageView.alpha = 1.0
                self.strokeView.alpha = 1.0
                self.caloriesView.alpha = 1.0
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
            if membersForDistance[indexPath.row].userID == appDelegate.g_userID {
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
            if membersForCal[indexPath.row].userID == appDelegate.g_userID {
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
            if membersForSpeed[indexPath.row].userID == appDelegate.g_userID {
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
            valueToSet = "\(membersForStrokes[indexPath.row].strokes)s/m"
            tmpCell.numberLabel.text = "\(indexPath.row + 1)st"
            tmpCell.nameLabel.text = "\(membersForStrokes[indexPath.row].name)"
            tmpCell.valueLabel.text = valueToSet
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if membersForStrokes[indexPath.row].userID == appDelegate.g_userID {
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
            valueToSet = "\(membersForWattage[indexPath.row].wattage)wat"
            tmpCell.numberLabel.text = "\(indexPath.row + 1)st"
            tmpCell.nameLabel.text = "\(membersForWattage[indexPath.row].name)"
            tmpCell.valueLabel.text = valueToSet
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if membersForWattage[indexPath.row].userID == appDelegate.g_userID {
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
    
    func C2ConnectionManagerDidConnect(_ deviceName: String) {
        self.view.makeToast("\(deviceName) is connected successfully!")
    }
    
    func C2ConnectionManagerFailConnect() {
    }
    
    func C2ConnectionManagerDidReceiveData(_ parameter: CBCharacteristic) {
        if lobbyState != KEY_LOBBY_STATE_PROGRESS {
            return
        }
        
        if parameter.uuid.uuidString == C2ScanningManager.PM5_CHAR31_UUID {
            if let value = parameter.value {
                let data = [UInt8](value).map { (i) -> Int in
                    Int(i)
                }
                Log.e("0x31================ \(data)")
                time = Int(Float(data[0] + (data[1] << 8) + (data[2] << 16)) * 10 / 1000.0)
                distance = Int(Float(data[3] + (data[4] << 8) + (data[5] << 16)) / 10.0)
                
//                self.timeLabel.text = "\(time)s"
//                self.distanceLabel.text = "\(distance)m"
                
                SocketManager.sharedManager.pushOnChannel(distance: distance, wattage: wattage, speed: speed, calories: calories, strokes_per_minute: strokes_per_minute)
            }
        }
        
        if parameter.uuid.uuidString == C2ScanningManager.PM5_CHAR32_UUID {
            if let value = parameter.value {
                let data = [UInt8](value).map { (i) -> Int in
                    Int(i)
                }
                Log.e("0x32=================== \(data)")
                speed = Int(Float(data[3] + (data[4] << 8)) / 1000.0)
                strokes_per_minute = data[5]
                pace500m = Int(Float(data[7] + (data[8] << 8)) * 10 / 1000.0)
            }
            
//            self.speedLabel.text = "\(speed)m/s"
            
            SocketManager.sharedManager.pushOnChannel(distance: distance, wattage: wattage, speed: speed, calories: calories, strokes_per_minute: strokes_per_minute)
        }
        
        if parameter.uuid.uuidString == C2ScanningManager.PM5_CHAR33_UUID {
            if let value = parameter.value {
                let data = [UInt8](value).map { (i) -> Int in
                    Int(i)
                }
                Log.e("0x33================ \(data)")
                wattage = data[10] + (data[11] << 8)
                calories = data[12] + (data[13] << 8)
            }
            
            SocketManager.sharedManager.pushOnChannel(distance: distance, wattage: wattage, speed: speed, calories: calories, strokes_per_minute: strokes_per_minute)
        }
        
//        labelTotalDistance.text = "\(time) s : \(distance) m : \(speed) m/s"
    }
}

extension ClassVideoViewController: SocketConnectionManagerDelegate {
    
    func onErrorGetData() {
        SocketManager.sharedManager.disconnectOnSocket()
        MKProgress.hide(false)
        let alert = UIAlertController(title: "Lobby Error", message: "Failed to Get Data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { [weak self] (_) in
            self?.onClose(self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func SocketDidOpen(msg: String) {
        let topic = "lobby:\(self.lobbyId)"
        SocketManager.sharedManager.connectChannel(topic: topic)
    }
    
    func SocketDidClose(msg: String) {
        
    }
    
    func SocketDidError(msg: String) {
        MKProgress.hide(false)
        let alert = UIAlertController(title: "Socket Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { [weak self] (_) in
            self?.onClose(self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func SocketDidJoin(response: [String: Any]) {
        
        self.lobbyState = response["lobby_status"] as! String
        
        if lobbyState == KEY_LOBBY_STATE_ACCEPTING || lobbyState == KEY_LOBBY_STATE_FINISHED {
            self.startingTimePanel.isHidden = false
            if lobbyState == KEY_LOBBY_STATE_FINISHED {
                self.lblLobbyState.text = MSG_LOBBY_FINISHED
            }
        } else {
            self.startingTimePanel.isHidden = true
        }
        
        let owned = response["owned"] as! Bool
        if owned == true && lobbyState == KEY_LOBBY_STATE_ACCEPTING {
            self.btnStart.isHidden = false
        }
        else {
            self.btnStart.isHidden = true
        }
        
        if owned == true && lobbyState != KEY_LOBBY_STATE_FINISHED {
            self.btnLeave.isHidden = false
            self.btnLeaveWidthConstraint.constant = 90
        }
        else {
            self.btnLeave.isHidden = true
            self.btnLeaveWidthConstraint.constant = 0
        }

        
        var members = [ClassMember]()
        let memberData = response["members"] as! [[String: Any]]
        for member in memberData {
            let memberItem = ClassMember.init(name_: member["username"] as! String, distance_: "\(member["distance"] as! Int)", cal_: "\(member["calories"] as! Int)", speed_: "\(member["speed"] as! Int)", strokes_: "\(member["strokes_per_minute"] as! Int)", wattage_: "\(member["wattage"] as! Int)")
            memberItem.userID = member["user_id"] as! Int
            members.append(memberItem)
        }

        classMembers = members
        sortMembers()
        self.distanceTableView.reloadData()
        self.calTableView.reloadData()
        self.speedTableView.reloadData()
        self.strokesTableView.reloadData()
        self.wattageTableView.reloadData()
        
        MKProgress.hide()

    }
    
    func SocketDidPushOnCannel(message: String) {
        
    }
    
    func onNewParticipant(response: [String: Any]) {
        
        let member = ClassMember.init(name_: response["username"] as! String, distance_: "0", cal_: "0", speed_: "0", strokes_: "0", wattage_: "0")
        member.userID = response["user_id"] as! Int
        classMembers.append(member)
        sortMembers()
        self.distanceTableView.reloadData()
        self.calTableView.reloadData()
        self.speedTableView.reloadData()
        self.strokesTableView.reloadData()
        self.wattageTableView.reloadData()
        
        self.view.makeToast("\(member.name) has joined to this workout")
    }
    
    func onLeaveParticipant(response: [String : Any]) {
        let member = ClassMember.init(name_: response["username"] as! String, distance_: "0", cal_: "0", speed_: "0", strokes_: "0", wattage_: "0")
        member.userID = response["user_id"] as! Int
        self.view.makeToast("\(member.name) has left")
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
        self.btnStart.isHidden = true
        self.btnLeave.isHidden = true
        self.btnLeaveWidthConstraint.constant = 0
    }
    
    func onLeaderboardUpdated(response: [String : Any]) {
        let members = response.map { (key, value) -> ClassMember in
            let data = value as! [String: Any]
            let classMember = ClassMember.init(name_: data["username"] as! String, distance_: "\(data["distance"] as! Int)", cal_: "\(data["calories"] as! Int)", speed_: "\(data["speed"] as! Int)", strokes_: "\(data["strokes_per_minute"] as! Int)", wattage_: "\(data["wattage"] as! Int)")
            classMember.userID = Int(key)!
            return classMember
        }
        classMembers = members
        sortMembers()
        self.distanceTableView.reloadData()
        self.calTableView.reloadData()
        self.speedTableView.reloadData()
        self.strokesTableView.reloadData()
        self.wattageTableView.reloadData()
    }
    
}

extension ClassVideoViewController: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        print(#function)
        playerView.play()
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        switch playerState {
        case .Buffering:
            print("\(#function): Buffering")
        case .Ended:
            print("\(#function): Ended")
            playerView.play()
        case .Paused:
            print("\(#function): Paused")
        case .Playing:
            print("\(#function): Playing")
            playerView.isHidden = false
        case .Queued:
            print("\(#function): Queued")
        case .Unstarted:
            print("\(#function): Unstrated")
        }
    }
    
    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
        
    }
}
