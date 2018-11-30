//
//  PresetDescription.swift
//  SwiftEntryKit_Example
//
//  Created by Luccas on 4/24/18.
//  Copyright (c) 2018 Luccas. All rights reserved.
//

import SwiftEntryKit

// Description of a single preset to be presented
struct PresetDescription {
    let title: String
    let description: String
    let thumb: String
    let attributes: EKAttributes
    
    init(with attributes: EKAttributes, title: String, description: String = "", thumb: String) {
        self.attributes = attributes
        self.title = title
        self.description = description
        self.thumb = thumb
    }
}
