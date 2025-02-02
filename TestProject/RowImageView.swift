//
//  RowImageView.swift
//  TestProject
//
//  Created by Alberto Peinado Santana on 29/1/25.
//

import SwiftUI

struct RowImageView: View {
    var data: Data?
    let size: CGSize
    
    var body: some View {
        if let imageData = data, let uiImage = downsample(data: imageData, size: size) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            Image("placeholder")
                .resizable()
                .scaledToFit()
        }
    }
    
    func downsample(data: Data, size: CGSize) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
            return nil
        }
        
        guard let aspectRatio = aspectRatio(data: data) else {
            return nil
        }
        
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.width * aspectRatio) * UIScreen.main.scale
        ] as CFDictionary
        
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        return UIImage(cgImage: downsampledImage)
    }
    
    func aspectRatio(data: Data) -> CGFloat? {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
              let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
              let height = properties[kCGImagePropertyPixelHeight] as? CGFloat else {
            return nil
        }
        
        return width / height
    }
}

//#Preview {
//    RowImageView()
//}
