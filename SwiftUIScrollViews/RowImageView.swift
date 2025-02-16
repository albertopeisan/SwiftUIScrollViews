//
//  RowImageView.swift
//  SwiftUIScrollViews
//
//  Created by Alberto Peinado Santana on 29/1/25.
//

import SwiftUI

struct RowImageView: View {
    var data: Data?
    let size: CGSize
    
    var body: some View {
        if let imageData = data, let uiImage = downsampledImage(data: imageData, size: size) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            Image("placeholder")
                .resizable()
                .scaledToFit()
        }
    }
}

//#Preview {
//    RowImageView()
//}
