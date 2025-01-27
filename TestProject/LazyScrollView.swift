//
//  LazyScrollView.swift
//  TestProject
//
//  Created by Alberto Peinado Santana on 21/1/25.
//

import PhotosUI
import SwiftUI
import SwiftData

struct LazyScrollView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingPhotosPicker: Bool = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @Query private var items: [Item]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            Image(uiImage: UIImage(data: item.photo)!)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
            }
            .navigationTitle("LazyScrollView")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingPhotosPicker.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationDestination(for: Item.self) { item in
                Image(uiImage: UIImage(data: item.photo)!)
                    .resizable()
                    .scaledToFit()
            }
            .photosPicker(isPresented: $isShowingPhotosPicker, selection: $selectedItems, maxSelectionCount: 100, matching: .images, preferredItemEncoding: .automatic)
            .task(id: selectedItems) {
                await withTaskGroup(of: Void.self) { group in
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
                
                do {
                    try modelContext.save()
                } catch {
                    fatalError(error.localizedDescription)
                }
                
                selectedItems.removeAll()
            }
        }
    }
}

#Preview {
    LazyScrollView()
}
