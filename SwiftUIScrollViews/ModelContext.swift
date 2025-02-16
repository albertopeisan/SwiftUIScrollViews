//
//  ModelContext.swift
//  SwiftUIScrollViews
//
//  Created by Alberto Peinado Santana on 2/2/25.
//

import Foundation
import SwiftData

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
