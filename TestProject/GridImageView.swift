//
//  GridImageView.swift
//  TestProject
//
//  Created by Alberto Peinado Santana on 2/2/25.
//

import Foundation
import SwiftUI

struct GridImageView: View {
    var data: Data?
    let size: CGSize
    
    var body: some View {
        if let imageData = data, let uiImage = downsampledImage(data: imageData, size: size) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.width)
                .clipped()
        } else {
            Image("placeholder")
                .resizable()
                .scaledToFit()
        }
    }
}
