//
//  Item.swift
//  SwiftUIScrollViews
//
//  Created by Alberto Peinado Santana on 21/1/25.
//

import Foundation
import SwiftData

@Model
final class Item: Identifiable {
    var id: UUID = UUID()
    var timestamp: Date = Date.now
    @Attribute(.externalStorage) var photo: Data? = nil
    
    init(photo: Data = Data(), timestamp: Date = Date.now) {
        self.photo = photo
        self.timestamp = timestamp
    }
}
