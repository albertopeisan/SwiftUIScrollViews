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
    @Query(sort: \Item.timestamp, order: .reverse) private var items: [Item]
    
    // State to manage loaded images
    @State private var loadedImages: [UUID: UIImage] = [:]
    @State private var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100 // Set a reasonable limit for the cache size
        return cache
    }()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            Image(uiImage: loadedImages[item.id, default: UIImage()])
                                .resizable()
                                .scaledToFit()
                                .onAppear {
                                    loadImage(for: item)
                                }
                                .onDisappear {
                                    unloadImage(for: item)
                                }
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
                Image(uiImage: loadedImages[item.id, default: UIImage()])
                    .resizable()
                    .scaledToFit()
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
    
    // Function to load image into memory
    private func loadImage(for item: Item) {
        guard loadedImages[item.id] == nil else { return }
        
        if let cachedImage = imageCache.object(forKey: NSString(string: item.id.uuidString)) {
            loadedImages[item.id] = cachedImage
            return
        }
        
        Task {
            if let image = UIImage(data: item.photo) {
                await MainActor.run {
                    loadedImages[item.id] = image
                    imageCache.setObject(image, forKey: NSString(string: item.id.uuidString))
                }
            }
        }
    }
    
    // Function to unload image from memory
    private func unloadImage(for item: Item) {
        loadedImages.removeValue(forKey: item.id)
        // Optionally, remove from cache as well if needed
        // imageCache.removeObject(forKey: NSString(string: item.id.uuidString))
    }
}


#Preview {
    LazyScrollView()
}
