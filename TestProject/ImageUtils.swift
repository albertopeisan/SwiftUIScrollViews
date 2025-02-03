//
//  Helpers.swift
//  TestProject
//
//  Created by Alberto Peinado Santana on 3/2/25.
//

import Foundation
import SwiftUI

func downsampledImage(data: Data, size: CGSize) -> UIImage? {
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    
    guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
        return nil
    }
    
    guard let aspectRatio = imageAspectRatio(data: data) else {
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

func imageAspectRatio(data: Data) -> CGFloat? {
    guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
          let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
          let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
          let height = properties[kCGImagePropertyPixelHeight] as? CGFloat else {
        return nil
    }
    
    return width / height
}
