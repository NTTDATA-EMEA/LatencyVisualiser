//
//  Message.swift
//  LatencyVisualiser
//
//  Created by Oliver Köth on 04.01.21.
//

import Foundation

struct Message : Codable {
    init(action:String, data:String) {
        self.action=action
        self.data=data
    }
    var action:String
    var data:String
}
