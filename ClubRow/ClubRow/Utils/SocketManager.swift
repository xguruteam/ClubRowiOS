//
//  SingletonManager.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/7/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import Foundation
import SwiftPhoenixClient
import SwiftyJSON
import KRProgressHUD

protocol SocketConnectionManagerDelegate {
    func SocketDidOpen(msg: String)
    func SocketDidClose(msg: String)
    func SocketDidJoin(members: [ClassMember])
    func SocketDidPushOnCannel(message: String)
//    func C2ConnectionManagerFailConnect()
//    func C2ConnectionManagerDidReceiveData(_ parameter: CBCharacteristic)
}

class SocketManager {
    
    // These are the properties you can store in your singleton
    private var myName: String = "bob"
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    
    var delegate: SocketConnectionManagerDelegate?
    
    // Socket
    var topic: String = "lobby:lobbyID"
    var lobbyChannel: Channel!
    
    var socket = Socket(url: "ws://159.89.117.106:4000/socket/websocket", params:  ["username": "test"])
    
    
    func socketConnect(url: String, params: Payload) {
        socket.onOpen {
//            print("Socket has opened")
            self.delegate?.SocketDidOpen(msg: "Socket has opended")
        }
        socket.onClose {
//            print("Socket has closed")
            self.delegate?.SocketDidClose(msg: "Socket has closed")
        }
        socket.onError { error in
            print("Socket has errored: ", error.localizedDescription)
        }
        socket.logger = { msg in
            print(msg)
        }
        socket.connect()
    }
    
    func connectChannel(topic: String) {
        
        let channel = socket.channel(topic)
        
        // join
        KRProgressHUD.show()
        channel
            .join()
            .receive("ok") { (payload) in
                KRProgressHUD.dismiss()
                //                    print("========================================")
                //                    print("Joined Channel: ", payload)
                //                    print("hhhhhh",  payload.payload["response"]!)
        
                //
                let dic = payload.payload["response"] as! NSDictionary
                let keys = dic.allKeys
                var members = [ClassMember]()
                
                for key in keys {
                    //                        print("key =========", key)
                    let dic = dic[key as! String] as! NSDictionary
                    let dist = dic["distance"] as! Int
                    //                        print("dist=========", dist!)
        
                    let member = ClassMember.init(name_: key as! String, distance_: String.init(format: "%ld", dist))
                    members.append(member)
                }
                
                self.delegate?.SocketDidJoin(members: members)
        
            }.receive("error") { (payload) in
                print("Failed to join channel: ", payload)
        }
        
        // 1. new_participant
        channel.on("new_participant") { (message) in
            print("new_participant================")
        }
        
        // 2. workout_started
        channel.on("workout_started") { (message) in
            print("workout_started==========")
        }
        
        // 3. workout_finished
        channel.on("workout_finished") { (message) in
            print("workout_finished===================")
        }
        
        // 4. leaderboard_updated
        channel.on("leaderboard_updated") { (message) in
            print("leaderboard_updated==============")
            
            let dic = message.payload as NSDictionary
            let keys = dic.allKeys
            var members = [ClassMember]()
            
            for key in keys {
                //                        print("key =========", key)
                let dic = dic[key as! String] as! NSDictionary
                let dist = dic["distance"] as! Int
                //                        print("dist=========", dist!)
                
                let member = ClassMember.init(name_: key as! String, distance_: String.init(format: "%ld", dist))
                members.append(member)
            }
            
            self.delegate?.SocketDidJoin(members: members)
        }
        lobbyChannel = channel

    }
    
    func pushOnChannel(distance: String, wattage: String, speed: String, calories: String, strokes_per_minute: String) {
        lobbyChannel
            .push("workout_update", payload: ["distance": distance, "wattage": wattage, "speed": speed, "calories": calories, "strokes_per_minute": strokes_per_minute])
            .receive("ok") { (message) in
                print("success", message)
            }
            .receive("error") { (errorMessage) in
                print("error: ", errorMessage)
        }
    }
    
    func disconnectOnSocket() {
        socket.disconnect()
    }

    // Teachers
//    var teachers = [Teacher]()
    
    class var sharedManager: SocketManager {
        struct Static {
            static let instance = SocketManager()
        }
        return Static.instance
    }
}
