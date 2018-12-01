//
//  LiveClass.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/28/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

class LiveClass: NSObject {
    var id: Int
    var name: String
    var teacher_id: Int
    var teacher: NSDictionary
    var start_at: String
    var finish_at: String
    var lobby_id: Int
    var featured: Bool
    
    
    init(data: NSDictionary) {
        id = data["id"] as! Int
        name = data["name"] as! String
        teacher_id = data["teacher_id"] as! Int
        teacher = data["teacher"] as! NSDictionary
        start_at = data["starts_at"] as! String
        finish_at = data["finishes_at"] as! String
        if let lobby_id_ = (data["lobby_id"] as? Int) {
            lobby_id = lobby_id_
        } else {
            lobby_id = -1
        }
        featured = data["featured"] as! Bool
        
    }
}
