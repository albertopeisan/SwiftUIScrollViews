//
//  LazyGridView.swift
//  SwiftUIScrollViews
//
//  Created by Alberto Peinado Santana on 21/1/25.
//

import PhotosUI
import SwiftUI
import SwiftData

struct LazyGridView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingPhotosPicker: Bool = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @Query private var items: [Item]
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 1, alignment: .top), count: 3)
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 1) {
                    ForEach(items) { item in
                        GeometryReader { geo in
                            NavigationLink(value: item) {
                                GridImageView(data: item.photo!, size: geo.size)
                            }
                        }
                        .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            .navigationTitle("LazyGrid")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Item.self) { item in
                GeometryReader { geo in
                    if let imageData = item.photo, let uiImage = downsampledImage(data: imageData, size: geo.size) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    } else {
                        Image("placeholder")
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingPhotosPicker.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .photosPicker(isPresented: $isShowingPhotosPicker, selection: $selectedItems, maxSelectionCount: 100, matching: .images, preferredItemEncoding: .automatic)
            .task(id: selectedItems) {
                await withDiscardingTaskGroup { group in
                    for item in selectedItems {
                        group.addTask {
                            if let data = try? await item.loadTransferable(type: Data.self) {
                                let newItem = Item(photo: data)
                                await MainActor.run {
                                    modelContext.insert(newItem)
                                }
                            }
                        }
                    }
                }
                
                selectedItems.removeAll()
                
                do {
                    try modelContext.save()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    LazyGridView()
}
