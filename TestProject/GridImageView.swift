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
        if let imageData = data, let uiImage = downsample(data: imageData, size: size) {
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
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.width * aspectRatio) * 1
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
