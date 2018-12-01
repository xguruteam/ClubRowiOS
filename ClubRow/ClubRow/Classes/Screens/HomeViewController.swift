//
//  HomeViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/2/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD
import SimpleAlert
import Device

class HomeViewController: SuperViewController {

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var titleBarView: UIView!
    
    @IBOutlet weak var top: NSLayoutConstraint!
    
    var aryLiveClasses = [LiveClass]()
    var teachers = [Teacher]()
    var members = [ClassMember]()
    var lobbies = [Lobby]()
    var tmpLobbies = [Lobby]() //TODO
    var lobbyList = [NSDictionary]()//TODO
    var selectedLobbyState: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        
        // shadow
        titleBarView.layer.shadowColor = UIColor.black.cgColor
        titleBarView.layer.shadowOffset = CGSize(width: 0, height: 3)
        titleBarView.layer.shadowOpacity = 0.07
        titleBarView.layer.shadowRadius = 3
        
        loadLiveClasses()
        loadLobbies()
        // open Socket
        SocketManager.sharedManager.delegate = self
        SocketManager.sharedManager.socketConnect(url: "ws://159.89.117.106:4000/socket/websocket", params: ["username": "test"])
        
        // for test
        for _ in 1...5 {
            let lob = Lobby(name_: "Nates Hip Hop Class", startedAt_: "00:60", cur_member_: "1", entire_member_: "100")
            lobbies.append(lob)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLiveClasses() {
        // API
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        KRProgressHUD.show()
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Token token=\(appDelegate.g_token)"
        ]
        let url = SERVER_URL + KEY_API_LOAD_LIVE_CLASSES
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                KRProgressHUD.dismiss()
                switch response.result
                {
                case .failure( _):
                    self.view.makeToast(MSG_HOME_FAILED_LOAD_CLASSES)
                    break
                case .success( _):
                    
                    let dic = response.result.value as! NSDictionary
                    
                    let list =  dic["data"] as! NSArray
                    print(list)
                    
                    for item in list {
                        let dic = item as! NSDictionary
                        let live_class = LiveClass.init(data: dic)
                        self.aryLiveClasses.append(live_class)
                    }
                    
                    self.homeTableView.reloadData()
                }
        }
    }
    
    func loadLobbies() {
        // API
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        KRProgressHUD.show()
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Token token=\(appDelegate.g_token)"
        ]
        let url = SERVER_URL + KEY_API_LOAD_LOBBIES
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON
            { response in
                KRProgressHUD.dismiss()
                switch response.result
                {
                    case .failure( _): break
                    
                    case .success( _):
                        
                        let dic = response.result.value as! NSDictionary
                        
                        self.lobbyList =  dic["data"] as! [NSDictionary] //TODO
                        
//                    for item in list {
//                        let dic = item as! NSDictionary
//                        let lobby = Lobby.init(data: dic)
//                        self.tmpLobbies.append(lobby)
//                    }
                
                    
                    self.homeTableView.reloadData()
            }
        }
    }
    
    func resizeTopView() {
        switch "\(Device.version())" {
        case "simulator":
            let string = UIDevice().modelName
            let start = String.Index(encodedOffset: 6)
            let end = String.Index(encodedOffset: 8)
            let substring = String(string[start..<end])
            print(substring)
            
            if substring == "10" {
                top.constant = 44
            } else {
                top.constant = 0
            }
        case "iPhoneX":
            top.constant = 44
        case "iPhoneXS":
            top.constant = 44
        case "iPhoneXS_Max":
            top.constant = 44
        case "iPhoneXR":
            top.constant = 44
        default:
            top.constant = 0
            print("unkown")
        }
    }
    
    func dropShadowOn(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.16
        view.layer.shadowRadius = 4
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return lobbies.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "ClassLobbyCell", for: indexPath) as! ClassLobbyCell
            cell.liveClasses = aryLiveClasses
            cell.selectionStyle = .none
            
            cell.collectionView.reloadData()
            cell.delegate = self
            return cell
        case 1:
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "RobbyTitleCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        case 2:
            let curLobby = lobbies[indexPath.row]
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "LobbyCell", for: indexPath) as! LobbyTableViewCell
            cell.lblName.text = curLobby.name
            cell.lblStartedAt.text = String.init(format: "Starting in %@", curLobby.startedAt)
            cell.lblMembers.text = String.init(format: "%@/%@", curLobby.cur_member, curLobby.entire_member)
            cell.btnSelectLobby.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        default:
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "LobbyCell", for: indexPath) as! SelectedTeacherCell
            cell.selectionStyle = .none
            return cell        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 263
        case 1:
            return 70
        case 2:
            return 67
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
}

extension HomeViewController: SocketConnectionManagerDelegate {
    func onNewParticipant(member: ClassMember) {
        
    }
    
    func onStartWorkout() {
        
    }
    
    func onFinishWorkout() {
        
    }
    
    func onLeaderboardUpdated(members: [ClassMember]) {
        
    }
    
    func SocketDidPushOnCannel(message: String) {
        
    }
    
    func SocketDidJoin(members: [ClassMember]) {
        let vc = self.getStoryboardWithIdentifier(identifier:"ClassVideoViewController") as! ClassVideoViewController
        vc.distance = 4 //self.teachers[indexPath.row].distance
        vc.time = 9 //self.teachers[indexPath.row].time
        vc.speed = 200 //self.teachers[indexPath.row].speed
        vc.lobbyState = self.selectedLobbyState
        vc.classMembers = members
        MainViewController.getInstance().navigationController?.pushViewController(vc, animated: true)
    }
    
    func SocketDidOpen(msg: String) {
        print(msg)
    }
    
    func SocketDidClose(msg: String) {
        print(msg)
    }
}

extension HomeViewController: ClassLobbyCellDelegate {
    func onJoinClass(_ sender_id: Int, _ isExistLobby: Bool) {
        if !isExistLobby {
            self.view.makeToast("Can't join this class")
            return
        }
        
        
        for liveClass in aryLiveClasses {
            if liveClass.id == sender_id {
                var lobby_state: String = ""
                for lobby in self.lobbyList {
                    let lobby_id = lobby["id"] as! Int
                    if lobby_id == liveClass.lobby_id {
                        lobby_state = lobby["status"] as! String
                    }
                }
                selectedLobbyState = lobby_state
                let topic = "lobby:\(liveClass.lobby_id)"
                SocketManager.sharedManager.delegate = self
                SocketManager.sharedManager.connectChannel(topic: topic)
            }
        }
    }
}

extension HomeViewController: SelectLobbyDelegate {
    func onSelectLobby(_index: Int) {
        //TODO
//        let name = "lobby"
//        let topic = "\(name):\(teachers[0].id)"
//        SocketManager.sharedManager.delegate = self
//        SocketManager.sharedManager.connectChannel(topic: topic)
    }
}
