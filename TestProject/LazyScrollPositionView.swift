//
//  LazyScrollPositionView.swift
//  TestProject
//
//  Created by Alberto Peinado Santana on 23/1/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct LazyScrollPositionView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingPhotosPicker: Bool = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var scrolledID: Item.ID?
    @Query private var items: [Item]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(items) { item in
                        NavigationLink {
                            Image(uiImage: UIImage(data: item.photo)!)
                                .resizable()
                                .scaledToFit()
                        } label: {
                            Image(uiImage: UIImage(data: item.photo)!)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $scrolledID)
            .overlay {
                Text("\(String(describing: scrolledID))")
                    .background(Color.black)
                    .foregroundStyle(Color.indigo)
            }
            .navigationTitle("LazyScrollPositionView")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("\(items.count) items")
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingPhotosPicker.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .photosPicker(isPresented: $isShowingPhotosPicker, selection: $selectedItems, maxSelectionCount: 100, matching: .images, preferredItemEncoding: .automatic)
            .onChange(of: selectedItems) {
                Task {
                    do {
                        for item in selectedItems {
                            if let data = try await item.loadTransferable(type: Data.self) {
                                let item = Item(photo: data)
                                modelContext.insert(item)
                            }
                        }
                        
                        try modelContext.save()
                        selectedItems = []
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    LazyScrollPositionView()
}
