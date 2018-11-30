//
//  ViewController.swift
//  socket_client
//
//  Created by Lucass Beck on 11/3/18.
//  Copyright © 2018 Lucass Beck. All rights reserved.
//

import UIKit
import SwiftPhoenixClient
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var conseptTableView: UITableView!
    
    var socket = Socket(url: "ws://159.89.117.106:4000/socket/websocket")
//    var topic: String = "rooms:lobby"
    var topic: String = "lobby:lobbyID"
    var lobbyChannel: Channel!
    
    let editTitles = ["Username", "Lobby ID", "New Distance"]
    let editButtonTitles = ["Connect to Socket using your Username", "Connect to Lobby", "Push Distance To Lobby"]
    
    var connectionStatusArray = [String]()
    var leaderboardArray = [String]()
    
    var currentUser: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.conseptTableView.delegate = self;
        self.conseptTableView.dataSource = self;
        
//        socket.onOpen {
//            print("Socket has opened")
//        }
//
//        socket.onClose {
//            print("Socket has closed")
//        }
//
//        socket.onError { error in
//            print("Socket has errored: ", error.localizedDescription)
//        }
//
//        socket.logger = { msg in
//            print(msg)
//        }
//
//        socket.connect()
        
//        let channel = socket.channel(topic, params: ["status":"joining"])
//        channel.on("join") { (payload) in
////            self.chatWindow.text = "You joined the room.\n"
//            print("You joined the room")
//        }
//
//        channel.on("new:msg") { (message) in
//            let payload = message.payload
//            guard let username = payload["user"], let body = payload["body"] else { return }
//            let newMessage = "[\(username)] \(body)\n"
////            let updatedText = self.chatWindow.text.appending(newMessage)
////            self.chatWindow.text = updatedText
//            print(newMessage)
//        }
//
//        channel.on("user:entered") { (message) in
//            let username = "anonymous"
////            self.chatWindow.text = self.chatWindow.text.appending("[\(username) entered]\n")
//            print(username)
//        }
//
//        channel
//            .join()
//            .receive("ok") { (payload) in
//                print("Joined Channel")
//            }.receive("error") { (payload) in
//                print("Failed to join channel: ", payload)
//        }
//        self.lobbyChannel = channel
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return connectionStatusArray.count
        case 2:
            return leaderboardArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditCell", for: indexPath) as! EditCell
            cell.delegate = self
            
            if indexPath.row == 0 {
                cell.userNameLabel.text = editTitles[0]
//                cell.editBtn.titleLabel?.text = editButtonTitles[0]
                cell.editBtn.setTitle(editButtonTitles[0], for: .normal)
            }
            if indexPath.row == 1 {
                cell.userNameLabel.text = editTitles[1]
                cell.editBtn.setTitle(editButtonTitles[1], for: .normal)
            }
            if indexPath.row == 2 {
                cell.userNameLabel.text = editTitles[2]
                cell.editBtn.setTitle(editButtonTitles[2], for: .normal)
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionStatusCell", for: indexPath) as! ConnectionStatusCell
            cell.connectionStatusLabel?.text = connectionStatusArray[indexPath.row]
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
            cell.leaderInfoLabel.text = leaderboardArray[indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
            cell.leaderInfoLabel.text = "sdfsfsfsfsfdsdfs"
            return cell
        }
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view: UIView = UIView()
//        return view
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 40
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Leaderboard"
    }
}

extension ViewController: UITableViewDelegate, EditCellDelegate {

