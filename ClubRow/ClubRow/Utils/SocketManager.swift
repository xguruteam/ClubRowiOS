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
import MKProgress

protocol SocketConnectionManagerDelegate {
    func SocketDidOpen(msg: String)
    func SocketDidClose(msg: String)
    func SocketDidError(msg: String)
    func SocketDidJoin(response: [String: Any])
    func SocketDidPushOnCannel(message: String)
    //
    func onNewParticipant(response: [String: Any])
    func onLeaveParticipant(response: [String: Any])
    func onStartWorkout()
    func onFinishWorkout()
    func onLeaderboardUpdated(response: [String: Any])
    func onErrorGetData()
//    func C2ConnectionManagerFailConnect()
//    func C2ConnectionManagerDidReceiveData(_ parameter: CBCharacteristic)
}


class SocketManager {
    
    var delegate: SocketConnectionManagerDelegate?
    
    // Socket
    var lobbyChannel: Channel!
    
    var socket: Socket!
    
    
    func socketConnect(url: String, params: Payload) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        socket = Socket(url: "ws://35.247.62.121:4000/socket/websocket", params: ["token": appDelegate.g_token])
        socket.onOpen {
            print("Socket has opened")
            self.delegate?.SocketDidOpen(msg: "Socket has opended")
        }
        socket.onClose {
            print("Socket has closed")
            self.delegate?.SocketDidClose(msg: "Socket has closed")
        }
        socket.onError { error in
            print("Socket has errored: ", error.localizedDescription)
            self.delegate?.SocketDidError(msg: "Failed to connect Server")
        }
        socket.logger = { msg in
            print(msg)
        }
        
        socket.connect()
    }
    
    func connectChannel(topic: String) {
        
        let channel = socket.channel(topic)
        
        // join
        channel
            .join()
            .receive("ok") { (payload) in
//                print(payload)
//                let dic = payload.payload["response"] as! NSDictionary
//                let keys = dic.allKeys
//                var members = [ClassMember]()
//                var index: Int = 0
//                for key in keys {
//                    //                        print("key =========", key)
//                    let dic = dic[key as! String] as! NSDictionary
//                    let dist = dic["distance"] as! Int
//                    //                        print("dist=========", dist!)
//                    let member = ClassMember.init(name_: key as! String, distance_: "\(dist)", cal_: "\(index)", speed_: "\(index + 2)", strokes_: "\(index+4)", wattage_: "\(index + 10)") //TODO
//                    members.append(member)
//                    index += 1
//                }
                self.delegate?.SocketDidJoin(response: payload.payload["response"] as! [String: Any])
        
            }.receive("error") { (payload) in
                self.delegate!.onErrorGetData()
                print("Failed to join channel: ", payload)
        }
        // 1. new_participant
        channel.on("new_participant") { (message) in
//            let dic = message.payload as NSDictionary
//            self.delegate!.onNewParticipant(member: ClassMember.init(name_: dic.object(forKey: "username") as! String, distance_: "0", cal_: "0", speed_: "0", strokes_: "0", wattage_: "0"))
            self.delegate!.onNewParticipant(response: message.payload )
            print("new_participant================")
        }
        
        channel.on("leave_participant") { (message) in
            self.delegate!.onLeaveParticipant(response: message.payload )
            print("leave_participant================")
        }
        
        // 2. workout_started
        channel.on("workout_started") { (message) in
            self.delegate!.onStartWorkout()
            print("workout_started==========")
        }
        
        // 3. workout_finished
        channel.on("workout_finished") { (message) in
            self.delegate!.onFinishWorkout()
            print("workout_finished===================")
        }
        
        // 4. leaderboard_updated
        channel.on("leaderboard_updated") { (message) in
            print("leaderboard_updated==============")
            
//            let dic = message.payload as NSDictionary
//            let keys = dic.allKeys
//            var members = [ClassMember]()
//            var index: Int = 0
//            for key in keys {
//                //                        print("key =========", key)
//                let dic = dic[key as! String] as! NSDictionary
//                let dist = dic["distance"] as! Int
//                //                        print("dist=========", dist!)
//                let member = ClassMember.init(name_: key as! String, distance_: "\(dist)", cal_: "\(index)", speed_: "\(index + 2)", strokes_: "\(index+4)", wattage_: "\(index + 10)") //TODO
//                members.append(member)
//                index += 1
//            }
//
            self.delegate?.onLeaderboardUpdated(response: message.payload)
        }
        
        
        
        lobbyChannel = channel
    }
    
    func leaveChannel() {
        if lobbyChannel != nil {
            lobbyChannel.leave()
        }
    }
    
    func pushOnChannel(distance: Int, wattage: Int, speed: Int, calories: Int, strokes_per_minute: Int) {
        lobbyChannel
            .push("workout_update", payload: ["distance": distance, "wattage": wattage, "speed": speed, "calories": calories, "strokes_per_minute": strokes_per_minute])
            .receive("ok") { (message) in
                print("success", message)
            }
            .receive("error") { (errorMessage) in
                print("error: ", errorMessage)
        }
    }
    
    func startWorkOut() {
        lobbyChannel
            .push("start_workout", payload: ["token":""])
            .receive("ok") { (message) in
                print("success", message)
            }
            .receive("error") { (errorMessage) in
                print("error: ", errorMessage)
        }
    }
    
    func finishWorkOut() {
        lobbyChannel
            .push("finish_workout", payload: ["token":""])
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
