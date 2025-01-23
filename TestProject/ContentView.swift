//
//  ContentView.swift
//  TestProject
//
//  Created by Alberto Peinado Santana on 21/1/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            LazyScrollView()
                .tabItem {
                    Label("LazyScrollView", systemImage: "scroll.fill")
                }
            
            LazyScrollPositionView()
                .tabItem {
                    Label("LazyScrollPositionView", systemImage: "list.number")
                }
            
            LazyGridView()
                .tabItem {
                    Label("LazyGridView", systemImage: "square.grid.2x2.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