    func clickedEditBtn(_ sender: EditCell) {
        
        switch sender.userNameLabel.text {
        case "Username":
            print("clickedUsername")
            
            self.currentUser = sender.userNameTextField.text!
            
            self.socket = Socket(url: "ws://159.89.117.106:4000/socket/websocket", params:["username":sender.userNameTextField.text!])
            
            socket.onOpen {
                print("Socket has opened")
                self.connectionStatusArray.append("Connected to Socket. Is able to join channels now")
                self.conseptTableView.reloadData()
            }
            
            socket.onClose {
                print("Socket has closed")
            }
            
            socket.onError { error in
                print("Socket has errored: ", error.localizedDescription)
            }
            
            socket.logger = { msg in
                print(msg)
            }
            
            socket.connect()
        case "Lobby ID":
            print("clickedLobbyID")
            
//            let channel = socket.channel(topic, params: ["status":"joining"])
            var topic = "lobby:\(sender.userNameTextField.text!)"
            
            let channel = socket.channel(topic)
            
            // join
            channel
                .join()
                .receive("ok") { (payload) in
//                    print("========================================")
//                    print("Joined Channel: ", payload)
//                    print("hhhhhh",  payload.payload["response"]!)
                    
                    // init
                    self.leaderboardArray = [String]()
                    
                    let temp = payload.payload["response"] as! NSDictionary
                    let users = temp.allKeys
                    
//                    print(users)
//                    print(temp.allValues)
                    
                    for i in 0..<temp.allValues.count {
                        let user = users[i] as! String
                        let value = temp.allValues[i] as! NSDictionary
                        let distance = value.value(forKey: "distance")
                        
                        print(user)
                        print(distance!)

                        self.leaderboardArray.append("\(user):\(distance!)")
                    }
                    
                    self.conseptTableView.reloadData()
                    
                    
                }.receive("error") { (payload) in
                    print("Failed to join channel: ", payload)
            }
            
            // 1. new_participant
            channel.on("new_participant") { (message) in
                print("new_participant")
                var temp = "New Participant: "
                let username = message.payload["username"]
                temp.append((username as? String)!)
                self.connectionStatusArray.append(temp)
                self.conseptTableView.reloadData()
            }
            
            // 2. workout_started
            channel.on("workout_started") { (message) in
                print("workout_started")
                self.connectionStatusArray.append(message.status!)
                self.conseptTableView.reloadData()
            }
            
            // 3. workout_finished
            channel.on("workout_finished") { (message) in
                print("workout_finished")

                self.connectionStatusArray.append(message.status!)
                self.conseptTableView.reloadData()
            }
            
            // 4. leaderboard_updated
            channel.on("leaderboard_updated") { (message) in
                print("leaderboard_updated")
                
                self.connectionStatusArray.append("Leaderboard Updated!")
                
                // init
                self.leaderboardArray = [String]()
                
                
                let temp = message.payload as NSDictionary
                let users = temp.allKeys
                
                //                    print(users)
                //                    print(temp.allValues)
                
                for i in 0..<temp.allValues.count {
                    let user = users[i] as! String
                    let value = temp.allValues[i] as! NSDictionary
                    let distance = value.value(forKey: "distance")
                    
                    print(user)
                    print(distance!)
                    
                    
                    let responseJSON = JSON(distance!)
                    let dd = responseJSON["body"]
                    
//                    self.leaderboardArray.append("\(user):\(distance!)")
                    
//                    if !dd.isEmpty {
                    print(dd)
                    
                    self.leaderboardArray.append("\(user):\(distance!)")

//                    }
//                        self.leaderboardArray.append("\(user):\(dd)")
                    
                    
//                    let dd = distance as! NSDictionary
//                    print(dd)
                    
                }
                
                self.conseptTableView.reloadData()
            }
            self.lobbyChannel = channel
        case "New Distance":
            print("clickedNewDistance", sender.userNameTextField.text!)
            
            // push
//            let payload = ["user":userField.text!, "body": messageField.text!]
//            let payload = ["user":"test", "body":"testMessage"]
            
            self.lobbyChannel
                .push("workout_update", payload: ["distance": sender.userNameTextField.text!, "wattage":"0", "speed":"0", "calories":"0", "strokes_per_minute":"0"])
                .receive("ok") { (message) in
                    print("success", message)
                }
                .receive("error") { (errorMessage) in
                    print("error: ", errorMessage)
            }
            
        default:
            print("Nothing")
        }

    }
}
