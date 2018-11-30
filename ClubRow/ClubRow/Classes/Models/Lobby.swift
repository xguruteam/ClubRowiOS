//
//  ClassMember.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/8/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import Foundation

class Lobby {
    
    var name: String
    var startedAt: String
    var cur_member: String
    var entire_member: String
    
    init(name_: String, startedAt_: String, cur_member_: String, entire_member_: String) {
        name = name_
        startedAt = startedAt_
        cur_member = cur_member_
        entire_member = entire_member_
    }
}
