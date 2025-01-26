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
                        NavigationLink {
                            Image(uiImage: UIImage(data: item.photos.first!.photo)!)
                                .resizable()
                                .scaledToFit()
                        } label: {
                            Image(uiImage: UIImage(data: item.photos.first!.photo)!)
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
            .photosPicker(isPresented: $isShowingPhotosPicker, selection: $selectedItems, maxSelectionCount: 100, matching: .images, preferredItemEncoding: .automatic)
            .onChange(of: selectedItems) {
                Task {
                    do {
                        for item in selectedItems {
                            if let data = try await item.loadTransferable(type: Data.self) {
                                let photo = Photo(photo: data)
                                let item = Item(photos: [photo])
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
    LazyScrollView()
}
