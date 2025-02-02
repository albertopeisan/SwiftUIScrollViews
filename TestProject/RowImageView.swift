//
//  RowImageView.swift
//  TestProject
//
//  Created by Alberto Peinado Santana on 29/1/25.
//

import SwiftUI

struct RowImageView: View {
    var imageData: Data
    
    var body: some View {
        if let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image("placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

//#Preview {
//    RowImageView()
//}
