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
    @Relationship(deleteRule: .nullify, inverse: \Photo.item) var photos: [Photo]
    
    init(photos: [Photo] = []) {
        self.photos = photos
    }
}

extension Item: Identifiable {}

@Model
final class Photo {
    var id: UUID = UUID()
    var timestamp: Date = Date.now
    @Attribute(.externalStorage)
    var photo: Data = Data()
    var item: Item?
    
    init(photo: Data = Data()) {
        self.photo = photo
    }
}

extension Photo: Identifiable {}
