//
//  ImageDataWrapper.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import Foundation

// MARK: - Image model for cache

class ImageDataWrapper {
    let imageData: Data
    
    init(imageData: Data) {
        self.imageData = imageData
    }
}
