//
//  Item.swift
//  TestProject
//
//  Created by Alberto Peinado Santana on 21/1/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
