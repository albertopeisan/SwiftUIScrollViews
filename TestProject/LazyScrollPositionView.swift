//
//  LazyScrollPositionView.swift
//  TestProject
//
//  Created by Alberto Peinado Santana on 23/1/25.
//

import PhotosUI
import SwiftUI
import SwiftData

struct LazyScrollPositionView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingPhotosPicker: Bool = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var scrolledID: Item.ID?
    @Query private var items: [Item]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            RowImageView(imageData: item.photo!)
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
            .navigationTitle("LazyScrollPosition")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Item.self) { item in
                if let data = item.photo, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
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
    LazyScrollPositionView()
}
