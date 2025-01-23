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
    var id: UUID = UUID()
    var timestamp: Date = Date.now
    var photo: Data = Data()
    
    init(photo: Data = Data(), timestamp: Date = Date.now) {
        self.photo = photo
        self.timestamp = timestamp
    }
}

extension Item: Identifiable {}
