//
//  TeacherModel.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/6/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import Foundation

//struct Teacher {
//    var time: Int
//    var distance: Int
//    var speed: Int
//    var id: Int
//    var status: String
//
//    init(time: Int, distance: Int, speed: Int, id: Int, status: String) {
//        self.time = time
//        self.distance = distance
//        self.speed = speed
//        self.id = id
//        self.status = status
//    }
//}

class Teacher {
//    var time: Int = 0
//    var distance: Int
//    var speed: Int
    
    var id: Int
    var teacherStatus: String  // working_progress
//    var markedStatus: String               // featured
    
    init(data: NSDictionary) {
        teacherStatus = data["status"] as! String
        id = data["id"] as! Int
//        distance = data["ditance"] as! Int
//        time = data["time"] as! Int
//        speed = data["speed"] as! Int
//        teacherStatus = data["teacherStatus"] as! String
//        markedStatus = data["markedStatus"] as! String
    }
}
