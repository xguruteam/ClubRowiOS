//
//  ClassMember.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/8/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import Foundation

class Lobby {
    
    var id: Int
    var name: String
    var status: String
    var startedAt: String
    var cur_member: Int
    var entire_member: Int
    
    init( data: NSDictionary) {
        
        //TODO
        //tmp datas is used.
    
        id = data["id"] as! Int
        name = "Nates Hip Hop Class" //data["name"] as! String
        startedAt = "06:00" //data["starts_at"] as! String
        cur_member = 2 //data["cur_member"] as! Int
        entire_member = 200 //data["entire_member"] as! Int
        status = data["status"] as! String //data["status"] as! String
    }
}
